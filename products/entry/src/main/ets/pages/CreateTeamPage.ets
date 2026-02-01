import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

// 团队成员
interface TeamMember {
  userId: string;
  userName: string;
  userAvatar: string;
}

@Entry
@Component
struct CreateTeamPage {
  @State teamName: string = '';
  @State teamDescription: string = '';
  @State teamType: 'public' | 'private' = 'public';
  @State selectedMembers: TeamMember[] = [];
  @State showMemberSelector: boolean = false;
  @State availableMembers: TeamMember[] = [];
  @State submitting: boolean = false;
  @State enableTeamCurrency: boolean = false;
  @State teamCurrencyName: string = '';

  aboutToAppear() {
    this.loadAvailableMembers();
  }

  async loadAvailableMembers() {
    // 模拟加载好友列表
    await new Promise<void>((resolve) => setTimeout(resolve, 300));

    this.availableMembers = [
      {
        userId: 'user_001',
        userName: '小明',
        userAvatar: ''
      },
      {
        userId: 'user_002',
        userName: '小红',
        userAvatar: ''
      },
      {
        userId: 'user_003',
        userName: '小李',
        userAvatar: ''
      },
      {
        userId: 'user_004',
        userName: '小张',
        userAvatar: ''
      },
      {
        userId: 'user_005',
        userName: '小王',
        userAvatar: ''
      }
    ];
  }

  handleAddMember(member: TeamMember) {
    // 检查是否已添加
    const exists = this.selectedMembers.some(m => m.userId === member.userId);
    if (!exists) {
      this.selectedMembers.push(member);
      this.selectedMembers = [...this.selectedMembers];
    }
  }

  handleRemoveMember(userId: string) {
    this.selectedMembers = this.selectedMembers.filter(m => m.userId !== userId);
  }

  isMemberSelected(userId: string): boolean {
    return this.selectedMembers.some(m => m.userId === userId);
  }

  async handleSubmit() {
    // 验证表单
    if (!this.teamName.trim()) {
      promptAction.showToast({
        message: '请输入团队名称',
        duration: 2000
      });
      return;
    }

    if (this.selectedMembers.length === 0) {
      promptAction.showToast({
        message: '请至少添加一个成员',
        duration: 2000
      });
      return;
    }

    if (this.enableTeamCurrency && !this.teamCurrencyName.trim()) {
      promptAction.showToast({
        message: '请输入团队币名称',
        duration: 2000
      });
      return;
    }

    this.submitting = true;
    await new Promise<void>((resolve) => setTimeout(resolve, 1000));

    promptAction.showToast({
      message: '团队创建成功！',
      duration: 2000
    });

    // 返回上一页
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

        Text('创建团队')
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
          // 团队名称
          Column() {
            Text('团队名称')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2937')
              .width('100%')
              .margin({ bottom: 12 })

            TextInput({ placeholder: '请输入团队名称', text: this.teamName })
              .height(48)
              .backgroundColor('#F8FAFC')
              .borderRadius(8)
              .onChange((value: string) => {
                this.teamName = value;
              })
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
          .margin({ top: 16, left: 16, right: 16 })

          // 团队描述
          Column() {
            Text('团队描述')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2937')
              .width('100%')
              .margin({ bottom: 12 })

            TextArea({ placeholder: '请输入团队描述（可选）', text: this.teamDescription })
              .height(100)
              .backgroundColor('#F8FAFC')
              .borderRadius(8)
              .onChange((value: string) => {
                this.teamDescription = value;
              })
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
          .margin({ top: 12, left: 16, right: 16 })

          // 团队类型
          Column() {
            Text('团队类型')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2937')
              .width('100%')
              .margin({ bottom: 12 })

            Row() {
              Column() {
                Row() {
                  Radio({ value: 'public', group: 'teamType' })
                    .checked(this.teamType === 'public')
                    .onChange((isChecked: boolean) => {
                      if (isChecked) {
                        this.teamType = 'public';
                      }
                    })

                  Column() {
                    Text('公开团队')
                      .fontSize(15)
                      .fontWeight(FontWeight.Medium)
                      .fontColor('#1F2937')
                    Text('任何人都可以申请加入')
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
              .backgroundColor(this.teamType === 'public' ? '#FFF1F2' : '#F8FAFC')
              .borderRadius(8)
              .border({
                width: 2,
                color: this.teamType === 'public' ? '#E11D48' : '#E2E8F0'
              })
              .onClick(() => {
                this.teamType = 'public';
              })

              Column() {
                Row() {
                  Radio({ value: 'private', group: 'teamType' })
                    .checked(this.teamType === 'private')
                    .onChange((isChecked: boolean) => {
                      if (isChecked) {
                        this.teamType = 'private';
                      }
                    })

                  Column() {
                    Text('私密团队')
                      .fontSize(15)
                      .fontWeight(FontWeight.Medium)
                      .fontColor('#1F2937')
                    Text('仅邀请成员可加入')
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
              .backgroundColor(this.teamType === 'private' ? '#FFF1F2' : '#F8FAFC')
              .borderRadius(8)
              .border({
                width: 2,
                color: this.teamType === 'private' ? '#E11D48' : '#E2E8F0'
              })
              .margin({ left: 12 })
              .onClick(() => {
                this.teamType = 'private';
              })
            }
            .width('100%')
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
          .margin({ top: 12, left: 16, right: 16 })

          // 团队币设置
          Column() {
            Row() {
              Column() {
                Text('启用团队币')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1F2937')
                Text('团队内部流通的专属货币')
                  .fontSize(12)
                  .fontColor('#64748B')
                  .margin({ top: 4 })
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)

              Toggle({ type: ToggleType.Switch, isOn: this.enableTeamCurrency })
                .onChange((isOn: boolean) => {
                  this.enableTeamCurrency = isOn;
                })
            }
            .width('100%')
            .margin({ bottom: this.enableTeamCurrency ? 16 : 0 })

            if (this.enableTeamCurrency) {
              Column() {
                Text('团队币名称')
                  .fontSize(14)
                  .fontColor('#64748B')
                  .width('100%')
                  .margin({ bottom: 8 })

                TextInput({ placeholder: '例如：家庭积分、工作币等', text: this.teamCurrencyName })
                  .height(44)
                  .backgroundColor('#F8FAFC')
                  .borderRadius(8)
                  .onChange((value: string) => {
                    this.teamCurrencyName = value;
                  })
              }
              .width('100%')
            }
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
          .margin({ top: 12, left: 16, right: 16 })

          // 添加成员
          Column() {
            Row() {
              Text('团队成员')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1F2937')
                .layoutWeight(1)

              Button('+ 添加成员')
                .height(32)
                .fontSize(13)
                .fontColor('#2563EB')
                .backgroundColor('#EFF6FF')
                .borderRadius(16)
                .padding({ left: 16, right: 16 })
                .onClick(() => {
                  this.showMemberSelector = true;
                })
            }
            .width('100%')
            .margin({ bottom: 12 })

            if (this.selectedMembers.length === 0) {
              Column() {
                Text('👥')
                  .fontSize(32)
                Text('暂无成员')
                  .fontSize(14)
                  .fontColor('#94A3B8')
                  .margin({ top: 8 })
                Text('点击上方按钮添加成员')
                  .fontSize(12)
                  .fontColor('#CBD5E1')
                  .margin({ top: 4 })
              }
              .width('100%')
              .padding(32)
              .backgroundColor('#F8FAFC')
              .borderRadius(8)
            } else {
              Column() {
                ForEach(this.selectedMembers, (member: TeamMember) => {
                  Row() {
                    Circle()
                      .width(40)
                      .height(40)
                      .fill('#F1F5F9')

                    Text(member.userName)
                      .fontSize(15)
                      .fontColor('#1F2937')
                      .margin({ left: 12 })
                      .layoutWeight(1)

                    Text('✕')
                      .fontSize(20)
                      .fontColor('#94A3B8')
                      .onClick(() => {
                        this.handleRemoveMember(member.userId);
                      })
                  }
                  .width('100%')
                  .padding(12)
                  .backgroundColor('#F8FAFC')
                  .borderRadius(8)
                  .margin({ bottom: 8 })
                })
              }
              .width('100%')
            }
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
          .margin({ top: 12, left: 16, right: 16 })

          // 提交按钮
          Button(this.submitting ? '创建中...' : '创建团队')
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

      // 成员选择器弹窗
      if (this.showMemberSelector) {
        this.MemberSelectorDialog()
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  MemberSelectorDialog() {
    Column() {
      Column() {
        // 标题
        Row() {
          Text('添加成员')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F2937')
            .layoutWeight(1)

          Text('✕')
            .fontSize(24)
            .fontColor('#94A3B8')
            .onClick(() => {
              this.showMemberSelector = false;
            })
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#FFFFFF')

        Divider()
          .color('#F1F5F9')

        // 成员列表
        List({ space: 0 }) {
          ForEach(this.availableMembers, (member: TeamMember) => {
            ListItem() {
              Row() {
                Circle()
                  .width(48)
                  .height(48)
                  .fill('#F1F5F9')

                Text(member.userName)
                  .fontSize(16)
                  .fontColor('#1F2937')
                  .margin({ left: 12 })
                  .layoutWeight(1)

                if (this.isMemberSelected(member.userId)) {
                  Text('✓')
                    .fontSize(24)
                    .fontColor('#10B981')
                } else {
                  Button('添加')
                    .height(32)
                    .fontSize(13)
                    .fontColor('#FFFFFF')
                    .backgroundColor('#E11D48')
                    .borderRadius(16)
                    .padding({ left: 16, right: 16 })
                    .onClick(() => {
                      this.handleAddMember(member);
                    })
                }
              }
              .width('100%')
              .padding(16)
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

        // 底部按钮
        Row() {
          Button('完成')
            .width('90%')
            .height(44)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .backgroundColor('#E11D48')
            .borderRadius(22)
            .onClick(() => {
              this.showMemberSelector = false;
            })
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#FFFFFF')
      }
      .width('90%')
      .height('70%')
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
      .shadow({ radius: 16, color: 'rgba(0, 0, 0, 0.2)', offsetY: 4 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgba(0, 0, 0, 0.5)')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.showMemberSelector = false;
    })
  }
}
