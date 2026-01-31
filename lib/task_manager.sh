#!/bin/bash

# -e: 命令失败时立即退出
# -u: 使用未定义变量时报错
set -eu

# 获得处理过的历史任务数
get_history_task_count() {
    # 只统计当前目录（不含子目录）
    local count=$(find . -maxdepth 1 -type f -name "*_task.md" 2>/dev/null | wc -l | xargs)
    count=$((count + 0))
    echo "$count"
}

gen_new_history_task_file_name() {
    local history_task_count=$(get_history_task_count)
    local new_count=$((history_task_count + 1))
    local time=$(date '+%Y-%m-%d#%H:%M:%S')
    local new_file_name="${new_count}_task.md"

    echo "$new_file_name"
}

# 任务归档
task_archiving() {
    local src_path="$1"

    # 要保存的目录
    local save_dir="$PROJECT_ZHIREN_DIR/task_history"
    mkdir -p "$save_dir"

    # 归档后的文件名
    local file_name=$(gen_new_history_task_file_name)
    local target_path="$save_dir/$file_name"

    cp -f "$src_path" "$target_path"
    log "INFO" "The task has been archived, from '$src_path' to '$target_path'."
}

export -f task_archiving