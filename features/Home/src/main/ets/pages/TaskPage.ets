import { router } from '@kit.ArkUI';

// 任务状态枚举
enum TaskStatus {
  PENDING = 'pending',      // 待决策
  ONGOING = 'ongoing',      // 进行中
  COMPLETED = 'completed',  // 已完成
  CONFIRMED = 'confirmed'   // 已确认
}

// 货币类型枚举
enum CurrencyType {
  WORLD = 'world',    // 世界币
  PERSONAL = 'personal', // 个人币
  TEAM = 'team'       // 团体币
}

// 任务数据接口
interface Task {
  id: string;
  title: string;
  description: string;
  currencyType: CurrencyType;
  reward: number;
  publisherName: string;
  publisherAvatar: string;
  deadline: number; // 时间戳
  status: TaskStatus;
  isForced: boolean; // 是否强制指派
  subtaskCount?: number; // 子任务总数
  completedSubtasks?: number; // 已完成子任务数
  currentSubtask?: string; // 当前子任务名称
  executorName?: string; // 执行者名称
  completedAt?: number; // 完成时间
  isPublisher?: boolean; // 是否是发布者视角
}

@Component
export struct TaskPage {
  @State currentTab: number = 0; // 0: 待决策, 1: 进行中, 2: 已完成, 3: 我的发布
  @State pendingTasks: Task[] = [];
  @State ongoingTasks: Task[] = [];
  @State completedTasks: Task[] = [];
  @State publishedTasks: Task[] = [];

  aboutToAppear() {
    this.loadMockData();
  }

  // 加载模拟数据
  loadMockData() {
    this.pendingTasks = [
      {
        id: '1',
        title: '帮忙搬运家具到新家',
        description: '需要帮忙搬运沙发、床等大件家具',
        currencyType: CurrencyType.WORLD,
        reward: 50,
        publisherName: '张三',
        publisherAvatar: '',
        deadline: Date.now() + 2 * 24 * 60 * 60 * 1000, // 2天后
        status: TaskStatus.PENDING,
        isForced: false
      },
      {
        id: '2',
        title: '代购星巴克咖啡',
        description: '帮忙买一杯拿铁，送到公司',
        currencyType: CurrencyType.PERSONAL,
        reward: 20,
        publisherName: '李四',
        publisherAvatar: '',
        deadline: Date.now() + 3 * 60 * 60 * 1000, // 3小时后
        status: TaskStatus.PENDING,
        isForced: false
      },
      {
        id: '3',
        title: '团队周报整理',
        description: '整理本周团队工作周报并提交',
        currencyType: CurrencyType.TEAM,
        reward: 100,
        publisherName: '王经理',
        publisherAvatar: '',
        deadline: Date.now() + 1 * 24 * 60 * 60 * 1000, // 1天后
        status: TaskStatus.PENDING,
        isForced: true
      }
    ];

    this.ongoingTasks = [
      {
        id: '4',
        title: '超市采购清单',
        description: '按照清单购买食材',
        currencyType: CurrencyType.WORLD,
        reward: 30,
        publisherName: '赵六',
        publisherAvatar: '',
        deadline: Date.now() + 5 * 60 * 60 * 1000,
        status: TaskStatus.ONGOING,
        isForced: false,
        subtaskCount: 5,
        completedSubtasks: 2,
        currentSubtask: '购买蔬菜'
      },
      {
        id: '5',
        title: '文档翻译任务',
        description: '将英文文档翻译成中文',
        currencyType: CurrencyType.PERSONAL,
        reward: 80,
        publisherName: '孙七',
        publisherAvatar: '',
        deadline: Date.now() + 2 * 24 * 60 * 60 * 1000,
        status: TaskStatus.ONGOING,
        isForced: false,
        subtaskCount: 3,
        completedSubtasks: 1,
        currentSubtask: '翻译第二章节'
      }
    ];

    // 已完成的任务（执行者视角）
    this.completedTasks = [
      {
        id: '6',
        title: '帮我买一杯咖啡',
        description: '需要在星巴克购买一杯中杯拿铁',
        currencyType: CurrencyType.WORLD,
        reward: 50,
        publisherName: '小明',
        publisherAvatar: '',
        deadline: Date.now() - 1 * 60 * 60 * 1000,
        status: TaskStatus.COMPLETED,
        isForced: false,
        subtaskCount: 4,
        completedSubtasks: 4,
        completedAt: Date.now() - 30 * 60 * 1000 // 30分钟前完成
      },
      {
        id: '7',
        title: '整理会议记录',
        description: '整理上周的会议记录并归档',
        currencyType: CurrencyType.TEAM,
        reward: 60,
        publisherName: '李经理',
        publisherAvatar: '',
        deadline: Date.now() - 2 * 24 * 60 * 60 * 1000,
        status: TaskStatus.CONFIRMED,
        isForced: false,
        subtaskCount: 3,
        completedSubtasks: 3,
        completedAt: Date.now() - 3 * 24 * 60 * 60 * 1000 // 3天前完成
      }
    ];

    // 我发布的任务
    this.publishedTasks = [
      {
        id: '8',
        title: '帮我取快递',
        description: '快递在菜鸟驿站，取货码：1234',
        currencyType: CurrencyType.WORLD,
        reward: 15,
        publisherName: '我',
        publisherAvatar: '',
        deadline: Date.now() + 4 * 60 * 60 * 1000,
        status: TaskStatus.ONGOING,
        isForced: false,
        isPublisher: true,
        executorName: '小王',
        subtaskCount: 2,
        completedSubtasks: 1,
        currentSubtask: '前往驿站'
      },
      {
        id: '9',
        title: '打印文件',
        description: '打印10份合同文件',
        currencyType: CurrencyType.PERSONAL,
        reward: 25,
        publisherName: '我',
        publisherAvatar: '',
        deadline: Date.now() + 1 * 24 * 60 * 60 * 1000,
        status: TaskStatus.COMPLETED,
        isForced: false,
        isPublisher: true,
        executorName: '小李',
        subtaskCount: 3,
        completedSubtasks: 3,
        completedAt: Date.now() - 2 * 60 * 60 * 1000 // 2小时前完成
      }
    ];
  }

  // 获取货币类型颜色
  getCurrencyColor(type: CurrencyType): string {
    switch (type) {
      case CurrencyType.WORLD:
        return '#F59E0B'; // 橙色
      case CurrencyType.PERSONAL:
        return '#8B5CF6'; // 紫色
      case CurrencyType.TEAM:
        return '#10B981'; // 绿色
      default:
        return '#94A3B8';
    }
  }

  // 获取货币类型名称
  getCurrencyName(type: CurrencyType): string {
    switch (type) {
      case CurrencyType.WORLD:
        return '世界币';
      case CurrencyType.PERSONAL:
        return '个人币';
      case CurrencyType.TEAM:
        return '团体币';
      default:
        return '';
    }
  }

  // 计算剩余时间
  getTimeRemaining(deadline: number): string {
    const now = Date.now();
    const diff = deadline - now;

    if (diff < 0) return '已超时';

    const hours = Math.floor(diff / (1000 * 60 * 60));
    const days = Math.floor(hours / 24);

    if (days > 0) return `${days}天后`;
    if (hours > 0) return `${hours}小时后`;
    return '即将到期';
  }

  // 接受任务
  handleAcceptTask(taskId: string) {
    const taskIndex = this.pendingTasks.findIndex(t => t.id === taskId);
    if (taskIndex !== -1) {
      const task = this.pendingTasks[taskIndex];
      task.status = TaskStatus.ONGOING;
      task.subtaskCount = 3;
      task.completedSubtasks = 0;
      task.currentSubtask = '开始任务';

      this.ongoingTasks.push(task);
      this.pendingTasks.splice(taskIndex, 1);

      // 跳转到任务详情
      router.pushUrl({ url: 'pages/TaskDetailPage', params: { taskId: taskId } });
    }
  }

  // 拒绝任务
  handleRejectTask(taskId: string) {
    const taskIndex = this.pendingTasks.findIndex(t => t.id === taskId);
    if (taskIndex !== -1) {
      this.pendingTasks.splice(taskIndex, 1);
    }
  }

  // 协商任务
  handleNegotiateTask(task: Task) {
    // 跳转到与发布者的聊天页面
    router.pushUrl({
      url: 'pages/ChatPage',
      params: {
        friendId: task.id + '_publisher',
        friendName: task.publisherName,
        friendAvatar: task.publisherAvatar
      }
    });
  }

  // 继续执行任务
  handleContinueTask(taskId: string) {
    router.pushUrl({ url: 'pages/TaskDetailPage', params: { taskId: taskId } });
  }

  // 查看已完成任务
  handleViewCompletedTask(taskId: string) {
    router.pushUrl({
      url: 'pages/TaskDetailPage',
      params: {
        taskId: taskId,
        from: 'completed',
        isPublisher: 'false'
      }
    });
  }

  // 查看我发布的任务
  handleViewPublishedTask(task: Task) {
    router.pushUrl({
      url: 'pages/TaskDetailPage',
      params: {
        taskId: task.id,
        from: task.status === TaskStatus.COMPLETED ? 'completed' : '',
        isPublisher: 'true'
      }
    });
  }

  build() {
    Column() {
      // 顶部导航区
      Column() {
        Text('我的任务')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor('#881337')
          .margin({ top: 20, bottom: 16 })

        // Segmented Control
        Row() {
          Button(`待决策 ${this.pendingTasks.length}`)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.currentTab === 0 ? '#FFFFFF' : '#64748B')
            .backgroundColor(this.currentTab === 0 ? '#E11D48' : 'transparent')
            .height(36)
            .layoutWeight(1)
            .borderRadius(8)
            .onClick(() => {
              this.currentTab = 0;
            })

          Button(`进行中 ${this.ongoingTasks.length}`)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.currentTab === 1 ? '#FFFFFF' : '#64748B')
            .backgroundColor(this.currentTab === 1 ? '#E11D48' : 'transparent')
            .height(36)
            .layoutWeight(1)
            .borderRadius(8)
            .onClick(() => {
              this.currentTab = 1;
            })

          Button(`已完成 ${this.completedTasks.length}`)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.currentTab === 2 ? '#FFFFFF' : '#64748B')
            .backgroundColor(this.currentTab === 2 ? '#E11D48' : 'transparent')
            .height(36)
            .layoutWeight(1)
            .borderRadius(8)
            .onClick(() => {
              this.currentTab = 2;
            })

          Button(`我的发布 ${this.publishedTasks.length}`)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.currentTab === 3 ? '#FFFFFF' : '#64748B')
            .backgroundColor(this.currentTab === 3 ? '#E11D48' : 'transparent')
            .height(36)
            .layoutWeight(1)
            .borderRadius(8)
            .onClick(() => {
              this.currentTab = 3;
            })
        }
        .width('90%')
        .backgroundColor('#F1F5F9')
        .borderRadius(10)
        .padding(4)
      }
      .width('100%')
      .padding({ left: 20, right: 20, bottom: 16 })
      .backgroundColor('#FFFFFF')
      .shadow({ radius: 4, color: 'rgba(0, 0, 0, 0.04)', offsetY: 2 })

      // 主内容区
      if (this.currentTab === 0) {
        // 待决策列表
        if (this.pendingTasks.length > 0) {
          List({ space: 16 }) {
            ForEach(this.pendingTasks, (task: Task) => {
              ListItem() {
                this.PendingTaskCard(task)
              }
            })
          }
          .width('100%')
          .layoutWeight(1)
          .padding({ left: 20, right: 20, top: 16 })
        } else {
          this.EmptyState('暂无待决策任务')
        }
      } else if (this.currentTab === 1) {
        // 进行中列表
        if (this.ongoingTasks.length > 0) {
          List({ space: 16 }) {
            ForEach(this.ongoingTasks, (task: Task) => {
              ListItem() {
                this.OngoingTaskCard(task)
              }
            })
          }
          .width('100%')
          .layoutWeight(1)
          .padding({ left: 20, right: 20, top: 16 })
        } else {
          this.EmptyState('暂无进行中任务')
        }
      } else if (this.currentTab === 2) {
        // 已完成列表
        if (this.completedTasks.length > 0) {
          List({ space: 16 }) {
            ForEach(this.completedTasks, (task: Task) => {
              ListItem() {
                this.CompletedTaskCard(task)
              }
            })
          }
          .width('100%')
          .layoutWeight(1)
          .padding({ left: 20, right: 20, top: 16 })
        } else {
          this.EmptyState('暂无已完成任务')
        }
      } else {
        // 我的发布列表
        if (this.publishedTasks.length > 0) {
          List({ space: 16 }) {
            ForEach(this.publishedTasks, (task: Task) => {
              ListItem() {
                this.PublishedTaskCard(task)
              }
            })
          }
          .width('100%')
          .layoutWeight(1)
          .padding({ left: 20, right: 20, top: 16 })
        } else {
          this.EmptyState('暂无发布的任务')
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF1F2')
  }

  // 待决策任务卡片
  @Builder
  PendingTaskCard(task: Task) {
    Column() {
      // 可点击区域 - 进入任务详情
      Column() {
        // 头部：货币类型 + 标题
        Row() {
          Text(this.getCurrencyName(task.currencyType))
            .fontSize(12)
            .fontColor('#FFFFFF')
            .backgroundColor(this.getCurrencyColor(task.currencyType))
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .borderRadius(4)

          if (task.isForced) {
            Text('强制指派')
              .fontSize(12)
              .fontColor('#FF3B30')
              .backgroundColor('#FFEBEE')
              .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              .borderRadius(4)
              .margin({ left: 8 })
          }
        }
        .width('100%')
        .margin({ bottom: 10 })

        Text(task.title)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2937')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ bottom: 10 })

        // 信息区
        Row() {
          // 发布者
          Row() {
            Circle()
              .width(24)
              .height(24)
              .fill('#E0E0E0')

            Text(task.publisherName)
              .fontSize(14)
              .fontColor('#64748B')
              .margin({ left: 6 })
          }

          Blank()

          // 截止时间
          Row() {
            Text('⏰')
              .fontSize(14)
            Text(this.getTimeRemaining(task.deadline))
              .fontSize(14)
              .fontColor('#FF3B30')
              .margin({ left: 4 })
          }
        }
        .width('100%')
        .margin({ bottom: 10 })

        Text(task.description)
          .fontSize(14)
          .fontColor('#64748B')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ bottom: 16 })

        // 赏金
        Row() {
          Text('💰')
            .fontSize(18)
          Text(`${task.reward}`)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.getCurrencyColor(task.currencyType))
            .margin({ left: 4 })
        }
        .margin({ bottom: 16 })
      }
      .width('100%')
      .onClick(() => {
        // 点击卡片进入任务详情
        router.pushUrl({ url: 'pages/TaskDetailPage', params: { taskId: task.id, from: 'pending' } });
      })

      // 操作区 - 不可点击穿透
      Row() {
        if (!task.isForced) {
          Button('拒绝')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor('#64748B')
            .backgroundColor('#F1F5F9')
            .height(44)
            .borderRadius(8)
            .layoutWeight(1)
            .onClick(() => {
              this.handleRejectTask(task.id);
            })
        } else {
          Button('申诉')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor('#64748B')
            .backgroundColor('#F1F5F9')
            .height(44)
            .borderRadius(8)
            .layoutWeight(1)
            .onClick(() => {
              console.log('申诉任务');
            })
        }

        Button('协商')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#2563EB')
          .backgroundColor('#EFF6FF')
          .height(44)
          .borderRadius(8)
          .layoutWeight(1)
          .margin({ left: 10 })
          .onClick(() => {
            this.handleNegotiateTask(task);
          })

        Button('接受')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .height(44)
          .borderRadius(8)
          .layoutWeight(1)
          .margin({ left: 10 })
          .linearGradient({
            angle: 135,
            colors: [['#E11D48', 0.0], ['#FB7185', 1.0]]
          })
          .onClick(() => {
            this.handleAcceptTask(task.id);
          })
      }
      .width('100%')
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .padding(15)
  }

  // 进行中任务卡片
  @Builder
  OngoingTaskCard(task: Task) {
    Column() {
      // 头部
      Row() {
        Text(this.getCurrencyName(task.currencyType))
          .fontSize(12)
          .fontColor('#FFFFFF')
          .backgroundColor(this.getCurrencyColor(task.currencyType))
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .borderRadius(4)

        Text('进行中')
          .fontSize(12)
          .fontColor('#10B981')
          .backgroundColor('#D1FAE5')
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .borderRadius(4)
          .margin({ left: 8 })

        Blank()

        Text('⏰ ' + this.getTimeRemaining(task.deadline))
          .fontSize(12)
          .fontColor('#FF3B30')
      }
      .width('100%')
      .margin({ bottom: 10 })

      Text(task.title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1F2937')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ bottom: 12 })

      // 进度区
      Row() {
        Text(`步骤 ${task.completedSubtasks}/${task.subtaskCount}`)
          .fontSize(14)
          .fontColor('#64748B')

        Blank()

        Text(`${Math.floor((task.completedSubtasks! / task.subtaskCount!) * 100)}%`)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor('#E11D48')
      }
      .width('100%')
      .margin({ bottom: 8 })

      // 进度条
      Progress({ value: task.completedSubtasks, total: task.subtaskCount, type: ProgressType.Linear })
        .width('100%')
        .color('#E11D48')
        .height(6)
        .borderRadius(3)
        .margin({ bottom: 12 })

      // 当前焦点
      Row() {
        Text('当前：')
          .fontSize(14)
          .fontColor('#94A3B8')
        Text(task.currentSubtask || '')
          .fontSize(14)
          .fontColor('#1F2937')
          .fontWeight(FontWeight.Medium)
      }
      .margin({ bottom: 16 })

      // 操作按钮
      Button('继续执行')
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFFFFF')
        .width('100%')
        .height(44)
        .borderRadius(8)
        .linearGradient({
          angle: 135,
          colors: [['#E11D48', 0.0], ['#FB7185', 1.0]]
        })
        .onClick(() => {
          this.handleContinueTask(task.id);
        })
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .padding(15)
  }

  // 空状态
  @Builder
  EmptyState(message: string) {
    Column() {
      Text('📭')
        .fontSize(64)
        .margin({ bottom: 15 })

      Text(message)
        .fontSize(16)
        .fontColor('#94A3B8')
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }

  // 已完成任务卡片
  @Builder
  CompletedTaskCard(task: Task) {
    Column() {
      // 头部：货币类型 + 状态标签
      Row() {
        Text(this.getCurrencyName(task.currencyType))
          .fontSize(12)
          .fontColor('#FFFFFF')
          .backgroundColor(this.getCurrencyColor(task.currencyType))
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .borderRadius(4)

        Text(task.status === TaskStatus.CONFIRMED ? '已确认' : '待确认')
          .fontSize(12)
          .fontColor('#FFFFFF')
          .backgroundColor(task.status === TaskStatus.CONFIRMED ? '#10B981' : '#F59E0B')
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .borderRadius(4)
          .margin({ left: 8 })
      }
      .width('100%')
      .margin({ bottom: 10 })

      Text(task.title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1F2937')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ bottom: 10 })

      // 发布者和完成时间
      Row() {
        Row() {
          Circle()
            .width(24)
            .height(24)
            .fill('#E0E0E0')

          Text(task.publisherName)
            .fontSize(14)
            .fontColor('#64748B')
            .margin({ left: 6 })
        }

        Blank()

        if (task.completedAt) {
          Text(`完成于 ${this.formatCompletedTime(task.completedAt)}`)
            .fontSize(12)
            .fontColor('#10B981')
        }
      }
      .width('100%')
      .margin({ bottom: 10 })

      Text(task.description)
        .fontSize(14)
        .fontColor('#64748B')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ bottom: 16 })

      // 赏金
      Row() {
        Text('💰')
          .fontSize(18)
        Text(`${task.reward}`)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.getCurrencyColor(task.currencyType))
          .margin({ left: 4 })

        Blank()

        Button('查看详情')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#E11D48')
          .backgroundColor('#FFF1F2')
          .height(36)
          .borderRadius(8)
          .onClick(() => {
            this.handleViewCompletedTask(task.id);
          })
      }
      .width('100%')
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .padding(15)
  }

  // 我的发布任务卡片
  @Builder
  PublishedTaskCard(task: Task) {
    Column() {
      // 头部：货币类型 + 状态标签
      Row() {
        Text(this.getCurrencyName(task.currencyType))
          .fontSize(12)
          .fontColor('#FFFFFF')
          .backgroundColor(this.getCurrencyColor(task.currencyType))
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .borderRadius(4)

        if (task.status === TaskStatus.ONGOING) {
          Text('进行中')
            .fontSize(12)
            .fontColor('#FFFFFF')
            .backgroundColor('#2563EB')
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .borderRadius(4)
            .margin({ left: 8 })
        } else if (task.status === TaskStatus.COMPLETED) {
          Text('待确认')
            .fontSize(12)
            .fontColor('#FFFFFF')
            .backgroundColor('#F59E0B')
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .borderRadius(4)
            .margin({ left: 8 })
        } else if (task.status === TaskStatus.CONFIRMED) {
          Text('已完成')
            .fontSize(12)
            .fontColor('#FFFFFF')
            .backgroundColor('#10B981')
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .borderRadius(4)
            .margin({ left: 8 })
        }
      }
      .width('100%')
      .margin({ bottom: 10 })

      Text(task.title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1F2937')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ bottom: 10 })

      // 执行者信息
      if (task.executorName) {
        Row() {
          Text('执行者：')
            .fontSize(14)
            .fontColor('#94A3B8')
          Text(task.executorName)
            .fontSize(14)
            .fontColor('#1F2937')
            .fontWeight(FontWeight.Medium)

          Blank()

          if (task.status === TaskStatus.ONGOING && task.subtaskCount && task.completedSubtasks !== undefined) {
            Text(`${task.completedSubtasks}/${task.subtaskCount}`)
              .fontSize(14)
              .fontColor('#64748B')
          }
        }
        .width('100%')
        .margin({ bottom: 10 })
      }

      Text(task.description)
        .fontSize(14)
        .fontColor('#64748B')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ bottom: 16 })

      // 赏金和操作按钮
      Row() {
        Row() {
          Text('💰')
            .fontSize(18)
          Text(`${task.reward}`)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.getCurrencyColor(task.currencyType))
            .margin({ left: 4 })
        }

        Blank()

        Button(task.status === TaskStatus.COMPLETED ? '确认完成' : '查看详情')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#FFFFFF')
          .backgroundColor(task.status === TaskStatus.COMPLETED ? '#10B981' : '#E11D48')
          .height(36)
          .borderRadius(8)
          .onClick(() => {
            this.handleViewPublishedTask(task);
          })
      }
      .width('100%')
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .padding(15)
  }

  // 格式化完成时间
  formatCompletedTime(timestamp: number): string {
    const now = Date.now();
    const diff = now - timestamp;
    const minutes = Math.floor(diff / (1000 * 60));
    const hours = Math.floor(minutes / 60);
    const days = Math.floor(hours / 24);

    if (days > 0) return `${days}天前`;
    if (hours > 0) return `${hours}小时前`;
    if (minutes > 0) return `${minutes}分钟前`;
    return '刚刚';
  }
}
