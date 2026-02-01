import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

// 好友信息
interface Friend {
  friendId: string;
  friendName: string;
  friendAvatar: string;
  isOnline: boolean;
  groupName: string;
}

// 团队信息
interface Team {
  teamId: string;
  teamName: string;
  teamAvatar: string;
  memberCount: number;
  description: string;
}

@Entry
@Component
struct ContactsPage {
  @State currentTab: number = 0; // 0: 好友, 1: 团队
  @State friends: Friend[] = [];
  @State teams: Team[] = [];
  @State friendGroups: string[] = [];

  aboutToAppear() {
    this.loadFriends();
    this.loadTeams();
  }

  async loadFriends() {
    // 模拟加载好友列表
    this.friends = [
      {
        friendId: 'user_001',
        friendName: '小明',
        friendAvatar: '',
        isOnline: true,
        groupName: '好友'
      },
      {
        friendId: 'user_002',
        friendName: '小红',
        friendAvatar: '',
        isOnline: false,
        groupName: '好友'
      },
      {
        friendId: 'user_003',
        friendName: '小李',
        friendAvatar: '',
        isOnline: true,
        groupName: '同事'
      },
      {
        friendId: 'user_004',
        friendName: '小张',
        friendAvatar: '',
        isOnline: false,
        groupName: '同事'
      },
      {
        friendId: 'user_005',
        friendName: '小王',
        friendAvatar: '',
        isOnline: true,
        groupName: '家人'
      }
    ];

    // 提取分组
    this.friendGroups = Array.from(new Set(this.friends.map(f => f.groupName)));
  }

  async loadTeams() {
    // 模拟加载团队列表
    this.teams = [
      {
        teamId: 'team_001',
        teamName: '我们的家',
        teamAvatar: '',
        memberCount: 4,
        description: '家庭团队'
      },
      {
        teamId: 'team_002',
        teamName: '工作小组',
        teamAvatar: '',
        memberCount: 8,
        description: '项目协作团队'
      }
    ];
  }

  handleAddFriend() {
    router.pushUrl({ url: 'pages/AddFriendPage' });
  }

  handleCreateTeam() {
    router.pushUrl({ url: 'pages/CreateTeamPage' });
  }

  handleFriendClick(friend: Friend) {
    router.pushUrl({
      url: 'pages/ChatPage',
      params: {
        friendId: friend.friendId,
        friendName: friend.friendName,
        friendAvatar: friend.friendAvatar
      }
    });
  }

  handleTeamClick(team: Team) {
    router.pushUrl({
      url: 'pages/TeamDetailPage',
      params: {
        teamId: team.teamId,
        teamName: team.teamName
      }
    });
  }

  getFriendsByGroup(groupName: string): Friend[] {
    return this.friends.filter(f => f.groupName === groupName);
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

        Text('通讯录')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#881337')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Row() {
          Text('+')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#E11D48')
        }
        .width(40)
        .height(40)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          if (this.currentTab === 0) {
            this.handleAddFriend();
          } else {
            this.handleCreateTeam();
          }
        })
      }
      .width('100%')
      .height(56)
      .padding({ left: 8, right: 8 })
      .backgroundColor('#FFFFFF')
      .shadow({ radius: 4, color: 'rgba(0, 0, 0, 0.05)', offsetY: 2 })

      // Tab切换
      Row() {
        Column() {
          Text('好友')
            .fontSize(16)
            .fontWeight(this.currentTab === 0 ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.currentTab === 0 ? '#E11D48' : '#64748B')
            .padding({ bottom: 12 })

          if (this.currentTab === 0) {
            Divider()
              .width(40)
              .height(3)
              .color('#E11D48')
          }
        }
        .layoutWeight(1)
        .onClick(() => {
          this.currentTab = 0;
        })

        Column() {
          Text('团队')
            .fontSize(16)
            .fontWeight(this.currentTab === 1 ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.currentTab === 1 ? '#E11D48' : '#64748B')
            .padding({ bottom: 12 })

          if (this.currentTab === 1) {
            Divider()
              .width(40)
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
        this.FriendsView()
      } else {
        this.TeamsView()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF1F2')
  }

  @Builder
  FriendsView() {
    if (this.friends.length === 0) {
      Column() {
        Text('👥')
          .fontSize(48)
        Text('暂无好友')
          .fontSize(16)
          .fontColor('#94A3B8')
          .margin({ top: 12 })
        Text('点击右上角+添加好友')
          .fontSize(14)
          .fontColor('#CBD5E1')
          .margin({ top: 8 })
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
    } else {
      List() {
        ForEach(this.friendGroups, (groupName: string) => {
          ListItemGroup({ header: this.GroupHeader(groupName) }) {
            ForEach(this.getFriendsByGroup(groupName), (friend: Friend) => {
              ListItem() {
                this.FriendCard(friend)
              }
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
        startMargin: 68,
        endMargin: 16
      })
    }
  }

  @Builder
  GroupHeader(groupName: string) {
    Row() {
      Text(groupName)
        .fontSize(14)
        .fontColor('#64748B')
        .fontWeight(FontWeight.Medium)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 8 })
    .backgroundColor('#F8FAFC')
  }

  @Builder
  FriendCard(friend: Friend) {
    Row() {
      // 头像
      Stack() {
        Circle()
          .width(48)
          .height(48)
          .fill('#F1F5F9')

        // 在线状态
        if (friend.isOnline) {
          Circle()
            .width(12)
            .height(12)
            .fill('#10B981')
            .border({ width: 2, color: '#FFFFFF' })
        }
      }
      .alignContent(Alignment.BottomEnd)

      // 好友信息
      Column() {
        Text(friend.friendName)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1F2937')
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 12 })
      .layoutWeight(1)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .onClick(() => {
      this.handleFriendClick(friend);
    })
  }

  @Builder
  TeamsView() {
    if (this.teams.length === 0) {
      Column() {
        Text('👥')
          .fontSize(48)
        Text('暂无团队')
          .fontSize(16)
          .fontColor('#94A3B8')
          .margin({ top: 12 })
        Text('点击右上角+创建团队')
          .fontSize(14)
          .fontColor('#CBD5E1')
          .margin({ top: 8 })
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
    } else {
      List({ space: 12 }) {
        ForEach(this.teams, (team: Team) => {
          ListItem() {
            this.TeamCard(team)
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .padding(16)
    }
  }

  @Builder
  TeamCard(team: Team) {
    Row() {
      // 团队图标
      Column() {
        Text('👥')
          .fontSize(28)
      }
      .width(56)
      .height(56)
      .backgroundColor('#F1F5F9')
      .borderRadius(28)
      .justifyContent(FlexAlign.Center)

      // 团队信息
      Column() {
        Text(team.teamName)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2937')
          .margin({ bottom: 4 })

        Text(`${team.memberCount}名成员`)
          .fontSize(12)
          .fontColor('#64748B')
          .margin({ bottom: 4 })

        Text(team.description)
          .fontSize(12)
          .fontColor('#94A3B8')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 12 })
      .layoutWeight(1)

      Text('›')
        .fontSize(20)
        .fontColor('#94A3B8')
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({ radius: 4, color: 'rgba(0, 0, 0, 0.05)', offsetY: 2 })
    .onClick(() => {
      this.handleTeamClick(team);
    })
  }
}
