#!/bin/bash

# -e: 命令失败时立即退出
# -u: 使用未定义变量时报错
set -eu

# Files
TASK_FILE="TASKS.md"
CONTEXT_FILE="CONTEXT.md"
SPECS_DIR="specs"
TASK_STATE=".task"

# Directories
ZHIREN_HOME="$HOME/.zhiren"
LIB_CONSTS_SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
RESOURCES_DIR=$(get_real_path "$LIB_CONSTS_SCRIPT_DIR/../resources")
RESOURCES_PROMPTS_DIR="$RESOURCES_DIR/prompts"

ZHIREN_PROJECT_ROOT="$(pwd)"
PROJECT_ZHIREN_DIR="$ZHIREN_PROJECT_ROOT/.zhiren"

# 当前要执行的任务文件路径
DEFAULT_CURRENT_TASK_FILE_PATH="$ZHIREN_PROJECT_ROOT/$TASK_STATE"

# Retry settings
MAX_RETRIES=5
RETRY_DELAY=10

#==============================================================================
# Export variables
export TASK_FILE
export CONTEXT_FILE
export SPECS_DIR
export TASK_STATE

export ZHIREN_HOME
export PROJECT_ZHIREN_DIR

export DEFAULT_CURRENT_TASK_FILE_PATH

export MAX_RETRIES
export RETRY_DELAY
