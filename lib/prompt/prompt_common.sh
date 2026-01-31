#!/bin/bash

# -e: 命令失败时立即退出
# -u: 使用未定义变量时报错
set -eu

get_file_maps_prompt() {
    read -r -d '' prompt_content << EOF
**IMPORTANT Path Maps:**
- Current Working Directory (cwd for short): \`$ZHIREN_PROJECT_ROOT\`. Code will be generated into the cwd.
- Zhiren Project Info Directory: \`[cwd]/.zhiren\` .All files or directories without an explicitly specified path (e.g., $CURRENT_TASK_FILE_NAME, TASKS.md, CONTEXT.md, specs/) will be stored here.
- PROMPT SNIPPET DIRECTORY: \`$RESOURCES_PROMPTS_DIR\`.
EOF
    
    echo "$prompt_content"
}

export -f get_file_maps_prompt