import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

// 搜索结果
interface SearchResult {
  userId: string;
  userName: string;
  userAvatar: string;
  isFriend: boolean;
}

@Entry
@Component
struct AddFriendPage {
  @State searchText: string = '';
  @State searchResults: SearchResult[] = [];
  @State searching: boolean = false;

  async handleSearch() {
    if (!this.searchText.trim()) {
      promptAction.showToast({
        message: '请输入用户ID或昵称',
        duration: 2000
      });
      return;
    }

    this.searching = true;
    // 模拟搜索
    await new Promise<void>((resolve) => setTimeout(resolve, 500));

    this.searchResults = [
      {
        userId: 'user_006',
        userName: '小赵',
        userAvatar: '',
        isFriend: false
      },
      {
        userId: 'user_007',
        userName: '小钱',
        userAvatar: '',
        isFriend: false
      }
    ];

    this.searching = false;
  }

  async handleAddFriend(userId: string) {
    // 模拟添加好友
    await new Promise<void>((resolve) => setTimeout(resolve, 500));

    promptAction.showToast({
      message: '好友请求已发送',
      duration: 2000
    });

    // 更新状态
    const result = this.searchResults.find(r => r.userId === userId);
    if (result) {
      result.isFriend = true;
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

        Text('添加好友')
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

      Column() {
        // 搜索框
        Row() {
          TextInput({ placeholder: '输入用户ID或昵称', text: this.searchText })
            .height(44)
            .backgroundColor('#F8FAFC')
            .borderRadius(22)
            .layoutWeight(1)
            .onChange((value: string) => {
              this.searchText = value;
            })

          Button('搜索')
            .height(44)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor('#FFFFFF')
            .backgroundColor('#E11D48')
            .borderRadius(22)
            .padding({ left: 24, right: 24 })
            .margin({ left: 12 })
            .onClick(() => {
              this.handleSearch();
            })
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#FFFFFF')

        // 搜索结果
        if (this.searching) {
          Column() {
            LoadingProgress()
              .width(40)
              .height(40)
              .color('#E11D48')
            Text('搜索中...')
              .fontSize(14)
              .fontColor('#94A3B8')
              .margin({ top: 12 })
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
        } else if (this.searchResults.length === 0) {
          Column() {
            Text('🔍')
              .fontSize(48)
            Text('搜索用户')
              .fontSize(16)
              .fontColor('#94A3B8')
              .margin({ top: 12 })
            Text('输入用户ID或昵称进行搜索')
              .fontSize(14)
              .fontColor('#CBD5E1')
              .margin({ top: 8 })
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
        } else {
          List({ space: 12 }) {
            ForEach(this.searchResults, (result: SearchResult) => {
              ListItem() {
                this.UserCard(result)
              }
            })
          }
          .width('100%')
          .layoutWeight(1)
          .padding(16)
        }
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor('#FFF1F2')
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  UserCard(result: SearchResult) {
    Row() {
      Circle()
        .width(48)
        .height(48)
        .fill('#F1F5F9')

      Column() {
        Text(result.userName)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1F2937')
          .margin({ bottom: 4 })

        Text(`ID: ${result.userId}`)
          .fontSize(12)
          .fontColor('#64748B')
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 12 })
      .layoutWeight(1)

      if (result.isFriend) {
        Text('已添加')
          .fontSize(14)
          .fontColor('#94A3B8')
      } else {
        Button('添加')
          .height(36)
          .fontSize(14)
          .fontColor('#FFFFFF')
          .backgroundColor('#E11D48')
          .borderRadius(18)
          .padding({ left: 20, right: 20 })
          .onClick(() => {
            this.handleAddFriend(result.userId);
          })
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({ radius: 4, color: 'rgba(0, 0, 0, 0.05)', offsetY: 2 })
  }
}
