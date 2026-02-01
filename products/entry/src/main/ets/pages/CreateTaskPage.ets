import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

// 执行模式
enum ExecutionMode {
  SEQUENTIAL = 'sequential', // 顺序执行
  FREE = 'free'              // 自由执行
}

// 子任务信息
interface SubTaskInput {
  title: string;
  description: string;
  order: number;
}

// 任务发布数据
interface TaskPublishData {
  title: string;
  description: string;
  reward: number;
  currencyType: string;
  deadline: string | number;
  location: string;
  category: string;
  executionMode: ExecutionMode;
  subTasks: SubTaskInput[];
}

@Entry
@Component
struct CreateTaskPage {
  @State taskTitle: string = '';
  @State taskDescription: string = '';
  @State reward: string = '';
  @State currencyType: string = '世界币';
  @State deadline: string = '';
  @State location: string = '';
  @State executionMode: ExecutionMode = ExecutionMode.SEQUENTIAL;
  @State subTasks: SubTaskInput[] = [];
  @State category: string = '跑腿';

  // 分类选项
  private categories: string[] = ['跑腿', '生活', '办公', '学习', '其他'];
  // 货币类型选项
  private currencyTypes: string[] = ['世界币', '个人币', '团体币'];

  aboutToAppear() {
    // 初始化一个空的子任务
    this.addSubTask();
  }

  addSubTask() {
    this.subTasks.push({
      title: '',
      description: '',
      order: this.subTasks.length + 1
    });
  }

  removeSubTask(index: number) {
    this.subTasks.splice(index, 1);
    // 重新排序
    this.subTasks.forEach((task, idx) => {
      task.order = idx + 1;
    });
  }

  validateForm(): boolean {
    if (!this.taskTitle.trim()) {
      promptAction.showToast({ message: '请输入任务标题', duration: 2000 });
      return false;
    }
    if (!this.taskDescription.trim()) {
      promptAction.showToast({ message: '请输入任务描述', duration: 2000 });
      return false;
    }
    if (!this.reward || parseFloat(this.reward) <= 0) {
      promptAction.showToast({ message: '请输入有效的悬赏金额', duration: 2000 });
      return false;
    }
    if (this.subTasks.length === 0) {
      promptAction.showToast({ message: '请至少添加一个子任务', duration: 2000 });
      return false;
    }
    for (let task of this.subTasks) {
      if (!task.title.trim()) {
        promptAction.showToast({ message: '请填写所有子任务标题', duration: 2000 });
        return false;
      }
    }
    return true;
  }

  async handlePublish() {
    if (!this.validateForm()) {
      return;
    }

    // 构建任务数据
    const taskData: TaskPublishData = {
      title: this.taskTitle,
      description: this.taskDescription,
      reward: parseFloat(this.reward),
      currencyType: this.currencyType,
      deadline: this.deadline || Date.now() + 86400000, // 默认24小时后
      location: this.location,
      category: this.category,
      executionMode: this.executionMode,
      subTasks: this.subTasks.filter(t => t.title.trim())
    };

    // TODO: 调用API发布任务
    console.log('发布任务:', JSON.stringify(taskData));

    promptAction.showToast({
      message: '任务发布成功！',
      duration: 2000
    });

    // 延迟返回
    setTimeout(() => {
      router.back();
    }, 2000);
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

        Text('发布任务')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#881337')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        // 占位，保持标题居中
        Row()
          .width(40)
          .height(40)
      }
      .width('100%')
      .height(56)
      .padding({ left: 8, right: 8 })
      .backgroundColor('#FFFFFF')
      .shadow({ radius: 4, color: 'rgba(0, 0, 0, 0.05)', offsetY: 2 })

      // 表单内容
      Scroll() {
        Column() {
          // 基本信息
          this.SectionTitle('基本信息')

          this.FormItem('任务标题', true)
          TextInput({ placeholder: '简短描述你的任务' })
            .height(44)
            .backgroundColor('#F8FAFC')
            .borderRadius(8)
            .onChange((value: string) => {
              this.taskTitle = value;
            })
            .margin({ bottom: 16 })

          this.FormItem('任务描述', true)
          TextArea({ placeholder: '详细说明任务要求和注意事项' })
            .height(100)
            .backgroundColor('#F8FAFC')
            .borderRadius(8)
            .onChange((value: string) => {
              this.taskDescription = value;
            })
            .margin({ bottom: 16 })

          this.FormItem('任务分类', true)
          Row() {
            ForEach(this.categories, (cat: string) => {
              Text(cat)
                .fontSize(14)
                .fontColor(this.category === cat ? '#FFFFFF' : '#64748B')
                .padding({ left: 16, right: 16, top: 8, bottom: 8 })
                .backgroundColor(this.category === cat ? '#E11D48' : '#F1F5F9')
                .borderRadius(16)
                .margin({ right: 8 })
                .onClick(() => {
                  this.category = cat;
                })
            })
          }
          .margin({ bottom: 16 })

          // 悬赏设置
          this.SectionTitle('悬赏设置')

          this.FormItem('悬赏金额', true)
          Row() {
            TextInput({ placeholder: '输入金额' })
              .type(InputType.Number)
              .height(44)
              .backgroundColor('#F8FAFC')
              .borderRadius(8)
              .layoutWeight(1)
              .onChange((value: string) => {
                this.reward = value;
              })

            Text(this.currencyType)
              .fontSize(14)
              .fontColor('#64748B')
              .margin({ left: 12 })
          }
          .margin({ bottom: 12 })

          this.FormItem('货币类型', false)
          Row() {
            ForEach(this.currencyTypes, (type: string) => {
              Text(type)
                .fontSize(14)
                .fontColor(this.currencyType === type ? '#FFFFFF' : '#64748B')
                .padding({ left: 16, right: 16, top: 8, bottom: 8 })
                .backgroundColor(this.currencyType === type ? '#E11D48' : '#F1F5F9')
                .borderRadius(16)
                .margin({ right: 8 })
                .onClick(() => {
                  this.currencyType = type;
                })
            })
          }
          .margin({ bottom: 16 })

          // 其他信息
          this.SectionTitle('其他信息')

          this.FormItem('任务地点', false)
          TextInput({ placeholder: '选填：任务执行地点' })
            .height(44)
            .backgroundColor('#F8FAFC')
            .borderRadius(8)
            .onChange((value: string) => {
              this.location = value;
            })
            .margin({ bottom: 16 })

          this.FormItem('执行模式', true)
          Row() {
            Row() {
              Radio({ value: 'sequential', group: 'executionMode' })
                .checked(this.executionMode === ExecutionMode.SEQUENTIAL)
                .onChange((isChecked: boolean) => {
                  if (isChecked) {
                    this.executionMode = ExecutionMode.SEQUENTIAL;
                  }
                })
              Column() {
                Text('顺序执行')
                  .fontSize(14)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#1F2937')
                Text('子任务必须按顺序完成')
                  .fontSize(12)
                  .fontColor('#94A3B8')
                  .margin({ top: 2 })
              }
              .alignItems(HorizontalAlign.Start)
              .margin({ left: 8 })
            }
            .layoutWeight(1)

            Row() {
              Radio({ value: 'free', group: 'executionMode' })
                .checked(this.executionMode === ExecutionMode.FREE)
                .onChange((isChecked: boolean) => {
                  if (isChecked) {
                    this.executionMode = ExecutionMode.FREE;
                  }
                })
              Column() {
                Text('自由执行')
                  .fontSize(14)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#1F2937')
                Text('可以任意顺序完成')
                  .fontSize(12)
                  .fontColor('#94A3B8')
                  .margin({ top: 2 })
              }
              .alignItems(HorizontalAlign.Start)
              .margin({ left: 8 })
            }
            .layoutWeight(1)
          }
          .margin({ bottom: 16 })

          // 子任务列表
          this.SectionTitle('子任务列表')

          ForEach(this.subTasks, (subTask: SubTaskInput, index: number) => {
            this.SubTaskItem(subTask, index)
          })

          // 添加子任务按钮
          Button('+ 添加子任务')
            .width('100%')
            .height(44)
            .fontSize(14)
            .fontColor('#2563EB')
            .backgroundColor('#EFF6FF')
            .borderRadius(8)
            .onClick(() => {
              this.addSubTask();
            })
            .margin({ bottom: 24 })
        }
        .width('100%')
        .padding(16)
      }
      .layoutWeight(1)
      .backgroundColor('#FFF1F2')

      // 底部发布按钮
      Column() {
        Button('发布任务')
          .width('100%')
          .height(48)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .backgroundColor('#E11D48')
          .borderRadius(24)
          .onClick(() => {
            this.handlePublish();
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
  SectionTitle(title: string) {
    Text(title)
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .fontColor('#881337')
      .margin({ top: 8, bottom: 12 })
  }

  @Builder
  FormItem(label: string, required: boolean) {
    Row() {
      Text(label)
        .fontSize(14)
        .fontColor('#1F2937')
      if (required) {
        Text('*')
          .fontSize(14)
          .fontColor('#E11D48')
          .margin({ left: 4 })
      }
    }
    .margin({ bottom: 8 })
  }

  @Builder
  SubTaskItem(subTask: SubTaskInput, index: number) {
    Column() {
      Row() {
        Text(`子任务 ${index + 1}`)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1F2937')
          .layoutWeight(1)

        if (this.subTasks.length > 1) {
          Text('删除')
            .fontSize(12)
            .fontColor('#EF4444')
            .onClick(() => {
              this.removeSubTask(index);
            })
        }
      }
      .width('100%')
      .margin({ bottom: 8 })

      TextInput({ placeholder: '子任务标题' })
        .height(40)
        .backgroundColor('#F8FAFC')
        .borderRadius(8)
        .onChange((value: string) => {
          this.subTasks[index].title = value;
        })
        .margin({ bottom: 8 })

      TextInput({ placeholder: '子任务描述（选填）' })
        .height(40)
        .backgroundColor('#F8FAFC')
        .borderRadius(8)
        .onChange((value: string) => {
          this.subTasks[index].description = value;
        })
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin({ bottom: 12 })
  }
}
