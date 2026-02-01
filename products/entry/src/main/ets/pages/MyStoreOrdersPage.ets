import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

// 兑换订单状态
enum OrderStatus {
  PENDING = 'pending',        // 待核销
  COMPLETED = 'completed',    // 已完成
  EXPIRED = 'expired',        // 已过期
  CANCELLED = 'cancelled'     // 已取消
}

// 我的兑换订单
interface MyExchangeOrder {
  orderId: string;
  productId: string;
  productName: string;
  productImage: string;
  price: number;
  quantity: number;
  currencyName: string;
  totalPrice: number;
  exchangeCode: string;
  status: OrderStatus;
  createTime: string;
  expiryTime: string;
  usedTime?: string;
}

@Entry
@Component
struct MyStoreOrdersPage {
  @State storeId: string = '';
  @State storeName: string = '';
  @State orders: MyExchangeOrder[] = [];
  @State loading: boolean = true;

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    this.storeId = params['storeId'] || '';
    this.storeName = params['storeName'] || '';
    this.loadOrders();
  }

  async loadOrders() {
    this.loading = true;
    await new Promise<void>((resolve) => setTimeout(resolve, 500));

    // 模拟加载我在该商店的兑换记录
    this.orders = [
      {
        orderId: 'order_001',
        productId: 'prod_001',
        productName: '咖啡券',
        productImage: '',
        price: 30,
        quantity: 1,
        currencyName: '世界币',
        totalPrice: 30,
        exchangeCode: 'ABCD-1234',
        status: OrderStatus.PENDING,
        createTime: '2026-02-01 14:00:00',
        expiryTime: '2026-02-02 14:00:00'
      },
      {
        orderId: 'order_002',
        productId: 'prod_002',
        productName: '电影票',
        productImage: '',
        price: 50,
        quantity: 2,
        currencyName: '世界币',
        totalPrice: 100,
        exchangeCode: 'EFGH-5678',
        status: OrderStatus.COMPLETED,
        createTime: '2026-01-30 10:00:00',
        expiryTime: '2026-01-31 10:00:00',
        usedTime: '2026-01-30 18:30:00'
      },
      {
        orderId: 'order_003',
        productId: 'prod_003',
        productName: '零食大礼包',
        productImage: '',
        price: 80,
        quantity: 1,
        currencyName: '小明币',
        totalPrice: 80,
        exchangeCode: 'IJKL-9012',
        status: OrderStatus.EXPIRED,
        createTime: '2026-01-28 12:00:00',
        expiryTime: '2026-01-29 12:00:00'
      }
    ];

    this.loading = false;
  }

  handleOrderClick(order: MyExchangeOrder) {
    router.pushUrl({
      url: 'pages/OrderDetailPage',
      params: {
        orderId: order.orderId,
        fromStore: 'true'
      }
    });
  }

  getStatusText(status: OrderStatus): string {
    switch (status) {
      case OrderStatus.PENDING:
        return '待核销';
      case OrderStatus.COMPLETED:
        return '已完成';
      case OrderStatus.EXPIRED:
        return '已过期';
      case OrderStatus.CANCELLED:
        return '已取消';
      default:
        return '';
    }
  }

  getStatusColor(status: OrderStatus): string {
    switch (status) {
      case OrderStatus.PENDING:
        return '#F59E0B';
      case OrderStatus.COMPLETED:
        return '#10B981';
      case OrderStatus.EXPIRED:
        return '#94A3B8';
      case OrderStatus.CANCELLED:
        return '#EF4444';
      default:
        return '#94A3B8';
    }
  }

  formatTime(timeStr: string): string {
    const date = new Date(timeStr);
    const month = date.getMonth() + 1;
    const day = date.getDate();
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

        Text(`在${this.storeName}的消费`)
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
      } else if (this.orders.length === 0) {
        Column() {
          Text('🛒')
            .fontSize(48)
          Text('暂无消费记录')
            .fontSize(16)
            .fontColor('#94A3B8')
            .margin({ top: 12 })
          Text('去商店逛逛吧')
            .fontSize(14)
            .fontColor('#CBD5E1')
            .margin({ top: 8 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List({ space: 12 }) {
          ForEach(this.orders, (order: MyExchangeOrder) => {
            ListItem() {
              this.OrderCard(order)
            }
          })
        }
        .width('100%')
        .layoutWeight(1)
        .padding(16)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF1F2')
  }

  @Builder
  OrderCard(order: MyExchangeOrder) {
    Column() {
      Row() {
        // 商品图片
        Column()
          .width(80)
          .height(80)
          .backgroundColor('#F1F5F9')
          .borderRadius(8)

        // 商品信息
        Column() {
          Row() {
            Text(order.productName)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2937')
              .layoutWeight(1)

            Text(this.getStatusText(order.status))
              .fontSize(12)
              .fontColor('#FFFFFF')
              .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              .backgroundColor(this.getStatusColor(order.status))
              .borderRadius(4)
          }
          .width('100%')
          .margin({ bottom: 8 })

          Row() {
            Text(`${order.price}`)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#E11D48')
            Text(order.currencyName)
              .fontSize(12)
              .fontColor('#E11D48')
              .margin({ left: 4 })

            Text(`x${order.quantity}`)
              .fontSize(12)
              .fontColor('#64748B')
              .margin({ left: 8 })
          }
          .margin({ bottom: 8 })

          Text(`兑换码: ${order.exchangeCode}`)
            .fontSize(12)
            .fontColor('#64748B')
        }
        .layoutWeight(1)
        .margin({ left: 12 })
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .margin({ bottom: 12 })

      Divider()
        .color('#F1F5F9')
        .margin({ bottom: 12 })

      // 时间信息
      Row() {
        Text(`兑换时间: ${this.formatTime(order.createTime)}`)
          .fontSize(12)
          .fontColor('#94A3B8')

        Blank()

        if (order.status === OrderStatus.PENDING) {
          Text(`有效期至: ${this.formatTime(order.expiryTime)}`)
            .fontSize(12)
            .fontColor('#F59E0B')
        } else if (order.status === OrderStatus.COMPLETED && order.usedTime) {
          Text(`核销时间: ${this.formatTime(order.usedTime)}`)
            .fontSize(12)
            .fontColor('#10B981')
        }
      }
      .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({ radius: 4, color: 'rgba(0, 0, 0, 0.05)', offsetY: 2 })
    .onClick(() => {
      this.handleOrderClick(order);
    })
  }
}
