#!/bin/bash

# -e: 命令失败时立即退出
# -u: 使用未定义变量时报错
set -eu

# Files
CURRENT_TASK_FILE_NAME=".task"

# Directories
ZHIREN_HOME="$HOME/.zhiren"
LIB_CONSTS_SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
RESOURCES_DIR=$(get_real_path "$LIB_CONSTS_SCRIPT_DIR/../resources")
RESOURCES_PROMPTS_DIR="$RESOURCES_DIR/prompts"

ZHIREN_PROJECT_ROOT="$(pwd)"
PROJECT_ZHIREN_DIR="$ZHIREN_PROJECT_ROOT/.zhiren"

CONTEXT_FILE="$PROJECT_ZHIREN_DIR/CONTEXT.md"
TASK_FILE="$PROJECT_ZHIREN_DIR/TASKS.md"
SPECS_DIR="$PROJECT_ZHIREN_DIR/specs"

# 当前要执行的任务文件路径
CURRENT_TASK_FILE_PATH="$PROJECT_ZHIREN_DIR/$CURRENT_TASK_FILE_NAME"

# Retry settings
MAX_RETRIES=5
RETRY_DELAY=10

#==============================================================================
# Export variables
export TASK_FILE
export CONTEXT_FILE
export SPECS_DIR
export CURRENT_TASK_FILE_PATH
export CURRENT_TASK_FILE_NAME

export ZHIREN_HOME
export PROJECT_ZHIREN_DIR

export DEFAULT_CURRENT_TASK_FILE_PATH

export MAX_RETRIES
export RETRY_DELAY
