#!/bin/bash

set -e

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

copy_to_home() {
    # 创建zhiren的目录
    mkdir -p "$ZHIREN_HOME"

    # 复制可执行脚本
    cp "$SCRIPT_DIR/zhiren" "$ZHIREN_HOME/"
    cp "$SCRIPT_DIR/zhiren_init" "$ZHIREN_HOME/"

    # 复制 lib 和 resources 目录（保留结构）
    cp -r "$SCRIPT_DIR/lib" "$ZHIREN_HOME/"
    log "Copied lib directory to $ZHIREN_HOME/lib/"
    cp -r "$SCRIPT_DIR/resources" "$ZHIREN_HOME/"
    log "Copied resources directory to $ZHIREN_HOME/resources/"

    # 确保脚本有执行权限
    # chmod +x "$ZHIREN_HOME/zhiren" "$ZHIREN_HOME/zhiren_init"
}

install() {
    log ""

    mkdir -p "$ZHIREN_BIN_DIR"

    # Create zhiren command
    cat > "$ZHIREN_BIN_DIR/zhiren" << 'EOF'
#!/bin/bash

ZHIREN_HOME="$HOME/.zhiren"

exec "$ZHIREN_HOME/zhiren" "$@"
EOF
    chmod a+x "$ZHIREN_BIN_DIR/zhiren"
    log "Installed zhiren command to $ZHIREN_BIN_DIR/zhiren"

    # Create zhiren-init command
    cat > "$ZHIREN_BIN_DIR/zhiren-init" << 'EOF'
#!/bin/bash


ZHIREN_HOME="$HOME/.zhiren"

exec "$ZHIREN_HOME/zhiren_init" "$@"
EOF
    chmod a+x "$ZHIREN_BIN_DIR/zhiren-init"
    log "Installed zhiren-init command to $ZHIREN_BIN_DIR/zhiren-init"

    log ""
}

copy_to_home
install

# 提示用户添加 PATH
log "✅ 安装成功！"
log "请将以下行添加到你的 shell 配置文件中（如 ~/.bashrc、~/.zshrc 等）："
log ""
log "    export PATH=\"\$PATH:$ZHIREN_BIN_DIR\""
log ""
log "然后运行：source ~/.bashrc（或对应配置文件）以生效。"