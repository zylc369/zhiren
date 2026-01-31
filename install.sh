#!/bin/bash

set -eu

log() {
    local msg="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local log_content="[$timestamp] $msg"
    echo "$log_content"
}

log "🚀 Installing Zhiren..."
log ""

# 设置安装目录
ZHIREN_HOME="$HOME/.zhiren"
ZHIREN_BIN_DIR="$HOME/.local/bin"

# 确保当前脚本所在目录为项目根目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 检查必要文件是否存在
if [[ ! -f "$SCRIPT_DIR/zhiren" ]] || [[ ! -f "$SCRIPT_DIR/zhiren_init" ]] || \
   [[ ! -d "$SCRIPT_DIR/lib" ]] || [[ ! -d "$SCRIPT_DIR/resources" ]]; then
    log "错误：当前目录缺少必要的文件或目录（zhiren, zhiren_init, lib, resources）"
    exit 1
fi

CLEAN_INSTALL=false

# 使用说明函数
usage() {
    cat << EOF
用法: $0 [选项]

选项:
    -c, --clean-install    执行全新安装（清理现有安装）
    -h, --help             显示此帮助信息

示例:
    $0                     # 普通安装
    $0 -c                  # 全新安装
EOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        -c|--clean-install)
            CLEAN_INSTALL=true
            shift 1
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -*|*)
            log "ERROR" "未知选项: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
done

copy_to_home() {
    # 创建zhiren的目录
    mkdir -p "$ZHIREN_HOME"

    # 复制可执行脚本
    cp "$SCRIPT_DIR/zhiren" "$ZHIREN_HOME/"
    cp "$SCRIPT_DIR/zhiren_init" "$ZHIREN_HOME/"
    cp "$SCRIPT_DIR/zhiren_clean_project" "$ZHIREN_HOME/"

    # 复制 lib 目录（保留结构）
    cp -r "$SCRIPT_DIR/lib" "$ZHIREN_HOME/"
    log "Copied lib directory to $ZHIREN_HOME/lib/"

    # 复制 resources 目录（保留结构）
    cp -r "$SCRIPT_DIR/resources" "$ZHIREN_HOME/"
    log "Copied resources directory to $ZHIREN_HOME/resources/"
}

inner_install() {
    local installed_command="$1"
    local target_command="$2"

    cat > "$ZHIREN_BIN_DIR/$installed_command" << EOF
#!/bin/bash

ZHIREN_HOME="\$HOME/.zhiren"

exec "\$ZHIREN_HOME/$target_command" "\$@"
EOF

    chmod a+x "$ZHIREN_BIN_DIR/$installed_command"
    log "Installed $installed_command command to $ZHIREN_BIN_DIR/$installed_command"
}

install() {
    log ""

    mkdir -p "$ZHIREN_BIN_DIR"

    # Create zhiren command
    inner_install "zhiren" "zhiren"

    # Create zhiren-init command
    inner_install "zhiren-init" "zhiren_init"

    # Create zhiren-clean-project command
    inner_install "zhiren-clean-project" "zhiren_clean_project"

    # Create zhiren-refresh command
    inner_install "zhiren-refresh" "zhiren_refresh"

    log ""
}

if [[ "$CLEAN_INSTALL" == "true" ]];then
    log "干净安装，先删除：$ZHIREN_HOME"
    rm -rf "$ZHIREN_HOME"
    log ""
fi

copy_to_home
install

# 提示用户添加 PATH
log "✅ 安装成功！"
log "请将以下行添加到你的 shell 配置文件中（如 ~/.bashrc、~/.zshrc 等）："
log ""
log "    export PATH=\"\$PATH:$ZHIREN_BIN_DIR\""
log ""
log "然后运行：source ~/.bashrc（或对应配置文件）以生效。"