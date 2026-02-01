import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

// 货币类型
enum CurrencyType {
  SHELL = 'shell',    // 世界币
  STAR = 'star',      // 个人币
  GUILD = 'guild'     // 团体币
}

// 货币信息
interface WalletCurrency {
  currencyId: string;
  currencyName: string;
  currencyType: CurrencyType;
  balance: number;
  issuer?: string;
  icon: string;
}

// 交易记录
interface Transaction {
  transactionId: string;
  type: 'income' | 'expense';
  amount: number;
  currencyName: string;
  description: string;
  time: string;
}

@Entry
@Component
struct WalletPage {
  @State currentTab: number = 0; // 0: 我的货币, 1: 交易记录
  @State currencies: WalletCurrency[] = [];
  @State transactions: Transaction[] = [];
  @State totalValue: number = 0;

  aboutToAppear() {
    this.loadCurrencies();
    this.loadTransactions();
  }

  async loadCurrencies() {
    // 模拟加载货币数据
    this.currencies = [
      {
        currencyId: 'shell_1',
        currencyName: '世界币',
        currencyType: CurrencyType.SHELL,
        balance: 1280,
        icon: '💎'
      },
      {
        currencyId: 'star_xiaoming',
        currencyName: '小明币',
        currencyType: CurrencyType.STAR,
        balance: 350,
        issuer: '小明',
        icon: '👤'
      },
      {
        currencyId: 'star_xiaohong',
        currencyName: '小红币',
        currencyType: CurrencyType.STAR,
        balance: 120,
        issuer: '小红',
        icon: '👤'
      },
      {
        currencyId: 'guild_family',
        currencyName: '家庭币',
        currencyType: CurrencyType.GUILD,
        balance: 500,
        issuer: '我们的家',
        icon: '👥'
      }
    ];

    // 计算总价值（以世界币为基准）
    this.totalValue = this.currencies.reduce((sum, c) => sum + c.balance, 0);
  }

  async loadTransactions() {
    // 模拟加载交易记录
    this.transactions = [
      {
        transactionId: '1',
        type: 'income',
        amount: 50,
        currencyName: '世界币',
        description: '完成任务：帮我买咖啡',
        time: '2026-02-01 14:30:00'
      },
      {
        transactionId: '2',
        type: 'expense',
        amount: 30,
        currencyName: '世界币',
        description: '兑换商品：咖啡券',
        time: '2026-02-01 12:15:00'
      },
      {
        transactionId: '3',
        type: 'income',
        amount: 20,
        currencyName: '小明币',
        description: '完成任务：整理文档',
        time: '2026-02-01 10:00:00'
      },
      {
        transactionId: '4',
        type: 'income',
        amount: 100,
        currencyName: '家庭币',
        description: '完成任务：整理房间',
        time: '2026-01-31 18:00:00'
      }
    ];
  }

  handleCurrencyClick(currency: WalletCurrency) {
    router.pushUrl({
      url: 'pages/CurrencyDetailPage',
      params: {
        currencyId: currency.currencyId,
        currencyName: currency.currencyName
      }
    });
  }

  handleTransfer() {
    router.pushUrl({ url: 'pages/TransferPage' });
  }

  handleIssueCurrency() {
    router.pushUrl({ url: 'pages/IssueCurrencyPage' });
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

        Text('我的钱包')
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

      // 总资产卡片
      Column() {
        Text('总资产（等值）')
          .fontSize(14)
          .fontColor('rgba(255, 255, 255, 0.8)')
          .margin({ bottom: 8 })

        Text(`${this.totalValue}`)
          .fontSize(36)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .margin({ bottom: 24 })

        Row() {
          Button('转账')
            .height(40)
            .fontSize(14)
            .fontColor('#E11D48')
            .backgroundColor('#FFFFFF')
            .borderRadius(20)
            .layoutWeight(1)
            .onClick(() => {
              this.handleTransfer();
            })

          Button('发行货币')
            .height(40)
            .fontSize(14)
            .fontColor('#E11D48')
            .backgroundColor('#FFFFFF')
            .borderRadius(20)
            .layoutWeight(1)
            .margin({ left: 12 })
            .onClick(() => {
              this.handleIssueCurrency();
            })
        }
        .width('100%')
      }
      .width('100%')
      .padding(24)
      .linearGradient({
        angle: 135,
        colors: [['#E11D48', 0.0], ['#FB7185', 1.0]]
      })

      // Tab切换
      Row() {
        Column() {
          Text('我的货币')
            .fontSize(16)
            .fontWeight(this.currentTab === 0 ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.currentTab === 0 ? '#E11D48' : '#64748B')
            .padding({ bottom: 12 })

          if (this.currentTab === 0) {
            Divider()
              .width(60)
              .height(3)
              .color('#E11D48')
          }
        }
        .layoutWeight(1)
        .onClick(() => {
          this.currentTab = 0;
        })

        Column() {
          Text('交易记录')
            .fontSize(16)
            .fontWeight(this.currentTab === 1 ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.currentTab === 1 ? '#E11D48' : '#64748B')
            .padding({ bottom: 12 })

          if (this.currentTab === 1) {
            Divider()
              .width(60)
              .height(3)
              .color('#E11D48')
          }
        }
        .layoutWeight(1)
        .onClick(() => {
          this.currentTab = 1;
        })
      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .padding({ top: 8 })

      Divider()
        .color('#F1F5F9')

      // 内容区域
      if (this.currentTab === 0) {
        this.CurrenciesView()
      } else {
        this.TransactionsView()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF1F2')
  }

  @Builder
  CurrenciesView() {
    List({ space: 12 }) {
      ForEach(this.currencies, (currency: WalletCurrency) => {
        ListItem() {
          this.CurrencyCard(currency)
        }
      })
    }
    .width('100%')
    .layoutWeight(1)
    .padding(16)
  }

  @Builder
  CurrencyCard(currency: WalletCurrency) {
    Row() {
      // 货币图标
      Column() {
        Text(currency.icon)
          .fontSize(32)
      }
      .width(56)
      .height(56)
      .backgroundColor('#F1F5F9')
      .borderRadius(28)
      .justifyContent(FlexAlign.Center)

      // 货币信息
      Column() {
        Text(currency.currencyName)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2937')
          .margin({ bottom: 4 })

        if (currency.issuer) {
          Text(`发行者: ${currency.issuer}`)
            .fontSize(12)
            .fontColor('#64748B')
        }
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 12 })
      .layoutWeight(1)

      // 余额
      Column() {
        Text(`${currency.balance}`)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#E11D48')
      }
      .alignItems(HorizontalAlign.End)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({ radius: 4, color: 'rgba(0, 0, 0, 0.05)', offsetY: 2 })
    .onClick(() => {
      this.handleCurrencyClick(currency);
    })
  }

  @Builder
  TransactionsView() {
    if (this.transactions.length === 0) {
      Column() {
        Text('📊')
          .fontSize(48)
        Text('暂无交易记录')
          .fontSize(16)
          .fontColor('#94A3B8')
          .margin({ top: 12 })
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
    } else {
      List({ space: 0 }) {
        ForEach(this.transactions, (transaction: Transaction) => {
          ListItem() {
            this.TransactionCard(transaction)
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor('#FFFFFF')
      .divider({
        strokeWidth: 1,
        color: '#F1F5F9',
        startMargin: 16,
        endMargin: 16
      })
    }
  }

  @Builder
  TransactionCard(transaction: Transaction) {
    Row() {
      // 类型图标
      Column() {
        Text(transaction.type === 'income' ? '↓' : '↑')
          .fontSize(24)
          .fontColor(transaction.type === 'income' ? '#10B981' : '#EF4444')
      }
      .width(40)
      .height(40)
      .backgroundColor(transaction.type === 'income' ? '#D1FAE5' : '#FEE2E2')
      .borderRadius(20)
      .justifyContent(FlexAlign.Center)

      // 交易信息
      Column() {
        Text(transaction.description)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1F2937')
          .margin({ bottom: 4 })

        Row() {
          Text(transaction.currencyName)
            .fontSize(12)
            .fontColor('#64748B')

          Text('•')
            .fontSize(12)
            .fontColor('#E5E7EB')
            .margin({ left: 6, right: 6 })

          Text(this.formatTime(transaction.time))
            .fontSize(12)
            .fontColor('#94A3B8')
        }
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 12 })
      .layoutWeight(1)

      // 金额
      Text(`${transaction.type === 'income' ? '+' : '-'}${transaction.amount}`)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor(transaction.type === 'income' ? '#10B981' : '#EF4444')
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
  }
}
