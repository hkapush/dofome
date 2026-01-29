import { hilog } from '@kit.PerformanceAnalysisKit';

@Component
export struct LoginPage {
  @State username: string = '';
  @State password: string = '';
  @State isAgreed: boolean = false;
  @State isLoading: boolean = false;
  @State loginError: string = '';

  private readonly TAG: string = 'LoginPage';

  private async handleLogin() {
    if (!this.isAgreed) {
      this.loginError = '请先同意用户协议';
      return;
    }

    if (this.username.length < 11 || this.password.length < 6) {
      this.loginError = '手机号或密码错误';
      return;
    }

    this.isLoading = true;

    // 模拟登录
    setTimeout(() => {
      this.isLoading = false;
      hilog.info(0x0000, this.TAG, '登录成功');
      // 跳转首页 router.replaceUrl({ url: 'pages/Index' });
    }, 1000);
  }

  build() {
    Column() {
      Blank().height(40)

      Column() {
        // Logo
        Column() {
          Text('TL')
            .fontSize(32)
            .fontWeight(FontWeight.Bold)
            .fontColor('#007DFF')
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .width(80)
        .height(80)
        .borderRadius(20)
        .backgroundColor('#E6F2FF')
        .shadow({ radius: 16, color: 'rgba(0,125,255,0.15)' })
        .margin({ top: 40 })

        // 标题
        Text('任务圈 • TaskLoop')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .margin({ top: 16, bottom: 32 })

        // 输入区域
        this.LoginForm()

        // 错误提示
        if (this.loginError) {
          Text(this.loginError)
            .fontSize(12)
            .fontColor('#FA2C2C')
            .margin({ top: 8 })
        }

        // 登录按钮
        Button() {
          if (this.isLoading) {
            LoadingProgress().width(24).height(24).color('#FFFFFF')
          } else {
            Text('登录').fontSize(16).fontColor('#FFFFFF').fontWeight(FontWeight.Medium)
          }
        }
        .width('100%')
        .height(48)
        .backgroundColor(this.isAgreed ? '#007DFF' : '#94BFFF')
        .borderRadius(24)
        .margin({ top: 24 })
        .enabled(this.isAgreed && !this.isLoading)
        .onClick(() => this.handleLogin())

        // 操作链接
        Row() {
          Text('注册账号').fontSize(14).fontColor('#4E5969')
          Blank().width(32)
          Text('忘记密码').fontSize(14).fontColor('#4E5969')
        }
        .margin({ top: 16 })

        // 协议
        Row() {
          Checkbox()
            .select(this.isAgreed)
            .width(16)
            .height(16)
            .selectedColor('#007DFF')
            .onChange((value) => this.isAgreed = value)
          Text() {
            Span('我已阅读并同意')
            Span('《用户协议》').fontColor('#007DFF')
            Span('和')
            Span('《隐私政策》').fontColor('#007DFF')
          }
          .fontSize(12)
          .fontColor('#86909C')
          .margin({ left: 6 })
        }
        .margin({ top: 24 })
      }
      .width('100%')
      .padding(24)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }

  @Builder
  LoginForm() {
    Column() {
      // 手机号
      TextInput({ placeholder: '请输入手机号', text: this.username })
        .type(InputType.PhoneNumber)
        .maxLength(11)
        .height(48)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
        .padding({ left: 16 })
        .border({ width: 1, color: '#E5E6EB' })
        .onChange((value) => this.username = value)

        TextInput({ placeholder: '请输入密码', text: this.password })
          .type( InputType.Password)
          .maxLength(20)
          .height(48)
          .backgroundColor('#FFFFFF')
          .borderRadius(8)
          .padding({ left: 16,right:8 })
          .border({ width: 1, color: '#E5E6EB' })
          .onChange((value) => this.password = value)
          .margin({
            top:16
          })
    }
    .width('100%')
  }
}