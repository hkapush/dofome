import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

// 我在某个商店的消费记录
interface PurchaseRecord {
  orderId: string;
  productName: string;
  productImage: string;
  price: number;
  quantity: number;
  status: 'pending' | 'completed' | 'cancelled' | 'refunded';
  orderTime: string;
  completedTime?: string;
  exchangeCode?: string;
}

@Entry
@Component
struct MyPurchasesInStorePage {
  @State storeId: string = '';
  @State storeName: string = '';
  @State purchases: PurchaseRecord[] = [];
  @State loading: boolean = true;
  @State totalSpent: number = 0;

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    this.storeId = params['storeId'] || '';
    this.storeName = params['storeName'] || '';
    this.loadPurchases();
  }

  async loadPurchases() {
    this.loading = true;
    await new Promise<void>((resolve) => setTimeout(resolve, 500));

    // 模拟数据：我在这个商店的消费记录
    this.purchases = [
      {
        orderId: 'order_001',
        productName: '咖啡券',
        productImage: '',
        price: 50,
        quantity: 2,
        status: 'completed',
        orderTime: '2026-02-01 10:30:00',
        completedTime: '2026-02-01 11:00:00',
        exchangeCode: 'ABC123'
      },
      {
        orderId: 'order_002',
        productName: '电影票',
        productImage: '',
        price: 80,
        quantity: 1,
        status: 'pending',
        orderTime: '2026-01-31 15:20:00',
        exchangeCode: 'XYZ789'
      },
      {
        orderId: 'order_003',
        productName: '奶茶券',
        productImage: '',
        price: 30,
        quantity: 3,
        status: 'completed',
        orderTime: '2026-01-30 14:10:00',
        completedTime: '2026-01-30 16:30:00',
        exchangeCode: 'DEF456'
      },
      {
        orderId: 'order_004',
        productName: '健身卡',
        productImage: '',
        price: 200,
        quantity: 1,
        status: 'cancelled',
        orderTime: '2026-01-29 09:00:00'
      }
    ];

    // 计算总消费
    this.totalSpent = this.purchases
      .filter(p => p.status === 'completed')
      .reduce((sum, p) => sum + (p.price * p.quantity), 0);

    this.loading = false;
  }

  handlePurchaseClick(purchase: PurchaseRecord) {
    // 跳转到兑换详情页面
    router.pushUrl({
      url: 'pages/PurchaseDetailPage',
      params: {
        orderId: purchase.orderId,
        storeId: this.storeId,
        storeName: this.storeName
      }
    });
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
    const month = time.getMonth() + 1;
    const day = time.getDate();
    const hours = time.getHours().toString().padStart(2, '0');
    const minutes = time.getMinutes().toString().padStart(2, '0');
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
          Text('我的消费记录')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#881337')
          Text(this.storeName)
            .fontSize(12)
            .fontColor('#94A3B8')
            .margin({ top: 2 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)

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
      } else {
        Column() {
          // 统计信息卡片
          Column() {
            Row() {
              Column() {
                Text(`${this.purchases.length}`)
                  .fontSize(24)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#E11D48')
                Text('总订单数')
                  .fontSize(12)
                  .fontColor('#64748B')
                  .margin({ top: 4 })
              }
              .layoutWeight(1)

              Divider()
                .vertical(true)
                .height(40)
                .color('#F1F5F9')

              Column() {
                Text(`${this.totalSpent}`)
                  .fontSize(24)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#E11D48')
                Text('总消费积分')
                  .fontSize(12)
                  .fontColor('#64748B')
                  .margin({ top: 4 })
              }
              .layoutWeight(1)

              Divider()
                .vertical(true)
                .height(40)
                .color('#F1F5F9')

              Column() {
                Text(`${this.purchases.filter(p => p.status === 'pending').length}`)
                  .fontSize(24)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#F59E0B')
                Text('待使用')
                  .fontSize(12)
                  .fontColor('#64748B')
                  .margin({ top: 4 })
              }
              .layoutWeight(1)
            }
            .width('100%')
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
          .margin({ top: 16, left: 16, right: 16 })

          // 消费记录列表
          if (this.purchases.length === 0) {
            Column() {
              Text('🛍️')
                .fontSize(48)
              Text('暂无消费记录')
                .fontSize(16)
                .fontColor('#94A3B8')
                .margin({ top: 12 })
            }
            .width('100%')
            .layoutWeight(1)
            .justifyContent(FlexAlign.Center)
          } else {
            List({ space: 12 }) {
              ForEach(this.purchases, (purchase: PurchaseRecord) => {
                ListItem() {
                  this.PurchaseCard(purchase)
                }
              })
            }
            .width('100%')
            .layoutWeight(1)
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
          }
        }
        .width('100%')
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF1F2')
  }

  @Builder
  PurchaseCard(purchase: PurchaseRecord) {
    Column() {
      // 订单头部
      Row() {
        Text('订单号：')
          .fontSize(12)
          .fontColor('#94A3B8')
        Text(purchase.orderId)
          .fontSize(12)
          .fontColor('#64748B')

        Blank()

        Text(this.getStatusText(purchase.status))
          .fontSize(12)
          .fontColor(this.getStatusColor(purchase.status))
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      .backgroundColor('#F8FAFC')

      Divider()
        .color('#F1F5F9')

      // 商品信息
      Row() {
        // 商品图片占位
        Column()
          .width(60)
          .height(60)
          .backgroundColor('#F1F5F9')
          .borderRadius(8)

        Column() {
          Text(purchase.productName)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor('#1F2937')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Row() {
            Text(`${purchase.price}`)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#E11D48')
            Text('积分')
              .fontSize(12)
              .fontColor('#E11D48')
              .margin({ left: 2 })

            Text(`×${purchase.quantity}`)
              .fontSize(14)
              .fontColor('#64748B')
              .margin({ left: 8 })
          }
          .margin({ top: 6 })
        }
        .layoutWeight(1)
        .margin({ left: 12 })
        .alignItems(HorizontalAlign.Start)

        Column() {
          Text(`${purchase.price * purchase.quantity}`)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#E11D48')
          Text('积分')
            .fontSize(11)
            .fontColor('#E11D48')
        }
        .alignItems(HorizontalAlign.End)
      }
      .width('100%')
      .padding(16)
      .alignItems(VerticalAlign.Top)

      // 兑换码（如果有）
      if (purchase.exchangeCode && purchase.status === 'pending') {
        Column() {
          Divider()
            .color('#F1F5F9')

          Row() {
            Column() {
              Text('兑换码')
                .fontSize(12)
                .fontColor('#64748B')
              Text(purchase.exchangeCode)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#E11D48')
                .margin({ top: 4 })
                .letterSpacing(2)
            }
            .alignItems(HorizontalAlign.Start)

            Blank()

            Text('复制')
              .fontSize(14)
              .fontColor('#2563EB')
              .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              .backgroundColor('#EFF6FF')
              .borderRadius(6)
              .onClick(() => {
                promptAction.showToast({
                  message: '兑换码已复制',
                  duration: 2000
                });
              })
          }
          .width('100%')
          .padding(16)
        }
      }

      Divider()
        .color('#F1F5F9')

      // 订单时间
      Row() {
        Text(`下单时间：${this.formatTime(purchase.orderTime)}`)
          .fontSize(12)
          .fontColor('#94A3B8')

        if (purchase.completedTime) {
          Text(`完成时间：${this.formatTime(purchase.completedTime)}`)
            .fontSize(12)
            .fontColor('#94A3B8')
            .margin({ left: 16 })
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 12 })
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
    .onClick(() => {
      this.handlePurchaseClick(purchase);
    })
  }
}
