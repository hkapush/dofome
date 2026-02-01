# DoForMe 开发指南

## 📖 项目简介

DoForMe是一个轻娱乐社交/创意类应用，采用HarmonyOS ArkTS开发。本项目采用模块化架构，清晰的分层设计，易于维护和扩展。

## 🏗️ 架构概览

### 分层架构

```
表现层 (Pages/Components)
    ↓
服务层 (Services)
    ↓
数据层 (API/Storage)
```

### 核心模块

- **Login**: 登录认证模块
- **Home**: 主功能模块（任务、商店、消息、个人中心）

## 📁 项目结构

```
DoForMe/
├── features/                    # 功能模块
│   ├── Login/                   # 登录模块
│   └── Home/                    # 主页模块
│       ├── src/main/ets/
│       │   ├── pages/          # 页面
│       │   ├── models/         # 数据模型
│       │   ├── services/       # 服务层
│       │   └── utils/          # 工具类
│       └── Index.ets           # 模块导出
├── products/entry/              # 应用入口
├── DESIGN_GUIDE.md             # 设计规范
├── ARCHITECTURE_SUMMARY.md     # 架构总结
└── README.md                   # 本文档
```

## 🚀 快速开始

### 1. 导入模块

```typescript
// 导入页面
import { HomePage, TaskPage, ShopPage, MessagePage, MyPage } from 'home'

// 导入模型
import { Task, TaskStatus, Product, Message } from 'home'

// 导入服务
import { TaskService, ProductService, MessageService, UserManager } from 'home'
```

### 2. 使用服务层

#### 任务服务示例

```typescript
import { TaskService, Task, TaskStatus } from 'home'

@Component
struct MyTaskList {
  @State tasks: Task[] = [];
  private taskService = TaskService.getInstance();

  aboutToAppear() {
    this.loadTasks();
  }

  async loadTasks() {
    // 获取所有任务
    this.tasks = await this.taskService.getTasks();

    // 获取待接取的任务
    const pendingTasks = await this.taskService.getTasks({
      status: TaskStatus.PENDING
    });

    // 获取特定任务详情
    const task = await this.taskService.getTaskById('1');
  }

  build() {
    // UI代码
  }
}
```

#### 商品服务示例

```typescript
import { ProductService, Product, ProductCategory } from 'home'

@Component
struct MyShop {
  @State products: Product[] = [];
  private productService = ProductService.getInstance();

  async loadProducts() {
    // 获取所有商品
    this.products = await this.productService.getProducts();

    // 获取数码类商品
    const digitalProducts = await this.productService.getProducts(
      ProductCategory.DIGITAL
    );

    // 获取热门商品
    const hotProducts = await this.productService.getHotProducts();
  }

  build() {
    // UI代码
  }
}
```

#### 消息服务示例

```typescript
import { MessageService, Message, MessageType } from 'home'

@Component
struct MyMessages {
  @State messages: Message[] = [];
  @State unreadCount: number = 0;
  private messageService = MessageService.getInstance();

  async loadMessages() {
    // 获取所有消息
    this.messages = await this.messageService.getMessages();

    // 获取系统消息
    const systemMessages = await this.messageService.getMessages(
      MessageType.SYSTEM
    );

    // 获取未读数量
    this.unreadCount = await this.messageService.getUnreadCount();

    // 标记消息为已读
    await this.messageService.markAsRead('message_id');

    // 标记所有消息为已读
    await this.messageService.markAllAsRead();
  }

  build() {
    // UI代码
  }
}
```

#### 用户管理示例

```typescript
import { UserManager, UserInfo } from 'home'
import { common } from '@kit.AbilityKit'

@Component
struct MyProfile {
  @State userInfo: UserInfo | null = null;
  private context = getContext(this) as common.UIAbilityContext;

  async aboutToAppear() {
    // 初始化UserManager
    await UserManager.getInstance().init(this.context);

    // 检查登录状态
    const isLoggedIn = await UserManager.getInstance().isLoggedIn();

    if (isLoggedIn) {
      // 获取用户信息
      this.userInfo = await UserManager.getInstance().getUserInfo();
    }
  }

  async handleLogin() {
    // 模拟登录
    const result = await UserManager.getInstance().mockLogin(
      'username',
      'password'
    );

    if (result.success) {
      this.userInfo = result.data;
    }
  }

  async handleLogout() {
    await UserManager.getInstance().logout();
    this.userInfo = null;
  }

  build() {
    // UI代码
  }
}
```

## 📊 数据模型

### Task（任务）

```typescript
interface Task {
  taskId: string;           // 任务ID
  title: string;            // 任务标题
  description: string;      // 任务描述
  reward: number;           // 悬赏金额
  status: TaskStatus;       // 任务状态
  category: string;         // 任务分类
  deadline: string | number;// 截止时间
  subTasks: SubTask[];      // 子任务列表
  // ... 更多字段
}
```

### Product（商品）

```typescript
interface Product {
  productId: string;        // 商品ID
  name: string;             // 商品名称
  description: string;      // 商品描述
  price: number;            // 价格（积分）
  category: string;         // 商品分类
  stock: number;            // 库存数量
  sales: number;            // 销量
  rating: number;           // 评分
  // ... 更多字段
}
```

### Message（消息）

```typescript
interface Message {
  messageId: string;        // 消息ID
  type: MessageType;        // 消息类型
  title: string;            // 消息标题
  content: string;          // 消息内容
  isRead: boolean;          // 是否已读
  createdAt: string;        // 创建时间
  // ... 更多字段
}
```

## 🎨 设计规范

### 配色方案

| 用途 | 颜色 | HEX |
|------|------|-----|
| 主色调 | 玫瑰红 | `#E11D48` |
| 次要色 | 粉红 | `#FB7185` |
| 强调色 | 蓝色 | `#2563EB` |
| 背景色 | 浅粉 | `#FFF1F2` |
| 成功色 | 绿色 | `#10B981` |
| 警告色 | 橙色 | `#F59E0B` |

### 圆角规范

- 小圆角: 8px（按钮、标签）
- 中圆角: 16px（卡片）
- 大圆角: 24px（大卡片）
- 圆形: 50%（头像）

### 间距规范

- xs: 4px
- sm: 8px
- md: 16px
- lg: 24px
- xl: 32px

详细设计规范请查看 [DESIGN_GUIDE.md](./DESIGN_GUIDE.md)

## 🔧 开发规范

### 命名规范

```typescript
// 文件名: PascalCase
TaskPage.ets
UserManager.ets

// 组件名: PascalCase
@Component
struct TaskCard { }

// 变量名: camelCase
let taskList: Task[] = [];
let userName: string = '';

// 常量名: UPPER_SNAKE_CASE
const MAX_COUNT = 100;
const API_BASE_URL = 'https://api.example.com';

// 接口名: PascalCase
interface UserInfo { }
interface TaskFilter { }
```

### 代码组织

```typescript
// 1. 导入语句
import { router } from '@kit.ArkUI';
import { TaskService } from '../services/TaskService';

// 2. 类型定义
interface TaskFilter {
  status?: TaskStatus;
}

// 3. 组件定义
@Component
export struct TaskPage {
  // 3.1 状态变量
  @State tasks: Task[] = [];
  @State loading: boolean = false;

  // 3.2 私有变量
  private taskService = TaskService.getInstance();

  // 3.3 生命周期方法
  aboutToAppear() {
    this.loadTasks();
  }

  // 3.4 业务方法
  async loadTasks() {
    // 实现代码
  }

  // 3.5 UI构建方法
  build() {
    // UI代码
  }

  // 3.6 Builder方法
  @Builder
  TaskCard(task: Task) {
    // 卡片UI
  }
}
```

### 注释规范

```typescript
/**
 * 任务服务类
 * 负责处理任务相关的业务逻辑
 */
export class TaskService {
  /**
   * 获取任务列表
   * @param filter 过滤条件
   * @returns 任务列表
   */
  async getTasks(filter?: TaskFilter): Promise<Task[]> {
    // 实现代码
  }
}
```

## 🧪 测试

### 单元测试示例

```typescript
import { describe, it, expect } from '@ohos/hypium';
import { TaskService } from '../services/TaskService';

describe('TaskService', () => {
  it('should get tasks successfully', async () => {
    const service = TaskService.getInstance();
    const tasks = await service.getTasks();
    expect(tasks).not.toBeNull();
    expect(Array.isArray(tasks)).toBe(true);
  });

  it('should filter tasks by status', async () => {
    const service = TaskService.getInstance();
    const tasks = await service.getTasks({
      status: TaskStatus.PENDING
    });
    tasks.forEach(task => {
      expect(task.status).toBe(TaskStatus.PENDING);
    });
  });
});
```

## 📚 相关文档

- [DESIGN_GUIDE.md](./DESIGN_GUIDE.md) - 完整的UI设计规范和技术架构规范
- [ARCHITECTURE_SUMMARY.md](./ARCHITECTURE_SUMMARY.md) - 架构实施总结
- [UI_REDESIGN_SUMMARY.md](./UI_REDESIGN_SUMMARY.md) - UI改造总结

## 🤝 贡献指南

1. 遵循项目的代码规范
2. 保持代码简洁清晰
3. 添加必要的注释
4. 编写单元测试
5. 更新相关文档

## 📝 更新日志

### 2026-02-01
- ✅ 完成数据模型设计
- ✅ 完成服务层架构
- ✅ 完善商店页和消息页
- ✅ 补充技术架构文档
- ✅ 创建开发指南

## 📄 许可证

[待定]

---

**项目版本**: 1.0
**最后更新**: 2026-02-01
