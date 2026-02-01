import { router } from '@kit.ArkUI';
import { UserManager, UserInfo } from '../utils/UserManager';
import { common } from '@kit.AbilityKit';

@Component
export struct MyPage {
  @State userInfo: UserInfo | null = null;
  private context = getContext(this) as common.UIAbilityContext;

  aboutToAppear() {
    this.loadUserInfo();
  }

  async loadUserInfo() {
    await UserManager.getInstance().init(this.context);
    this.userInfo = await UserManager.getInstance().getUserInfo();
  }

  async handleLogout() {
    await UserManager.getInstance().logout();
    router.replaceUrl({ url: 'pages/LoginPage' });
  }

  build() {
    Column() {
      // 用户信息区域 - 使用渐变背景
      Column() {
        Row() {
          // 头像
          Circle()
            .width(72)
            .height(72)
            .fill('#FFFFFF')
            .border({ width: 3, color: 'rgba(255, 255, 255, 0.5)' })

          Column() {
            Text(this.userInfo?.nickname || '未登录')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .margin({ bottom: 6 })

            Text(this.userInfo?.phone || '点击登录')
              .fontSize(14)
              .fontColor('rgba(255, 255, 255, 0.85)')
              .fontWeight(FontWeight.Medium)
          }
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 16 })
        }
        .width('100%')
        .padding({ left: 24, right: 24, top: 48, bottom: 32 })
      }
      .width('100%')
      .linearGradient({
        angle: 135,
        colors: [['#E11D48', 0.0], ['#FB7185', 1.0]]
      })

      // 功能列表
      Column() {
        this.MenuItem('我的钱包', () => {
          router.pushUrl({ url: 'pages/WalletPage' });
        })
        Divider().color('#F1F5F9')
        this.MenuItem('个人信息', () => {})
        Divider().color('#F1F5F9')
        this.MenuItem('账号设置', () => {})
        Divider().color('#F1F5F9')
        this.MenuItem('隐私设置', () => {})
      }
      .width('90%')
      .backgroundColor('#FFFFFF')
      .margin({ top: -16, bottom: 16 })
      .borderRadius(16)
      .padding({ left: 20, right: 20 })
      .shadow({ radius: 12, color: 'rgba(0, 0, 0, 0.08)', offsetY: 4 })

      // 退出登录按钮
      Button('退出登录')
        .width('90%')
        .height(48)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor('#EF4444')
        .backgroundColor('#FFFFFF')
        .borderRadius(16)
        .border({ width: 1.5, color: '#EF4444' })
        .margin({ top: 8 })
        .onClick(() => {
          this.handleLogout();
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF1F2')
  }

  @Builder
  MenuItem(title: string, onClick: () => void) {
    Row() {
      Text(title)
        .fontSize(16)
        .fontColor('#1F2937')
        .fontWeight(FontWeight.Medium)

      Blank()

      Text('›')
        .fontSize(20)
        .fontColor('#94A3B8')
    }
    .width('100%')
    .height(56)
    .onClick(onClick)
  }
}
