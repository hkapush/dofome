import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

// 群聊消息
interface GroupMessage {
  messageId: string;
  senderId: string;
  senderName: string;
  senderAvatar: string;
  content: string;
  timestamp: number;
  isSelf: boolean;
}

@Entry
@Component
struct GroupChatPage {
  @State teamId: string = '';
  @State teamName: string = '';
  @State messages: GroupMessage[] = [];
  @State inputText: string = '';
  private scroller: Scroller = new Scroller();

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    this.teamId = params['teamId'] || '';
    this.teamName = params['teamName'] || '';
    this.loadMessages();
  }

  async loadMessages() {
    // 模拟加载群聊消息
    this.messages = [
      {
        messageId: '1',
        senderId: 'user_001',
        senderName: '爸爸',
        senderAvatar: '',
        content: '大家周末有空吗？',
        timestamp: Date.now() - 300000,
        isSelf: false
      },
      {
        messageId: '2',
        senderId: 'user_002',
        senderName: '妈妈',
        senderAvatar: '',
        content: '我有空',
        timestamp: Date.now() - 240000,
        isSelf: false
      },
      {
        messageId: '3',
        senderId: 'me',
        senderName: '我',
        senderAvatar: '',
        content: '我也有空！',
        timestamp: Date.now() - 180000,
        isSelf: true
      }
    ];

    setTimeout(() => {
      this.scroller.scrollEdge(Edge.Bottom);
    }, 100);
  }

  handleSendMessage() {
    if (!this.inputText.trim()) {
      return;
    }

    const newMessage: GroupMessage = {
      messageId: Date.now().toString(),
      senderId: 'me',
      senderName: '我',
      senderAvatar: '',
      content: this.inputText,
      timestamp: Date.now(),
      isSelf: true
    };

    this.messages.push(newMessage);
    this.inputText = '';

    setTimeout(() => {
      this.scroller.scrollEdge(Edge.Bottom);
    }, 100);
  }

  handleTeamInfo() {
    router.back();
  }

  formatTime(timestamp: number): string {
    const date = new Date(timestamp);
    const now = new Date();
    const diff = now.getTime() - timestamp;

    if (date.toDateString() === now.toDateString()) {
      const hours = date.getHours().toString().padStart(2, '0');
      const minutes = date.getMinutes().toString().padStart(2, '0');
      return `${hours}:${minutes}`;
    }

    const yesterday = new Date(now);
    yesterday.setDate(yesterday.getDate() - 1);
    if (date.toDateString() === yesterday.toDateString()) {
      const hours = date.getHours().toString().padStart(2, '0');
      const minutes = date.getMinutes().toString().padStart(2, '0');
      return `昨天 ${hours}:${minutes}`;
    }

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
          Text(this.teamName)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#881337')

          Text('群聊')
            .fontSize(12)
            .fontColor('#94A3B8')
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 8 })

        Row() {
          Text('👥')
            .fontSize(20)
        }
        .width(40)
        .height(40)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.handleTeamInfo();
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
          ForEach(this.messages, (message: GroupMessage, index: number) => {
            Column() {
              // 显示时间
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
  SelfMessageBubble(message: GroupMessage) {
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
  OtherMessageBubble(message: GroupMessage) {
    Column() {
      // 发送者名称
      Text(message.senderName)
        .fontSize(12)
        .fontColor('#94A3B8')
        .margin({ left: 44, bottom: 4 })

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
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .margin({ bottom: 12 })
  }
}
