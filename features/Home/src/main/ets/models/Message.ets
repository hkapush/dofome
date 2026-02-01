/**
 * 消息模型
 */
export interface Message {
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

/**
 * 消息类型
 */
export enum MessageType {
  SYSTEM = 'system',        // 系统消息
  TASK = 'task',            // 任务消息
  ORDER = 'order',          // 订单消息
  CHAT = 'chat'             // 聊天消息
}
