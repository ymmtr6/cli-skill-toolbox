#!/bin/bash

# CLI Skill Toolbox - Claude Code / Codex スキル自動登録スクリプト
# インストール済みのCLIコマンドを検出し、Claude Code・Codexのスキルとして登録します

set -euo pipefail

# 色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/commands.conf"
TEMPLATES_DIR="${SCRIPT_DIR}/templates"
CLAUDE_SKILLS_DIR="${HOME}/.claude/skills"
CODEX_SKILLS_DIR="${HOME}/.codex/skills"

# ログ関数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# ヘルプメッセージ
show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

インストール済みのCLIコマンドを検出し、Claude Code・Codexのスキルとして登録します。

Options:
  -c, --config FILE    設定ファイルを指定 (デフォルト: commands.conf)
  -t, --target TARGET  登録先を指定: claude, codex, all (デフォルト: all)
  -d, --dry-run        実際にファイルを作成せずに実行内容を表示
  -l, --list           登録可能なコマンドを一覧表示
  -u, --uninstall CMD  指定したスキルを削除（複数指定可）
  -U, --uninstall-all  登録済みの全スキルを削除
  -y, --yes            確認プロンプトをスキップ（削除時）
  -h, --help           このヘルプを表示

Examples:
  $(basename "$0")                  # 両方にスキルを登録
  $(basename "$0") --target claude  # Claude Codeのみ
  $(basename "$0") --target codex   # Codexのみ
  $(basename "$0") --dry-run        # ドライランで確認
  $(basename "$0") --list           # 登録可能なコマンドを一覧表示
  $(basename "$0") --uninstall gh jq  # 指定したスキルを削除
  $(basename "$0") --uninstall-all   # 登録済みの全スキルを削除
EOF
}

# コマンドがインストールされているか確認
command_exists() {
    command -v "$1" &> /dev/null
}

# 設定ファイルからコマンドリストを読み取り
read_commands() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        log_error "設定ファイルが見つかりません: $CONFIG_FILE"
        exit 1
    fi

    # コメントと空行を除外してコマンドを読み取り
    grep -v '^#' "$CONFIG_FILE" | grep -v '^[[:space:]]*$' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

# テンプレートからallowed-toolsを除去してCodex用SKILL.mdを生成
strip_allowed_tools() {
    local input_file="$1"
    # YAMLフロントマター内のallowed-tools行とその配列項目を除去
    sed '/^allowed-tools:$/,/^[^ -]/{ /^allowed-tools:$/d; /^  - /d; }' "$input_file"
}

# スキルを登録（target: claude または codex）
register_skill() {
    local cmd="$1"
    local dry_run="$2"
    local target="$3"
    local template_file="${TEMPLATES_DIR}/${cmd}.md"

    local skills_dir
    if [[ "$target" == "codex" ]]; then
        skills_dir="$CODEX_SKILLS_DIR"
    else
        skills_dir="$CLAUDE_SKILLS_DIR"
    fi

    local skill_dir="${skills_dir}/${cmd}"
    local skill_file="${skill_dir}/SKILL.md"

    # テンプレートが存在するか確認
    if [[ ! -f "$template_file" ]]; then
        log_warning "テンプレートが見つかりません: $cmd (${template_file})"
        return 1
    fi

    if [[ "$dry_run" == "true" ]]; then
        log_info "[DRY-RUN] [$target] スキルを登録: $cmd -> $skill_file"
        return 0
    fi

    # スキルディレクトリを作成
    mkdir -p "$skill_dir"

    if [[ "$target" == "codex" ]]; then
        # Codex向け: allowed-toolsを除去してコピー
        strip_allowed_tools "$template_file" > "$skill_file"
    else
        # Claude Code向け: そのままコピー
        cp "$template_file" "$skill_file"
    fi

    log_success "[$target] スキルを登録しました: $cmd -> $skill_file"
}

# スキルをアンインストール
uninstall_skill() {
    local cmd="$1"
    local dry_run="$2"
    local target="$3"
    local confirm="$4"

    local skills_dir
    if [[ "$target" == "codex" ]]; then
        skills_dir="$CODEX_SKILLS_DIR"
    else
        skills_dir="$CLAUDE_SKILLS_DIR"
    fi

    local skill_dir="${skills_dir}/${cmd}"
    local skill_file="${skill_dir}/SKILL.md"

    # スキルが存在するか確認
    if [[ ! -d "$skill_dir" ]]; then
        log_warning "[$target] スキルが見つかりません: $cmd"
        return 1
    fi

    if [[ "$dry_run" == "true" ]]; then
        log_info "[DRY-RUN] [$target] スキルを削除: $skill_dir"
        return 0
    fi

    # 確認プロンプト（-y オプションがない場合）
    if [[ "$confirm" != "yes" ]]; then
        echo -n "[$target] スキル '$cmd' を削除しますか？ [y/N] "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            log_info "[$target] スキルの削除をキャンセルしました: $cmd"
            return 0
        fi
    fi

    # スキルディレクトリを削除
    rm -rf "$skill_dir"
    log_success "[$target] スキルを削除しました: $cmd"
}

# メイン処理
main() {
    local dry_run="false"
    local list_only="false"
    local target="all"
    local uninstall_mode="false"
    local uninstall_all_mode="false"
    local confirm="no"
    local uninstall_cmds=()

    # 引数をパース
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -c|--config)
                CONFIG_FILE="$2"
                shift 2
                ;;
            -t|--target)
                target="$2"
                if [[ "$target" != "claude" && "$target" != "codex" && "$target" != "all" ]]; then
                    log_error "無効なターゲット: $target (claude, codex, all のいずれかを指定)"
                    exit 1
                fi
                shift 2
                ;;
            -d|--dry-run)
                dry_run="true"
                shift
                ;;
            -l|--list)
                list_only="true"
                shift
                ;;
            -u|--uninstall)
                uninstall_mode="true"
                shift
                # 残りの引数がスキル名（オプションでない）
                while [[ $# -gt 0 && ! "$1" =~ ^- ]]; do
                    uninstall_cmds+=("$1")
                    shift
                done
                ;;
            -U|--uninstall-all)
                uninstall_all_mode="true"
                shift
                ;;
            -y|--yes)
                confirm="yes"
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                log_error "不明なオプション: $1"
                show_help
                exit 1
                ;;
        esac
    done

    log_info "CLI Skill Toolbox - スキル登録スクリプト"
    log_info "設定ファイル: $CONFIG_FILE"
    log_info "テンプレートディレクトリ: $TEMPLATES_DIR"
    log_info "ターゲット: $target"
    if [[ "$target" == "claude" || "$target" == "all" ]]; then
        log_info "Claude Code スキルディレクトリ: $CLAUDE_SKILLS_DIR"
    fi
    if [[ "$target" == "codex" || "$target" == "all" ]]; then
        log_info "Codex スキルディレクトリ: $CODEX_SKILLS_DIR"
    fi
    echo

    # アンインストールモード
    if [[ "$uninstall_mode" == "true" ]]; then
        if [[ ${#uninstall_cmds[@]} -eq 0 ]]; then
            log_error "--uninstall オプションには削除するスキル名を指定してください"
            exit 1
        fi

        log_info "スキルをアンインストールします: ${uninstall_cmds[*]}"
        echo

        local uninstalled=0
        local not_installed=0

        for cmd in "${uninstall_cmds[@]}"; do
            for t in "${targets[@]}"; do
                if uninstall_skill "$cmd" "$dry_run" "$t" "$confirm"; then
                    ((uninstalled++))
                else
                    ((not_installed++))
                fi
            done
        done

        echo
        log_info "=== 結果サマリー ==="
        log_info "削除成功: $uninstalled"
        log_info "見つからないスキル: $not_installed"

        if [[ "$dry_run" == "true" ]]; then
            echo
            log_warning "これはドライランです。実際にファイルは削除されていません。"
        fi
        exit 0
    fi

    # 全スキルアンインストールモード
    if [[ "$uninstall_all_mode" == "true" ]]; then
        log_info "登録済みの全スキルをアンインストールします"
        echo

        # 全スキル削除の確認
        if [[ "$confirm" != "yes" ]]; then
            echo -n "本当に登録済みの全スキルを削除しますか？ [y/N] "
            read -r response
            if [[ ! "$response" =~ ^[Yy]$ ]]; then
                log_info "全スキルの削除をキャンセルしました"
                exit 0
            fi
        fi

        local uninstalled=0

        for t in "${targets[@]}"; do
            local skills_dir
            if [[ "$t" == "codex" ]]; then
                skills_dir="$CODEX_SKILLS_DIR"
            else
                skills_dir="$CLAUDE_SKILLS_DIR"
            fi

            if [[ ! -d "$skills_dir" ]]; then
                log_warning "[$t] スキルディレクトリが見つかりません: $skills_dir"
                continue
            fi

            # ディレクトリ内の全スキルを削除
            for skill_dir in "$skills_dir"/*; do
                if [[ -d "$skill_dir" ]]; then
                    local cmd_name=$(basename "$skill_dir")

                    if [[ "$dry_run" == "true" ]]; then
                        log_info "[DRY-RUN] [$t] スキルを削除: $skill_dir"
                    else
                        rm -rf "$skill_dir"
                        log_success "[$t] スキルを削除しました: $cmd_name"
                    fi
                    ((uninstalled++))
                fi
            done
        done

        echo
        log_info "=== 結果サマリー ==="
        log_info "削除成功: $uninstalled"

        if [[ "$dry_run" == "true" ]]; then
            echo
            log_warning "これはドライランです。実際にファイルは削除されていません。"
        fi
        exit 0
    fi

    echo

    # コマンドリストを取得
    local commands
    commands=$(read_commands)

    local registered=0
    local skipped=0
    local not_found=0

    # 一覧表示モード
    if [[ "$list_only" == "true" ]]; then
        log_info "登録可能なコマンド一覧:"
        echo
        printf "%-12s %-12s %-12s\n" "コマンド" "インストール" "テンプレート"
        printf "%-12s %-12s %-12s\n" "--------" "----------" "----------"

        for cmd in $commands; do
            local installed="No"
            local has_template="No"

            if command_exists "$cmd"; then
                installed="${GREEN}Yes${NC}"
            else
                installed="${RED}No${NC}"
            fi

            if [[ -f "${TEMPLATES_DIR}/${cmd}.md" ]]; then
                has_template="${GREEN}Yes${NC}"
            else
                has_template="${RED}No${NC}"
            fi

            printf "%-12s %-23b %-23b\n" "$cmd" "$installed" "$has_template"
        done
        exit 0
    fi

    # 登録対象のターゲットリストを構築
    local targets=()
    if [[ "$target" == "claude" || "$target" == "all" ]]; then
        targets+=("claude")
    fi
    if [[ "$target" == "codex" || "$target" == "all" ]]; then
        targets+=("codex")
    fi

    # スキルを登録
    for cmd in $commands; do
        if ! command_exists "$cmd"; then
            log_warning "コマンドがインストールされていません: $cmd"
            ((not_found++))
            continue
        fi

        for t in "${targets[@]}"; do
            if register_skill "$cmd" "$dry_run" "$t"; then
                ((registered++))
            else
                ((skipped++))
            fi
        done
    done

    echo
    log_info "=== 結果サマリー ==="
    log_info "登録成功: $registered"
    log_info "スキップ (テンプレートなし): $skipped"
    log_info "未インストール: $not_found"

    if [[ "$dry_run" == "true" ]]; then
        echo
        log_warning "これはドライランです。実際にファイルは作成されていません。"
    fi
}

main "$@"
