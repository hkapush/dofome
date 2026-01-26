import { HMDefaultGlobalAnimator, HMNavigation, HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { AttributeUpdater } from '@kit.ArkUI';


class NavModifier extends AttributeUpdater<NavigationAttribute> {
  initializeModifier(instance: NavigationAttribute): void {
    instance.mode(NavigationMode.Stack);
    instance.navBarWidth('100%');
    instance.hideTitleBar(true);
    instance.hideToolBar(true);
  }
}

@Entry
@Component
struct Index {
  modifier: NavModifier = new NavModifier();
  @State message: string = 'Hello World';

  build() {
    Column() {
      HMNavigation({
        navigationId: 'mainNavigation', options: {
          standardAnimator: HMDefaultGlobalAnimator.STANDARD_ANIMATOR,
          dialogAnimator: HMDefaultGlobalAnimator.DIALOG_ANIMATOR,
          modifier: this.modifier
        }
      }) {
        RelativeContainer() {
          Text(this.message)
            .id('HelloWorld')
            .fontSize($r('app.float.page_text_font_size'))
            .fontWeight(FontWeight.Bold)
            .alignRules({
              center: { anchor: '__container__', align: VerticalAlign.Center },
              middle: { anchor: '__container__', align: HorizontalAlign.Center }
            })
            .onClick(() => {
              HMRouterMgr.push(
                {
                  navigationId: "mainNavigation",
                  pageUrl: "TwoPage"}
              );
            })
        }
        .height('100%')
        .width('100%')
      }
    }
  }
}