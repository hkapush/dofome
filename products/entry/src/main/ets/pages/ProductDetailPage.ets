import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

// 货币类型
enum CurrencyType {
  SHELL = 'shell',    // 世界币
  STAR = 'star',      // 个人币
  GUILD = 'guild'     // 团体币
}

// 商品信息
interface ProductDetail {
  productId: string;
  name: string;
  description: string;
  price: number;
  originalPrice?: number;
  stock: number;
  sales: number;
  rating: number;
  images: string[];
  storeId: string;
  storeName: string;
  storeAvatar: string;
  acceptedCurrencies: CurrencyType[];
  redemptionRate: number;
  category: string;
  tags: string[];
  isMyProduct?: boolean; // 是否是我管理的商品
}

// 用户持有的货币
interface UserCurrency {
  currencyId: string;
  currencyName: string;
  currencyType: CurrencyType;
  balance: number;
}

@Entry
@Component
struct ProductDetailPage {
  @State product: ProductDetail | null = null;
  @State selectedCurrency: string = '';
  @State userCurrencies: UserCurrency[] = [];
  @State quantity: number = 1;
  @State loading: boolean = true;

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    const productId = params['productId'] || '1';
    const isMyProduct = params['isMyProduct'] === 'true';
    this.loadProductDetail(productId, isMyProduct);
    this.loadUserCurrencies();
  }

  async loadProductDetail(productId: string, isMyProduct: boolean = false) {
    this.loading = true;
    // 模拟加载商品详情
    await new Promise<void>((resolve) => setTimeout(resolve, 500));

    this.product = {
      productId: productId,
      name: '无线蓝牙耳机',
      description: '高品质音质，长续航，舒适佩戴。支持蓝牙5.0，续航时间长达24小时，降噪效果出色。',
      price: 299,
      originalPrice: 399,
      stock: 50,
      sales: 1234,
      rating: 4.8,
      images: [],
      storeId: 'store_001',
      storeName: '小明的杂货铺',
      storeAvatar: '',
      acceptedCurrencies: [CurrencyType.SHELL, CurrencyType.STAR],
      redemptionRate: 98.5,
      category: '数码产品',
      tags: ['热销', '新品'],
      isMyProduct: isMyProduct
    };

    this.loading = false;
  }

  async loadUserCurrencies() {
    // 模拟加载用户持有的货币
    this.userCurrencies = [
      {
        currencyId: 'shell_1',
        currencyName: '世界币',
        currencyType: CurrencyType.SHELL,
        balance: 1280
      },
      {
        currencyId: 'star_xiaoming',
        currencyName: '小明币',
        currencyType: CurrencyType.STAR,
        balance: 350
      }
    ];

    // 默认选择第一个可用货币
    if (this.product && this.userCurrencies.length > 0) {
      const availableCurrency = this.userCurrencies.find(c =>
        this.product!.acceptedCurrencies.includes(c.currencyType)
      );
      if (availableCurrency) {
        this.selectedCurrency = availableCurrency.currencyId;
      }
    }
  }

  handleQuantityChange(delta: number) {
    const newQuantity = this.quantity + delta;
    if (newQuantity >= 1 && newQuantity <= (this.product?.stock || 1)) {
      this.quantity = newQuantity;
    }
  }

  handleExchange() {
    if (!this.product) return;

    const selectedCurrencyInfo = this.userCurrencies.find(c => c.currencyId === this.selectedCurrency);
    if (!selectedCurrencyInfo) {
      promptAction.showToast({
        message: '请选择支付货币',
        duration: 2000
      });
      return;
    }

    const totalPrice = this.product.price * this.quantity;
    if (selectedCurrencyInfo.balance < totalPrice) {
      promptAction.showToast({
        message: '货币余额不足',
        duration: 2000
      });
      return;
    }

    // 跳转到兑换确认页
    router.pushUrl({
      url: 'pages/ExchangeConfirmPage',
      params: {
        productId: this.product.productId,
        productName: this.product.name,
        productPrice: this.product.price.toString(),
        quantity: this.quantity.toString(),
        currencyId: this.selectedCurrency,
        currencyName: selectedCurrencyInfo.currencyName,
        totalPrice: totalPrice.toString()
      }
    });
  }

  handleDeleteProduct() {
    if (!this.product) return;

    promptAction.showDialog({
      title: '删除商品',
      message: `确定要删除"${this.product.name}"吗？`,
      buttons: [
        { text: '取消', color: '#64748B' },
        { text: '删除', color: '#EF4444' }
      ]
    }, (err, data) => {
      if (data.index === 1) {
        // TODO: 调用API删除商品
        promptAction.showToast({
          message: '商品已删除',
          duration: 2000
        });
        router.back();
      }
    });
  }

  handleEditProduct() {
    if (!this.product) return;

    router.pushUrl({
      url: 'pages/AddProductPage',
      params: {
        productId: this.product.productId,
        isEdit: 'true'
      }
    });
  }

  getCurrencyIcon(type: CurrencyType): string {
    switch (type) {
      case CurrencyType.SHELL:
        return '💎';
      case CurrencyType.STAR:
        return '👤';
      case CurrencyType.GUILD:
        return '👥';
      default:
        return '💰';
    }
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

        Text('商品详情')
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
      } else if (this.product) {
        Scroll() {
          Column() {
            // 商品图片
            Column()
              .width('100%')
              .height(300)
              .backgroundColor('#F1F5F9')

            // 商品信息
            Column() {
              // 标签
              if (this.product.tags.length > 0) {
                Row() {
                  ForEach(this.product.tags, (tag: string) => {
                    Text(tag)
                      .fontSize(12)
                      .fontColor('#FFFFFF')
                      .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                      .backgroundColor('#E11D48')
                      .borderRadius(4)
                      .margin({ right: 8 })
                  })
                }
                .margin({ bottom: 12 })
              }

              // 商品名称
              Text(this.product.name)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1F2937')
                .margin({ bottom: 8 })

              // 价格
              Row() {
                Text(`${this.product.price}`)
                  .fontSize(28)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#E11D48')
                Text('积分')
                  .fontSize(14)
                  .fontColor('#E11D48')
                  .margin({ left: 4 })

                if (this.product.originalPrice) {
                  Text(`${this.product.originalPrice}`)
                    .fontSize(14)
                    .fontColor('#94A3B8')
                    .decoration({ type: TextDecorationType.LineThrough })
                    .margin({ left: 12 })
                }
              }
              .margin({ bottom: 16 })

              // 销量和评分
              Row() {
                Text(`已售${this.product.sales}`)
                  .fontSize(14)
                  .fontColor('#64748B')

                Text('|')
                  .fontSize(14)
                  .fontColor('#E5E7EB')
                  .margin({ left: 12, right: 12 })

                Row() {
                  Text('★')
                    .fontSize(14)
                    .fontColor('#F59E0B')
                  Text(`${this.product.rating}`)
                    .fontSize(14)
                    .fontColor('#64748B')
                    .margin({ left: 4 })
                }

                Text('|')
                  .fontSize(14)
                  .fontColor('#E5E7EB')
                  .margin({ left: 12, right: 12 })

                Text(`库存${this.product.stock}`)
                  .fontSize(14)
                  .fontColor('#64748B')
              }
            }
            .width('100%')
            .padding(16)
            .backgroundColor('#FFFFFF')
            .margin({ bottom: 8 })

            // 店铺信息
            Row() {
              Circle()
                .width(40)
                .height(40)
                .fill('#F1F5F9')

              Column() {
                Text(this.product.storeName)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#1F2937')
                  .margin({ bottom: 4 })

                Text(`兑付率 ${this.product.redemptionRate}%`)
                  .fontSize(12)
                  .fontColor('#10B981')
              }
              .alignItems(HorizontalAlign.Start)
              .margin({ left: 12 })
              .layoutWeight(1)

              Text('进店 ›')
                .fontSize(14)
                .fontColor('#2563EB')
            }
            .width('100%')
            .padding(16)
            .backgroundColor('#FFFFFF')
            .margin({ bottom: 8 })
            .onClick(() => {
              // TODO: 跳转到店铺页面
            })

            // 商品描述
            Column() {
              Text('商品描述')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1F2937')
                .margin({ bottom: 12 })

              Text(this.product.description)
                .fontSize(14)
                .fontColor('#64748B')
                .lineHeight(22)
            }
            .width('100%')
            .padding(16)
            .backgroundColor('#FFFFFF')
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')
        }
        .layoutWeight(1)
        .backgroundColor('#FFF1F2')

        // 底部操作栏
        Column() {
          // 选择货币（仅普通用户显示）
          if (!this.product.isMyProduct) {
            Row() {
              Text('支付货币:')
                .fontSize(14)
                .fontColor('#64748B')
                .margin({ right: 12 })

              ForEach(this.userCurrencies.filter(c =>
                this.product!.acceptedCurrencies.includes(c.currencyType)
              ), (currency: UserCurrency) => {
                Row() {
                  Text(this.getCurrencyIcon(currency.currencyType))
                    .fontSize(16)
                  Text(currency.currencyName)
                    .fontSize(14)
                    .fontColor(this.selectedCurrency === currency.currencyId ? '#E11D48' : '#64748B')
                    .margin({ left: 4 })
                  Text(`(${currency.balance})`)
                    .fontSize(12)
                    .fontColor('#94A3B8')
                    .margin({ left: 4 })
                }
                .padding({ left: 12, right: 12, top: 6, bottom: 6 })
                .backgroundColor(this.selectedCurrency === currency.currencyId ? '#FFF1F2' : '#F8FAFC')
                .borderRadius(12)
                .border({
                  width: 1.5,
                  color: this.selectedCurrency === currency.currencyId ? '#E11D48' : '#E5E7EB'
                })
                .margin({ right: 8 })
                .onClick(() => {
                  this.selectedCurrency = currency.currencyId;
                })
              })
            }
            .width('100%')
            .margin({ bottom: 12 })
          }

          // 底部按钮区域 - 根据是否是商品管理者显示不同内容
          if (this.product.isMyProduct) {
            // 商品管理者：显示编辑和删除按钮
            Row() {
              Button('编辑商品')
                .layoutWeight(1)
                .height(44)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#2563EB')
                .backgroundColor('#EFF6FF')
                .borderRadius(22)
                .onClick(() => {
                  this.handleEditProduct();
                })

              Button('删除商品')
                .layoutWeight(1)
                .height(44)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
                .backgroundColor('#EF4444')
                .borderRadius(22)
                .margin({ left: 12 })
                .onClick(() => {
                  this.handleDeleteProduct();
                })
            }
            .width('100%')
          } else {
            // 普通用户：显示数量选择和兑换按钮
            Row() {
              // 数量选择
              Row() {
                Text('数量:')
                  .fontSize(14)
                  .fontColor('#64748B')
                  .margin({ right: 8 })

                Row() {
                  Text('-')
                    .fontSize(20)
                    .fontColor('#64748B')
                    .width(32)
                    .height(32)
                    .textAlign(TextAlign.Center)
                    .onClick(() => {
                      this.handleQuantityChange(-1);
                    })

                  Text(`${this.quantity}`)
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#1F2937')
                    .width(40)
                    .textAlign(TextAlign.Center)

                  Text('+')
                    .fontSize(20)
                    .fontColor('#64748B')
                    .width(32)
                    .height(32)
                    .textAlign(TextAlign.Center)
                    .onClick(() => {
                      this.handleQuantityChange(1);
                    })
                }
                .backgroundColor('#F8FAFC')
                .borderRadius(8)
              }

              Blank()

              // 兑换按钮
              Button(`兑换 ${this.product.price * this.quantity}积分`)
                .height(44)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
                .backgroundColor('#E11D48')
                .borderRadius(22)
                .padding({ left: 32, right: 32 })
                .onClick(() => {
                  this.handleExchange();
                })
            }
            .width('100%')
          }
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#FFFFFF')
        .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.1)', offsetY: -2 })
      }
    }
    .width('100%')
    .height('100%')
  }
}
