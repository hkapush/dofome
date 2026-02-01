import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

// 兑换详情
interface PurchaseDetail {
  orderId: string;
  productName: string;
  productImage: string;
  productDescription: string;
  price: number;
  quantity: number;
  totalPrice: number;
  status: 'pending' | 'completed' | 'cancelled' | 'refunded';
  orderTime: string;
  completedTime?: string;
  exchangeCode?: string;
  storeId: string;
  storeName: string;
  storeAddress?: string;
  validUntil?: string;
  usageInstructions?: string;
}

@Entry
@Component
struct PurchaseDetailPage {
  @State orderId: string = '';
  @State storeId: string = '';
  @State storeName: string = '';
  @State detail: PurchaseDetail | null = null;
  @State loading: boolean = true;

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    this.orderId = params['orderId'] || '';
    this.storeId = params['storeId'] || '';
    this.storeName = params['storeName'] || '';
    this.loadDetail();
  }

  async loadDetail() {
    this.loading = true;
    await new Promise<void>((resolve) => setTimeout(resolve, 500));

    // 模拟数据
    this.detail = {
      orderId: this.orderId,
      productName: '咖啡券',
      productImage: '',
      productDescription: '可兑换任意中杯咖啡一杯',
      price: 50,
      quantity: 2,
      totalPrice: 100,
      status: 'pending',
      orderTime: '2026-02-01 10:30:00',
      exchangeCode: 'ABC123',
      storeId: this.storeId,
      storeName: this.storeName,
      storeAddress: '北京市朝阳区建国路88号',
      validUntil: '2026-03-01',
      usageInstructions: '1. 到店出示兑换码\n2. 工作人员核销后即可使用\n3. 每张券限用一次\n4. 不可与其他优惠同时使用'
    };

    this.loading = false;
  }

  getStatusText(status: string): string {
    switch (status) {
      case 'pending':
        return '待使用';
      case 'completed':
        return '已完成';
      case 'cancelled':
        return '已取消';
      case 'refunded':
        return '已退款';
      default:
        return '';
    }
  }

  getStatusColor(status: string): string {
    switch (status) {
      case 'pending':
        return '#F59E0B';
      case 'completed':
        return '#10B981';
      case 'cancelled':
        return '#94A3B8';
      case 'refunded':
        return '#2563EB';
      default:
        return '#64748B';
    }
  }

  formatTime(timeStr: string): string {
    const time = new Date(timeStr);
    const year = time.getFullYear();
    const month = (time.getMonth() + 1).toString().padStart(2, '0');
    const day = time.getDate().toString().padStart(2, '0');
    const hours = time.getHours().toString().padStart(2, '0');
    const minutes = time.getMinutes().toString().padStart(2, '0');
    return `${year}-${month}-${day} ${hours}:${minutes}`;
  }

  formatDate(dateStr: string): string {
    const date = new Date(dateStr);
    const year = date.getFullYear();
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const day = date.getDate().toString().padStart(2, '0');
    return `${year}年${month}月${day}日`;
  }

  handleCopyCode() {
    if (this.detail?.exchangeCode) {
      promptAction.showToast({
        message: '兑换码已复制',
        duration: 2000
      });
    }
  }

  handleContactStore() {
    promptAction.showDialog({
      title: '联系商家',
      message: '是否要联系商家？',
      buttons: [
        { text: '取消', color: '#94A3B8' },
        { text: '确定', color: '#E11D48' }
      ]
    });
  }

  handleCancelOrder() {
    promptAction.showDialog({
      title: '取消订单',
      message: '确定要取消这个订单吗？',
      buttons: [
        { text: '取消', color: '#94A3B8' },
        {
          text: '确定',
          color: '#E11D48'
        }
      ]
    }, (err, data) => {
      if (data.index === 1) {
        promptAction.showToast({
          message: '订单已取消',
          duration: 2000
        });
        router.back();
      }
    });
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

        Text('兑换详情')
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
      } else if (this.detail) {
        Scroll() {
          Column() {
            // 状态卡片
            Column() {
              Text(this.getStatusText(this.detail.status))
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.getStatusColor(this.detail.status))

              if (this.detail.status === 'pending') {
                Text('请到店出示兑换码')
                  .fontSize(14)
                  .fontColor('#64748B')
                  .margin({ top: 8 })
              } else if (this.detail.status === 'completed') {
                Text('感谢您的使用')
                  .fontSize(14)
                  .fontColor('#64748B')
                  .margin({ top: 8 })
              }
            }
            .width('100%')
            .padding(24)
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
            .margin({ top: 16, left: 16, right: 16 })

            // 兑换码卡片（待使用状态）
            if (this.detail.exchangeCode && this.detail.status === 'pending') {
              Column() {
                Text('兑换码')
                  .fontSize(14)
                  .fontColor('#64748B')
                  .margin({ bottom: 12 })

                Text(this.detail.exchangeCode)
                  .fontSize(32)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#E11D48')
                  .letterSpacing(4)
                  .margin({ bottom: 16 })

                Row() {
                  Text('复制兑换码')
                    .fontSize(15)
                    .fontColor('#FFFFFF')
                }
                .width('100%')
                .height(44)
                .backgroundColor('#E11D48')
                .borderRadius(8)
                .justifyContent(FlexAlign.Center)
                .onClick(() => {
                  this.handleCopyCode();
                })

                if (this.detail.validUntil) {
                  Text(`有效期至：${this.formatDate(this.detail.validUntil)}`)
                    .fontSize(12)
                    .fontColor('#94A3B8')
                    .margin({ top: 12 })
                }
              }
              .width('100%')
              .padding(20)
              .backgroundColor('#FFFFFF')
              .borderRadius(12)
              .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
              .margin({ top: 12, left: 16, right: 16 })
            }

            // 商品信息
            Column() {
              Text('商品信息')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1F2937')
                .width('100%')
                .margin({ bottom: 16 })

              Row() {
                // 商品图片占位
                Column()
                  .width(80)
                  .height(80)
                  .backgroundColor('#F1F5F9')
                  .borderRadius(8)

                Column() {
                  Text(this.detail.productName)
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#1F2937')
                    .width('100%')

                  Text(this.detail.productDescription)
                    .fontSize(13)
                    .fontColor('#64748B')
                    .width('100%')
                    .margin({ top: 6 })
                    .maxLines(2)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  Row() {
                    Text(`${this.detail.price}`)
                      .fontSize(18)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#E11D48')
                    Text('积分')
                      .fontSize(12)
                      .fontColor('#E11D48')
                      .margin({ left: 2 })

                    Text(`×${this.detail.quantity}`)
                      .fontSize(14)
                      .fontColor('#64748B')
                      .margin({ left: 8 })
                  }
                  .margin({ top: 8 })
                }
                .layoutWeight(1)
                .margin({ left: 12 })
                .alignItems(HorizontalAlign.Start)
              }
              .width('100%')
            }
            .width('100%')
            .padding(20)
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
            .margin({ top: 12, left: 16, right: 16 })

            // 商店信息
            Column() {
              Text('商店信息')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1F2937')
                .width('100%')
                .margin({ bottom: 16 })

              Row() {
                Column() {
                  Text('🏪')
                    .fontSize(32)
                }
                .width(56)
                .height(56)
                .backgroundColor('#F1F5F9')
                .borderRadius(28)
                .justifyContent(FlexAlign.Center)

                Column() {
                  Text(this.detail.storeName)
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#1F2937')
                    .width('100%')

                  if (this.detail.storeAddress) {
                    Row() {
                      Text('📍')
                        .fontSize(12)
                      Text(this.detail.storeAddress)
                        .fontSize(13)
                        .fontColor('#64748B')
                        .margin({ left: 4 })
                        .layoutWeight(1)
                    }
                    .width('100%')
                    .margin({ top: 6 })
                  }
                }
                .layoutWeight(1)
                .margin({ left: 12 })
                .alignItems(HorizontalAlign.Start)

                Text('→')
                  .fontSize(20)
                  .fontColor('#94A3B8')
              }
              .width('100%')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/StoreDetailPage',
                  params: {
                    storeId: this.detail?.storeId,
                    storeName: this.detail?.storeName
                  }
                });
              })
            }
            .width('100%')
            .padding(20)
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
            .margin({ top: 12, left: 16, right: 16 })

            // 使用说明
            if (this.detail.usageInstructions) {
              Column() {
                Text('使用说明')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1F2937')
                  .width('100%')
                  .margin({ bottom: 12 })

                Text(this.detail.usageInstructions)
                  .fontSize(14)
                  .fontColor('#64748B')
                  .lineHeight(22)
                  .width('100%')
              }
              .width('100%')
              .padding(20)
              .backgroundColor('#FFFFFF')
              .borderRadius(12)
              .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
              .margin({ top: 12, left: 16, right: 16 })
            }

            // 订单信息
            Column() {
              Text('订单信息')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1F2937')
                .width('100%')
                .margin({ bottom: 16 })

              Row() {
                Text('订单号')
                  .fontSize(14)
                  .fontColor('#64748B')
                  .width(80)
                Text(this.detail.orderId)
                  .fontSize(14)
                  .fontColor('#1F2937')
                  .layoutWeight(1)
              }
              .width('100%')
              .margin({ bottom: 12 })

              Row() {
                Text('下单时间')
                  .fontSize(14)
                  .fontColor('#64748B')
                  .width(80)
                Text(this.formatTime(this.detail.orderTime))
                  .fontSize(14)
                  .fontColor('#1F2937')
                  .layoutWeight(1)
              }
              .width('100%')
              .margin({ bottom: 12 })

              if (this.detail.completedTime) {
                Row() {
                  Text('完成时间')
                    .fontSize(14)
                    .fontColor('#64748B')
                    .width(80)
                  Text(this.formatTime(this.detail.completedTime))
                    .fontSize(14)
                    .fontColor('#1F2937')
                    .layoutWeight(1)
                }
                .width('100%')
                .margin({ bottom: 12 })
              }

              Row() {
                Text('支付金额')
                  .fontSize(14)
                  .fontColor('#64748B')
                  .width(80)
                Row() {
                  Text(`${this.detail.totalPrice}`)
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#E11D48')
                  Text('积分')
                    .fontSize(12)
                    .fontColor('#E11D48')
                    .margin({ left: 2 })
                }
              }
              .width('100%')
            }
            .width('100%')
            .padding(20)
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
            .margin({ top: 12, left: 16, right: 16 })

            // 底部操作按钮
            if (this.detail.status === 'pending') {
              Row() {
                Column() {
                  Text('联系商家')
                    .fontSize(15)
                    .fontColor('#E11D48')
                }
                .layoutWeight(1)
                .height(44)
                .backgroundColor('#FFFFFF')
                .borderRadius(8)
                .border({ width: 1, color: '#E11D48' })
                .justifyContent(FlexAlign.Center)
                .onClick(() => {
                  this.handleContactStore();
                })

                Column() {
                  Text('取消订单')
                    .fontSize(15)
                    .fontColor('#64748B')
                }
                .layoutWeight(1)
                .height(44)
                .backgroundColor('#F1F5F9')
                .borderRadius(8)
                .justifyContent(FlexAlign.Center)
                .margin({ left: 12 })
                .onClick(() => {
                  this.handleCancelOrder();
                })
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 12, bottom: 16 })
            }
          }
          .width('100%')
        }
        .width('100%')
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF1F2')
  }
}
