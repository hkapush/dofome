import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

// 消息类型
enum ChatMessageType {
  TEXT = 'text',
  IMAGE = 'image',
  LOCATION = 'location',
  TASK = 'task'  // 任务卡片
}

// 聊天消息
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

@Entry
@Component
struct ChatPage {
  @State messages: ChatMessage[] = [];
  @State inputText: string = '';
  @State friendId: string = '';
  @State friendName: string = '';
  @State friendAvatar: string = '';
  @State isOnline: boolean = true;
  private scroller: Scroller = new Scroller();

  aboutToAppear() {
    // 从路由参数获取好友信息
    const params = router.getParams() as Record<string, string>;
    this.friendId = params['friendId'] || 'user_001';
    this.friendName = params['friendName'] || '小明';
    this.friendAvatar = params['friendAvatar'] || '';

    // 加载历史消息
    this.loadMessages();
  }

  async loadMessages() {
    // 模拟加载历史消息
    this.messages = [
      {
        messageId: '1',
        senderId: this.friendId,
        senderName: this.friendName,
        senderAvatar: this.friendAvatar,
        type: ChatMessageType.TEXT,
        content: '你好，关于这个任务我想了解一下',
        timestamp: Date.now() - 300000,
        isSelf: false
      },
      {
        messageId: '2',
        senderId: 'me',
        senderName: '我',
        senderAvatar: '',
        type: ChatMessageType.TEXT,
        content: '好的，你想了解什么呢？',
        timestamp: Date.now() - 240000,
        isSelf: true
      },
      {
        messageId: '3',
        senderId: this.friendId,
        senderName: this.friendName,
        senderAvatar: this.friendAvatar,
        type: ChatMessageType.TEXT,
        content: '具体的时间和地点是？',
        timestamp: Date.now() - 180000,
        isSelf: false
      }
    ];

    // 滚动到底部
    setTimeout(() => {
      this.scroller.scrollEdge(Edge.Bottom);
    }, 100);
  }

  handleSendMessage() {
    if (!this.inputText.trim()) {
      return;
    }

    const newMessage: ChatMessage = {
      messageId: Date.now().toString(),
      senderId: 'me',
      senderName: '我',
      senderAvatar: '',
      type: ChatMessageType.TEXT,
      content: this.inputText,
      timestamp: Date.now(),
      isSelf: true
    };

    this.messages.push(newMessage);
    this.inputText = '';

    // 滚动到底部
    setTimeout(() => {
      this.scroller.scrollEdge(Edge.Bottom);
    }, 100);

    // 模拟对方回复
    setTimeout(() => {
      this.simulateReply();
    }, 2000);
  }

  simulateReply() {
    const replies = [
      '好的，我明白了',
      '没问题',
      '那我们就这样定了',
      '谢谢！'
    ];
    const randomReply = replies[Math.floor(Math.random() * replies.length)];

    const replyMessage: ChatMessage = {
      messageId: Date.now().toString(),
      senderId: this.friendId,
      senderName: this.friendName,
      senderAvatar: this.friendAvatar,
      type: ChatMessageType.TEXT,
      content: randomReply,
      timestamp: Date.now(),
      isSelf: false
    };

    this.messages.push(replyMessage);

    setTimeout(() => {
      this.scroller.scrollEdge(Edge.Bottom);
    }, 100);
  }

  handleMoreActions() {
    promptAction.showDialog({
      title: '更多功能',
      message: '选择操作',
      buttons: [
        { text: '查看TA的任务', color: '#E11D48' },
        { text: '发布任务给TA', color: '#2563EB' },
        { text: '发送图片', color: '#10B981' },
        { text: '取消', color: '#94A3B8' }
      ]
    }).then((result) => {
      if (result.index === 0) {
        // 查看对方的任务
        router.pushUrl({
          url: 'pages/UserTasksPage',
          params: {
            userId: this.friendId,
            userName: this.friendName
          }
        });
      } else if (result.index === 1) {
        // 发布任务给对方
        router.pushUrl({
          url: 'pages/CreateTaskPage',
          params: {
            targetUserId: this.friendId,
            targetUserName: this.friendName,
            isDirectTask: 'true'
          }
        });
      } else if (result.index === 2) {
        promptAction.showToast({
          message: '发送图片功能开发中',
          duration: 2000
        });
      }
    });
  }

  formatTime(timestamp: number): string {
    const date = new Date(timestamp);
    const now = new Date();
    const diff = now.getTime() - timestamp;

    // 如果是今天
    if (date.toDateString() === now.toDateString()) {
      const hours = date.getHours().toString().padStart(2, '0');
      const minutes = date.getMinutes().toString().padStart(2, '0');
      return `${hours}:${minutes}`;
    }

    // 如果是昨天
    const yesterday = new Date(now);
    yesterday.setDate(yesterday.getDate() - 1);
    if (date.toDateString() === yesterday.toDateString()) {
      const hours = date.getHours().toString().padStart(2, '0');
      const minutes = date.getMinutes().toString().padStart(2, '0');
      return `昨天 ${hours}:${minutes}`;
    }

    // 其他日期
    const month = (date.getMonth() + 1).toString();
    const day = date.getDate().toString();
    const hours = date.getHours().toString().padStart(2, '0');
    const minutes = date.getMinutes().toString().padStart(2, '0');
    return `${month}月${day}日 ${hours}:${minutes}`;
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Row() {
          Text('←')
            .fontSize(24)
            .fontColor('#1F2937')
        }
        .width(40)
        .height(40)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          router.back();
        })

        Column() {
          Text(this.friendName)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#881337')

          Row() {
            if (this.isOnline) {
              Circle()
                .width(6)
                .height(6)
                .fill('#10B981')
                .margin({ right: 4 })
            }
            Text(this.isOnline ? '在线' : '离线')
              .fontSize(12)
              .fontColor('#94A3B8')
          }
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 8 })

        Row() {
          Text('⋯')
            .fontSize(24)
            .fontColor('#1F2937')
        }
        .width(40)
        .height(40)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.handleMoreActions();
        })
      }
      .width('100%')
      .height(56)
      .padding({ left: 8, right: 8 })
      .backgroundColor('#FFFFFF')
      .shadow({ radius: 4, color: 'rgba(0, 0, 0, 0.05)', offsetY: 2 })

      // 消息列表
      Scroll(this.scroller) {
        Column() {
          ForEach(this.messages, (message: ChatMessage, index: number) => {
            Column() {
              // 显示时间（如果与上一条消息间隔超过5分钟）
              if (index === 0 || message.timestamp - this.messages[index - 1].timestamp > 300000) {
                Text(this.formatTime(message.timestamp))
                  .fontSize(12)
                  .fontColor('#94A3B8')
                  .margin({ top: 16, bottom: 8 })
              }

              // 消息气泡
              if (message.isSelf) {
                this.SelfMessageBubble(message)
              } else {
                this.OtherMessageBubble(message)
              }
            }
            .width('100%')
          })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      }
      .layoutWeight(1)
      .backgroundColor('#F8FAFC')
      .scrollBar(BarState.Off)

      // 底部输入栏
      Row() {
        TextInput({ text: this.inputText, placeholder: '说点什么...' })
          .height(40)
          .backgroundColor('#F1F5F9')
          .borderRadius(20)
          .layoutWeight(1)
          .onChange((value: string) => {
            this.inputText = value;
          })

        Button('发送')
          .height(40)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#FFFFFF')
          .backgroundColor('#E11D48')
          .borderRadius(20)
          .margin({ left: 8 })
          .onClick(() => {
            this.handleSendMessage();
          })
      }
      .width('100%')
      .padding(12)
      .backgroundColor('#FFFFFF')
      .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.1)', offsetY: -2 })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  SelfMessageBubble(message: ChatMessage) {
    Row() {
      Blank()

      Column() {
        Text(message.content)
          .fontSize(15)
          .fontColor('#FFFFFF')
          .lineHeight(22)
      }
      .padding(12)
      .backgroundColor('#E11D48')
      .borderRadius(12)
      .constraintSize({ maxWidth: '70%' })

      Circle()
        .width(36)
        .height(36)
        .fill('#FFF1F2')
        .margin({ left: 8 })
    }
    .width('100%')
    .margin({ bottom: 12 })
  }

  @Builder
  OtherMessageBubble(message: ChatMessage) {
    Row() {
      Circle()
        .width(36)
        .height(36)
        .fill('#F1F5F9')
        .margin({ right: 8 })

      Column() {
        Text(message.content)
          .fontSize(15)
          .fontColor('#1F2937')
          .lineHeight(22)
      }
      .padding(12)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .constraintSize({ maxWidth: '70%' })
      .shadow({ radius: 4, color: 'rgba(0, 0, 0, 0.05)', offsetY: 1 })

      Blank()
    }
    .width('100%')
    .margin({ bottom: 12 })
  }
}
