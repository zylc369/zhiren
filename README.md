# Zhiren
Using AI to solve problems, the Ralph loop can automatically and accurately resolve issues.

## Runtime Context
文件名为：runtime_context.json。存储在`.zhiren/<类型，当前两个枚举值：init、>/<Zhiren Session Id>`目录下。
```json
{
    "session": {
        "id": "Zhiren Session Id。格式：唯一序号",
        "createTime": "格式：YYYY-MM-DD HH:MM:SS"
    },
    "startup": {
        "count": 相同会话内命令启动次数，命令如：Zhiren、Zhiren-init,
        "latestTime": "最新命令启动时间，格式：YYYY-MM-DD HH:MM:SS",
        "history": [
            {
                "time": "历史命令启动时间，包含本次启动时间，格式：YYYY-MM-DD HH:MM:SS"
            }
        ]
    },
    "assistant": {
        "session": {
            "id": "助手的Session Id"
        },
        "name": "助手名。目前两个枚举值：CLAUDE_CODE、OPEN_CODE"
    },
    "tasks": [
        {
            "id": "任务ID。格式：T1、T2、T3……",
            "step": "当前步骤，记录当前步骤有助于断点续作",
            "temp": {
                "iterationIndex:" 当前迭代索引,
            }
        }
    ]
}
```

- Zhiren Session Id：用于区分不同会话的上下文、提示词、需求规格等文件。
- 任务所在目录`.zhiren/.zhiren/<类型，当前两个枚举值：init、>/<Zhiren Session Id>/<任务ID>`下。