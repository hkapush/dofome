import { router } from '@kit.ArkUI';
import { UserManager } from '../utils/UserManager';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct Index {
  private context = getContext(this) as common.UIAbilityContext;

  aboutToAppear(): void {
    this.checkLoginStatus();
  }

  async checkLoginStatus() {
    // 初始化UserManager
    await UserManager.getInstance().init(this.context);

    // 显示启动页1秒后检查登录状态
    setTimeout(async () => {
      const isLoggedIn = await UserManager.getInstance().isLoggedIn();

      if (isLoggedIn) {
        // 已登录，跳转到首页
        router.replaceUrl({ url: 'pages/HomePage' });
      } else {
        // 未登录，跳转到登录页
        router.replaceUrl({ url: 'pages/LoginPage' });
      }
    }, 1500);
  }

  build() {
    Column() {
      // 启动页UI - 使用品牌渐变背景
      Column() {
        Image($r('app.media.startIcon'))
          .width(120)
          .height(120)
          .margin({ bottom: 24 })
          .borderRadius(24)

        Text('DoForMe')
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .margin({ bottom: 12 })
          .letterSpacing(1)

        Text('让生活更简单')
          .fontSize(18)
          .fontColor('rgba(255, 255, 255, 0.85)')
          .fontWeight(FontWeight.Medium)
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .linearGradient({
      angle: 135,
      colors: [['#E11D48', 0.0], ['#FB7185', 1.0]]
    })
  }
}