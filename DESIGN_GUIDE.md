# DoForMe App - UI设计指南

## 🎨 设计理念

DoForMe是一个轻娱乐社交/创意类app，面向年轻用户群体。设计风格应该：
- **活泼有趣** - 使用鲜艳的色彩和圆润的形状
- **现代时尚** - 采用当下流行的设计元素
- **易于使用** - 清晰的视觉层次和直观的交互
- **充满活力** - 通过色彩和动效传递能量感

## 🎯 核心设计系统

### 配色方案

| 用途 | 颜色 | HEX | 使用场景 |
|------|------|-----|---------|
| 主色调 | 玫瑰红 | `#E11D48` | 主要按钮、重要标签、品牌元素 |
| 次要色 | 粉红 | `#FB7185` | 次要按钮、装饰元素、渐变 |
| 强调色 | 蓝色 | `#2563EB` | CTA按钮、链接、活跃状态 |
| 背景色 | 浅粉 | `#FFF1F2` | 页面背景 |
| 文字色 | 深玫瑰 | `#881337` | 主要文字 |
| 次要文字 | 灰色 | `#64748B` | 辅助信息 |
| 成功色 | 绿色 | `#10B981` | 完成状态、成功提示 |
| 警告色 | 橙色 | `#F59E0B` | 警告信息 |
| 错误色 | 红色 | `#EF4444` | 错误提示、危险操作 |
| 白色 | 纯白 | `#FFFFFF` | 卡片背景、输入框 |

### 渐变色方案

```
主渐变: linear-gradient(135deg, #E11D48 0%, #FB7185 100%)
次渐变: linear-gradient(135deg, #2563EB 0%, #3B82F6 100%)
背景渐变: linear-gradient(180deg, #FFF1F2 0%, #FFFFFF 100%)
```

### 字体系统

- **标题字体**: Fredoka (圆润、友好、活泼)
  - 大标题: 28-32px, Bold (700)
  - 中标题: 20-24px, SemiBold (600)
  - 小标题: 16-18px, Medium (500)

- **正文字体**: Nunito (清晰、易读、现代)
  - 正文: 14-16px, Regular (400)
  - 强调: 14-16px, SemiBold (600)
  - 辅助: 12-14px, Light (300)

### 圆角规范

| 元素类型 | 圆角大小 | 使用场景 |
|---------|---------|---------|
| 小圆角 | 8px | 小按钮、标签、输入框 |
| 中圆角 | 16px | 卡片、大按钮 |
| 大圆角 | 24px | 大卡片、模态框 |
| 圆形 | 50% | 头像、图标按钮 |

### 阴影系统

```
轻阴影: 0 2px 8px rgba(0, 0, 0, 0.08)
中阴影: 0 4px 16px rgba(0, 0, 0, 0.12)
重阴影: 0 8px 24px rgba(0, 0, 0, 0.16)
悬浮阴影: 0 12px 32px rgba(0, 0, 0, 0.2)
```

### 间距系统

```
xs: 4px   - 紧密元素间距
sm: 8px   - 小间距
md: 16px  - 标准间距
lg: 24px  - 大间距
xl: 32px  - 区块间距
2xl: 48px - 大区块间距
```

## 📱 页面设计规范

### 1. 启动页 (Index)

**设计要点:**
- 使用品牌渐变背景
- Logo居中，带有轻微动画效果
- Slogan使用次要文字色
- 整体简洁大气

**配色:**
- 背景: 主渐变
- Logo: 白色
- Slogan: 白色 80%透明度

### 2. 登录页 (LoginPage)

**设计要点:**
- 顶部使用品牌色渐变区域
- 表单区域使用白色卡片，带阴影
- 输入框圆角、带图标
- 按钮使用渐变色，带悬浮效果
- 底部链接使用强调色

**配色:**
- 顶部背景: 主渐变
- 卡片背景: 白色
- 输入框边框: #E5E7EB
- 主按钮: 主渐变
- 链接: 强调色

### 3. 首页 (HomePage)

**设计要点:**
- 底部导航栏使用白色背景，带顶部阴影
- 选中状态使用主色调
- 中间"+"按钮突出，使用渐变色
- 图标使用SVG，不使用emoji

**配色:**
- 导航栏背景: 白色
- 选中状态: 主色调
- 未选中: #94A3B8
- 中间按钮: 主渐变

### 4. 任务页 (TaskPage)

**设计要点:**
- 任务卡片使用白色背景，圆角16px
- 卡片间距16px
- 悬赏金额使用醒目颜色
- 状态标签使用不同颜色区分
- 卡片带轻阴影，hover时加深

**配色:**
- 卡片背景: 白色
- 悬赏金额: #F59E0B
- 进行中: #2563EB
- 已完成: #10B981
- 已过期: #94A3B8

### 5. 任务详情页 (TaskDetailPage)

**设计要点:**
- 顶部导航栏固定，白色背景
- 任务信息卡片突出显示
- 子任务使用时间线或网格布局
- 凭证上传区域使用图标+文字
- 底部操作栏固定，带阴影

**配色:**
- 导航栏: 白色
- 信息卡片: 白色，带中阴影
- 当前步骤: 主色调边框
- 已完成: 成功色
- 未解锁: 灰色

### 6. 个人中心 (MyPage)

**设计要点:**
- 顶部用户信息区域使用渐变背景
- 头像圆形，带白色边框
- 功能列表使用卡片式设计
- 退出按钮使用错误色

**配色:**
- 顶部背景: 主渐变
- 用户信息: 白色文字
- 功能卡片: 白色背景
- 退出按钮: 错误色

## 🎭 组件设计规范

### 按钮

**主要按钮:**
```
背景: 主渐变
文字: 白色
圆角: 8px
高度: 44px
阴影: 轻阴影
Hover: 加深阴影 + 轻微缩放(1.02)
```

**次要按钮:**
```
背景: 白色
文字: 主色调
边框: 1px 主色调
圆角: 8px
高度: 44px
Hover: 背景变为主色调5%透明度
```

### 卡片

```
背景: 白色
圆角: 16px
内边距: 16px
阴影: 轻阴影
Hover: 中阴影 + 轻微上移(-2px)
过渡: 200ms ease
```

### 输入框

```
背景: 白色
边框: 1px #E5E7EB
圆角: 8px
高度: 44px
内边距: 12px
Focus: 边框变为主色调，带外发光
```

### 标签

```
背景: 主色调10%透明度
文字: 主色调
圆角: 4px
内边距: 4px 8px
字号: 12px
```

## ✨ 动效规范

### 过渡时间

- 快速: 150ms - 小元素状态变化
- 标准: 200ms - 按钮、卡片hover
- 慢速: 300ms - 页面切换、模态框

### 缓动函数

- ease-out: 元素进入
- ease-in: 元素退出
- ease-in-out: 状态变化

### 常用动效

1. **按钮点击**: 轻微缩放(0.98) + 阴影变化
2. **卡片hover**: 上移(-2px) + 阴影加深
3. **页面切换**: 淡入淡出 + 轻微位移
4. **加载动画**: 旋转 + 渐变色变化

## 📐 布局规范

### 页面边距

- 移动端: 16px
- 平板: 24px
- 桌面: 32px

### 内容最大宽度

- 移动端: 100%
- 平板: 768px
- 桌面: 1200px

### 栅格系统

- 列数: 12列
- 间距: 16px

## ♿ 无障碍设计

1. **颜色对比度**: 所有文字与背景对比度 ≥ 4.5:1
2. **触摸目标**: 最小44x44px
3. **焦点状态**: 所有可交互元素有明显焦点样式
4. **语义化**: 使用正确的组件和属性

## 🚀 实施优先级

### Phase 1: 核心页面 (高优先级)
1. ✅ 启动页 - 品牌第一印象
2. ✅ 登录页 - 用户入口
3. ✅ 首页 - 主要导航

### Phase 2: 功能页面 (中优先级)
4. ✅ 任务页 - 核心功能
5. ✅ 任务详情页 - 核心交互
6. ✅ 个人中心 - 用户管理

### Phase 3: 辅助页面 (低优先级)
7. 商店页
8. 消息页

## 📝 设计检查清单

在完成每个页面后，请检查：

- [ ] 使用了正确的品牌色
- [ ] 圆角大小符合规范
- [ ] 阴影效果适当
- [ ] 间距统一
- [ ] 字体大小和粗细正确
- [ ] 所有交互元素有hover/active状态
- [ ] 过渡动画流畅
- [ ] 颜色对比度符合无障碍标准
- [ ] 触摸目标大小足够
- [ ] 响应式布局正常

## 🗄️ 数据模型设计

### 核心数据模型

#### 1. 用户模型 (UserInfo)

```typescript
interface UserInfo {
  userId: string;           // 用户ID
  username: string;         // 用户名
  nickname: string;         // 昵称
  avatar: string;           // 头像URL
  phone: string;            // 手机号
  email?: string;           // 邮箱（可选）
  points: number;           // 积分
  level: number;            // 等级
  createdAt: string;        // 注册时间
}
```

#### 2. 任务模型 (Task)

```typescript
interface Task {
  taskId: string;           // 任务ID
  title: string;            // 任务标题
  description: string;      // 任务描述
  reward: number;           // 悬赏金额
  status: TaskStatus;       // 任务状态
  creatorId: string;        // 发布者ID
  creatorName: string;      // 发布者昵称
  acceptorId?: string;      // 接受者ID（可选）
  acceptorName?: string;    // 接受者昵称（可选）
  category: string;         // 任务分类
  tags: string[];           // 任务标签
  deadline: string;         // 截止时间
  createdAt: string;        // 创建时间
  updatedAt: string;        // 更新时间
  subTasks: SubTask[];      // 子任务列表
  location?: string;        // 地点（可选）
  images?: string[];        // 图片列表（可选）
}

enum TaskStatus {
  PENDING = 'pending',      // 待接取
  IN_PROGRESS = 'in_progress', // 进行中
  COMPLETED = 'completed',  // 已完成
  EXPIRED = 'expired',      // 已过期
  CANCELLED = 'cancelled'   // 已取消
}
```

#### 3. 子任务模型 (SubTask)

```typescript
interface SubTask {
  subTaskId: string;        // 子任务ID
  title: string;            // 子任务标题
  description: string;      // 子任务描述
  status: SubTaskStatus;    // 子任务状态
  order: number;            // 排序序号
  isRequired: boolean;      // 是否必须完成
  proof?: Proof;            // 完成凭证（可选）
}

enum SubTaskStatus {
  LOCKED = 'locked',        // 未解锁
  UNLOCKED = 'unlocked',    // 已解锁
  IN_PROGRESS = 'in_progress', // 进行中
  COMPLETED = 'completed'   // 已完成
}
```

#### 4. 凭证模型 (Proof)

```typescript
interface Proof {
  proofId: string;          // 凭证ID
  type: ProofType;          // 凭证类型
  content: string;          // 凭证内容（图片URL或文本）
  uploadedAt: string;       // 上传时间
  status: ProofStatus;      // 审核状态
}

enum ProofType {
  IMAGE = 'image',          // 图片
  TEXT = 'text',            // 文本
  VIDEO = 'video'           // 视频
}

enum ProofStatus {
  PENDING = 'pending',      // 待审核
  APPROVED = 'approved',    // 已通过
  REJECTED = 'rejected'     // 已拒绝
}
```

#### 5. 商品模型 (Product)

```typescript
interface Product {
  productId: string;        // 商品ID
  name: string;             // 商品名称
  description: string;      // 商品描述
  price: number;            // 价格（积分）
  originalPrice?: number;   // 原价（可选）
  image: string;            // 商品图片
  category: string;         // 商品分类
  stock: number;            // 库存数量
  sales: number;            // 销量
  rating: number;           // 评分
  tags: string[];           // 商品标签
  isHot: boolean;           // 是否热门
  isNew: boolean;           // 是否新品
  createdAt: string;        // 上架时间
}
```

#### 6. 订单模型 (Order)

```typescript
interface Order {
  orderId: string;          // 订单ID
  userId: string;           // 用户ID
  productId: string;        // 商品ID
  productName: string;      // 商品名称
  productImage: string;     // 商品图片
  quantity: number;         // 数量
  totalPrice: number;       // 总价
  status: OrderStatus;      // 订单状态
  createdAt: string;        // 创建时间
  paidAt?: string;          // 支付时间（可选）
  deliveredAt?: string;     // 发货时间（可选）
}

enum OrderStatus {
  PENDING = 'pending',      // 待支付
  PAID = 'paid',            // 已支付
  DELIVERED = 'delivered',  // 已发货
  COMPLETED = 'completed',  // 已完成
  CANCELLED = 'cancelled'   // 已取消
}
```

#### 7. 消息模型 (Message)

```typescript
interface Message {
  messageId: string;        // 消息ID
  type: MessageType;        // 消息类型
  title: string;            // 消息标题
  content: string;          // 消息内容
  senderId?: string;        // 发送者ID（可选）
  senderName?: string;      // 发送者昵称（可选）
  senderAvatar?: string;    // 发送者头像（可选）
  receiverId: string;       // 接收者ID
  isRead: boolean;          // 是否已读
  createdAt: string;        // 创建时间
  relatedId?: string;       // 关联ID（任务ID或订单ID）
}

enum MessageType {
  SYSTEM = 'system',        // 系统消息
  TASK = 'task',            // 任务消息
  ORDER = 'order',          // 订单消息
  CHAT = 'chat'             // 聊天消息
}
```

### 数据存储策略

#### 本地存储 (Preferences)

用于存储用户登录状态和基本信息：

```typescript
// 存储键名规范
const STORAGE_KEYS = {
  IS_LOGGED_IN: 'is_logged_in',
  USER_INFO: 'user_info',
  TOKEN: 'token',
  LAST_LOGIN_TIME: 'last_login_time'
};
```

#### 内存缓存

用于存储临时数据和频繁访问的数据：

```typescript
// 缓存管理器
class CacheManager {
  private cache: Map<string, CacheItem>;
  private maxAge: number = 5 * 60 * 1000; // 5分钟

  set(key: string, value: any, ttl?: number): void;
  get(key: string): any | null;
  clear(): void;
}
```

#### 远程数据

通过API获取的数据，需要实现：
- 请求缓存
- 数据预加载
- 离线支持

## 🏗️ 技术架构规范

### 项目结构

```
DoForMe/
├── features/                    # 功能模块
│   ├── Login/                   # 登录模块
│   │   ├── src/main/ets/
│   │   │   ├── pages/          # 页面
│   │   │   ├── models/         # 数据模型
│   │   │   └── utils/          # 工具类
│   │   └── Index.ets           # 模块导出
│   ├── Home/                    # 主页模块
│   │   ├── src/main/ets/
│   │   │   ├── pages/          # 页面（HomePage, TaskPage, ShopPage等）
│   │   │   ├── components/     # 组件
│   │   │   ├── models/         # 数据模型
│   │   │   ├── services/       # 服务层
│   │   │   └── utils/          # 工具类
│   │   └── Index.ets
│   └── ...
├── products/entry/              # 主应用入口
│   └── src/main/ets/
│       ├── pages/              # 页面入口
│       ├── entryability/       # Ability
│       └── resources/          # 资源文件
└── common/                      # 公共模块（待创建）
    ├── constants/              # 常量定义
    ├── models/                 # 公共数据模型
    ├── services/               # 公共服务
    └── utils/                  # 公共工具
```

### 分层架构

#### 1. 表现层 (Presentation Layer)

**职责**: UI渲染和用户交互

```typescript
// 页面组件
@Component
export struct TaskPage {
  @State tasks: Task[] = [];
  private taskService = TaskService.getInstance();

  aboutToAppear() {
    this.loadTasks();
  }

  async loadTasks() {
    this.tasks = await this.taskService.getTasks();
  }

  build() {
    // UI代码
  }
}
```

**规范**:
- 使用 `@State` 管理组件状态
- 使用 `@Prop` 接收父组件传递的数据
- 使用 `@Link` 实现双向绑定
- 避免在组件中直接处理业务逻辑
- 所有数据操作通过Service层

#### 2. 服务层 (Service Layer)

**职责**: 业务逻辑和数据处理

```typescript
// 任务服务
export class TaskService {
  private static instance: TaskService;
  private apiService = ApiService.getInstance();
  private cacheManager = CacheManager.getInstance();

  static getInstance(): TaskService {
    if (!TaskService.instance) {
      TaskService.instance = new TaskService();
    }
    return TaskService.instance;
  }

  async getTasks(filter?: TaskFilter): Promise<Task[]> {
    // 1. 检查缓存
    const cacheKey = `tasks_${JSON.stringify(filter)}`;
    const cached = this.cacheManager.get(cacheKey);
    if (cached) return cached;

    // 2. 请求API
    const tasks = await this.apiService.get<Task[]>('/tasks', filter);

    // 3. 更新缓存
    this.cacheManager.set(cacheKey, tasks);

    return tasks;
  }

  async createTask(task: Partial<Task>): Promise<Task> {
    const newTask = await this.apiService.post<Task>('/tasks', task);
    this.cacheManager.clear(); // 清除缓存
    return newTask;
  }
}
```

**规范**:
- 使用单例模式
- 统一错误处理
- 实现数据缓存
- 提供清晰的API接口

#### 3. 数据层 (Data Layer)

**职责**: 数据获取和持久化

```typescript
// API服务
export class ApiService {
  private static instance: ApiService;
  private baseUrl = 'https://api.doforme.com';
  private token: string = '';

  static getInstance(): ApiService {
    if (!ApiService.instance) {
      ApiService.instance = new ApiService();
    }
    return ApiService.instance;
  }

  setToken(token: string) {
    this.token = token;
  }

  async get<T>(endpoint: string, params?: any): Promise<T> {
    const url = this.buildUrl(endpoint, params);
    const response = await fetch(url, {
      method: 'GET',
      headers: this.getHeaders()
    });
    return this.handleResponse<T>(response);
  }

  async post<T>(endpoint: string, data: any): Promise<T> {
    const response = await fetch(this.baseUrl + endpoint, {
      method: 'POST',
      headers: this.getHeaders(),
      body: JSON.stringify(data)
    });
    return this.handleResponse<T>(response);
  }

  private getHeaders(): Record<string, string> {
    return {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${this.token}`
    };
  }

  private async handleResponse<T>(response: Response): Promise<T> {
    if (!response.ok) {
      throw new Error(`API Error: ${response.status}`);
    }
    const data = await response.json();
    return data as T;
  }

  private buildUrl(endpoint: string, params?: any): string {
    const url = new URL(this.baseUrl + endpoint);
    if (params) {
      Object.keys(params).forEach(key => {
        url.searchParams.append(key, params[key]);
      });
    }
    return url.toString();
  }
}
```

**规范**:
- 统一的请求封装
- 自动添加认证信息
- 统一的错误处理
- 支持请求拦截和响应拦截

### 状态管理

#### 本地状态

使用 `@State` 管理组件内部状态：

```typescript
@Component
struct MyComponent {
  @State count: number = 0;

  build() {
    Button(`Count: ${this.count}`)
      .onClick(() => this.count++)
  }
}
```

#### 全局状态

使用单例Service管理全局状态：

```typescript
// 全局状态管理
export class AppState {
  private static instance: AppState;
  private listeners: Map<string, Function[]> = new Map();

  private _userInfo: UserInfo | null = null;
  private _unreadCount: number = 0;

  static getInstance(): AppState {
    if (!AppState.instance) {
      AppState.instance = new AppState();
    }
    return AppState.instance;
  }

  get userInfo(): UserInfo | null {
    return this._userInfo;
  }

  set userInfo(value: UserInfo | null) {
    this._userInfo = value;
    this.notify('userInfo', value);
  }

  subscribe(key: string, callback: Function) {
    if (!this.listeners.has(key)) {
      this.listeners.set(key, []);
    }
    this.listeners.get(key)?.push(callback);
  }

  private notify(key: string, value: any) {
    this.listeners.get(key)?.forEach(callback => callback(value));
  }
}
```

### 路由管理

```typescript
// 路由配置
export const ROUTES = {
  INDEX: 'pages/Index',
  LOGIN: 'pages/LoginPage',
  HOME: 'pages/HomePage',
  TASK_DETAIL: 'pages/TaskDetailPage',
  PROFILE: 'pages/ProfilePage'
};

// 路由工具
export class RouterUtil {
  static push(url: string, params?: any) {
    router.pushUrl({ url, params });
  }

  static replace(url: string, params?: any) {
    router.replaceUrl({ url, params });
  }

  static back() {
    router.back();
  }

  static getParams(): any {
    return router.getParams();
  }
}
```

### 错误处理

```typescript
// 错误类型
export enum ErrorType {
  NETWORK = 'network',
  AUTH = 'auth',
  VALIDATION = 'validation',
  UNKNOWN = 'unknown'
}

// 错误处理器
export class ErrorHandler {
  static handle(error: Error, type: ErrorType = ErrorType.UNKNOWN) {
    console.error(`[${type}] ${error.message}`);

    // 显示错误提示
    promptAction.showToast({
      message: this.getErrorMessage(error, type),
      duration: 2000
    });

    // 特殊错误处理
    if (type === ErrorType.AUTH) {
      // 跳转到登录页
      RouterUtil.replace(ROUTES.LOGIN);
    }
  }

  private static getErrorMessage(error: Error, type: ErrorType): string {
    switch (type) {
      case ErrorType.NETWORK:
        return '网络连接失败，请检查网络设置';
      case ErrorType.AUTH:
        return '登录已过期，请重新登录';
      case ErrorType.VALIDATION:
        return '输入信息有误，请检查后重试';
      default:
        return error.message || '操作失败，请稍后重试';
    }
  }
}
```

### 性能优化

#### 1. 懒加载

```typescript
// 延迟加载组件
@Component
struct LazyList {
  @State items: any[] = [];
  private pageSize = 20;
  private currentPage = 0;

  aboutToAppear() {
    this.loadMore();
  }

  async loadMore() {
    const newItems = await this.fetchItems(this.currentPage, this.pageSize);
    this.items = [...this.items, ...newItems];
    this.currentPage++;
  }

  build() {
    List() {
      ForEach(this.items, (item: any) => {
        ListItem() {
          // 渲染项
        }
      })
    }
    .onReachEnd(() => {
      this.loadMore();
    })
  }
}
```

#### 2. 图片优化

```typescript
// 图片加载优化
Image(url)
  .objectFit(ImageFit.Cover)
  .interpolation(ImageInterpolation.High)
  .renderMode(ImageRenderMode.Original)
  .alt($r('app.media.placeholder')) // 占位图
```

#### 3. 防抖和节流

```typescript
// 防抖函数
export function debounce(fn: Function, delay: number = 300) {
  let timer: number | null = null;
  return function(...args: any[]) {
    if (timer) clearTimeout(timer);
    timer = setTimeout(() => fn(...args), delay);
  };
}

// 节流函数
export function throttle(fn: Function, delay: number = 300) {
  let lastTime = 0;
  return function(...args: any[]) {
    const now = Date.now();
    if (now - lastTime >= delay) {
      fn(...args);
      lastTime = now;
    }
  };
}
```

### 代码规范

#### 命名规范

- **文件名**: PascalCase (如: `TaskPage.ets`, `UserManager.ets`)
- **组件名**: PascalCase (如: `TaskCard`, `UserAvatar`)
- **变量名**: camelCase (如: `userName`, `taskList`)
- **常量名**: UPPER_SNAKE_CASE (如: `MAX_COUNT`, `API_BASE_URL`)
- **接口名**: PascalCase (如: `UserInfo`, `TaskFilter`)
- **枚举名**: PascalCase (如: `TaskStatus`, `MessageType`)

#### 注释规范

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

#### 代码组织

```typescript
// 1. 导入语句
import { router } from '@kit.ArkUI';
import { TaskService } from '../services/TaskService';

// 2. 类型定义
interface TaskFilter {
  status?: TaskStatus;
  category?: string;
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

### 测试规范

#### 单元测试

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
});
```

### 安全规范

1. **输入验证**: 所有用户输入必须验证
2. **XSS防护**: 避免直接渲染用户输入的HTML
3. **敏感信息**: 不在代码中硬编码密钥和密码
4. **HTTPS**: 所有API请求使用HTTPS
5. **Token管理**: 安全存储和传输认证Token

---

**设计系统版本**: 1.0
**最后更新**: 2026-02-01
