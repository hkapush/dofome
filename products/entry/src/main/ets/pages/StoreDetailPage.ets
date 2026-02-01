import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

// 商品信息
interface StoreProduct {
  productId: string;
  name: string;
  description: string;
  price: number;
  originalPrice?: number;
  stock: number;
  sales: number;
  rating: number;
  image: string;
  tags: string[];
}

@Entry
@Component
struct StoreDetailPage {
  @State storeId: string = '';
  @State storeName: string = '';
  @State products: StoreProduct[] = [];
  @State loading: boolean = true;

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    this.storeId = params['storeId'] || '';
    this.storeName = params['storeName'] || '';
    this.loadProducts();
  }

  async loadProducts() {
    this.loading = true;
    await new Promise<void>((resolve) => setTimeout(resolve, 500));

    // 模拟商品数据
    this.products = [
      {
        productId: '1',
        name: '无线蓝牙耳机',
        description: '高品质音质，长续航',
        price: 299,
        originalPrice: 399,
        stock: 50,
        sales: 1234,
        rating: 4.8,
        image: '',
        tags: ['热销', '新品']
      },
      {
        productId: '2',
        name: '智能手环',
        description: '健康监测，运动追踪',
        price: 199,
        originalPrice: 299,
        stock: 100,
        sales: 856,
        rating: 4.6,
        image: '',
        tags: ['热销']
      },
      {
        productId: '3',
        name: '保温杯',
        description: '304不锈钢，24小时保温',
        price: 89,
        stock: 200,
        sales: 2341,
        rating: 4.9,
        image: '',
        tags: []
      }
    ];

    this.loading = false;
  }

  handleProductClick(productId: string) {
    router.pushUrl({
      url: 'pages/ProductDetailPage',
      params: { productId: productId }
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

        Text(this.storeName)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#881337')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        // 我的消费记录按钮
        Row() {
          Text('📋')
            .fontSize(20)
        }
        .width(40)
        .height(40)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/MyPurchasesInStorePage',
            params: {
              storeId: this.storeId,
              storeName: this.storeName
            }
          });
        })
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
        Grid() {
          ForEach(this.products, (product: StoreProduct) => {
            GridItem() {
              this.ProductCard(product)
            }
          })
        }
        .columnsTemplate('1fr 1fr')
        .columnsGap(12)
        .rowsGap(12)
        .padding(16)
        .width('100%')
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF1F2')
  }

  @Builder
  ProductCard(product: StoreProduct) {
    Column() {
      // 商品图片占位
      Stack() {
        Column()
          .width('100%')
          .height(140)
          .backgroundColor('#F1F5F9')
          .borderRadius({ topLeft: 12, topRight: 12 })

        // 标签
        if (product.tags.length > 0) {
          Row() {
            ForEach(product.tags.slice(0, 2), (tag: string) => {
              Text(tag)
                .fontSize(10)
                .fontColor('#FFFFFF')
                .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                .backgroundColor('rgba(225, 29, 72, 0.9)')
                .borderRadius(4)
                .margin({ right: 4 })
            })
          }
          .padding(8)
        }
      }
      .width('100%')
      .alignContent(Alignment.TopStart)

      // 商品信息
      Column() {
        Text(product.name)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1F2937')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .lineHeight(20)

        Row() {
          Text(`${product.price}`)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#E11D48')
          Text('积分')
            .fontSize(12)
            .fontColor('#E11D48')
            .margin({ left: 2 })

          if (product.originalPrice) {
            Text(`${product.originalPrice}`)
              .fontSize(12)
              .fontColor('#94A3B8')
              .decoration({ type: TextDecorationType.LineThrough })
              .margin({ left: 6 })
          }
        }
        .margin({ top: 6 })

        Row() {
          Text(`已售${product.sales}`)
            .fontSize(11)
            .fontColor('#94A3B8')

          Blank()

          Row() {
            Text('★')
              .fontSize(12)
              .fontColor('#F59E0B')
            Text(`${product.rating}`)
              .fontSize(11)
              .fontColor('#64748B')
              .margin({ left: 2 })
          }
        }
        .width('100%')
        .margin({ top: 4 })
      }
      .padding(10)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
    .onClick(() => {
      this.handleProductClick(product.productId);
    })
  }
}
