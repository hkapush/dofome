import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

// 货币类型
enum CurrencyType {
  SHELL = 'shell',    // 世界币
  STAR = 'star',      // 个人币
  GUILD = 'guild'     // 团体币
}

@Entry
@Component
struct AddProductPage {
  @State storeId: string = '';
  @State storeName: string = '';
  @State productId: string = '';
  @State isEdit: boolean = false;

  @State productName: string = '';
  @State productDescription: string = '';
  @State price: string = '';
  @State stock: string = '';
  @State selectedCurrency: CurrencyType = CurrencyType.SHELL;
  @State submitting: boolean = false;

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    this.storeId = params['storeId'] || '';
    this.storeName = params['storeName'] || '';
    this.productId = params['productId'] || '';
    this.isEdit = params['isEdit'] === 'true';

    if (this.isEdit) {
      this.loadProductData();
    }
  }

  async loadProductData() {
    // 模拟加载商品数据
    await new Promise<void>((resolve) => setTimeout(resolve, 300));

    this.productName = '咖啡券';
    this.productDescription = '星巴克中杯咖啡一杯';
    this.price = '30';
    this.stock = '10';
    this.selectedCurrency = CurrencyType.SHELL;
  }

  async handleSubmit() {
    // 验证表单
    if (!this.productName.trim()) {
      promptAction.showToast({
        message: '请输入商品名称',
        duration: 2000
      });
      return;
    }

    if (!this.price || Number(this.price) <= 0) {
      promptAction.showToast({
        message: '请输入有效的价格',
        duration: 2000
      });
      return;
    }

    if (!this.stock || Number(this.stock) < 0) {
      promptAction.showToast({
        message: '请输入有效的库存',
        duration: 2000
      });
      return;
    }

    this.submitting = true;

    // 模拟提交
    await new Promise<void>((resolve) => setTimeout(resolve, 1000));

    promptAction.showToast({
      message: this.isEdit ? '商品已更新' : '商品已添加',
      duration: 2000
    });

    this.submitting = false;
    router.back();
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

        Text(this.isEdit ? '编辑商品' : '添加商品')
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

      Scroll() {
        Column() {
          // 店铺信息
          if (this.storeName) {
            Row() {
              Text('店铺：')
                .fontSize(14)
                .fontColor('#64748B')
              Text(this.storeName)
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor('#1F2937')
            }
            .width('100%')
            .padding(16)
            .backgroundColor('#F8FAFC')
          }

          // 商品名称
          Column() {
            Text('商品名称')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2937')
              .width('100%')
              .margin({ bottom: 12 })

            TextInput({ placeholder: '请输入商品名称', text: this.productName })
              .height(48)
              .backgroundColor('#F8FAFC')
              .borderRadius(8)
              .onChange((value: string) => {
                this.productName = value;
              })
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
          .margin({ top: 16, left: 16, right: 16 })

          // 商品描述
          Column() {
            Text('商品描述')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2937')
              .width('100%')
              .margin({ bottom: 12 })

            TextArea({ placeholder: '请输入商品描述', text: this.productDescription })
              .height(100)
              .backgroundColor('#F8FAFC')
              .borderRadius(8)
              .onChange((value: string) => {
                this.productDescription = value;
              })
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
          .margin({ top: 12, left: 16, right: 16 })

          // 货币类型
          Column() {
            Text('货币类型')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2937')
              .width('100%')
              .margin({ bottom: 12 })

            Row() {
              this.CurrencyOption(CurrencyType.SHELL)
              this.CurrencyOption(CurrencyType.STAR)
              this.CurrencyOption(CurrencyType.GUILD)
            }
            .width('100%')
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
          .margin({ top: 12, left: 16, right: 16 })

          // 价格和库存
          Row() {
            Column() {
              Text('价格')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1F2937')
                .width('100%')
                .margin({ bottom: 12 })

              TextInput({ placeholder: '0', text: this.price })
                .height(48)
                .backgroundColor('#F8FAFC')
                .borderRadius(8)
                .type(InputType.Number)
                .onChange((value: string) => {
                  this.price = value;
                })
            }
            .layoutWeight(1)
            .padding(16)
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })

            Column() {
              Text('库存')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1F2937')
                .width('100%')
                .margin({ bottom: 12 })

              TextInput({ placeholder: '0', text: this.stock })
                .height(48)
                .backgroundColor('#F8FAFC')
                .borderRadius(8)
                .type(InputType.Number)
                .onChange((value: string) => {
                  this.stock = value;
                })
            }
            .layoutWeight(1)
            .padding(16)
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
            .margin({ left: 12 })
          }
          .width('100%')
          .padding({ left: 16, right: 16 })
          .margin({ top: 12 })

          // 提交按钮
          Button(this.submitting ? '提交中...' : (this.isEdit ? '保存修改' : '添加商品'))
            .width('90%')
            .height(48)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .backgroundColor(this.submitting ? '#94A3B8' : '#E11D48')
            .borderRadius(24)
            .margin({ top: 24, bottom: 24 })
            .enabled(!this.submitting)
            .onClick(() => {
              this.handleSubmit();
            })
        }
        .width('100%')
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor('#FFF1F2')
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  CurrencyOption(type: CurrencyType) {
    Column() {
      Text(this.getCurrencyIcon(type))
        .fontSize(24)
        .margin({ bottom: 4 })
      Text(this.getCurrencyName(type))
        .fontSize(12)
        .fontColor(this.selectedCurrency === type ? '#E11D48' : '#64748B')
    }
    .layoutWeight(1)
    .padding(12)
    .backgroundColor(this.selectedCurrency === type ? '#FFF1F2' : '#F8FAFC')
    .borderRadius(8)
    .border({
      width: 2,
      color: this.selectedCurrency === type ? '#E11D48' : '#E2E8F0'
    })
    .margin({ right: type !== CurrencyType.GUILD ? 8 : 0 })
    .onClick(() => {
      this.selectedCurrency = type;
    })
  }
}
