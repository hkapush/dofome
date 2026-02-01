import { Task, TaskStatus, SubTask, SubTaskStatus, TaskFilter, ExecutionMode, ProofType } from '../models/Task';

/**
 * 任务服务类
 * 负责处理任务相关的业务逻辑
 */
export class TaskService {
  private static instance: TaskService;

  private constructor() {}

  static getInstance(): TaskService {
    if (!TaskService.instance) {
      TaskService.instance = new TaskService();
    }
    return TaskService.instance;
  }

  /**
   * 获取任务列表
   * @param filter 过滤条件
   * @returns 任务列表
   */
  async getTasks(filter?: TaskFilter): Promise<Task[]> {
    // 模拟网络延迟
    await new Promise<void>((resolve) => setTimeout(resolve, 500));

    // 模拟数据
    const allTasks: Task[] = [
      {
        taskId: '1',
        title: '帮我买杯咖啡',
        description: '需要一杯美式咖啡，不加糖',
        reward: 15,
        currencyType: '积分',
        status: TaskStatus.PENDING,
        creatorName: '小明',
        publisherName: '小明',
        publisherAvatar: '',
        category: '跑腿',
        tags: ['简单', '快速'],
        deadline: Date.now() + 3600000,
        createdAt: '2026-02-01 10:00:00',
        location: '星巴克(中关村店)',
        subTasks: [
          {
            subTaskId: '1-1',
            title: '购买咖啡',
            description: '在星巴克购买一杯美式咖啡',
            status: SubTaskStatus.UNLOCKED,
            order: 1
          },
          {
            subTaskId: '1-2',
            title: '送达指定地点',
            description: '将咖啡送到办公室',
            status: SubTaskStatus.LOCKED,
            order: 2
          }
        ],
        executionMode: ExecutionMode.SEQUENTIAL
      },
      {
        taskId: '2',
        title: '帮我取快递',
        description: '快递在菜鸟驿站，取件码：1234',
        reward: 10,
        currencyType: '积分',
        status: TaskStatus.IN_PROGRESS,
        creatorName: '小红',
        publisherName: '小红',
        publisherAvatar: '',
        acceptorName: '小李',
        category: '跑腿',
        tags: ['简单'],
        deadline: Date.now() + 7200000,
        createdAt: '2026-02-01 09:30:00',
        location: '菜鸟驿站(中关村店)',
        subTasks: [
          {
            subTaskId: '2-1',
            title: '到达菜鸟驿站',
            description: '前往菜鸟驿站',
            status: SubTaskStatus.COMPLETED,
            order: 1
          },
          {
            subTaskId: '2-2',
            title: '取件',
            description: '使用取件码1234取件',
            status: SubTaskStatus.UNLOCKED,
            order: 2
          }
        ],
        executionMode: ExecutionMode.SEQUENTIAL
      },
      {
        taskId: '3',
        title: '帮我遛狗',
        description: '遛我家的金毛，需要遛30分钟',
        reward: 30,
        currencyType: '积分',
        status: TaskStatus.PENDING,
        creatorName: '小张',
        publisherName: '小张',
        publisherAvatar: '',
        category: '生活',
        tags: ['宠物', '户外'],
        deadline: Date.now() + 10800000,
        createdAt: '2026-02-01 08:00:00',
        location: '小区公园',
        subTasks: [
          {
            subTaskId: '3-1',
            title: '接狗',
            description: '到我家接金毛',
            status: SubTaskStatus.UNLOCKED,
            order: 1
          },
          {
            subTaskId: '3-2',
            title: '遛狗',
            description: '在公园遛狗30分钟',
            status: SubTaskStatus.LOCKED,
            order: 2
          },
          {
            subTaskId: '3-3',
            title: '送回',
            description: '将狗送回家',
            status: SubTaskStatus.LOCKED,
            order: 3
          }
        ],
        executionMode: ExecutionMode.SEQUENTIAL
      },
      {
        taskId: '4',
        title: '帮我打印文件',
        description: '需要打印10页文件，黑白即可',
        reward: 8,
        currencyType: '积分',
        status: TaskStatus.COMPLETED,
        creatorName: '小王',
        publisherName: '小王',
        publisherAvatar: '',
        acceptorName: '小刘',
        category: '办公',
        tags: ['简单'],
        deadline: Date.now() - 3600000,
        createdAt: '2026-01-31 16:00:00',
        location: '图书馆',
        subTasks: [
          {
            subTaskId: '4-1',
            title: '打印文件',
            description: '打印10页文件',
            status: SubTaskStatus.COMPLETED,
            order: 1
          }
        ],
        executionMode: ExecutionMode.FREE
      }
    ];

    // 应用过滤条件
    let filteredTasks = allTasks;

    if (filter) {
      if (filter.status) {
        filteredTasks = filteredTasks.filter(t => t.status === filter.status);
      }
      if (filter.category) {
        filteredTasks = filteredTasks.filter(t => t.category === filter.category);
      }
      if (filter.minReward !== undefined) {
        filteredTasks = filteredTasks.filter(t => t.reward >= filter.minReward!);
      }
      if (filter.maxReward !== undefined) {
        filteredTasks = filteredTasks.filter(t => t.reward <= filter.maxReward!);
      }
      if (filter.keyword) {
        const keyword = filter.keyword.toLowerCase();
        filteredTasks = filteredTasks.filter(t =>
          t.title.toLowerCase().includes(keyword) ||
          t.description.toLowerCase().includes(keyword)
        );
      }
    }

    return filteredTasks;
  }

  /**
   * 根据ID获取任务详情
   * @param taskId 任务ID
   * @returns 任务详情
   */
  async getTaskById(taskId: string): Promise<Task | null> {
    const tasks = await this.getTasks();
    return tasks.find(t => t.taskId === taskId || t.id === taskId) || null;
  }

  /**
   * 创建任务
   * @param task 任务信息
   * @returns 创建的任务
   */
  async createTask(task: Partial<Task>): Promise<Task> {
    // 模拟网络延迟
    await new Promise<void>((resolve) => setTimeout(resolve, 800));

    const newTask: Task = {
      taskId: Date.now().toString(),
      title: task.title || '',
      description: task.description || '',
      reward: task.reward || 0,
      status: TaskStatus.PENDING,
      category: task.category || '其他',
      deadline: task.deadline || Date.now() + 86400000,
      subTasks: task.subTasks || [],
      createdAt: new Date().toISOString()
    };

    return newTask;
  }

  /**
   * 接取任务
   * @param taskId 任务ID
   * @param userId 用户ID
   */
  async acceptTask(taskId: string, userId: string): Promise<void> {
    // 模拟网络延迟
    await new Promise<void>((resolve) => setTimeout(resolve, 500));
    console.log(`用户 ${userId} 接取了任务 ${taskId}`);
  }

  /**
   * 完成子任务
   * @param taskId 任务ID
   * @param subTaskId 子任务ID
   */
  async completeSubTask(taskId: string, subTaskId: string): Promise<void> {
    // 模拟网络延迟
    await new Promise<void>((resolve) => setTimeout(resolve, 500));
    console.log(`完成子任务 ${subTaskId}`);
  }

  /**
   * 完成任务
   * @param taskId 任务ID
   */
  async completeTask(taskId: string): Promise<void> {
    // 模拟网络延迟
    await new Promise<void>((resolve) => setTimeout(resolve, 500));
    console.log(`完成任务 ${taskId}`);
  }
}
