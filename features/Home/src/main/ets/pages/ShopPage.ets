import { promptAction } from '@kit.ArkUI';
import { router } from '@kit.ArkUI';

// 货币类型
enum CurrencyType {
  SHELL = 'shell',    // 世界币
  STAR = 'star',      // 个人币
  GUILD = 'guild'     // 团体币
}

// 货币信息
interface Currency {
  id: string;
  name: string;
  type: CurrencyType;
  balance: number;
  icon: string;
}

// 商店信息
interface Store {
  storeId: string;
  storeName: string;
  ownerName: string;
  ownerAvatar: string;
  acceptedCurrencies: CurrencyType[];
  redemptionRate: number;  // 兑付率
  responseTime: string;     // 响应时间
  productCount: number;     // 商品数量
  rating: number;           // 评分
  previewImages: string[];  // 商品预览图
}

@Component
export struct ShopPage {
  @State currentTab: number = 0; // 0: 发现商店, 1: 我的店铺
  @State myCurrencies: Currency[] = [];
  @State selectedCurrencyType: string = 'all'; // 'all' 或 CurrencyType
  @State stores: Store[] = [];
  @State filteredStores: Store[] = [];
  @State loading: boolean = false;

  aboutToAppear() {
    this.loadMyCurrencies();
    this.loadStores();
  }

  async loadMyCurrencies() {
    // 模拟加载我持有的货币
    this.myCurrencies = [
      {
        id: 'shell_1',
        name: '世界币',
        type: CurrencyType.SHELL,
        balance: 1280,
        icon: '💎'
      },
      {
        id: 'star_xiaoming',
        name: '小明币',
        type: CurrencyType.STAR,
        balance: 350,
        icon: '👤'
      },
      {
        id: 'star_xiaohong',
        name: '小红币',
        type: CurrencyType.STAR,
        balance: 120,
        icon: '👤'
      },
      {
        id: 'guild_family',
        name: '家庭币',
        type: CurrencyType.GUILD,
        balance: 500,
        icon: '👥'
      }
    ];
  }

  async loadStores() {
    this.loading = true;
    // 模拟加载商店数据
    await new Promise<void>((resolve) => setTimeout(resolve, 500));

    this.stores = [
      {
        storeId: '1',
        storeName: '小明的杂货铺',
        ownerName: '小明',
        ownerAvatar: '',
        acceptedCurrencies: [CurrencyType.STAR, CurrencyType.SHELL],
        redemptionRate: 98.5,
        responseTime: '2小时内',
        productCount: 15,
        rating: 4.8,
        previewImages: []
      },
      {
        storeId: '2',
        storeName: '家庭奖励商店',
        ownerName: '爸爸',
        ownerAvatar: '',
        acceptedCurrencies: [CurrencyType.GUILD],
        redemptionRate: 100,
        responseTime: '即时',
        productCount: 8,
        rating: 5.0,
        previewImages: []
      },
      {
        storeId: '3',
        storeName: '小红的咖啡馆',
        ownerName: '小红',
        ownerAvatar: '',
        acceptedCurrencies: [CurrencyType.STAR, CurrencyType.SHELL],
        redemptionRate: 95.0,
        responseTime: '1天内',
        productCount: 12,
        rating: 4.6,
        previewImages: []
      }
    ];

    this.filterStores();
    this.loading = false;
  }

  // 筛选商店
  filterStores() {
    if (this.selectedCurrencyType === 'all') {
      this.filteredStores = [...this.stores];
    } else {
      this.filteredStores = this.stores.filter(store =>
        store.acceptedCurrencies.includes(this.selectedCurrencyType as CurrencyType)
      );
    }
  }

  handleCurrencyFilter(currencyType: string) {
    this.selectedCurrencyType = currencyType;
    this.filterStores();
  }

  // 获取我持有的指定类型货币余额
  getMyCurrencyBalance(type: CurrencyType): number {
    const currency = this.myCurrencies.find(c => c.type === type);
    return currency ? currency.balance : 0;
  }

  handleStoreClick(store: Store) {
    // 跳转到店铺详情页，显示商品列表
    router.pushUrl({
      url: 'pages/StoreDetailPage',
      params: {
        storeId: store.storeId,
        storeName: store.storeName
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

  getCurrencyName(type: CurrencyType): string {
    switch (type) {
      case CurrencyType.SHELL:
        return '世界币';
      case CurrencyType.STAR:
        return '个人币';
      case CurrencyType.GUILD:
        return '团体币';
      default:
        return '';
    }
  }

  build() {
    Column() {
      // 顶部标题栏
      Row() {
        Text('商店')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#881337')

        Blank()

        // Tab切换按钮
        Row() {
          Text('发现商店')
            .fontSize(14)
            .fontWeight(this.currentTab === 0 ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.currentTab === 0 ? '#E11D48' : '#64748B')
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .backgroundColor(this.currentTab === 0 ? '#FFF1F2' : 'transparent')
            .borderRadius(12)
            .onClick(() => {
              this.currentTab = 0;
            })

          Text('我的店铺')
            .fontSize(14)
            .fontWeight(this.currentTab === 1 ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.currentTab === 1 ? '#E11D48' : '#64748B')
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .backgroundColor(this.currentTab === 1 ? '#FFF1F2' : 'transparent')
            .borderRadius(12)
            .margin({ left: 8 })
            .onClick(() => {
              this.currentTab = 1;
            })
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 12 })
      .backgroundColor('#FFFFFF')

      if (this.currentTab === 0) {
        this.BrowseStoresView()
      } else {
        this.MyStoreView()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF1F2')
  }

  @Builder
  BrowseStoresView() {
    Column() {
      // 货币筛选条
      Column() {
        Scroll() {
          Row() {
            // 全部选项
            Button('全部')
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor(this.selectedCurrencyType === 'all' ? '#FFFFFF' : '#64748B')
              .backgroundColor(this.selectedCurrencyType === 'all' ? '#E11D48' : '#F1F5F9')
              .height(36)
              .borderRadius(18)
              .padding({ left: 16, right: 16 })
              .onClick(() => {
                this.handleCurrencyFilter('all');
              })

            // 世界币筛选
            Button() {
              Row() {
                Text('💎')
                  .fontSize(14)
                Text('世界币')
                  .fontSize(14)
                  .margin({ left: 4 })
              }
            }
            .fontWeight(FontWeight.Medium)
            .fontColor(this.selectedCurrencyType === CurrencyType.SHELL ? '#FFFFFF' : '#64748B')
            .backgroundColor(this.selectedCurrencyType === CurrencyType.SHELL ? '#E11D48' : '#F1F5F9')
            .height(36)
            .borderRadius(18)
            .padding({ left: 16, right: 16 })
            .margin({ left: 8 })
            .onClick(() => {
              this.handleCurrencyFilter(CurrencyType.SHELL);
            })

            // 个人币筛选
            Button() {
              Row() {
                Text('👤')
                  .fontSize(14)
                Text('个人币')
                  .fontSize(14)
                  .margin({ left: 4 })
              }
            }
            .fontWeight(FontWeight.Medium)
            .fontColor(this.selectedCurrencyType === CurrencyType.STAR ? '#FFFFFF' : '#64748B')
            .backgroundColor(this.selectedCurrencyType === CurrencyType.STAR ? '#E11D48' : '#F1F5F9')
            .height(36)
            .borderRadius(18)
            .padding({ left: 16, right: 16 })
            .margin({ left: 8 })
            .onClick(() => {
              this.handleCurrencyFilter(CurrencyType.STAR);
            })

            // 团体币筛选
            Button() {
              Row() {
                Text('👥')
                  .fontSize(14)
                Text('团体币')
                  .fontSize(14)
                  .margin({ left: 4 })
              }
            }
            .fontWeight(FontWeight.Medium)
            .fontColor(this.selectedCurrencyType === CurrencyType.GUILD ? '#FFFFFF' : '#64748B')
            .backgroundColor(this.selectedCurrencyType === CurrencyType.GUILD ? '#E11D48' : '#F1F5F9')
            .height(36)
            .borderRadius(18)
            .padding({ left: 16, right: 16 })
            .margin({ left: 8 })
            .onClick(() => {
              this.handleCurrencyFilter(CurrencyType.GUILD);
            })
          }
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .width('100%')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .margin({ bottom: 8 })

      // 商店列表
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
        List({ space: 12 }) {
          ForEach(this.filteredStores, (store: Store) => {
            ListItem() {
              this.StoreCard(store)
            }
          })
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 16, right: 16, top: 8, bottom: 16 })
      }
    }
    .width('100%')
    .layoutWeight(1)
  }

  @Builder
  MyStoreView() {
    Column() {
      // 我的店铺管理界面
      Column() {
        Text('🏪')
          .fontSize(48)
          .margin({ bottom: 12 })

        Text('我的店铺')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#881337')
          .margin({ bottom: 8 })

        Text('管理商品、库存与订单兑付')
          .fontSize(14)
          .fontColor('#64748B')
          .margin({ bottom: 24 })

        Button('进入店铺管理')
          .width(200)
          .height(44)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor('#FFFFFF')
          .backgroundColor('#E11D48')
          .borderRadius(22)
          .onClick(() => {
            router.pushUrl({ url: 'pages/MyStorePage' });
          })
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .layoutWeight(1)
  }

  @Builder
  StoreCard(store: Store) {
    Column() {
      Row() {
        // 店主头像
        Circle()
          .width(48)
          .height(48)
          .fill('#F1F5F9')

        Column() {
          Text(store.storeName)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F2937')
            .margin({ bottom: 4 })

          Row() {
            Text(`店主: ${store.ownerName}`)
              .fontSize(12)
              .fontColor('#64748B')

            Text('•')
              .fontSize(12)
              .fontColor('#94A3B8')
              .margin({ left: 6, right: 6 })

            Text(`${store.productCount}件商品`)
              .fontSize(12)
              .fontColor('#64748B')
          }
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 12 })
        .layoutWeight(1)

        // 评分
        Column() {
          Row() {
            Text('★')
              .fontSize(14)
              .fontColor('#F59E0B')
            Text(`${store.rating}`)
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2937')
              .margin({ left: 2 })
          }
        }
      }
      .width('100%')
      .margin({ bottom: 12 })

      // 支持的货币和我的余额
      Column() {
        Text('可用货币')
          .fontSize(12)
          .fontColor('#94A3B8')
          .margin({ bottom: 8 })
          .alignSelf(ItemAlign.Start)

        Row() {
          ForEach(store.acceptedCurrencies, (type: CurrencyType) => {
            Row() {
              Text(this.getCurrencyIcon(type))
                .fontSize(16)
              Text(this.getCurrencyName(type))
                .fontSize(13)
                .fontColor('#1F2937')
                .margin({ left: 4, right: 8 })
              Text(`${this.getMyCurrencyBalance(type)}`)
                .fontSize(13)
                .fontWeight(FontWeight.Bold)
                .fontColor('#E11D48')
            }
            .padding({ left: 10, right: 10, top: 6, bottom: 6 })
            .backgroundColor('#F8FAFC')
            .borderRadius(8)
            .margin({ right: 8 })
          })
        }
        .width('100%')
      }
      .width('100%')
      .padding(12)
      .backgroundColor('#FAFAFA')
      .borderRadius(8)
      .margin({ bottom: 12 })

      // 店铺信息
      Row() {
        Row() {
          Text('⏱️')
            .fontSize(12)
          Text(`${store.responseTime}`)
            .fontSize(12)
            .fontColor('#64748B')
            .margin({ left: 4 })
        }

        Blank()

        Text(`兑付率 ${store.redemptionRate}%`)
          .fontSize(12)
          .fontColor('#10B981')
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
    .onClick(() => {
      this.handleStoreClick(store);
    })
  }
}
