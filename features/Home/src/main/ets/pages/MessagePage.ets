import { promptAction } from '@kit.ArkUI';
import { router } from '@kit.ArkUI';

// 好友消息
interface FriendMessage {
  messageId: string;
  friendId: string;
  friendName: string;
  friendAvatar: string;
  lastMessage: string;
  lastMessageTime: string;
  unreadCount: number;
  isOnline: boolean;
}

// 商店消息
interface StoreMessage {
  messageId: string;
  storeId: string;
  storeName: string;
  storeAvatar: string;
  messageType: 'order' | 'redemption' | 'notification';
  content: string;
  time: string;
  isRead: boolean;
  isMyStore: boolean; // 是否是自己的商店
}

@Component
export struct MessagePage {
  @State currentTab: number = 0; // 0: 好友消息, 1: 商店消息
  @State friendMessages: FriendMessage[] = [];
  @State storeMessages: StoreMessage[] = [];
  @State loading: boolean = false;
  @State friendUnreadCount: number = 0;
  @State storeUnreadCount: number = 0;

  aboutToAppear() {
    this.loadFriendMessages();
    this.loadStoreMessages();
  }

  async loadFriendMessages() {
    this.loading = true;
    await new Promise<void>((resolve) => setTimeout(resolve, 500));

    this.friendMessages = [
      {
        messageId: '1',
        friendId: 'user_001',
        friendName: '小明',
        friendAvatar: '',
        lastMessage: '任务完成了吗？',
        lastMessageTime: '2026-02-01 14:30:00',
        unreadCount: 2,
        isOnline: true
      },
      {
        messageId: '2',
        friendId: 'user_002',
        friendName: '小红',
        friendAvatar: '',
        lastMessage: '明天一起去吃饭吧',
        lastMessageTime: '2026-02-01 12:15:00',
        unreadCount: 0,
        isOnline: false
      },
      {
        messageId: '3',
        friendId: 'user_003',
        friendName: '小李',
        friendAvatar: '',
        lastMessage: '好的，收到了',
        lastMessageTime: '2026-01-31 18:20:00',
        unreadCount: 0,
        isOnline: true
      }
    ];

    this.updateUnreadCounts();
    this.loading = false;
  }

  async loadStoreMessages() {
    // 商店消息包含：自己发布的商店消息 + 他人商店的消费消息
    this.storeMessages = [
      // 自己的商店消息（顶部）
      {
        messageId: 's1',
        storeId: 'my_store',
        storeName: '我的小店',
        storeAvatar: '',
        messageType: 'order',
        content: '小明兑换了"咖啡券"，请及时核销',
        time: '2026-02-01 15:00:00',
        isRead: false,
        isMyStore: true
      },
      {
        messageId: 's2',
        storeId: 'my_store',
        storeName: '我的小店',
        storeAvatar: '',
        messageType: 'redemption',
        content: '小红的兑换码已核销，订单已完成',
        time: '2026-02-01 10:30:00',
        isRead: true,
        isMyStore: true
      },
      // 他人商店的消费消息
      {
        messageId: 's4',
        storeId: 'store_001',
        storeName: '星巴克咖啡',
        storeAvatar: '',
        messageType: 'order',
        content: '您兑换的"拿铁咖啡券"已生成，兑换码：ABC123',
        time: '2026-02-01 14:20:00',
        isRead: false,
        isMyStore: false
      },
      {
        messageId: 's5',
        storeId: 'store_002',
        storeName: '万达影城',
        storeAvatar: '',
        messageType: 'redemption',
        content: '您的"电影票"已核销，祝您观影愉快',
        time: '2026-01-31 18:00:00',
        isRead: true,
        isMyStore: false
      },
      {
        messageId: 's6',
        storeId: 'store_001',
        storeName: '星巴克咖啡',
        storeAvatar: '',
        messageType: 'notification',
        content: '您有一张"美式咖啡券"即将过期，请尽快使用',
        time: '2026-01-30 09:00:00',
        isRead: true,
        isMyStore: false
      },
      {
        messageId: 's3',
        storeId: 'my_store',
        storeName: '我的小店',
        storeAvatar: '',
        messageType: 'notification',
        content: '您的商品"电影票"库存不足，请及时补货',
        time: '2026-01-31 16:00:00',
        isRead: true,
        isMyStore: true
      }
    ];

    // 排序：自己的商店消息在前，他人商店消息在后
    this.storeMessages.sort((a, b) => {
      if (a.isMyStore && !b.isMyStore) return -1;
      if (!a.isMyStore && b.isMyStore) return 1;
      return new Date(b.time).getTime() - new Date(a.time).getTime();
    });

    this.updateUnreadCounts();
  }

  updateUnreadCounts() {
    this.friendUnreadCount = this.friendMessages.reduce((sum, msg) => sum + msg.unreadCount, 0);
    this.storeUnreadCount = this.storeMessages.filter(msg => !msg.isRead).length;
  }

  getTotalUnreadCount(): number {
    return this.friendMessages.reduce((sum, msg) => sum + msg.unreadCount, 0) +
      this.storeMessages.filter(msg => !msg.isRead).length;
  }

  handleFriendClick(friend: FriendMessage) {
    // 跳转到聊天页面
    router.pushUrl({
      url: 'pages/ChatPage',
      params: {
        friendId: friend.friendId,
        friendName: friend.friendName,
        friendAvatar: friend.friendAvatar
      }
    });
  }

  handleStoreMessageClick(message: StoreMessage) {
    if (message.isMyStore) {
      // 自己店铺的消息，点击跳转到店铺管理
      router.pushUrl({
        url: 'pages/MyStorePage',
        params: {
          storeId: message.storeId,
          tab: message.messageType === 'order' ? '1' : '0' // 订单消息跳转到订单管理tab
        }
      });
    } else {
      // 他人商店的消息，点击跳转到"我在该商店的消费记录"页面
      router.pushUrl({
        url: 'pages/MyPurchasesInStorePage',
        params: {
          storeId: message.storeId,
          storeName: message.storeName
        }
      });
    }
  }

  handleAddClick() {
    promptAction.showDialog({
      title: '添加',
      message: '选择要添加的内容',
      buttons: [
        { text: '添加好友', color: '#2563EB' },
        { text: '创建团队', color: '#10B981' },
        { text: '取消', color: '#94A3B8' }
      ]
    }, (err, data) => {
      if (data.index === 0) {
        // 添加好友
        router.pushUrl({ url: 'pages/AddFriendPage' });
      } else if (data.index === 1) {
        // 创建团队
        router.pushUrl({ url: 'pages/CreateTeamPage' });
      }
    });
  }

  handleContactsClick() {
    router.pushUrl({ url: 'pages/ContactsPage' });
  }

  getMessageTypeLabel(type: string): string {
    switch (type) {
      case 'order':
        return '订单';
      case 'redemption':
        return '兑换';
      case 'notification':
        return '通知';
      default:
        return '';
    }
  }

  getMessageTypeColor(type: string): string {
    switch (type) {
      case 'order':
        return '#F59E0B';
      case 'redemption':
        return '#10B981';
      case 'notification':
        return '#2563EB';
      default:
        return '#94A3B8';
    }
  }

  formatTime(timeStr: string): string {
    const now = new Date();
    const time = new Date(timeStr);
    const diff = now.getTime() - time.getTime();
    const minutes = Math.floor(diff / 60000);
    const hours = Math.floor(diff / 3600000);
    const days = Math.floor(diff / 86400000);

    if (minutes < 1) return '刚刚';
    if (minutes < 60) return `${minutes}分钟前`;
    if (hours < 24) return `${hours}小时前`;
    if (days < 7) return `${days}天前`;

    // 返回日期
    const month = time.getMonth() + 1;
    const day = time.getDate();
    return `${month}月${day}日`;
  }

  build() {
    Column() {
      // 顶部标题栏
      Row() {
        Text('消息')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#881337')

        Blank()

        // 通讯录按钮
        Row() {
          Text('📖')
            .fontSize(20)
        }
        .width(36)
        .height(36)
        .borderRadius(18)
        .backgroundColor('#F1F5F9')
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.handleContactsClick();
        })

        // 添加按钮
        Row() {
          Text('+')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#E11D48')
        }
        .width(36)
        .height(36)
        .borderRadius(18)
        .backgroundColor('#FFF1F2')
        .justifyContent(FlexAlign.Center)
        .margin({ left: 8 })
        .onClick(() => {
          this.handleAddClick();
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 12 })
      .backgroundColor('#FFFFFF')

      // Tab切换
      Row() {
        Column() {
          Row() {
            Text('好友消息')
              .fontSize(16)
              .fontWeight(this.currentTab === 0 ? FontWeight.Bold : FontWeight.Normal)
              .fontColor(this.currentTab === 0 ? '#E11D48' : '#64748B')

            // 未读数量
            if (this.friendUnreadCount > 0) {
              Text(`${this.friendUnreadCount}`)
                .fontSize(12)
                .fontColor('#FFFFFF')
                .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                .backgroundColor('#E11D48')
                .borderRadius(8)
                .margin({ left: 6 })
            }
          }

          if (this.currentTab === 0) {
            Divider()
              .width(60)
              .height(3)
              .color('#E11D48')
              .margin({ top: 8 })
          }
        }
        .layoutWeight(1)
        .onClick(() => {
          this.currentTab = 0;
        })

        Column() {
          Row() {
            Text('商店消息')
              .fontSize(16)
              .fontWeight(this.currentTab === 1 ? FontWeight.Bold : FontWeight.Normal)
              .fontColor(this.currentTab === 1 ? '#E11D48' : '#64748B')

            // 未读数量
            if (this.storeUnreadCount > 0) {
              Text(`${this.storeUnreadCount}`)
                .fontSize(12)
                .fontColor('#FFFFFF')
                .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                .backgroundColor('#E11D48')
                .borderRadius(8)
                .margin({ left: 6 })
            }
          }

          if (this.currentTab === 1) {
            Divider()
              .width(60)
              .height(3)
              .color('#E11D48')
              .margin({ top: 8 })
          }
        }
        .layoutWeight(1)
        .onClick(() => {
          this.currentTab = 1;
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 0 })
      .backgroundColor('#FFFFFF')

      Divider()
        .color('#F1F5F9')

      // 内容区域
      if (this.currentTab === 0) {
        this.FriendMessagesView()
      } else {
        this.StoreMessagesView()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF1F2')
  }

  @Builder
  FriendMessagesView() {
    if (this.loading) {
      Column() {
        LoadingProgress()
          .width(40)
          .height(40)
          .color('#E11D48')
        Text('加载中...')
          .fontSize(14)
          .fontColor('#94A3B8')
          .margin({ top: 12 })
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
    } else if (this.friendMessages.length === 0) {
      Column() {
        Text('💬')
          .fontSize(48)
        Text('暂无好友消息')
          .fontSize(16)
          .fontColor('#94A3B8')
          .margin({ top: 12 })
        Text('点击右上角+添加好友')
          .fontSize(14)
          .fontColor('#CBD5E1')
          .margin({ top: 8 })
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
    } else {
      List({ space: 0 }) {
        ForEach(this.friendMessages, (message: FriendMessage) => {
          ListItem() {
            this.FriendMessageCard(message)
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor('#FFFFFF')
      .divider({
        strokeWidth: 1,
        color: '#F1F5F9',
        startMargin: 76,
        endMargin: 16
      })
    }
  }

  @Builder
  StoreMessagesView() {
    if (this.storeMessages.length === 0) {
      Column() {
        Text('🏪')
          .fontSize(48)
        Text('暂无商店消息')
          .fontSize(16)
          .fontColor('#94A3B8')
          .margin({ top: 12 })
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
    } else {
      List({ space: 0 }) {
        ForEach(this.storeMessages, (message: StoreMessage) => {
          ListItem() {
            this.StoreMessageCard(message)
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor('#FFFFFF')
      .divider({
        strokeWidth: 1,
        color: '#F1F5F9',
        startMargin: 76,
        endMargin: 16
      })
    }
  }

  @Builder
  FriendMessageCard(message: FriendMessage) {
    Row() {
      // 头像
      Stack() {
        Circle()
          .width(52)
          .height(52)
          .fill('#F1F5F9')

        // 在线状态
        if (message.isOnline) {
          Circle()
            .width(12)
            .height(12)
            .fill('#10B981')
            .border({ width: 2, color: '#FFFFFF' })
        }
      }
      .alignContent(Alignment.BottomEnd)

      // 消息内容
      Column() {
        Row() {
          Text(message.friendName)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#1F2937')
            .layoutWeight(1)

          Text(this.formatTime(message.lastMessageTime))
            .fontSize(12)
            .fontColor('#94A3B8')
        }
        .width('100%')
        .margin({ bottom: 6 })

        Row() {
          Text(message.lastMessage)
            .fontSize(14)
            .fontColor('#64748B')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .layoutWeight(1)

          // 未读数量
          if (message.unreadCount > 0) {
            Text(`${message.unreadCount}`)
              .fontSize(12)
              .fontColor('#FFFFFF')
              .fontWeight(FontWeight.Bold)
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .backgroundColor('#E11D48')
              .borderRadius(10)
              .margin({ left: 8 })
          }
        }
        .width('100%')
      }
      .layoutWeight(1)
      .margin({ left: 12 })
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .backgroundColor(message.unreadCount > 0 ? '#FFFBFB' : '#FFFFFF')
    .onClick(() => {
      this.handleFriendClick(message);
    })
  }

  @Builder
  StoreMessageCard(message: StoreMessage) {
    Row() {
      // 商店图标
      Stack() {
        Column() {
          Text('🏪')
            .fontSize(28)
        }
        .width(52)
        .height(52)
        .backgroundColor('#F1F5F9')
        .borderRadius(26)
        .justifyContent(FlexAlign.Center)

        // 如果是自己的商店，显示标记
        if (message.isMyStore) {
          Column() {
            Text('我')
              .fontSize(10)
              .fontColor('#FFFFFF')
          }
          .width(18)
          .height(18)
          .backgroundColor('#E11D48')
          .borderRadius(9)
          .justifyContent(FlexAlign.Center)
          .border({ width: 2, color: '#FFFFFF' })
        }
      }
      .alignContent(Alignment.BottomEnd)

      // 消息内容
      Column() {
        Row() {
          Text(message.storeName)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#1F2937')

          // 消息类型标签
          Text(this.getMessageTypeLabel(message.messageType))
            .fontSize(10)
            .fontColor('#FFFFFF')
            .padding({ left: 6, right: 6, top: 2, bottom: 2 })
            .backgroundColor(this.getMessageTypeColor(message.messageType))
            .borderRadius(4)
            .margin({ left: 8 })

          Blank()

          Text(this.formatTime(message.time))
            .fontSize(12)
            .fontColor('#94A3B8')
        }
        .width('100%')
        .margin({ bottom: 6 })

        Row() {
          Text(message.content)
            .fontSize(14)
            .fontColor('#64748B')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .layoutWeight(1)

          // 未读标记
          if (!message.isRead) {
            Circle()
              .width(8)
              .height(8)
              .fill('#E11D48')
              .margin({ left: 8 })
          }
        }
        .width('100%')
      }
      .layoutWeight(1)
      .margin({ left: 12 })
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .backgroundColor(message.isRead ? '#FFFFFF' : '#FFFBFB')
    .onClick(() => {
      this.handleStoreMessageClick(message);
    })
  }
}
