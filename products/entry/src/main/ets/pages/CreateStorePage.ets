import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

// 货币类型
enum CurrencyType {
  WORLD = 'world',      // 世界币
  PERSONAL = 'personal', // 个人币
  TEAM = 'team'         // 团队币
}

// 团队信息
interface TeamInfo {
  teamId: string;
  teamName: string;
  isAdmin: boolean;
}

@Entry
@Component
struct CreateStorePage {
  @State storeName: string = '';
  @State storeDescription: string = '';
  @State selectedCurrencies: Set<CurrencyType> = new Set();
  @State storeType: 'personal' | 'team' = 'personal'; // 个人店铺或团队店铺
  @State myTeams: TeamInfo[] = [];
  @State selectedTeamId: string = '';
  @State showTeamSelector: boolean = false;
  @State submitting: boolean = false;

  aboutToAppear() {
    this.loadMyTeams();
  }

  async loadMyTeams() {
    // 模拟加载我管理的团队
    await new Promise<void>((resolve) => setTimeout(resolve, 300));

    this.myTeams = [
      {
        teamId: 'team_001',
        teamName: '家庭团队',
        isAdmin: true
      },
      {
        teamId: 'team_002',
        teamName: '工作小组',
        isAdmin: true
      },
      {
        teamId: 'team_003',
        teamName: '学习小组',
        isAdmin: false
      }
    ];
  }

  handleCurrencyToggle(currency: CurrencyType) {
    if (this.selectedCurrencies.has(currency)) {
      this.selectedCurrencies.delete(currency);
    } else {
      this.selectedCurrencies.add(currency);
    }
    // 触发UI更新
    this.selectedCurrencies = new Set(this.selectedCurrencies);
  }

  isCurrencySelected(currency: CurrencyType): boolean {
    return this.selectedCurrencies.has(currency);
  }

  getCurrencyName(currency: CurrencyType): string {
    switch (currency) {
      case CurrencyType.WORLD:
        return '世界币';
      case CurrencyType.PERSONAL:
        return '个人币';
      case CurrencyType.TEAM:
        return '团队币';
      default:
        return '';
    }
  }

  getCurrencyIcon(currency: CurrencyType): string {
    switch (currency) {
      case CurrencyType.WORLD:
        return '🌍';
      case CurrencyType.PERSONAL:
        return '⭐';
      case CurrencyType.TEAM:
        return '👥';
      default:
        return '';
    }
  }

  getCurrencyDescription(currency: CurrencyType): string {
    switch (currency) {
      case CurrencyType.WORLD:
        return '全球通用的货币，可与所有用户交易';
      case CurrencyType.PERSONAL:
        return '您发行的个人货币，用于个人店铺';
      case CurrencyType.TEAM:
        return '团队内部流通的货币';
      default:
        return '';
    }
  }

  getSelectedTeamName(): string {
    const team = this.myTeams.find(t => t.teamId === this.selectedTeamId);
    return team ? team.teamName : '选择团队';
  }

  async handleSubmit() {
    // 验证表单
    if (!this.storeName.trim()) {
      promptAction.showToast({
        message: '请输入店铺名称',
        duration: 2000
      });
      return;
    }

    if (this.selectedCurrencies.size === 0) {
      promptAction.showToast({
        message: '请至少选择一种货币类型',
        duration: 2000
      });
      return;
    }

    if (this.storeType === 'team' && !this.selectedTeamId) {
      promptAction.showToast({
        message: '请选择团队',
        duration: 2000
      });
      return;
    }

    // 如果选择了团队币但是个人店铺，提示错误
    if (this.storeType === 'personal' && this.selectedCurrencies.has(CurrencyType.TEAM)) {
      promptAction.showToast({
        message: '个人店铺不能使用团队币',
        duration: 2000
      });
      return;
    }

    this.submitting = true;
    await new Promise<void>((resolve) => setTimeout(resolve, 1000));

    promptAction.showToast({
      message: '店铺创建成功！',
      duration: 2000
    });

    // 返回到我的店铺页面
    router.back();
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

        Text('创建店铺')
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
          // 店铺类型选择
          Column() {
            Text('店铺类型')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2937')
              .width('100%')
              .margin({ bottom: 12 })

            Row() {
              Column() {
                Row() {
                  Radio({ value: 'personal', group: 'storeType' })
                    .checked(this.storeType === 'personal')
                    .onChange((isChecked: boolean) => {
                      if (isChecked) {
                        this.storeType = 'personal';
                        // 如果切换到个人店铺，移除团队币选择
                        if (this.selectedCurrencies.has(CurrencyType.TEAM)) {
                          this.selectedCurrencies.delete(CurrencyType.TEAM);
                          this.selectedCurrencies = new Set(this.selectedCurrencies);
                        }
                      }
                    })

                  Column() {
                    Text('个人店铺')
                      .fontSize(15)
                      .fontWeight(FontWeight.Medium)
                      .fontColor('#1F2937')
                    Text('使用世界币和个人币')
                      .fontSize(12)
                      .fontColor('#64748B')
                      .margin({ top: 2 })
                  }
                  .alignItems(HorizontalAlign.Start)
                  .margin({ left: 8 })
                }
                .width('100%')
              }
              .layoutWeight(1)
              .padding(12)
              .backgroundColor(this.storeType === 'personal' ? '#FFF1F2' : '#F8FAFC')
              .borderRadius(8)
              .border({
                width: 2,
                color: this.storeType === 'personal' ? '#E11D48' : '#E2E8F0'
              })
              .onClick(() => {
                this.storeType = 'personal';
                if (this.selectedCurrencies.has(CurrencyType.TEAM)) {
                  this.selectedCurrencies.delete(CurrencyType.TEAM);
                  this.selectedCurrencies = new Set(this.selectedCurrencies);
                }
              })

              Column() {
                Row() {
                  Radio({ value: 'team', group: 'storeType' })
                    .checked(this.storeType === 'team')
                    .onChange((isChecked: boolean) => {
                      if (isChecked) {
                        this.storeType = 'team';
                      }
                    })

                  Column() {
                    Text('团队店铺')
                      .fontSize(15)
                      .fontWeight(FontWeight.Medium)
                      .fontColor('#1F2937')
                    Text('使用世界币和团队币')
                      .fontSize(12)
                      .fontColor('#64748B')
                      .margin({ top: 2 })
                  }
                  .alignItems(HorizontalAlign.Start)
                  .margin({ left: 8 })
                }
                .width('100%')
              }
              .layoutWeight(1)
              .padding(12)
              .backgroundColor(this.storeType === 'team' ? '#FFF1F2' : '#F8FAFC')
              .borderRadius(8)
              .border({
                width: 2,
                color: this.storeType === 'team' ? '#E11D48' : '#E2E8F0'
              })
              .margin({ left: 12 })
              .onClick(() => {
                this.storeType = 'team';
              })
            }
            .width('100%')
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
          .margin({ top: 16, left: 16, right: 16 })

          // 团队选择（仅团队店铺）
          if (this.storeType === 'team') {
            Column() {
              Text('选择团队')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1F2937')
                .width('100%')
                .margin({ bottom: 12 })

              Row() {
                Text(this.getSelectedTeamName())
                  .fontSize(15)
                  .fontColor(this.selectedTeamId ? '#1F2937' : '#94A3B8')
                  .layoutWeight(1)

                Text('→')
                  .fontSize(20)
                  .fontColor('#94A3B8')
              }
              .width('100%')
              .height(48)
              .padding({ left: 16, right: 16 })
              .backgroundColor('#F8FAFC')
              .borderRadius(8)
              .onClick(() => {
                this.showTeamSelector = true;
              })
            }
            .width('100%')
            .padding(16)
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
            .margin({ top: 12, left: 16, right: 16 })
          }

          // 店铺名称
          Column() {
            Text('店铺名称')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2937')
              .width('100%')
              .margin({ bottom: 12 })

            TextInput({ placeholder: '请输入店铺名称', text: this.storeName })
              .height(48)
              .backgroundColor('#F8FAFC')
              .borderRadius(8)
              .onChange((value: string) => {
                this.storeName = value;
              })
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
          .margin({ top: 12, left: 16, right: 16 })

          // 店铺描述
          Column() {
            Text('店铺描述')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2937')
              .width('100%')
              .margin({ bottom: 12 })

            TextArea({ placeholder: '请输入店铺描述', text: this.storeDescription })
              .height(100)
              .backgroundColor('#F8FAFC')
              .borderRadius(8)
              .onChange((value: string) => {
                this.storeDescription = value;
              })
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
          .margin({ top: 12, left: 16, right: 16 })

          // 货币类型选择
          Column() {
            Text('接受的货币类型')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2937')
              .width('100%')
              .margin({ bottom: 8 })

            Text('至少选择一种货币类型')
              .fontSize(12)
              .fontColor('#94A3B8')
              .width('100%')
              .margin({ bottom: 12 })

            // 世界币
            this.CurrencyCard(CurrencyType.WORLD)

            // 个人币（仅个人店铺）
            if (this.storeType === 'personal') {
              this.CurrencyCard(CurrencyType.PERSONAL)
            }

            // 团队币（仅团队店铺）
            if (this.storeType === 'team') {
              this.CurrencyCard(CurrencyType.TEAM)
            }
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
          .margin({ top: 12, left: 16, right: 16 })

          // 提交按钮
          Button(this.submitting ? '创建中...' : '创建店铺')
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

      // 团队选择器弹窗
      if (this.showTeamSelector) {
        this.TeamSelectorDialog()
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  CurrencyCard(currency: CurrencyType) {
    Row() {
      Checkbox()
        .select(this.isCurrencySelected(currency))

      Column() {
        Row() {
          Text(this.getCurrencyIcon(currency))
            .fontSize(20)
          Text(this.getCurrencyName(currency))
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor('#1F2937')
            .margin({ left: 8 })
        }
        .margin({ bottom: 4 })

        Text(this.getCurrencyDescription(currency))
          .fontSize(12)
          .fontColor('#64748B')
          .width('100%')
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 12 })
      .layoutWeight(1)

    }
    .width('100%')
    .padding(12)
    .backgroundColor(this.isCurrencySelected(currency) ? '#FFF1F2' : '#F8FAFC')
    .borderRadius(8)
    .border({
      width: 2,
      color: this.isCurrencySelected(currency) ? '#E11D48' : '#E2E8F0'
    })
    .margin({ bottom: 12 })
    .onClick(() => {
      this.handleCurrencyToggle(currency);
    })
  }

  @Builder
  TeamSelectorDialog() {
    Column() {
      Column() {
        // 标题
        Row() {
          Text('选择团队')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F2937')
            .layoutWeight(1)

          Text('✕')
            .fontSize(24)
            .fontColor('#94A3B8')
            .onClick(() => {
              this.showTeamSelector = false;
            })
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#FFFFFF')

        Divider()
          .color('#F1F5F9')

        // 团队列表
        List({ space: 0 }) {
          ForEach(this.myTeams.filter(t => t.isAdmin), (team: TeamInfo) => {
            ListItem() {
              Row() {
                Column() {
                  Text('👥')
                    .fontSize(24)
                }
                .width(48)
                .height(48)
                .backgroundColor('#F1F5F9')
                .borderRadius(24)
                .justifyContent(FlexAlign.Center)

                Text(team.teamName)
                  .fontSize(16)
                  .fontColor('#1F2937')
                  .margin({ left: 12 })
                  .layoutWeight(1)

                if (this.selectedTeamId === team.teamId) {
                  Text('✓')
                    .fontSize(24)
                    .fontColor('#E11D48')
                }
              }
              .width('100%')
              .padding(16)
              .onClick(() => {
                this.selectedTeamId = team.teamId;
                this.showTeamSelector = false;
              })
            }
          })
        }
        .width('100%')
        .layoutWeight(1)
        .backgroundColor('#FFFFFF')
        .divider({
          strokeWidth: 1,
          color: '#F1F5F9',
          startMargin: 76,
          endMargin: 16
        })
      }
      .width('90%')
      .height('60%')
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
      .shadow({ radius: 16, color: 'rgba(0, 0, 0, 0.2)', offsetY: 4 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgba(0, 0, 0, 0.5)')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.showTeamSelector = false;
    })
  }
}
