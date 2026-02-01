import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

// 兑换订单信息
interface ExchangeOrder {
  productId: string;
  productName: string;
  productPrice: number;
  quantity: number;
  currencyId: string;
  currencyName: string;
  totalPrice: number;
}

@Entry
@Component
struct ExchangeConfirmPage {
  @State order: ExchangeOrder | null = null;

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    this.order = {
      productId: params['productId'] || '',
      productName: params['productName'] || '',
      productPrice: parseFloat(params['productPrice'] || '0'),
      quantity: parseInt(params['quantity'] || '1'),
      currencyId: params['currencyId'] || '',
      currencyName: params['currencyName'] || '',
      totalPrice: parseFloat(params['totalPrice'] || '0')
    };
  }

  async handleConfirmExchange() {
    if (!this.order) return;

    // 模拟支付处理
    await new Promise<void>((resolve) => setTimeout(resolve, 1000));

    // 生成兑换码
    const exchangeCode = this.generateExchangeCode();

    promptAction.showToast({
      message: '兑换成功！',
      duration: 2000
    });

    // 跳转到兑换码页面
    setTimeout(() => {
      router.replaceUrl({
        url: 'pages/ExchangeCodePage',
        params: {
          orderId: Date.now().toString(),
          productName: this.order!.productName,
          exchangeCode: exchangeCode,
          quantity: this.order!.quantity.toString(),
          expiryTime: (Date.now() + 86400000).toString() // 24小时后过期
        }
      });
    }, 2000);
  }

  generateExchangeCode(): string {
    // 生成8位兑换码
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    let code = '';
    for (let i = 0; i < 8; i++) {
      code += chars.charAt(Math.floor(Math.random() * chars.length));
      if (i === 3) code += '-'; // 中间加横线
    }
    return code;
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

        Text('确认兑换')
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

      if (this.order) {
        Column() {
          // 商品信息
          Column() {
            Text('商品信息')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2937')
              .margin({ bottom: 16 })
              .alignSelf(ItemAlign.Start)

            Row() {
              Column()
                .width(80)
                .height(80)
                .backgroundColor('#F1F5F9')
                .borderRadius(8)

              Column() {
                Text(this.order.productName)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#1F2937')
                  .margin({ bottom: 8 })

                Row() {
                  Text(`${this.order.productPrice}`)
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#E11D48')
                  Text('积分')
                    .fontSize(12)
                    .fontColor('#E11D48')
                    .margin({ left: 4 })

                  Blank()

                  Text(`x${this.order.quantity}`)
                    .fontSize(14)
                    .fontColor('#64748B')
                }
                .width('100%')
              }
              .layoutWeight(1)
              .margin({ left: 12 })
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .margin({ bottom: 16 })

          // 支付信息
          Column() {
            Text('支付信息')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2937')
              .margin({ bottom: 16 })
              .alignSelf(ItemAlign.Start)

            Row() {
              Text('支付货币')
                .fontSize(14)
                .fontColor('#64748B')
              Blank()
              Text(this.order.currencyName)
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor('#1F2937')
            }
            .width('100%')
            .margin({ bottom: 12 })

            Row() {
              Text('商品金额')
                .fontSize(14)
                .fontColor('#64748B')
              Blank()
              Text(`${this.order.productPrice * this.order.quantity}`)
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor('#1F2937')
            }
            .width('100%')
            .margin({ bottom: 12 })

            Divider()
              .color('#F1F5F9')
              .margin({ top: 8, bottom: 8 })

            Row() {
              Text('实付金额')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1F2937')
              Blank()
              Text(`${this.order.totalPrice}`)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor('#E11D48')
            }
            .width('100%')
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .margin({ bottom: 16 })

          // 说明
          Column() {
            Text('兑换说明')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2937')
              .margin({ bottom: 8 })
              .alignSelf(ItemAlign.Start)

            Text('• 兑换成功后将生成兑换码')
              .fontSize(12)
              .fontColor('#64748B')
              .margin({ bottom: 4 })
              .alignSelf(ItemAlign.Start)

            Text('• 兑换码有效期为24小时')
              .fontSize(12)
              .fontColor('#64748B')
              .margin({ bottom: 4 })
              .alignSelf(ItemAlign.Start)

            Text('• 请在有效期内到店核销')
              .fontSize(12)
              .fontColor('#64748B')
              .margin({ bottom: 4 })
              .alignSelf(ItemAlign.Start)

            Text('• 核销后不可退换')
              .fontSize(12)
              .fontColor('#64748B')
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
      }

      // 底部确认按钮
      Column() {
        Button('确认兑换')
          .width('100%')
          .height(48)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .backgroundColor('#E11D48')
          .borderRadius(24)
          .onClick(() => {
            this.handleConfirmExchange();
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
