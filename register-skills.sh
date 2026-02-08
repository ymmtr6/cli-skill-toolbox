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
  -g, --generate CMD   コマンドの--help出力からテンプレートを自動生成
  -h, --help           このヘルプを表示

Examples:
  $(basename "$0")                  # 両方にスキルを登録
  $(basename "$0") --target claude  # Claude Codeのみ
  $(basename "$0") --target codex   # Codexのみ
  $(basename "$0") --dry-run        # ドライランで確認
  $(basename "$0") --list           # 登録可能なコマンドを一覧表示
  $(basename "$0") --generate git   # gitのテンプレートを自動生成
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

# テンプレートを自動生成
generate_template() {
    local cmd="$1"

    # コマンドがインストールされているか確認
    if ! command_exists "$cmd"; then
        log_error "コマンドがインストールされていません: $cmd"
        return 1
    fi

    # テンプレートが既に存在する場合は確認
    local template_file="${TEMPLATES_DIR}/${cmd}.md"
    if [[ -f "$template_file" ]]; then
        log_warning "テンプレートが既に存在します: $template_file"
        echo -n "上書きしますか？ [y/N] "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            log_info "テンプレートの生成をキャンセルしました"
            return 0
        fi
    fi

    log_info "コマンドのヘルプを取得: $cmd --help"
    local help_output
    if ! help_output=$($cmd --help 2>&1); then
        # --help が失敗した場合、試しに man ページを取得
        log_warning "--help が利用できません。man ページを試します..."
        if ! help_output=$(man "$cmd" 2>/dev/null); then
            log_error "ヘルプ情報を取得できませんでした: $cmd"
            return 1
        fi
    fi

    # コマンドの説明を抽出（最初の数行）
    local description="CLI tool for ${cmd}"
    local first_lines=$(echo "$help_output" | head -20)
    if echo "$first_lines" | grep -qi "usage\|description\|${cmd}"; then
        # 簡単な説明を抽出（見出しや空行を除外）
        description=$(echo "$first_lines" | grep -v "^$" | grep -v "^USAGE\|^USAGE:\|^DESCRIPTION\|^DESCRIPTION:\|^OPTIONS\|^OPTIONS:" | head -3 | tr '\n' ' ' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        # 説明が長すぎる場合は切り詰め
        if [[ ${#description} -gt 100 ]]; then
            description="${description:0:100}..."
        fi
    fi

    # サブコマンドを抽出
    local subcommands=""
    if echo "$help_output" | grep -qi "subcommands\|commands\|available commands"; then
        subcommands=$(echo "$help_output" | grep -A 20 "Subcommands\|Commands\|Available Commands" | grep -E "^\s{2,}[a-z]" | head -10 | awk '{print $1}' | tr '\n' ' ')
    fi

    # 主要オプションを抽出
    local main_options=""
    if echo "$help_output" | grep -E "^\s*-" > /dev/null; then
        main_options=$(echo "$help_output" | grep -E "^\s*-\-?[a-z]" | head -10 | sed 's/^\s*//' | cut -d' ' -f1 | tr '\n' ' ')
    fi

    # テンプレートを生成
    cat > "$template_file" << EOF
---
name: ${cmd}
description: ${description}
allowed-tools:
  - Bash(${cmd}:*)
---

# ${cmd} スキル

\`${cmd}\` コマンドのスキルテンプレートです。

## 主な機能

コマンドの主な機能をここに記載します。

## 使用例

\`\`\`bash
# 基本的な使用例
${cmd} <argument>

# オプションを使用
${cmd} --option <value>
\`\`\`

Bashツールを使用して${cmd}コマンドを実行してください。

## 注意事項

**重要**: このテンプレートは自動生成されています。以下の点を手動で調整してください：

1. **主な機能**: コマンドの主な機能を具体的に記載してください
2. **使用例**: 実用的な使用例を追加してください
3. **注意事項**: 変更・削除を伴う操作がある場合は警告を追加してください
   - ファイルの削除・上書き操作
   - データの変更操作
   - ネットワーク操作（POST, PUT, DELETE等）
   - 認証情報の取り扱い

自動生成時に検出された情報：
- 説明: ${description}
EOF

    # サブコマンドが見つかった場合は追加
    if [[ -n "$subcommands" ]]; then
        echo "- サブコマンド: ${subcommands}" >> "$template_file"
    fi

    # 主要オプションが見つかった場合は追加
    if [[ -n "$main_options" ]]; then
        echo "- 主要オプション: ${main_options}" >> "$template_file"
    fi

    log_success "テンプレートを生成しました: $template_file"
    log_info "テンプレートを編集してから使用してください"
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

# メイン処理
main() {
    local dry_run="false"
    local list_only="false"
    local target="all"
    local generate_cmd=""

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
            -g|--generate)
                generate_cmd="$2"
                shift 2
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

    # テンプレート自動生成モード
    if [[ -n "$generate_cmd" ]]; then
        generate_template "$generate_cmd"
        exit $?
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
