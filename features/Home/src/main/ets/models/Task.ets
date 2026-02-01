/**
 * 任务状态
 */
export enum TaskStatus {
  PENDING = 'pending',      // 待接取
  IN_PROGRESS = 'in_progress', // 进行中
  COMPLETED = 'completed',  // 已完成
  EXPIRED = 'expired',      // 已过期
  CANCELLED = 'cancelled'   // 已取消
}

/**
 * 子任务状态
 */
export enum SubTaskStatus {
  LOCKED = 'locked',        // 未解锁
  UNLOCKED = 'unlocked',    // 已解锁
  IN_PROGRESS = 'in_progress', // 进行中
  COMPLETED = 'completed'   // 已完成
}

/**
 * 凭证类型
 */
export enum ProofType {
  IMAGE = 'image',          // 图片
  TEXT = 'text',            // 文本
  VIDEO = 'video',          // 视频
  LOCATION = 'location',    // 位置
  FILE = 'file'             // 文件
}

/**
 * 凭证状态
 */
export enum ProofStatus {
  PENDING = 'pending',      // 待审核
  APPROVED = 'approved',    // 已通过
  REJECTED = 'rejected'     // 已拒绝
}

/**
 * 执行模式
 */
export enum ExecutionMode {
  SEQUENTIAL = 'sequential', // 顺序执行
  FREE = 'free'              // 自由执行
}

/**
 * 凭证模型
 */
export interface Proof {
  proofId?: string;         // 凭证ID
  type: ProofType;          // 凭证类型
  content: string;          // 凭证内容（图片URL或文本）
  uploadedAt?: string;      // 上传时间
  status?: ProofStatus;     // 审核状态
  timestamp?: number;       // 时间戳
}

/**
 * 子任务模型
 */
export interface SubTask {
  subTaskId: string;        // 子任务ID
  id?: string;              // 兼容旧版ID字段
  title: string;            // 子任务标题
  description: string;      // 子任务描述
  status: SubTaskStatus;    // 子任务状态
  order: number;            // 排序序号
  isRequired?: boolean;     // 是否必须完成
  proof?: Proof;            // 完成凭证（可选）
  proofs?: Proof[];         // 凭证列表（兼容旧版）
}

/**
 * 任务模型
 */
export interface Task {
  taskId: string;           // 任务ID
  id?: string;              // 兼容旧版ID字段
  title: string;            // 任务标题
  description: string;      // 任务描述
  reward: number;           // 悬赏金额
  currencyType?: string;    // 货币类型
  status: TaskStatus;       // 任务状态
  creatorId?: string;       // 发布者ID
  creatorName?: string;     // 发布者昵称
  publisherName?: string;   // 发布者昵称（兼容旧版）
  publisherAvatar?: string; // 发布者头像
  acceptorId?: string;      // 接受者ID（可选）
  acceptorName?: string;    // 接受者昵称（可选）
  category: string;         // 任务分类
  tags?: string[];          // 任务标签
  deadline: string | number;// 截止时间
  createdAt?: string;       // 创建时间
  updatedAt?: string;       // 更新时间
  subTasks: SubTask[];      // 子任务列表
  subtasks?: SubTask[];     // 子任务列表（兼容旧版）
  location?: string;        // 地点（可选）
  images?: string[];        // 图片列表（可选）
  executionMode?: ExecutionMode; // 执行模式
}

/**
 * 任务筛选条件
 */
export interface TaskFilter {
  status?: TaskStatus;      // 任务状态
  category?: string;        // 任务分类
  minReward?: number;       // 最低悬赏
  maxReward?: number;       // 最高悬赏
  keyword?: string;         // 关键词搜索
}
