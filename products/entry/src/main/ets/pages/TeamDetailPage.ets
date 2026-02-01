import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

// 团队成员
interface TeamMember {
  memberId: string;
  memberName: string;
  memberAvatar: string;
  role: 'owner' | 'admin' | 'member';
  joinTime: string;
  isOnline: boolean;
}

// 团队公告
interface TeamAnnouncement {
  announcementId: string;
  content: string;
  publisherName: string;
  publishTime: string;
}

// 团队任务
interface TeamTask {
  taskId: string;
  title: string;
  reward: number;
  status: string;
  publisherName: string;
}

@Entry
@Component
struct TeamDetailPage {
  @State teamId: string = '';
  @State teamName: string = '';
  @State teamAvatar: string = '';
  @State teamDescription: string = '';
  @State memberCount: number = 0;
  @State currentTab: number = 0; // 0: 聊天, 1: 成员, 2: 任务, 3: 设置
  @State members: TeamMember[] = [];
  @State announcements: TeamAnnouncement[] = [];
  @State teamTasks: TeamTask[] = [];
  @State isOwner: boolean = false;

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    this.teamId = params['teamId'] || '';
    this.teamName = params['teamName'] || '';
    this.loadTeamInfo();
  }

  async loadTeamInfo() {
    // 模拟加载团队信息
    await new Promise<void>((resolve) => setTimeout(resolve, 500));

    this.teamDescription = '家庭团队，一起完成任务赚取家庭币';
    this.memberCount = 4;
    this.isOwner = true;

    // 加载成员
    this.members = [
      {
        memberId: 'user_001',
        memberName: '爸爸',
        memberAvatar: '',
        role: 'owner',
        joinTime: '2026-01-01',
        isOnline: true
      },
      {
        memberId: 'user_002',
        memberName: '妈妈',
        memberAvatar: '',
        role: 'admin',
        joinTime: '2026-01-01',
        isOnline: true
      },
      {
        memberId: 'user_003',
        memberName: '小明',
        memberAvatar: '',
        role: 'member',
        joinTime: '2026-01-01',
        isOnline: false
      },
      {
        memberId: 'user_004',
        memberName: '小红',
        memberAvatar: '',
        role: 'member',
        joinTime: '2026-01-01',
        isOnline: true
      }
    ];

    // 加载公告
    this.announcements = [
      {
        announcementId: '1',
        content: '本周末一起去公园玩！',
        publisherName: '爸爸',
        publishTime: '2026-02-01 10:00:00'
      }
    ];

    // 加载团队任务
    this.teamTasks = [
      {
        taskId: '1',
        title: '整理房间',
        reward: 20,
        status: '进行中',
        publisherName: '妈妈'
      },
      {
        taskId: '2',
        title: '洗碗',
        reward: 10,
        status: '待接取',
        publisherName: '爸爸'
      }
    ];
  }

  handleGroupChat() {
    router.pushUrl({
      url: 'pages/GroupChatPage',
      params: {
        teamId: this.teamId,
        teamName: this.teamName
      }
    });
  }

  handleMemberClick(member: TeamMember) {
    router.pushUrl({
      url: 'pages/ChatPage',
      params: {
        friendId: member.memberId,
        friendName: member.memberName,
        friendAvatar: member.memberAvatar
      }
    });
  }

  handleTaskClick(taskId: string) {
    router.pushUrl({
      url: 'pages/TaskDetailPage',
      params: { taskId: taskId }
    });
  }

  handlePublishTeamTask() {
    router.pushUrl({
      url: 'pages/CreateTaskPage',
      params: {
        teamId: this.teamId,
        teamName: this.teamName,
        isTeamTask: 'true'
      }
    });
  }

  handleInviteMember() {
    promptAction.showToast({
      message: '邀请成员功能开发中',
      duration: 2000
    });
  }

  getRoleText(role: string): string {
    switch (role) {
      case 'owner':
        return '群主';
      case 'admin':
        return '管理员';
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

        Text(this.teamName)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#881337')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Row() {
          Text('⋯')
            .fontSize(24)
            .fontColor('#1F2937')
        }
        .width(40)
        .height(40)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          // 更多操作
        })
      }
      .width('100%')
      .height(56)
      .padding({ left: 8, right: 8 })
      .backgroundColor('#FFFFFF')
      .shadow({ radius: 4, color: 'rgba(0, 0, 0, 0.05)', offsetY: 2 })

      // 团队信息卡片
      Column() {
        Row() {
          // 团队头像
          Column() {
            Text('👥')
              .fontSize(32)
          }
          .width(64)
          .height(64)
          .backgroundColor('#F1F5F9')
          .borderRadius(32)
          .justifyContent(FlexAlign.Center)

          Column() {
            Text(this.teamName)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2937')
              .margin({ bottom: 4 })

            Text(`${this.memberCount}名成员`)
              .fontSize(14)
              .fontColor('#64748B')
              .margin({ bottom: 4 })

            Text(this.teamDescription)
              .fontSize(12)
              .fontColor('#94A3B8')
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 16 })
          .layoutWeight(1)
        }
        .width('100%')
        .margin({ bottom: 16 })

        // 快捷操作
        Row() {
          Button('群聊')
            .height(40)
            .fontSize(14)
            .fontColor('#FFFFFF')
            .backgroundColor('#E11D48')
            .borderRadius(20)
            .layoutWeight(1)
            .onClick(() => {
              this.handleGroupChat();
            })

          Button('发布任务')
            .height(40)
            .fontSize(14)
            .fontColor('#E11D48')
            .backgroundColor('#FFF1F2')
            .borderRadius(20)
            .layoutWeight(1)
            .margin({ left: 12 })
            .onClick(() => {
              this.handlePublishTeamTask();
            })

          Button('邀请')
            .height(40)
            .fontSize(14)
            .fontColor('#2563EB')
            .backgroundColor('#EFF6FF')
            .borderRadius(20)
            .layoutWeight(1)
            .margin({ left: 12 })
            .onClick(() => {
              this.handleInviteMember();
            })
        }
        .width('100%')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .margin({ bottom: 8 })

      // 公告
      if (this.announcements.length > 0) {
        Column() {
          Row() {
            Text('📢')
              .fontSize(16)
            Text('团队公告')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2937')
              .margin({ left: 8 })
          }
          .margin({ bottom: 8 })

          Text(this.announcements[0].content)
            .fontSize(14)
            .fontColor('#64748B')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#FFF7F8')
        .borderRadius(12)
        .margin({ left: 16, right: 16, bottom: 8 })
        .alignItems(HorizontalAlign.Start)
      }

      // Tab切换
      Row() {
        this.TabItem('成员', 0, this.memberCount.toString())
        this.TabItem('任务', 1, this.teamTasks.length.toString())
      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .padding({ top: 8 })

      Divider()
        .color('#F1F5F9')

      // 内容区域
      if (this.currentTab === 0) {
        this.MembersView()
      } else {
        this.TasksView()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF1F2')
  }

  @Builder
  TabItem(label: string, index: number, count: string) {
    Column() {
      Row() {
        Text(label)
          .fontSize(16)
          .fontWeight(this.currentTab === index ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.currentTab === index ? '#E11D48' : '#64748B')

        Text(`(${count})`)
          .fontSize(14)
          .fontColor('#94A3B8')
          .margin({ left: 4 })
      }
      .padding({ bottom: 12 })

      if (this.currentTab === index) {
        Divider()
          .width(60)
          .height(3)
          .color('#E11D48')
      }
    }
    .layoutWeight(1)
    .onClick(() => {
      this.currentTab = index;
    })
  }

  @Builder
  MembersView() {
    List({ space: 0 }) {
      ForEach(this.members, (member: TeamMember) => {
        ListItem() {
          this.MemberCard(member)
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

  @Builder
  MemberCard(member: TeamMember) {
    Row() {
      // 头像
      Stack() {
        Circle()
          .width(48)
          .height(48)
          .fill('#F1F5F9')

        // 在线状态
        if (member.isOnline) {
          Circle()
            .width(12)
            .height(12)
            .fill('#10B981')
            .border({ width: 2, color: '#FFFFFF' })
        }
      }
      .alignContent(Alignment.BottomEnd)

      // 成员信息
      Column() {
        Row() {
          Text(member.memberName)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#1F2937')

          if (member.role !== 'member') {
            Text(this.getRoleText(member.role))
              .fontSize(10)
              .fontColor('#FFFFFF')
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .backgroundColor('#F59E0B')
              .borderRadius(4)
              .margin({ left: 8 })
          }
        }
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 12 })
      .layoutWeight(1)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .onClick(() => {
      this.handleMemberClick(member);
    })
  }

  @Builder
  TasksView() {
    if (this.teamTasks.length === 0) {
      Column() {
        Text('📋')
          .fontSize(48)
        Text('暂无团队任务')
          .fontSize(16)
          .fontColor('#94A3B8')
          .margin({ top: 12 })
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
    } else {
      List({ space: 12 }) {
        ForEach(this.teamTasks, (task: TeamTask) => {
          ListItem() {
            this.TaskCard(task)
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .padding(16)
    }
  }

  @Builder
  TaskCard(task: TeamTask) {
    Row() {
      Column() {
        Text(task.title)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1F2937')
          .margin({ bottom: 4 })

        Text(`发布者: ${task.publisherName}`)
          .fontSize(12)
          .fontColor('#64748B')
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Column() {
        Text(`${task.reward}`)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#E11D48')
          .margin({ bottom: 4 })

        Text(task.status)
          .fontSize(12)
          .fontColor('#2563EB')
      }
      .alignItems(HorizontalAlign.End)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({ radius: 4, color: 'rgba(0, 0, 0, 0.05)', offsetY: 2 })
    .onClick(() => {
      this.handleTaskClick(task.taskId);
    })
  }
}
