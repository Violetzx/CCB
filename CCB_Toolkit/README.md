## 对于号码菌的工具箱mod的CCB适配我有以下建议：

1. 为适配号码菌的后续更新，不修改任何其本体源码
2. 通过修改 DefaultValue 使得预设符合 CCB 游玩习惯（例如默认关闭结社、行业、默认开启金币交易等）
3. 所有的 MPH 移植功能的脚本、和 CCB 适配改动放在路径 MPH 下，方便管理

## 工具箱测试注意要点

1. 为防止自动更新，请进行如下操作：

    注释 `Update/UI/AutoUpdate.lua` 中最后一行的 `Initialize()`
    注释 `BSR/UI/StagingRoom.lua` 中约 4500 行附近的 `Modding.UpdateSubscription(v.SubscriptionId);`


——Vanadium