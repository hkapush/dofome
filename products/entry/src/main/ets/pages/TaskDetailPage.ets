import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { picker } from '@kit.CoreFileKit';
import { fileIo } from '@kit.CoreFileKit';
import { image } from '@kit.ImageKit';
import { geoLocationManager } from '@kit.LocationKit';
import { abilityAccessCtrl, common, PermissionRequestResult } from '@kit.AbilityKit';

// 上传数据接口
interface UploadData {
  subTaskId: string;
  photos: string[];
  location?: string;
  textNote?: string;
  timestamp: number;
}

// 子任务
interface SubTask {
  id: string;
  title: string;
  description: string;
  isCompleted: boolean;
  isCurrent: boolean;
  photos: string[];
  location?: string;
  textNote?: string;
}

// 任务详情
interface TaskDetail {
  id: string;
  title: string;
  description: string;
  publisherId: string;
  publisherName: string;
  publisherAvatar: string;
  reward: number;
  currencyType: string;
  deadline: string;
  subTasks: SubTask[];
  currentSubTaskIndex: number;
  status: string; // 'pending', 'in_progress', 'completed', 'confirmed', 'rejected'
  executorId?: string; // 执行者ID
  completedAt?: string; // 完成时间
  confirmedAt?: string; // 确认时间
  isPublisher?: boolean; // 当前用户是否是发布者
}

@Entry
@Component
struct TaskDetailPage {
  @State taskId: string = '';
  @State fromPage: string = ''; // 'pending' 表示从待决策列表进入, 'completed' 表示从已完成列表进入
  @State taskDetail: TaskDetail | null = null;
  @State loading: boolean = true;
  @State currentSubTaskId: string = '';
  @State locationInput: string = '';
  @State textNoteInput: string = '';
  @State isPendingTask: boolean = false; // 是否是待决策任务
  @State isCompletedTask: boolean = false; // 是否是已完成任务
  @State isPublisher: boolean = false; // 当前用户是否是发布者

  private photoDialogController: CustomDialogController | null = null;
  private locationDialogController: CustomDialogController | null = null;
  private textDialogController: CustomDialogController | null = null;

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    this.taskId = params['taskId'] || '';
    this.fromPage = params['from'] || '';
    this.isPendingTask = this.fromPage === 'pending';
    this.isCompletedTask = this.fromPage === 'completed';
    this.isPublisher = params['isPublisher'] === 'true';
    this.loadTaskDetail();
  }

  async loadTaskDetail() {
    this.loading = true;
    await new Promise<void>((resolve) => setTimeout(resolve, 500));

    // 根据不同状态模拟任务详情数据
    if (this.isCompletedTask && this.isPublisher) {
      // 发布者查看已完成的任务
      this.taskDetail = {
        id: this.taskId,
        title: '帮我买一杯咖啡',
        description: '需要在星巴克购买一杯中杯拿铁，要求热饮，不加糖。购买后请拍照确认并送到办公室A座302。',
        publisherId: 'user_001',
        publisherName: '小明',
        publisherAvatar: '',
        reward: 50,
        currencyType: 'shell',
        deadline: '2026-02-02 18:00:00',
        currentSubTaskIndex: 3,
        status: 'completed',
        executorId: 'user_002',
        completedAt: '2026-02-01 15:30:00',
        isPublisher: true,
        subTasks: [
          {
            id: 'sub_1',
            title: '前往星巴克',
            description: '到达最近的星巴克门店',
            isCompleted: true,
            isCurrent: false,
            photos: [],
            location: '北京市朝阳区建国路88号',
            textNote: '已到达星巴克'
          },
          {
            id: 'sub_2',
            title: '购买咖啡',
            description: '购买中杯拿铁，热饮，不加糖',
            isCompleted: true,
            isCurrent: false,
            photos: ['file://photo1.jpg', 'file://photo2.jpg'],
            location: '北京市朝阳区建国路88号星巴克',
            textNote: '已购买中杯拿铁，热饮，无糖'
          },
          {
            id: 'sub_3',
            title: '拍照确认',
            description: '拍摄咖啡照片并上传',
            isCompleted: true,
            isCurrent: false,
            photos: ['file://coffee1.jpg', 'file://coffee2.jpg'],
            location: '',
            textNote: '咖啡照片已上传'
          },
          {
            id: 'sub_4',
            title: '送达办公室',
            description: '将咖啡送到A座302办公室',
            isCompleted: true,
            isCurrent: false,
            photos: ['file://delivery.jpg'],
            location: 'A座302办公室',
            textNote: '已送达，客户已签收'
          }
        ]
      };
    } else {
      // 执行者进行中的任务
      this.taskDetail = {
        id: this.taskId,
        title: '帮我买一杯咖啡',
        description: '需要在星巴克购买一杯中杯拿铁，要求热饮，不加糖。购买后请拍照确认并送到办公室A座302。',
        publisherId: 'user_001',
        publisherName: '小明',
        publisherAvatar: '',
        reward: 50,
        currencyType: 'shell',
        deadline: '2026-02-02 18:00:00',
        currentSubTaskIndex: 1,
        status: 'in_progress',
        executorId: 'user_002',
        isPublisher: false,
        subTasks: [
          {
            id: 'sub_1',
            title: '前往星巴克',
            description: '到达最近的星巴克门店',
            isCompleted: true,
            isCurrent: false,
            photos: [],
            location: '北京市朝阳区建国路88号',
            textNote: '已到达星巴克'
          },
          {
            id: 'sub_2',
            title: '购买咖啡',
            description: '购买中杯拿铁，热饮，不加糖',
            isCompleted: false,
            isCurrent: true,
            photos: [],
            location: '',
            textNote: ''
          },
          {
            id: 'sub_3',
            title: '拍照确认',
            description: '拍摄咖啡照片并上传',
            isCompleted: false,
            isCurrent: false,
            photos: [],
            location: '',
            textNote: ''
          },
          {
            id: 'sub_4',
            title: '送达办公室',
            description: '将咖啡送到A座302办公室',
            isCompleted: false,
            isCurrent: false,
            photos: [],
            location: '',
            textNote: ''
          }
        ]
      };
    }

    this.loading = false;
  }

  getCurrencyName(type: string): string {
    switch (type) {
      case 'shell':
        return '世界币';
      case 'star':
        return '个人币';
      case 'guild':
        return '团体币';
      default:
        return '';
    }
  }

  getCurrencyColor(type: string): string {
    switch (type) {
      case 'shell':
        return '#F59E0B';
      case 'star':
        return '#8B5CF6';
      case 'guild':
        return '#10B981';
      default:
        return '#64748B';
    }
  }

  formatTime(timeStr: string): string {
    const time = new Date(timeStr);
    const month = time.getMonth() + 1;
    const day = time.getDate();
    const hours = time.getHours().toString().padStart(2, '0');
    const minutes = time.getMinutes().toString().padStart(2, '0');
    return `${month}月${day}日 ${hours}:${minutes}`;
  }

  handleAbandonTask() {
    promptAction.showDialog({
      title: '放弃任务',
      message: '确定要放弃这个任务吗？',
      buttons: [
        { text: '取消', color: '#64748B' },
        { text: '确定', color: '#EF4444' }
      ]
    }, (err, data) => {
      if (data.index === 1) {
        promptAction.showToast({
          message: '已放弃任务',
          duration: 2000
        });
        router.back();
      }
    });
  }

  async handleSubmitCurrentStep() {
    if (!this.taskDetail) return;

    const currentSubTask = this.taskDetail.subTasks[this.taskDetail.currentSubTaskIndex];

    promptAction.showDialog({
      title: '提交当前步骤',
      message: `确定提交"${currentSubTask.title}"吗？`,
      buttons: [
        { text: '取消', color: '#64748B' },
        { text: '提交', color: '#E11D48' }
      ]
    }, async (err, data) => {
      if (data.index === 1) {
        // 显示上传中提示
        promptAction.showToast({
          message: '正在上传数据...',
          duration: 2000
        });

        // 压缩并上传照片
        if (currentSubTask.photos && currentSubTask.photos.length > 0) {
          await this.compressAndUploadPhotos(currentSubTask.photos);
        }

        // 上传位置和文字信息到后端
        await this.uploadSubTaskData(currentSubTask);

        // 标记当前步骤完成
        currentSubTask.isCompleted = true;
        currentSubTask.isCurrent = false;

        // 移动到下一步
        if (this.taskDetail && this.taskDetail.currentSubTaskIndex < this.taskDetail.subTasks.length - 1) {
          this.taskDetail.currentSubTaskIndex++;
          this.taskDetail.subTasks[this.taskDetail.currentSubTaskIndex].isCurrent = true;

          promptAction.showToast({
            message: '步骤已提交，进入下一步',
            duration: 2000
          });
        } else {
          promptAction.showToast({
            message: '任务已完成！',
            duration: 2000
          });
          router.back();
        }
      }
    });
  }

  // 压缩并上传照片
  async compressAndUploadPhotos(photoUris: string[]) {
    try {
      for (const uri of photoUris) {
        // 读取图片
        const file = fileIo.openSync(uri, fileIo.OpenMode.READ_ONLY);
        const imageSourceApi = image.createImageSource(file.fd);

        // 获取图片信息
        const imageInfo = await imageSourceApi.getImageInfo();

        // 设置压缩参数
        const decodingOptions: image.DecodingOptions = {
          desiredSize: { width: 1080, height: 1080 }, // 压缩到最大1080px
          desiredPixelFormat: 3 // RGBA_8888
        };

        // 解码图片
        const pixelMap = await imageSourceApi.createPixelMap(decodingOptions);

        // 打包为JPEG格式，质量80%
        const imagePackerApi = image.createImagePacker();
        const packOpts: image.PackingOption = {
          format: 'image/jpeg',
          quality: 80
        };

        const compressedData = await imagePackerApi.packing(pixelMap, packOpts);

        // TODO: 上传压缩后的图片到后端服务器
        // await uploadToServer(compressedData);

        // 释放资源
        pixelMap.release();
        imageSourceApi.release();
        fileIo.closeSync(file);
      }

      console.info('照片压缩上传完成');
    } catch (err) {
      console.error('照片压缩上传失败:', JSON.stringify(err));
      promptAction.showToast({
        message: '照片上传失败',
        duration: 2000
      });
    }
  }

  // 上传子任务数据到后端
  async uploadSubTaskData(subTask: SubTask) {
    try {
      // TODO: 实现实际的后端API调用
      const data: UploadData = {
        subTaskId: subTask.id,
        photos: subTask.photos,
        location: subTask.location,
        textNote: subTask.textNote,
        timestamp: Date.now()
      };

      // 模拟API调用
      await new Promise<void>((resolve) => setTimeout(resolve, 500));

      console.info('子任务数据上传完成:', JSON.stringify(data));
    } catch (err) {
      console.error('子任务数据上传失败:', JSON.stringify(err));
      const error = new Error('上传失败');
      throw error;
    }
  }

  handleRejectTask() {
    promptAction.showDialog({
      title: '拒绝任务',
      message: '确定要拒绝这个任务吗？',
      buttons: [
        { text: '取消', color: '#64748B' },
        { text: '拒绝', color: '#EF4444' }
      ]
    }, (err, data) => {
      if (data.index === 1) {
        promptAction.showToast({
          message: '已拒绝任务',
          duration: 2000
        });
        router.back();
      }
    });
  }

  // 发布者确认任务完成并发放奖励
  handleConfirmTask() {
    promptAction.showDialog({
      title: '确认任务完成',
      message: '确认任务已完成并发放奖励吗？',
      buttons: [
        { text: '取消', color: '#64748B' },
        { text: '确认发放', color: '#10B981' }
      ]
    }, async (err, data) => {
      if (data.index === 1) {
        // TODO: 调用后端API发放奖励
        await new Promise<void>((resolve) => setTimeout(resolve, 500));

        if (this.taskDetail) {
          this.taskDetail.status = 'confirmed';
          this.taskDetail.confirmedAt = new Date().toISOString();
        }

        promptAction.showToast({
          message: '已确认完成并发放奖励',
          duration: 2000
        });

        router.back();
      }
    });
  }

  // 发布者拒绝任务完成
  handleRejectCompletion() {
    promptAction.showDialog({
      title: '拒绝任务完成',
      message: '确定要拒绝此任务完成吗？请说明原因。',
      buttons: [
        { text: '取消', color: '#64748B' },
        { text: '拒绝', color: '#EF4444' }
      ]
    }, async (err, data) => {
      if (data.index === 1) {
        // TODO: 调用后端API拒绝任务，并通知执行者
        await new Promise<void>((resolve) => setTimeout(resolve, 500));

        if (this.taskDetail) {
          this.taskDetail.status = 'rejected';
        }

        promptAction.showToast({
          message: '已拒绝任务完成',
          duration: 2000
        });

        router.back();
      }
    });
  }

  handleNegotiateTask() {
    promptAction.showToast({
      message: '进入协商页面',
      duration: 2000
    });
    // TODO: 跳转到协商页面
  }

  handleAcceptTask() {
    promptAction.showDialog({
      title: '接受任务',
      message: '确定要接受这个任务吗？',
      buttons: [
        { text: '取消', color: '#64748B' },
        { text: '接受', color: '#10B981' }
      ]
    }, (err, data) => {
      if (data.index === 1) {
        promptAction.showToast({
          message: '已接受任务',
          duration: 2000
        });
        // 接受后刷新页面状态
        this.isPendingTask = false;
      }
    });
  }

  handleChatWithPublisher() {
    if (!this.taskDetail) return;

    router.pushUrl({
      url: 'pages/ChatPage',
      params: {
        friendId: this.taskDetail.publisherId,
        friendName: this.taskDetail.publisherName,
        friendAvatar: this.taskDetail.publisherAvatar
      }
    });
  }

  handleAddPhoto(subTaskId: string) {
    this.currentSubTaskId = subTaskId;
    this.photoDialogController = new CustomDialogController({
      builder: PhotoDialogBuilder({
        onCamera: () => {
          this.photoDialogController?.close();
          this.openCamera();
        },
        onGallery: () => {
          this.photoDialogController?.close();
          this.openPhotoPicker();
        },
        onCancel: () => {
          this.photoDialogController?.close();
        }
      }),
      alignment: DialogAlignment.Bottom,
      offset: { dx: 0, dy: 0 },
      customStyle: true,
      autoCancel: true
    });
    this.photoDialogController.open();
  }

  handleAddLocation(subTaskId: string) {
    this.currentSubTaskId = subTaskId;
    this.locationDialogController = new CustomDialogController({
      builder: LocationDialogBuilder({
        onConfirm: () => {
          this.locationDialogController?.close();
          this.requestLocationPermissionAndGet();
        },
        onCancel: () => {
          this.locationDialogController?.close();
        }
      }),
      alignment: DialogAlignment.Center,
      customStyle: true,
      autoCancel: true
    });
    this.locationDialogController.open();
  }

  // 请求定位权限并获取位置
  async requestLocationPermissionAndGet() {
    try {
      const atManager = abilityAccessCtrl.createAtManager();
      const context = getContext(this) as common.UIAbilityContext;

      // 检查权限
      const checkResult = await atManager.checkAccessToken(
        context.applicationInfo.accessTokenId,
        'ohos.permission.APPROXIMATELY_LOCATION'
      );

      if (checkResult === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        // 已有权限，直接获取定位
        await this.getSystemLocation();
      } else {
        // 请求权限
        const result: PermissionRequestResult = await atManager.requestPermissionsFromUser(
          context,
          ['ohos.permission.APPROXIMATELY_LOCATION', 'ohos.permission.LOCATION']
        );

        if (result.authResults[0] === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
          // 权限授予成功，获取定位
          await this.getSystemLocation();
        } else {
          promptAction.showToast({
            message: '定位权限被拒绝',
            duration: 2000
          });
        }
      }
    } catch (err) {
      console.error('请求定位权限失败:', JSON.stringify(err));
      promptAction.showToast({
        message: '请求定位权限失败',
        duration: 2000
      });
    }
  }

  // 获取系统定位
  async getSystemLocation() {
    try {
      // 请求定位
      const requestInfo: geoLocationManager.LocationRequest = {
        priority: geoLocationManager.LocationRequestPriority.FIRST_FIX,
        scenario: geoLocationManager.LocationRequestScenario.UNSET,
        maxAccuracy: 0
      };

      // 获取当前位置
      const location = await geoLocationManager.getCurrentLocation(requestInfo);

      if (location) {
        // 逆地理编码，将经纬度转换为地址
        const reverseGeoCodeRequest: geoLocationManager.ReverseGeoCodeRequest = {
          latitude: location.latitude,
          longitude: location.longitude,
          maxItems: 1
        };

        const geoAddress = await geoLocationManager.getAddressesFromLocation(reverseGeoCodeRequest);

        if (geoAddress && geoAddress.length > 0) {
          const address = geoAddress[0];
          // 组合详细地址
          const fullAddress = `${address.administrativeArea || ''}${address.locality || ''}${address.subLocality || ''}${address.roadName || ''}${address.subRoadName || ''}`;
          this.locationInput = fullAddress || `${location.latitude}, ${location.longitude}`;
        } else {
          // 如果无法获取地址，显示经纬度
          this.locationInput = `${location.latitude.toFixed(6)}, ${location.longitude.toFixed(6)}`;
        }

        // 保存定位到当前子任务
        this.saveLocation();

        promptAction.showToast({
          message: '定位成功',
          duration: 2000
        });
      }
    } catch (err) {
      console.error('获取定位失败:', JSON.stringify(err));
      promptAction.showToast({
        message: '获取定位失败',
        duration: 2000
      });
    }
  }

  handleAddText(subTaskId: string) {
    this.currentSubTaskId = subTaskId;
    if (this.taskDetail && this.taskDetail.subTasks) {
      const subTask = this.taskDetail.subTasks.find(st => st.id === subTaskId);
      this.textNoteInput = subTask ? (subTask.textNote || '') : '';
    }
    this.textDialogController = new CustomDialogController({
      builder: TextDialogBuilder({
        textInput: this.textNoteInput,
        onTextChange: (value: string) => {
          this.textNoteInput = value;
        },
        onConfirm: () => {
          this.textDialogController?.close();
          this.saveTextNote();
        },
        onCancel: () => {
          this.textDialogController?.close();
          this.textNoteInput = '';
        }
      }),
      alignment: DialogAlignment.Center,
      customStyle: true,
      autoCancel: true
    });
    this.textDialogController.open();
  }

  // 保存照片
  async savePhoto(photoUrl: string) {
    if (!this.taskDetail || !this.taskDetail.subTasks) {
      return;
    }
    const subTaskIndex = this.taskDetail.subTasks.findIndex(st => st.id === this.currentSubTaskId);
    if (subTaskIndex !== -1) {
      const subTask = this.taskDetail.subTasks[subTaskIndex];
      if (subTask && subTask.photos) {
        subTask.photos.push(photoUrl);
        // 触发UI更新
        this.taskDetail.subTasks = [...this.taskDetail.subTasks];
      }
    }
  }

  // 打开系统相册选择照片
  async openPhotoPicker() {
    try {
      const photoSelectOptions = new picker.PhotoSelectOptions();
      photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
      photoSelectOptions.maxSelectNumber = 9; // 最多选择9张

      const photoPicker = new picker.PhotoViewPicker();
      const photoSelectResult = await photoPicker.select(photoSelectOptions);

      if (photoSelectResult && photoSelectResult.photoUris && photoSelectResult.photoUris.length > 0) {
        // 将选中的照片URI添加到当前子任务
        for (const uri of photoSelectResult.photoUris) {
          await this.savePhoto(uri);
        }
      }
    } catch (err) {
      console.error('选择照片失败:', JSON.stringify(err));
      promptAction.showToast({
        message: '选择照片失败',
        duration: 2000
      });
    }
  }

  // 打开相机拍照
  async openCamera() {
    try {
      const photoSelectOptions = new picker.PhotoSelectOptions();
      photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
      photoSelectOptions.maxSelectNumber = 1; // 拍照一次只能拍一张

      const photoPicker = new picker.PhotoViewPicker();
      // 注意：实际的相机调用可能需要使用 camera kit，这里使用 picker 作为简化实现
      const photoSelectResult = await photoPicker.select(photoSelectOptions);

      if (photoSelectResult && photoSelectResult.photoUris && photoSelectResult.photoUris.length > 0) {
        await this.savePhoto(photoSelectResult.photoUris[0]);
      }
    } catch (err) {
      console.error('拍照失败:', JSON.stringify(err));
      promptAction.showToast({
        message: '拍照失败',
        duration: 2000
      });
    }
  }

  // 删除照片
  deletePhoto(subTaskId: string, photoIndex: number) {
    if (!this.taskDetail || !this.taskDetail.subTasks) {
      return;
    }
    const subTaskIndex = this.taskDetail.subTasks.findIndex(st => st.id === subTaskId);
    if (subTaskIndex !== -1) {
      const subTask = this.taskDetail.subTasks[subTaskIndex];
      if (subTask && subTask.photos) {
        subTask.photos.splice(photoIndex, 1);
        // 触发UI更新
        this.taskDetail.subTasks = [...this.taskDetail.subTasks];
      }
    }
  }

  // 保存位置
  saveLocation() {
    if (!this.taskDetail || !this.taskDetail.subTasks) {
      return;
    }
    const subTaskIndex = this.taskDetail.subTasks.findIndex(st => st.id === this.currentSubTaskId);
    if (subTaskIndex !== -1) {
      const subTask = this.taskDetail.subTasks[subTaskIndex];
      if (subTask) {
        subTask.location = this.locationInput;
        // 触发UI更新
        this.taskDetail.subTasks = [...this.taskDetail.subTasks];
      }
    }
    this.locationInput = '';
  }

  // 保存文字备注
  saveTextNote() {
    if (!this.taskDetail || !this.taskDetail.subTasks) {
      return;
    }
    const subTaskIndex = this.taskDetail.subTasks.findIndex(st => st.id === this.currentSubTaskId);
    if (subTaskIndex !== -1) {
      const subTask = this.taskDetail.subTasks[subTaskIndex];
      if (subTask) {
        subTask.textNote = this.textNoteInput;
        // 触发UI更新
        this.taskDetail.subTasks = [...this.taskDetail.subTasks];
      }
    }
    this.textNoteInput = '';
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

        Text('任务详情')
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
      } else if (this.taskDetail) {
        Column() {
          Scroll() {
            Column() {
              // 顶部：任务描述与发布者信息
              Column() {
                // 任务标题和货币类型
                Row() {
                  Text(this.getCurrencyName(this.taskDetail.currencyType))
                    .fontSize(12)
                    .fontColor('#FFFFFF')
                    .backgroundColor(this.getCurrencyColor(this.taskDetail.currencyType))
                    .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                    .borderRadius(4)
                }
                .width('100%')
                .margin({ bottom: 12 })

                Text(this.taskDetail.title)
                  .fontSize(22)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1F2937')
                  .width('100%')
                  .margin({ bottom: 12 })

                Text(this.taskDetail.description)
                  .fontSize(15)
                  .fontColor('#64748B')
                  .lineHeight(24)
                  .width('100%')
                  .margin({ bottom: 16 })

                Divider()
                  .color('#F1F5F9')
                  .margin({ top: 8, bottom: 16 })

                // 发布者信息（可点击跳转聊天）
                Row() {
                  Row() {
                    Column() {
                      Circle()
                        .width(48)
                        .height(48)
                        .fill('#F1F5F9')
                    }

                    Column() {
                      Text(this.taskDetail.publisherName)
                        .fontSize(16)
                        .fontWeight(FontWeight.Medium)
                        .fontColor('#1F2937')
                        .margin({ bottom: 4 })

                      Text('任务发布者')
                        .fontSize(13)
                        .fontColor('#94A3B8')
                    }
                    .alignItems(HorizontalAlign.Start)
                    .margin({ left: 12 })
                  }
                  .layoutWeight(1)
                  .onClick(() => {
                    this.handleChatWithPublisher();
                  })

                  Column() {
                    Row() {
                      Text('💰')
                        .fontSize(20)
                      Text(`${this.taskDetail.reward}`)
                        .fontSize(24)
                        .fontWeight(FontWeight.Bold)
                        .fontColor(this.getCurrencyColor(this.taskDetail.currencyType))
                        .margin({ left: 4 })
                    }

                    Text(`截止：${this.formatTime(this.taskDetail.deadline)}`)
                      .fontSize(12)
                      .fontColor('#94A3B8')
                      .margin({ top: 4 })
                  }
                  .alignItems(HorizontalAlign.End)
                }
                .width('100%')
              }
              .width('100%')
              .padding(20)
              .backgroundColor('#FFFFFF')
              .borderRadius(12)
              .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
              .margin({ top: 16, left: 16, right: 16 })

              // 子任务流（仅当有子任务时显示）
              if (this.taskDetail.subTasks && this.taskDetail.subTasks.length > 0) {
                Column() {
                  Text('任务步骤')
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#1F2937')
                    .width('100%')
                    .margin({ bottom: 16 })

                  // 时间轴
                  Column() {
                    ForEach(this.taskDetail.subTasks, (subTask: SubTask, index: number) => {
                      this.SubTaskItem(subTask, index, this.taskDetail!.subTasks.length)
                    })
                  }
                  .width('100%')
                }
                .width('100%')
                .padding(20)
                .backgroundColor('#FFFFFF')
                .borderRadius(12)
                .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.08)', offsetY: 2 })
                .margin({ top: 12, left: 16, right: 16, bottom: 100 })
              }
            }
            .width('100%')
          }
          .width('100%')
          .layoutWeight(1)
        }
        .width('100%')
        .layoutWeight(1)

        // 底部操作按钮
        if (this.isPendingTask) {
          // 待决策任务：拒绝、协商、接受
          Row() {
            Button('拒绝')
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
              .fontColor('#64748B')
              .backgroundColor('#F1F5F9')
              .height(48)
              .borderRadius(24)
              .layoutWeight(1)
              .onClick(() => {
                this.handleRejectTask();
              })

            Button('协商')
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
              .fontColor('#2563EB')
              .backgroundColor('#EFF6FF')
              .height(48)
              .borderRadius(24)
              .layoutWeight(1)
              .margin({ left: 10 })
              .onClick(() => {
                this.handleNegotiateTask();
              })

            Button('接受')
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .height(48)
              .borderRadius(24)
              .layoutWeight(1)
              .margin({ left: 10 })
              .linearGradient({
                angle: 135,
                colors: [['#E11D48', 0.0], ['#FB7185', 1.0]]
              })
              .onClick(() => {
                this.handleAcceptTask();
              })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 12, bottom: 12 })
          .backgroundColor('#FFFFFF')
          .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.1)', offsetY: -2 })
        } else if (this.isCompletedTask && this.isPublisher && this.taskDetail && this.taskDetail.status === 'completed') {
          // 发布者查看已完成任务：拒绝、确认发放奖励
          Column() {
            // 任务状态提示
            Row() {
              Text('⏰')
                .fontSize(16)
              Text(`任务已于 ${this.taskDetail.completedAt} 完成，请确认`)
                .fontSize(13)
                .fontColor('#64748B')
                .margin({ left: 4 })
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 8, bottom: 8 })
            .backgroundColor('#FFF7ED')

            Row() {
              Button('拒绝完成')
                .fontSize(15)
                .fontWeight(FontWeight.Medium)
                .fontColor('#EF4444')
                .backgroundColor('#FEE2E2')
                .height(48)
                .borderRadius(24)
                .layoutWeight(1)
                .onClick(() => {
                  this.handleRejectCompletion();
                })

              Button('确认并发放奖励')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
                .height(48)
                .borderRadius(24)
                .layoutWeight(2)
                .margin({ left: 12 })
                .linearGradient({
                  angle: 135,
                  colors: [['#10B981', 0.0], ['#34D399', 1.0]]
                })
                .onClick(() => {
                  this.handleConfirmTask();
                })
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 12, bottom: 12 })
          }
          .width('100%')
          .backgroundColor('#FFFFFF')
          .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.1)', offsetY: -2 })
        } else if (this.isCompletedTask && this.isPublisher && this.taskDetail && this.taskDetail.status === 'confirmed') {
          // 已确认完成的任务
          Row() {
            Text('✅')
              .fontSize(20)
            Text('任务已确认完成，奖励已发放')
              .fontSize(15)
              .fontColor('#10B981')
              .fontWeight(FontWeight.Medium)
              .margin({ left: 8 })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 16, bottom: 16 })
          .backgroundColor('#F0FDF4')
          .justifyContent(FlexAlign.Center)
        } else if (!this.isPendingTask && !this.isCompletedTask) {
          // 执行中的任务：放弃任务、提交当前步骤
          Row() {
            Button('放弃任务')
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
              .fontColor('#EF4444')
              .backgroundColor('#FEE2E2')
              .height(48)
              .borderRadius(24)
              .layoutWeight(1)
              .onClick(() => {
                this.handleAbandonTask();
              })

            Button('提交当前步骤')
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .height(48)
              .borderRadius(24)
              .layoutWeight(2)
              .margin({ left: 12 })
              .linearGradient({
                angle: 135,
                colors: [['#E11D48', 0.0], ['#FB7185', 1.0]]
              })
              .onClick(() => {
                this.handleSubmitCurrentStep();
              })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 12, bottom: 12 })
          .backgroundColor('#FFFFFF')
          .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.1)', offsetY: -2 })
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF1F2')
  }

  @Builder
  SubTaskItem(subTask: SubTask, index: number, total: number) {
    Row() {
      // 左侧时间轴
      Column() {
        // 圆圈
        Circle()
          .width(20)
          .height(20)
          .fill(subTask.isCompleted ? '#10B981' : (subTask.isCurrent ? '#E11D48' : '#E2E8F0'))
          .border({
            width: 3,
            color: subTask.isCompleted ? '#10B981' : (subTask.isCurrent ? '#E11D48' : '#E2E8F0')
          })

        // 连接线（最后一个不显示）
        if (index < total - 1) {
          Column()
            .width(2)
            .height(80)
            .backgroundColor(subTask.isCompleted ? '#10B981' : '#E2E8F0')
            .margin({ top: 4, bottom: 4 })
        }
      }
      .width(20)
      .alignItems(HorizontalAlign.Center)

      // 右侧子任务描述
      Column() {
        Column() {
          Row() {
            Text(subTask.title)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor(subTask.isCurrent ? '#E11D48' : '#1F2937')
              .layoutWeight(1)

            if (subTask.isCompleted) {
              Text('✓')
                .fontSize(18)
                .fontColor('#10B981')
            } else if (subTask.isCurrent) {
              Text('进行中')
                .fontSize(12)
                .fontColor('#E11D48')
                .backgroundColor('#FFF1F2')
                .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                .borderRadius(4)
            }
          }
          .width('100%')
          .margin({ bottom: 8 })

          Text(subTask.description)
            .fontSize(14)
            .fontColor('#64748B')
            .lineHeight(20)
            .width('100%')
            .margin({ bottom: 12 })

          // 操作按钮区（仅当前步骤显示）
          if (subTask.isCurrent) {
            Row() {
              Button() {
                Column() {
                  Text('📷')
                    .fontSize(20)
                  Text('照片')
                    .fontSize(11)
                    .fontColor('#64748B')
                    .margin({ top: 2 })
                }
              }
              .height(60)
              .backgroundColor('#F8FAFC')
              .borderRadius(8)
              .layoutWeight(1)
              .onClick(() => {
                this.handleAddPhoto(subTask.id);
              })

              Button() {
                Column() {
                  Text('📍')
                    .fontSize(20)
                  Text('定位')
                    .fontSize(11)
                    .fontColor('#64748B')
                    .margin({ top: 2 })
                }
              }
              .height(60)
              .backgroundColor('#F8FAFC')
              .borderRadius(8)
              .layoutWeight(1)
              .margin({ left: 8 })
              .onClick(() => {
                this.handleAddLocation(subTask.id);
              })

              Button() {
                Column() {
                  Text('📝')
                    .fontSize(20)
                  Text('文字')
                    .fontSize(11)
                    .fontColor('#64748B')
                    .margin({ top: 2 })
                }
              }
              .height(60)
              .backgroundColor('#F8FAFC')
              .borderRadius(8)
              .layoutWeight(1)
              .margin({ left: 8 })
              .onClick(() => {
                this.handleAddText(subTask.id);
              })
            }
            .width('100%')
          }

          // 已添加的内容显示
          if (subTask.photos.length > 0 || subTask.location || subTask.textNote) {
            Column() {
              // 文字备注
              if (subTask.textNote) {
                Column() {
                  Text('📝 文字备注')
                    .fontSize(13)
                    .fontColor('#64748B')
                    .margin({ bottom: 4 })
                    .alignSelf(ItemAlign.Start)

                  Text(subTask.textNote)
                    .fontSize(13)
                    .fontColor('#1F2937')
                    .lineHeight(20)
                    .width('100%')
                    .padding(12)
                    .backgroundColor('#F8FAFC')
                    .borderRadius(8)
                }
                .width('100%')
                .alignItems(HorizontalAlign.Start)
              }

              // 照片网格显示
              if (subTask.photos.length > 0) {
                Column() {
                  Text('📷 照片')
                    .fontSize(13)
                    .fontColor('#64748B')
                    .margin({ bottom: 8 })
                    .alignSelf(ItemAlign.Start)

                  Grid() {
                    ForEach(subTask.photos, (photo: string, photoIndex: number) => {
                      GridItem() {
                        Stack({ alignContent: Alignment.TopEnd }) {
                          Image(photo)
                            .width('100%')
                            .height('100%')
                            .objectFit(ImageFit.Cover)
                            .borderRadius(8)

                          // 删除按钮
                          if (subTask.isCurrent) {
                            Button() {
                              Text('×')
                                .fontSize(16)
                                .fontColor('#FFFFFF')
                            }
                            .width(24)
                            .height(24)
                            .backgroundColor('rgba(239, 68, 68, 0.9)')
                            .borderRadius(12)
                            .margin({ top: 4, right: 4 })
                            .onClick(() => {
                              this.deletePhoto(subTask.id, photoIndex);
                            })
                          }
                        }
                        .width('100%')
                        .height('100%')
                      }
                      .width(80)
                      .height(80)
                    })
                  }
                  .columnsTemplate('1fr 1fr 1fr')
                  .rowsGap(8)
                  .columnsGap(8)
                  .width('100%')
                }
                .width('100%')
                .margin({ top: 8 })
              }

              // 定位
              if (subTask.location) {
                Row() {
                  Text('📍')
                    .fontSize(14)
                  Text(subTask.location)
                    .fontSize(13)
                    .fontColor('#64748B')
                    .margin({ left: 4 })
                }
                .margin({ top: 8 })
              }
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
          }
        }
        .width('100%')
        .padding(16)
        .backgroundColor(subTask.isCurrent ? '#FFF1F2' : '#F8FAFC')
        .borderRadius(12)
        .border({
          width: 2,
          color: subTask.isCurrent ? '#E11D48' : 'transparent'
        })
      }
      .layoutWeight(1)
      .margin({ left: 16, bottom: index < total - 1 ? 0 : 0 })
    }
    .width('100%')
    .alignItems(VerticalAlign.Top)
    .margin({ bottom: index < total - 1 ? 16 : 0 })
  }
}

// 照片选择对话框
@CustomDialog
struct PhotoDialogBuilder {
  controller: CustomDialogController;
  onCamera?: () => void;
  onGallery?: () => void;
  onCancel?: () => void;

  build() {
    Column() {
      Button('拍摄')
        .fontSize(16)
        .fontColor('#1F2937')
        .backgroundColor('#FFFFFF')
        .width('100%')
        .height(50)
        .onClick(() => {
          if (this.onCamera) {
            this.onCamera();
          }
        })

      Divider()
        .color('#E5E7EB')

      Button('从相册选择')
        .fontSize(16)
        .fontColor('#1F2937')
        .backgroundColor('#FFFFFF')
        .width('100%')
        .height(50)
        .onClick(() => {
          if (this.onGallery) {
            this.onGallery();
          }
        })

      Divider()
        .height(8)
        .color('#F3F4F6')

      Button('取消')
        .fontSize(16)
        .fontColor('#64748B')
        .backgroundColor('#FFFFFF')
        .width('100%')
        .height(50)
        .onClick(() => {
          if (this.onCancel) {
            this.onCancel();
          }
        })
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius({ topLeft: 16, topRight: 16 })
  }
}

// 定位对话框
@CustomDialog
struct LocationDialogBuilder {
  controller: CustomDialogController;
  onConfirm?: () => void;
  onCancel?: () => void;

  build() {
    Column() {
      Text('获取定位')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })

      Text('点击确定获取当前位置')
        .fontSize(14)
        .fontColor('#64748B')
        .margin({ bottom: 30 })

      Row() {
        Button('取消')
          .fontSize(16)
          .fontColor('#64748B')
          .backgroundColor('#F1F5F9')
          .layoutWeight(1)
          .onClick(() => {
            if (this.onCancel) {
              this.onCancel();
            }
          })

        Button('确定')
          .fontSize(16)
          .fontColor('#FFFFFF')
          .backgroundColor('#E11D48')
          .layoutWeight(1)
          .margin({ left: 12 })
          .onClick(() => {
            if (this.onConfirm) {
              this.onConfirm();
            }
          })
      }
      .width('100%')
    }
    .width('85%')
    .padding(24)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
  }
}

// 文字备注对话框
@CustomDialog
struct TextDialogBuilder {
  controller: CustomDialogController;
  textInput: string = '';
  onTextChange?: (value: string) => void;
  onConfirm?: () => void;
  onCancel?: () => void;

  build() {
    Column() {
      Text('添加文字备注')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })

      TextArea({ placeholder: '请输入文字备注', text: this.textInput })
        .fontSize(14)
        .height(120)
        .backgroundColor('#F8FAFC')
        .borderRadius(8)
        .margin({ bottom: 20 })
        .onChange((value: string) => {
          if (this.onTextChange) {
            this.onTextChange(value);
          }
        })

      Row() {
        Button('取消')
          .fontSize(16)
          .fontColor('#64748B')
          .backgroundColor('#F1F5F9')
          .layoutWeight(1)
          .onClick(() => {
            if (this.onCancel) {
              this.onCancel();
            }
          })

        Button('保存')
          .fontSize(16)
          .fontColor('#FFFFFF')
          .backgroundColor('#E11D48')
          .layoutWeight(1)
          .margin({ left: 12 })
          .onClick(() => {
            if (this.onConfirm) {
              this.onConfirm();
            }
          })
      }
      .width('100%')
    }
    .width('85%')
    .padding(24)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
  }
}
