#!/bin/bash

# -e: 命令失败时立即退出
# -u: 使用未定义变量时报错
set -eu

# session相关变量
ZHIREN_CLAUDE_SESSION_FILE_SUFFIX="${ZHIREN_EXECUTE_SCENE:+_${ZHIREN_EXECUTE_SCENE}}"
ZHIREN_CLAUDE_SESSION_FILE="${PROJECT_ZHIREN_DIR}/claude_session_id$ZHIREN_CLAUDE_SESSION_FILE_SUFFIX"

ZHIREN_CLAUDE_SESSION_IS_NEW=""
ZHIREN_CLAUDE_SESSION_ID=""
init_claude_session() {
    if [[ -n "$ZHIREN_CLAUDE_SESSION_IS_NEW" ]] && [[ -n "$ZHIREN_CLAUDE_SESSION_ID" ]]; then
        # 两个变量都不为空时
        return 0
    fi
    # echo "[init_claude_session]ZHIREN_CLAUDE_SESSION_IS_NEW=$ZHIREN_CLAUDE_SESSION_IS_NEW,ZHIREN_CLAUDE_SESSION_ID=$ZHIREN_CLAUDE_SESSION_ID" >&2

    # 检查文件是否存在且不为空
    if [[ ! -f "$ZHIREN_CLAUDE_SESSION_FILE" ]] || [[ ! -s "$ZHIREN_CLAUDE_SESSION_FILE" ]]; then
        # 文件不存在或为空
        local session_id=$(uuidgen)
        echo -n "$session_id" > "$ZHIREN_CLAUDE_SESSION_FILE"

        ZHIREN_CLAUDE_SESSION_IS_NEW="true"
        ZHIREN_CLAUDE_SESSION_ID="$session_id"
    else
        # 读取文件内容到变量，去除首尾空白字符
        local session_id=$(<"$ZHIREN_CLAUDE_SESSION_FILE")
        ZHIREN_CLAUDE_SESSION_IS_NEW="false"
        ZHIREN_CLAUDE_SESSION_ID="$session_id"
    fi

    log "LIGHT" "Claude session initialization completed. is_new:$ZHIREN_CLAUDE_SESSION_IS_NEW, session_id:$ZHIREN_CLAUDE_SESSION_ID." >&2
}

get_claude_session_is_new() {
    echo "$ZHIREN_CLAUDE_SESSION_IS_NEW"
}

get_claude_session_id() {
    echo "$ZHIREN_CLAUDE_SESSION_ID"
}

init_claude_session

export -f get_claude_session_is_new
export -f get_claude_session_id