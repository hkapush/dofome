# 🚀 DoForMe 快速参考

## 新增功能速查

### 1️⃣ 发布任务

**入口**: 首页中间 **+** 按钮 → "发布任务"

**快速步骤**:
```
1. 填写标题和描述
2. 设置悬赏金额和货币类型
3. 添加子任务（至少1个）
4. 点击"发布任务"
```

**文件**: `products/entry/src/main/ets/pages/CreateTaskPage.ets`

---

### 2️⃣ 任务协商

**入口**: 任务页 → 任务卡片 → "协商"按钮

**功能**: 自动跳转到与发布者的聊天页面

**实现**:
```typescript
// TaskPage.ets
handleNegotiateTask(task: Task) {
  router.pushUrl({
    url: 'pages/ChatPage',
    params: {
      friendId: task.id + '_publisher',
      friendName: task.publisherName,
      friendAvatar: task.publisherAvatar
    }
  });
}
```

---

### 3️⃣ IM聊天

**入口**:
- 任务页 → "协商"按钮
- 消息页 → 好友消息 → 点击好友

**功能**:
- 发送文本消息
- 消息气泡显示
- 在线状态
- 时间格式化

**文件**: `products/entry/src/main/ets/pages/ChatPage.ets`

---

### 4️⃣ 店铺管理

**入口**:
- 商店页 → "我的店铺" → "进入店铺管理"
- 首页+按钮 → "上架商品"

**功能**:
- 开通店铺引导
- 商品管理（添加/编辑/上下架）
- 订单管理（占位）
- 店铺设置（占位）

**文件**: `products/entry/src/main/ets/pages/MyStorePage.ets`

---

## 页面路由配置

已添加到 `main_pages.json`:
```json
{
  "src": [
    "pages/Index",
    "pages/LoginPage",
    "pages/HomePage",
    "pages/TaskDetailPage",
    "pages/CreateTaskPage",    // 新增
    "pages/ChatPage",           // 新增
    "pages/MyStorePage"         // 新增
  ]
}
```

---

## 数据模型

### TaskPublishData (CreateTaskPage.ets)
```typescript
interface TaskPublishData {
  title: string;
  description: string;
  reward: number;
  currencyType: string;
  deadline: string | number;
  location: string;
  category: string;
  executionMode: ExecutionMode;
  subTasks: SubTaskInput[];
}
```

### ChatMessage (ChatPage.ets)
```typescript
interface ChatMessage {
  messageId: string;
  senderId: string;
  senderName: string;
  senderAvatar: string;
  type: ChatMessageType;
  content: string;
  timestamp: number;
  isSelf: boolean;
}
```

### StoreInfo (MyStorePage.ets)
```typescript
interface StoreInfo {
  storeId: string;
  storeName: string;
  description: string;
  acceptedCurrencies: CurrencyType[];
  redemptionRate: number;
  responseTime: string;
}
```

---

## 常用代码片段

### 页面跳转
```typescript
// 跳转到聊天页面
router.pushUrl({
  url: 'pages/ChatPage',
  params: {
    friendId: 'user_001',
    friendName: '小明'
  }
});

// 返回上一页
router.back();
```

### Toast提示
```typescript
promptAction.showToast({
  message: '操作成功',
  duration: 2000
});
```

### 对话框
```typescript
promptAction.showDialog({
  title: '提示',
  message: '确认操作？',
  buttons: [
    { text: '确定', color: '#E11D48' },
    { text: '取消', color: '#94A3B8' }
  ]
}).then((result) => {
  if (result.index === 0) {
    // 确定操作
  }
});
```

---

## 设计规范速查

### 颜色
- 主色: `#E11D48`
- 背景: `#FFF1F2`
- 强调: `#2563EB`
- 成功: `#10B981`
- 警告: `#F59E0B`
- 错误: `#EF4444`

### 圆角
- 小: `8px`
- 中: `12px` / `16px`
- 大: `24px`

### 间距
- xs: `4px`
- sm: `8px`
- md: `12px` / `16px`
- lg: `24px`
- xl: `32px`

### 字体
- 标题: `20-24px`, Bold
- 正文: `14-16px`, Regular
- 辅助: `12px`, Light

---

## 调试技巧

### 查看日志
```typescript
console.log('调试信息:', data);
console.error('错误信息:', error);
```

### 检查路由参数
```typescript
const params = router.getParams() as Record<string, string>;
console.log('路由参数:', params);
```

### 模拟延迟
```typescript
await new Promise<void>((resolve) => setTimeout(resolve, 500));
```

---

## 文档索引

- **产品需求**: design.md
- **设计规范**: DESIGN_GUIDE.md
- **开发指南**: README.md
- **使用指南**: USER_GUIDE.md
- **开发进度**: DEVELOPMENT_PROGRESS.md
- **架构总结**: ARCHITECTURE_SUMMARY.md
- **业务闭环**: BUSINESS_CLOSURE_SUMMARY.md
- **最终总结**: FINAL_SUMMARY.md

---

## 快速命令

### 查看所有页面
```bash
find products/entry/src/main/ets/pages -name "*.ets"
```

### 查看所有模型
```bash
find features/Home/src/main/ets/models -name "*.ets"
```

### 查看所有服务
```bash
find features/Home/src/main/ets/services -name "*.ets"
```

### 统计代码行数
```bash
find . -name "*.ets" | xargs wc -l
```

---

**版本**: v2.0
**更新**: 2026-02-01
