import { Message, MessageType } from '../models/Message';

/**
 * 消息服务类
 * 负责处理消息相关的业务逻辑
 */
export class MessageService {
  private static instance: MessageService;

  private constructor() {}

  static getInstance(): MessageService {
    if (!MessageService.instance) {
      MessageService.instance = new MessageService();
    }
    return MessageService.instance;
  }

  /**
   * 获取消息列表
   * @param type 消息类型（可选）
   * @returns 消息列表
   */
  async getMessages(type?: MessageType): Promise<Message[]> {
    // 模拟网络延迟
    await new Promise<void>((resolve) => setTimeout(resolve, 500));

    // 模拟数据
    const allMessages: Message[] = [
      {
        messageId: '1',
        type: MessageType.SYSTEM,
        title: '系统通知',
        content: '欢迎使用DoForMe！完成新手任务可获得100积分奖励',
        receiverId: '10001',
        isRead: false,
        createdAt: '2026-02-01 10:30:00'
      },
      {
        messageId: '2',
        type: MessageType.TASK,
        title: '任务提醒',
        content: '您发布的任务"帮我买杯咖啡"已被接取',
        senderId: '10002',
        senderName: '小明',
        senderAvatar: '',
        receiverId: '10001',
        isRead: false,
        createdAt: '2026-02-01 09:15:00',
        relatedId: 'task_001'
      },
      {
        messageId: '3',
        type: MessageType.TASK,
        title: '任务完成',
        content: '您接取的任务"帮我取快递"已完成，获得50积分',
        receiverId: '10001',
        isRead: true,
        createdAt: '2026-01-31 18:20:00',
        relatedId: 'task_002'
      },
      {
        messageId: '4',
        type: MessageType.ORDER,
        title: '订单通知',
        content: '您兑换的"无线蓝牙耳机"已发货，请注意查收',
        receiverId: '10001',
        isRead: true,
        createdAt: '2026-01-31 14:00:00',
        relatedId: 'order_001'
      },
      {
        messageId: '5',
        type: MessageType.CHAT,
        title: '新消息',
        content: '任务详情可以再说明一下吗？',
        senderId: '10003',
        senderName: '小红',
        senderAvatar: '',
        receiverId: '10001',
        isRead: false,
        createdAt: '2026-01-31 11:30:00'
      },
      {
        messageId: '6',
        type: MessageType.SYSTEM,
        title: '活动通知',
        content: '周末积分翻倍活动开始啦！完成任务可获得双倍积分',
        receiverId: '10001',
        isRead: true,
        createdAt: '2026-01-30 08:00:00'
      }
    ];

    // 根据类型过滤
    if (type) {
      return allMessages.filter(m => m.type === type);
    }

    return allMessages;
  }

  /**
   * 获取未读消息数量
   * @returns 未读消息数量
   */
  async getUnreadCount(): Promise<number> {
    const messages = await this.getMessages();
    return messages.filter(m => !m.isRead).length;
  }

  /**
   * 标记消息为已读
   * @param messageId 消息ID
   */
  async markAsRead(messageId: string): Promise<void> {
    // 模拟网络延迟
    await new Promise<void>((resolve) => setTimeout(resolve, 300));
    console.log(`消息 ${messageId} 已标记为已读`);
  }

  /**
   * 标记所有消息为已读
   */
  async markAllAsRead(): Promise<void> {
    // 模拟网络延迟
    await new Promise<void>((resolve) => setTimeout(resolve, 500));
    console.log('所有消息已标记为已读');
  }

  /**
   * 删除消息
   * @param messageId 消息ID
   */
  async deleteMessage(messageId: string): Promise<void> {
    // 模拟网络延迟
    await new Promise<void>((resolve) => setTimeout(resolve, 300));
    console.log(`消息 ${messageId} 已删除`);
  }
}
