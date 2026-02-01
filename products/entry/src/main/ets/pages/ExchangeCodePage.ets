import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct ExchangeCodePage {
  @State orderId: string = '';
  @State productName: string = '';
  @State exchangeCode: string = '';
  @State quantity: number = 1;
  @State expiryTime: number = 0;
  @State timeRemaining: string = '';
  private timer: number = -1;

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    this.orderId = params['orderId'] || '';
    this.productName = params['productName'] || '';
    this.exchangeCode = params['exchangeCode'] || '';
    this.quantity = parseInt(params['quantity'] || '1');
    this.expiryTime = parseInt(params['expiryTime'] || '0');

    this.updateTimeRemaining();
    this.startTimer();
  }

  aboutToDisappear() {
    if (this.timer !== -1) {
      clearInterval(this.timer);
    }
  }

  startTimer() {
    this.timer = setInterval(() => {
      this.updateTimeRemaining();
    }, 1000);
  }

  updateTimeRemaining() {
    const now = Date.now();
    const diff = this.expiryTime - now;

    if (diff <= 0) {
      this.timeRemaining = '已过期';
      if (this.timer !== -1) {
        clearInterval(this.timer);
      }
      return;
    }

    const hours = Math.floor(diff / 3600000);
    const minutes = Math.floor((diff % 3600000) / 60000);
    const seconds = Math.floor((diff % 60000) / 1000);

    this.timeRemaining = `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
  }

  handleCopyCode() {
    // TODO: 实现复制到剪贴板
    promptAction.showToast({
      message: '兑换码已复制',
      duration: 2000
    });
  }

  handleViewOrders() {
    router.pushUrl({ url: 'pages/MyOrdersPage' });
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

        Text('兑换成功')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#881337')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Row()
          .width(40)
          .height(40)
      }
      .width('100%')
      .height(56)
      .padding({ left: 8, right: 8 })
      .backgroundColor('#FFFFFF')
      .shadow({ radius: 4, color: 'rgba(0, 0, 0, 0.05)', offsetY: 2 })

      Column() {
        // 成功图标
        Column() {
          Text('✓')
            .fontSize(64)
            .fontColor('#10B981')
            .fontWeight(FontWeight.Bold)

          Text('兑换成功')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F2937')
            .margin({ top: 16, bottom: 8 })

          Text(this.productName)
            .fontSize(16)
            .fontColor('#64748B')
        }
        .margin({ top: 32, bottom: 32 })

        // 兑换码卡片
        Column() {
          Text('兑换码')
            .fontSize(14)
            .fontColor('#64748B')
            .margin({ bottom: 16 })

          // 兑换码显示
          Text(this.exchangeCode)
            .fontSize(32)
            .fontWeight(FontWeight.Bold)
            .fontColor('#E11D48')
            .letterSpacing(4)
            .margin({ bottom: 16 })

          // 复制按钮
          Button('复制兑换码')
            .width(200)
            .height(40)
            .fontSize(14)
            .fontColor('#2563EB')
            .backgroundColor('#EFF6FF')
            .borderRadius(20)
            .onClick(() => {
              this.handleCopyCode();
            })
            .margin({ bottom: 24 })

          Divider()
            .color('#F1F5F9')
            .margin({ bottom: 16 })

          // 有效期
          Row() {
            Text('有效期至')
              .fontSize(14)
              .fontColor('#64748B')

            Blank()

            Text(this.timeRemaining)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.timeRemaining === '已过期' ? '#EF4444' : '#10B981')
          }
          .width('100%')
          .margin({ bottom: 12 })

          // 数量
          Row() {
            Text('兑换数量')
              .fontSize(14)
              .fontColor('#64748B')

            Blank()

            Text(`x${this.quantity}`)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1F2937')
          }
          .width('100%')
        }
        .width('100%')
        .padding(24)
        .backgroundColor('#FFFFFF')
        .borderRadius(16)
        .shadow({ radius: 12, color: 'rgba(0, 0, 0, 0.08)', offsetY: 4 })
        .margin({ bottom: 24 })

        // 使用说明
        Column() {
          Text('使用说明')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F2937')
            .margin({ bottom: 12 })
            .alignSelf(ItemAlign.Start)

          Text('1. 到店出示此兑换码')
            .fontSize(12)
            .fontColor('#64748B')
            .margin({ bottom: 8 })
            .alignSelf(ItemAlign.Start)

          Text('2. 店主扫码或输入兑换码核销')
            .fontSize(12)
            .fontColor('#64748B')
            .margin({ bottom: 8 })
            .alignSelf(ItemAlign.Start)

          Text('3. 核销成功后即可获得商品')
            .fontSize(12)
            .fontColor('#64748B')
            .margin({ bottom: 8 })
            .alignSelf(ItemAlign.Start)

          Text('4. 请在有效期内使用，过期作废')
            .fontSize(12)
            .fontColor('#EF4444')
            .alignSelf(ItemAlign.Start)
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#FFF7F8')
        .borderRadius(12)
      }
      .width('100%')
      .padding(16)
      .layoutWeight(1)

      // 底部按钮
      Column() {
        Button('查看我的订单')
          .width('100%')
          .height(48)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor('#FFFFFF')
          .backgroundColor('#E11D48')
          .borderRadius(24)
          .onClick(() => {
            this.handleViewOrders();
          })
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.1)', offsetY: -2 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF1F2')
  }
}
