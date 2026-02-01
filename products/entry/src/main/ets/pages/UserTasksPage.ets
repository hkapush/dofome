import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

// 任务状态
enum TaskStatus {
  PENDING = 'pending',
  IN_PROGRESS = 'in_progress',
  COMPLETED = 'completed'
}

// 用户任务
interface UserTask {
  taskId: string;
  title: string;
  description: string;
  reward: number;
  currencyType: string;
  status: TaskStatus;
  deadline: number;
  category: string;
}

@Entry
@Component
struct UserTasksPage {
  @State userId: string = '';
  @State userName: string = '';
  @State currentTab: number = 0; // 0: 发布的任务, 1: 接取的任务
  @State publishedTasks: UserTask[] = [];
  @State acceptedTasks: UserTask[] = [];
  @State loading: boolean = true;

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    this.userId = params['userId'] || '';
    this.userName = params['userName'] || '';
    this.loadTasks();
  }

  async loadTasks() {
    this.loading = true;
    await new Promise<void>((resolve) => setTimeout(resolve, 500));

    // 模拟加载用户发布的任务
    this.publishedTasks = [
      {
        taskId: '1',
        title: '帮我买杯咖啡',
        description: '需要一杯美式咖啡，不加糖',
        reward: 15,
        currencyType: '世界币',
        status: TaskStatus.PENDING,
        deadline: Date.now() + 3600000,
        category: '跑腿'
      },
      {
        taskId: '2',
        title: '帮我取快递',
        description: '快递在菜鸟驿站',
        reward: 10,
        currencyType: '世界币',
        status: TaskStatus.IN_PROGRESS,
        deadline: Date.now() + 7200000,
        category: '跑腿'
      }
    ];

    // 模拟加载用户接取的任务
    this.acceptedTasks = [
      {
        taskId: '3',
        title: '整理文档',
        description: '整理项目文档',
        reward: 30,
        currencyType: '世界币',
        status: TaskStatus.IN_PROGRESS,
        deadline: Date.now() + 86400000,
        category: '办公'
      }
    ];

    this.loading = false;
  }

  handleTaskClick(taskId: string) {
    router.pushUrl({
      url: 'pages/TaskDetailPage',
      params: { taskId: taskId }
    });
  }

  handlePublishTask() {
    router.pushUrl({
      url: 'pages/CreateTaskPage',
      params: {
        targetUserId: this.userId,
        targetUserName: this.userName,
        isDirectTask: 'true'
      }
    });
  }

  getStatusText(status: TaskStatus): string {
    switch (status) {
      case TaskStatus.PENDING:
        return '待接取';
      case TaskStatus.IN_PROGRESS:
        return '进行中';
      case TaskStatus.COMPLETED:
        return '已完成';
      default:
        return '';
    }
  }

  getStatusColor(status: TaskStatus): string {
    switch (status) {
      case TaskStatus.PENDING:
        return '#F59E0B';
      case TaskStatus.IN_PROGRESS:
        return '#2563EB';
      case TaskStatus.COMPLETED:
        return '#10B981';
      default:
        return '#94A3B8';
    }
  }

  formatTime(timestamp: number): string {
    const diff = timestamp - Date.now();
    if (diff < 0) return '已过期';
    const hours = Math.floor(diff / 3600000);
    const days = Math.floor(hours / 24);
    if (days > 0) return `${days}天后`;
    if (hours > 0) return `${hours}小时后`;
    return '即将到期';
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

        Text(`${this.userName}的任务`)
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

      // Tab切换
      Row() {
        Column() {
          Text('发布的任务')
            .fontSize(16)
            .fontWeight(this.currentTab === 0 ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.currentTab === 0 ? '#E11D48' : '#64748B')
            .padding({ bottom: 12 })

          if (this.currentTab === 0) {
            Divider()
              .width(70)
              .height(3)
              .color('#E11D48')
          }
        }
        .layoutWeight(1)
        .onClick(() => {
          this.currentTab = 0;
        })

        Column() {
          Text('接取的任务')
            .fontSize(16)
            .fontWeight(this.currentTab === 1 ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.currentTab === 1 ? '#E11D48' : '#64748B')
            .padding({ bottom: 12 })

          if (this.currentTab === 1) {
            Divider()
              .width(70)
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
      if (this.loading) {
        Column() {
          LoadingProgress()
            .width(40)
            .height(40)
            .color('#E11D48')
          Text('加载中...')
            .fontSize(14)
            .fontColor('#94A3B8')
            .margin({ top: 12 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        Column() {
          if (this.currentTab === 0) {
            this.TaskListView(this.publishedTasks)
          } else {
            this.TaskListView(this.acceptedTasks)
          }
        }
        .width('100%')
        .layoutWeight(1)
      }

      // 底部发布任务按钮
      Column() {
        Button(`发布任务给${this.userName}`)
          .width('100%')
          .height(48)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .backgroundColor('#E11D48')
          .borderRadius(24)
          .onClick(() => {
            this.handlePublishTask();
          })
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.1)', offsetY: -2 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF1F2')
  }

  @Builder
  TaskListView(tasks: UserTask[]) {
    if (tasks.length === 0) {
      Column() {
        Text('📋')
          .fontSize(48)
        Text('暂无任务')
          .fontSize(16)
          .fontColor('#94A3B8')
          .margin({ top: 12 })
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
    } else {
      List({ space: 12 }) {
        ForEach(tasks, (task: UserTask) => {
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
  TaskCard(task: UserTask) {
    Column() {
      // 标题和状态
      Row() {
        Text(task.title)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2937')
          .layoutWeight(1)

        Text(this.getStatusText(task.status))
          .fontSize(12)
          .fontColor('#FFFFFF')
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .backgroundColor(this.getStatusColor(task.status))
          .borderRadius(4)
      }
      .width('100%')
      .margin({ bottom: 8 })

      // 描述
      Text(task.description)
        .fontSize(14)
        .fontColor('#64748B')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ bottom: 12 })

      // 底部信息
      Row() {
        // 悬赏
        Row() {
          Text(`${task.reward}`)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#E11D48')
          Text(task.currencyType)
            .fontSize(12)
            .fontColor('#E11D48')
            .margin({ left: 4 })
        }

        Blank()

        // 分类和截止时间
        Row() {
          Text(task.category)
            .fontSize(12)
            .fontColor('#64748B')

          Text('|')
            .fontSize(12)
            .fontColor('#E5E7EB')
            .margin({ left: 8, right: 8 })

          Text(this.formatTime(task.deadline))
            .fontSize(12)
            .fontColor('#F59E0B')
        }
      }
      .width('100%')
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
