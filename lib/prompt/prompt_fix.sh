#!/bin/bash

# -e: 命令失败时立即退出
# -u: 使用未定义变量时报错
set -eu

get_fix_prompt() {
    read -r -d '' prompt_content << EOF
# FIX STEP

**IMPORTANT: This is step 4 of 4 in an automated pipeline (PLAN → EXECUTE → REVIEW → FIX).**
- There is NO human in the loop - fix issues found by REVIEW automatically
- Do NOT ask questions or request approval - just fix the issues
- Be direct and factual - no conversational language needed

Read REVIEW_RESULT in .task file. Fix issues by priority.

## NOTHING TO FIX? STOP HERE.
If REVIEW shows:
- OUTCOME_ACHIEVED: yes
- No ENVIRONMENT_ISSUES (empty or "none")
- No BLOCKERS (empty or "none")
- No ISSUES (empty or "none")

Then there is NOTHING for you to do. Simply:
1. Delete the .task file
2. Ensure task is marked \`- [x]\` in TASKS.md
3. STOP IMMEDIATELY - do NOT implement new code, do NOT start new tasks

The FIX step ONLY fixes problems found by REVIEW. It does NOT:
- Implement new features
- Start the next task
- Add improvements not flagged by REVIEW
- Do anything beyond fixing flagged issues

If there are no issues, your entire job is: delete .task, mark complete, done.

## Priority Order (only if issues exist)
Read prompt_snippet_fix_priority_order.md [in PROMPT SNIPPET DIRECTORY].

## If OUTCOME_ACHIEVED is "no"
The implementation doesn't do what the task required. You must:
1. Read EXPECTED_OUTCOME and OUTCOME_EVIDENCE from .task
2. Figure out WHY the outcome wasn't achieved
3. Fix the implementation until the outcome IS achieved
4. Re-verify the outcome yourself before proceeding
This is NOT optional - a task without its outcome is not done.

## Handling ENVIRONMENT_ISSUES (Critical!)
Read prompt_snippet_fix_handling_env_issues.md [in PROMPT SNIPPET DIRECTORY].

## Your Job for Code Issues
1. Fix BLOCKERS (mandatory)
2. Fix ISSUES (should fix)
3. Consider SUGGESTIONS (nice to have)
4. Re-run TEST_COMMAND to confirm
5. Commit fixes: "fix: [description]"

**IMPORTANT: Fix ALL flagged issues, not just ones from the current task.**
If REVIEW flagged a pre-existing issue (broken build, failing db:push, etc.),
you MUST fix it. Don't skip issues because "another task caused it."
A broken codebase blocks all future work - fix it now.

## NEVER Cheat on Tests
Read prompt_snippet_fix_never_cheat_on_tests.md [in PROMPT SNIPPET DIRECTORY].

## After Fixing
Read prompt_snippet_fix_after_fixing.md [in PROMPT SNIPPET DIRECTORY].

## Path Description
- Current Working Directory (cwd for short): \`$ZHIREN_PROJECT_ROOT\`. Code will be generated into the cwd.
- Zhiren Project Info Directory: \`[cwd]/.zhiren\` .All files or directories without an explicitly specified path (e.g., .task, TASKS.md, CONTEXT.md, specs/) will be stored here.
- PROMPT SNIPPET DIRECTORY: \`$RESOURCES_PROMPTS_DIR\`.
EOF
    
    echo "$prompt_content"
}

export -f get_fix_prompt