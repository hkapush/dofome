import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

// 货币类型
enum CurrencyType {
  SHELL = 'shell',    // 世界币
  STAR = 'star',      // 个人币
  GUILD = 'guild'     // 团体币
}

// 商品信息
interface Product {
  productId: string;
  name: string;
  description: string;
  price: number;
  currencyType: CurrencyType;
  stock: number;
  image: string;
  isActive: boolean;
}

// 店铺信息
interface StoreInfo {
  storeId: string;
  storeName: string;
  storeType: 'personal' | 'team';
  description: string;
  acceptedCurrencies: CurrencyType[];
  redemptionRate: number;
  responseTime: string;
  teamId?: string;
  teamName?: string;
}

@Entry
@Component
struct MyStorePage {
  @State myStores: StoreInfo[] = [];
  @State currentStoreIndex: number = 0;
  @State products: Product[] = [];
  @State currentTab: number = 0; // 0: 商品管理, 1: 订单管理, 2: 店铺设置
  @State hasStore: boolean = false;
  @State showStoreSelector: boolean = false;

  aboutToAppear() {
    this.loadMyStores();
  }

  async loadMyStores() {
    // 模拟加载我的店铺列表
    await new Promise<void>((resolve) => setTimeout(resolve, 300));

    this.myStores = [
      {
        storeId: 'store_001',
        storeName: '我的个人小店',
        storeType: 'personal',
        description: '提供各种生活用品和服务',
        acceptedCurrencies: [CurrencyType.SHELL, CurrencyType.STAR],
        redemptionRate: 98.5,
        responseTime: '2小时内'
      },
      {
        storeId: 'store_002',
        storeName: '家庭奖励商店',
        storeType: 'team',
        description: '家庭内部奖励兑换',
        acceptedCurrencies: [CurrencyType.GUILD],
        redemptionRate: 100,
        responseTime: '即时',
        teamId: 'team_001',
        teamName: '家庭团队'
      }
    ];

    this.hasStore = this.myStores.length > 0;

    if (this.hasStore) {
      this.loadProducts();
    }
  }

  get currentStore(): StoreInfo | null {
    return this.myStores.length > 0 ? this.myStores[this.currentStoreIndex] : null;
  }

  async loadProducts() {
    // 根据当前店铺加载商品
    if (!this.currentStore) return;

    // 模拟加载商品数据
    this.products = [
      {
        productId: '1',
        name: '咖啡券',
        description: '星巴克中杯咖啡一杯',
        price: 30,
        currencyType: CurrencyType.SHELL,
        stock: 10,
        image: '',
        isActive: true
      },
      {
        productId: '2',
        name: '电影票',
        description: '万达影城电影票一张',
        price: 50,
        currencyType: CurrencyType.SHELL,
        stock: 5,
        image: '',
        isActive: true
      }
    ];
  }

  handleSwitchStore(index: number) {
    this.currentStoreIndex = index;
    this.showStoreSelector = false;
    this.loadProducts();
  }

  handleOpenStore() {
    router.pushUrl({ url: 'pages/CreateStorePage' });
  }

  handleAddProduct() {
    if (!this.currentStore) return;
    router.pushUrl({
      url: 'pages/AddProductPage',
      params: {
        storeId: this.currentStore.storeId,
        storeName: this.currentStore.storeName
      }
    });
  }

  handleEditProduct(productId: string) {
    router.pushUrl({
      url: 'pages/AddProductPage',
      params: {
        productId: productId,
        isEdit: 'true'
      }
    });
  }

  handleDeleteProduct(productId: string, productName: string) {
    promptAction.showDialog({
      title: '删除商品',
      message: `确定要删除"${productName}"吗？`,
      buttons: [
        { text: '取消', color: '#64748B' },
        { text: '删除', color: '#EF4444' }
      ]
    }, (err, data) => {
      if (data.index === 1) {
        const index = this.products.findIndex(p => p.productId === productId);
        if (index !== -1) {
          this.products.splice(index, 1);
          promptAction.showToast({
            message: '商品已删除',
            duration: 2000
          });
        }
      }
    });
  }

  handleToggleProductStatus(productId: string) {
    const product = this.products.find(p => p.productId === productId);
    if (product) {
      product.isActive = !product.isActive;
      promptAction.showToast({
        message: product.isActive ? '商品已上架' : '商品已下架',
        duration: 2000
      });
    }
  }

  getCurrencyIcon(type: CurrencyType): string {
    switch (type) {
      case CurrencyType.SHELL:
        return '💎';
      case CurrencyType.STAR:
        return '⭐';
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

        Text('我的店铺')
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

      if (!this.hasStore) {
        // 未开通店铺
        this.EmptyStoreView()
      } else {
        // 已开通店铺
        this.StoreManagementView()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF1F2')
  }

  @Builder
  EmptyStoreView() {
    Column() {
      Text('🏪')
        .fontSize(64)
        .margin({ bottom: 16 })

      Text('开通你的专属店铺')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#881337')
        .margin({ bottom: 8 })

      Text('上架商品，接受货币兑换')
        .fontSize(14)
        .fontColor('#64748B')
        .margin({ bottom: 32 })

      Column() {
        Row() {
          Text('✓')
            .fontSize(16)
            .fontColor('#10B981')
            .margin({ right: 8 })
          Text('支持多种货币类型')
            .fontSize(14)
            .fontColor('#1F2937')
        }
        .width('100%')
        .margin({ bottom: 12 })

        Row() {
          Text('✓')
            .fontSize(16)
            .fontColor('#10B981')
            .margin({ right: 8 })
          Text('自定义商品和价格')
            .fontSize(14)
            .fontColor('#1F2937')
        }
        .width('100%')
        .margin({ bottom: 12 })

        Row() {
          Text('✓')
            .fontSize(16)
            .fontColor('#10B981')
            .margin({ right: 8 })
          Text('便捷的兑换码核销')
            .fontSize(14)
            .fontColor('#1F2937')
        }
        .width('100%')
        .margin({ bottom: 12 })

        Row() {
          Text('✓')
            .fontSize(16)
            .fontColor('#10B981')
            .margin({ right: 8 })
          Text('订单管理和统计')
            .fontSize(14)
            .fontColor('#1F2937')
        }
        .width('100%')
      }
      .width('80%')
      .padding(20)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .margin({ bottom: 32 })

      Button('立即开通')
        .width(200)
        .height(48)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFFFFF')
        .backgroundColor('#E11D48')
        .borderRadius(24)
        .onClick(() => {
          this.handleOpenStore();
        })
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  StoreManagementView() {
    Column() {
      // 店铺切换区域
      if (this.currentStore) {
        Row() {
          Column() {
            Text(this.currentStore.storeName)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2937')
              .margin({ bottom: 4 })

            Row() {
              Text(this.currentStore.storeType === 'personal' ? '个人店铺' : '团队店铺')
                .fontSize(12)
                .fontColor('#64748B')

              if (this.currentStore.teamName) {
                Text('•')
                  .fontSize(12)
                  .fontColor('#94A3B8')
                  .margin({ left: 6, right: 6 })
                Text(this.currentStore.teamName)
                  .fontSize(12)
                  .fontColor('#64748B')
              }
            }
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          if (this.myStores.length > 1) {
            Row() {
              Text('切换店铺')
                .fontSize(14)
                .fontColor('#E11D48')
                .margin({ right: 4 })
              Text('▼')
                .fontSize(12)
                .fontColor('#E11D48')
            }
            .onClick(() => {
              this.showStoreSelector = true;
            })
          }
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#FFFFFF')
        .border({ width: { bottom: 1 }, color: '#F1F5F9' })
      }

      // Tab切换
      Row() {
        Text('商品管理')
          .fontSize(16)
          .fontWeight(this.currentTab === 0 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.currentTab === 0 ? '#E11D48' : '#64748B')
          .padding({ bottom: 12 })
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.currentTab = 0;
          })
          .border({
            width: { bottom: this.currentTab === 0 ? 3 : 0 },
            color: '#E11D48'
          })

        Text('订单管理')
          .fontSize(16)
          .fontWeight(this.currentTab === 1 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.currentTab === 1 ? '#E11D48' : '#64748B')
          .padding({ bottom: 12 })
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.currentTab = 1;
          })
          .border({
            width: { bottom: this.currentTab === 1 ? 3 : 0 },
            color: '#E11D48'
          })

        Text('店铺设置')
          .fontSize(16)
          .fontWeight(this.currentTab === 2 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.currentTab === 2 ? '#E11D48' : '#64748B')
          .padding({ bottom: 12 })
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.currentTab = 2;
          })
          .border({
            width: { bottom: this.currentTab === 2 ? 3 : 0 },
            color: '#E11D48'
          })
      }
      .width('100%')
      .backgroundColor('#FFFFFF')

      // 内容区域
      if (this.currentTab === 0) {
        this.ProductManagementView()
      } else if (this.currentTab === 1) {
        this.OrderManagementView()
      } else {
        this.StoreSettingsView()
      }
    }
    .width('100%')
    .layoutWeight(1)

    // 店铺选择器弹窗
    if (this.showStoreSelector) {
      this.StoreSelectorPopup()
    }
  }

  @Builder
  ProductManagementView() {
    Column() {
      // 添加商品按钮
      Button('+ 添加商品')
        .width('90%')
        .height(44)
        .fontSize(14)
        .fontColor('#2563EB')
        .backgroundColor('#EFF6FF')
        .borderRadius(8)
        .margin({ top: 16, bottom: 16 })
        .onClick(() => {
          this.handleAddProduct();
        })

      // 商品列表
      if (this.products.length === 0) {
        Column() {
          Text('📦')
            .fontSize(48)
          Text('暂无商品')
            .fontSize(16)
            .fontColor('#94A3B8')
            .margin({ top: 12 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List({ space: 12 }) {
          ForEach(this.products, (product: Product) => {
            ListItem() {
              this.ProductCard(product)
            }
          })
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 16, right: 16 })
      }
    }
    .width('100%')
    .layoutWeight(1)
  }

  @Builder
  ProductCard(product: Product) {
    Row() {
      // 商品图片占位
      Column()
        .width(80)
        .height(80)
        .backgroundColor('#F1F5F9')
        .borderRadius(8)

      // 商品信息
      Column() {
        Text(product.name)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2937')
          .margin({ bottom: 4 })

        Text(product.description)
          .fontSize(12)
          .fontColor('#64748B')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ bottom: 8 })

        Row() {
          Text(this.getCurrencyIcon(product.currencyType))
            .fontSize(16)
          Text(`${product.price}`)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#E11D48')
            .margin({ left: 4 })

          Blank()

          Text(`库存: ${product.stock}`)
            .fontSize(12)
            .fontColor('#64748B')
        }
        .width('100%')
      }
      .layoutWeight(1)
      .margin({ left: 12 })
      .alignItems(HorizontalAlign.Start)

      // 操作按钮
      Column() {
        Button(product.isActive ? '下架' : '上架')
          .fontSize(12)
          .fontColor(product.isActive ? '#EF4444' : '#10B981')
          .backgroundColor(product.isActive ? '#FEE2E2' : '#D1FAE5')
          .height(32)
          .padding({ left: 12, right: 12 })
          .onClick(() => {
            this.handleToggleProductStatus(product.productId);
          })

        Button('编辑')
          .fontSize(12)
          .fontColor('#2563EB')
          .backgroundColor('#EFF6FF')
          .height(32)
          .padding({ left: 12, right: 12 })
          .margin({ top: 8 })
          .onClick(() => {
            this.handleEditProduct(product.productId);
          })

        Button('删除')
          .fontSize(12)
          .fontColor('#EF4444')
          .backgroundColor('#FEE2E2')
          .height(32)
          .padding({ left: 12, right: 12 })
          .margin({ top: 8 })
          .onClick(() => {
            this.handleDeleteProduct(product.productId, product.name);
          })
      }
      .margin({ left: 12 })
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({ radius: 4, color: 'rgba(0, 0, 0, 0.05)', offsetY: 2 })
  }

  @Builder
  OrderManagementView() {
    Column() {
      Text('📋')
        .fontSize(48)
      Text('订单管理')
        .fontSize(16)
        .fontColor('#94A3B8')
        .margin({ top: 12 })
      Text('功能开发中...')
        .fontSize(14)
        .fontColor('#CBD5E1')
        .margin({ top: 8 })
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  StoreSettingsView() {
    Column() {
      Text('⚙️')
        .fontSize(48)
      Text('店铺设置')
        .fontSize(16)
        .fontColor('#94A3B8')
        .margin({ top: 12 })
      Text('功能开发中...')
        .fontSize(14)
        .fontColor('#CBD5E1')
        .margin({ top: 8 })
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  StoreSelectorPopup() {
    Column() {
      Column() {
        // 标题
        Row() {
          Text('选择店铺')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F2937')
            .layoutWeight(1)

          Text('✕')
            .fontSize(24)
            .fontColor('#94A3B8')
            .onClick(() => {
              this.showStoreSelector = false;
            })
        }
        .width('100%')
        .margin({ bottom: 16 })

        // 店铺列表
        Column() {
          ForEach(this.myStores, (store: StoreInfo, index: number) => {
            Row() {
              Column() {
                Text(store.storeName)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#1F2937')
                  .margin({ bottom: 4 })

                Row() {
                  Text(store.storeType === 'personal' ? '个人店铺' : '团队店铺')
                    .fontSize(12)
                    .fontColor('#64748B')

                  if (store.teamName) {
                    Text('•')
                      .fontSize(12)
                      .fontColor('#94A3B8')
                      .margin({ left: 6, right: 6 })
                    Text(store.teamName)
                      .fontSize(12)
                      .fontColor('#64748B')
                  }
                }
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)

              if (index === this.currentStoreIndex) {
                Text('✓')
                  .fontSize(20)
                  .fontColor('#10B981')
              }
            }
            .width('100%')
            .padding(16)
            .backgroundColor(index === this.currentStoreIndex ? '#F0FDF4' : '#FFFFFF')
            .borderRadius(8)
            .border({
              width: 2,
              color: index === this.currentStoreIndex ? '#10B981' : '#E5E7EB'
            })
            .margin({ bottom: 12 })
            .onClick(() => {
              this.handleSwitchStore(index);
            })
          })
        }
        .width('100%')
      }
      .width('85%')
      .padding(24)
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgba(0, 0, 0, 0.5)')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.showStoreSelector = false;
    })
  }
}
