import { TaskPage } from './TaskPage'
import { ShopPage } from './ShopPage'
import { MessagePage } from './MessagePage'
import { MyPage } from './MyPage'
import { router } from '@kit.ArkUI'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
export struct HomePage {
  @State currentIndex: number = 0

  @Builder
  TabBuilder(title: string, targetIndex: number) {
    Column() {
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? '#E11D48' : '#94A3B8')
        .fontSize(this.currentIndex === targetIndex ? 14 : 12)
        .fontWeight(this.currentIndex === targetIndex ? FontWeight.Bold : FontWeight.Normal)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      // 主内容区域
      Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
        TabContent() {
          TaskPage()
        }
        .tabBar(this.TabBuilder('任务', 0))

        TabContent() {
          ShopPage()
        }
        .tabBar(this.TabBuilder('商店', 1))

        // 中间占位TabContent（用于+按钮）
        TabContent() {
          Column()
        }
        .tabBar(this.CenterAddButton())

        TabContent() {
          MessagePage()
        }
        .tabBar(this.TabBuilder('消息', 3))

        TabContent() {
          MyPage()
        }
        .tabBar(this.TabBuilder('我的', 4))
      }
      .vertical(false)
      .scrollable(true)
      .barMode(BarMode.Fixed)
      .barWidth('100%')
      .barHeight(56)
      .animationDuration(0)
      .onChange((index: number) => {
        // 如果点击中间的+按钮（index=2），不切换tab
        if (index !== 2) {
          this.currentIndex = index
        }
      })
      .width('100%')
      .height('100%')
      .backgroundColor('#FFF1F2')
    }
  }

  @Builder
  CenterAddButton() {
    Column() {
      Stack() {
        Circle()
          .width(56)
          .height(56)
          .linearGradient({
            angle: 135,
            colors: [['#E11D48', 0.0], ['#FB7185', 1.0]]
          })
          .shadow({
            radius: 12,
            color: 'rgba(225, 29, 72, 0.4)',
            offsetY: 4
          })
        Text('+')
          .fontSize(32)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
      }
      .margin({ bottom: 8 })
      .onClick(() => {
        // 显示发布选项菜单
        promptAction.showDialog({
          title: '发布',
          message: '选择要发布的内容',
          buttons: [
            {
              text: '发布任务',
              color: '#E11D48'
            },
            {
              text: '上架商品',
              color: '#2563EB'
            },
            {
              text: '取消',
              color: '#94A3B8'
            }
          ]
        }).then((result) => {
          if (result.index === 0) {
            // 发布任务
            router.pushUrl({ url: 'pages/CreateTaskPage' });
          } else if (result.index === 1) {
            // 上架商品
            router.pushUrl({ url: 'pages/MyStorePage' });
          }
        });
      })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
