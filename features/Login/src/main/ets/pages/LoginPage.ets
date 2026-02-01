import { hilog } from '@kit.PerformanceAnalysisKit';
import { router } from '@kit.ArkUI';
import { UserManager } from '../utils/UserManager';
import { common } from '@kit.AbilityKit';

@Component
export struct LoginPage {
  @State username: string = '';
  @State password: string = '';
  @State isAgreed: boolean = false;
  @State isLoading: boolean = false;
  @State loginError: string = '';
  @State usernameFocused: boolean = false;
  @State passwordFocused: boolean = false;
  @State cardOpacity: number = 0;
  @State cardTranslateY: number = 50;

  private readonly TAG: string = 'LoginPage';
  private context = getContext(this) as common.UIAbilityContext;

  aboutToAppear() {
    // 初始化UserManager
    UserManager.getInstance().init(this.context);

    // 入场动画
    animateTo({
      duration: 800,
      curve: Curve.FastOutSlowIn
    }, () => {
      this.cardOpacity = 1;
      this.cardTranslateY = 0;
    });
  }

  private async handleLogin() {
    if (!this.isAgreed) {
      this.loginError = '请先同意用户协议';
      return;
    }

    if (!this.username || !this.password) {
      this.loginError = '用户名或密码不能为空';
      return;
    }

    if (this.password.length < 6) {
      this.loginError = '密码长度不能少于6位';
      return;
    }

    this.isLoading = true;
    this.loginError = '';

    try {
      // 调用UserManager的模拟登录接口
      const result = await UserManager.getInstance().mockLogin(this.username, this.password);

      this.isLoading = false;

      if (result.success) {
        hilog.info(0x0000, this.TAG, '登录成功');
        // 跳转首页
        router.replaceUrl({ url: 'pages/HomePage' });
      } else {
        this.loginError = result.message;
      }
    } catch (err) {
      this.isLoading = false;
      this.loginError = '登录失败，请重试';
      hilog.error(0x0000, this.TAG, '登录异常: %{public}s', JSON.stringify(err));
    }
  }

  build() {
    Stack() {
      // 渐变背景 - 使用品牌色
      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          angle: 135,
          colors: [
            ['#E11D48', 0.0],
            ['#FB7185', 0.5],
            ['#FFF1F2', 1.0]
          ]
        })

      // 装饰圆圈
      Circle()
        .width(300)
        .height(300)
        .fill('rgba(255, 255, 255, 0.1)')
        .position({ x: -100, y: -100 })
        .blur(50)

      Circle()
        .width(200)
        .height(200)
        .fill('rgba(255, 255, 255, 0.08)')
        .position({ x: '80%', y: '70%' })
        .blur(40)

      // 主内容
      Scroll() {
        Column() {
          // Logo 区域
          Column() {
            // Logo 图标
            Column() {
              Text('✓')
                .fontSize(48)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
            }
            .width(100)
            .height(100)
            .borderRadius(50)
            .linearGradient({
              angle: 135,
              colors: [
                ['#E11D48', 0.0],
                ['#FB7185', 1.0]
              ]
            })
            .shadow({
              radius: 30,
              color: 'rgba(225, 29, 72, 0.4)',
              offsetY: 10
            })

            // 标题
            Text('DoForMe')
              .fontSize(32)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .margin({ top: 24 })
              .letterSpacing(1)

            Text('让任务管理更简单')
              .fontSize(14)
              .fontColor('rgba(255, 255, 255, 0.8)')
              .margin({ top: 8 })
          }
          .margin({ top: 60, bottom: 48 })

          // 登录卡片
          Column() {
            // 输入区域
            this.LoginForm()

            // 错误提示
            if (this.loginError) {
              Row() {
                Text('⚠ ')
                  .fontSize(14)
                  .fontColor('#FF4D4F')
                Text(this.loginError)
                  .fontSize(13)
                  .fontColor('#FF4D4F')
              }
              .width('100%')
              .padding({ left: 12, right: 12, top: 8, bottom: 8 })
              .backgroundColor('rgba(255, 77, 79, 0.1)')
              .borderRadius(8)
              .margin({ top: 16 })
            }

            // 登录按钮
            Button() {
              if (this.isLoading) {
                LoadingProgress()
                  .width(24)
                  .height(24)
                  .color('#FFFFFF')
              } else {
                Text('登 录')
                  .fontSize(16)
                  .fontColor('#FFFFFF')
                  .fontWeight(FontWeight.Medium)
                  .letterSpacing(2)
              }
            }
            .width('100%')
            .height(52)
            .linearGradient({
              angle: 90,
              colors: this.isAgreed ? [
                ['#E11D48', 0.0],
                ['#FB7185', 1.0]
              ] : [
                ['#cccccc', 0.0],
                ['#999999', 1.0]
              ]
            })
            .borderRadius(26)
            .margin({ top: 24 })
            .enabled(this.isAgreed && !this.isLoading)
            .shadow({
              radius: 20,
              color: this.isAgreed ? 'rgba(225, 29, 72, 0.4)' : 'rgba(0, 0, 0, 0.1)',
              offsetY: 8
            })
            .onClick(() => this.handleLogin())

            // 操作链接
            Row() {
              Text('注册账号')
                .fontSize(14)
                .fontColor('#E11D48')
                .fontWeight(FontWeight.Medium)
              Blank()
              Text('忘记密码')
                .fontSize(14)
                .fontColor('#E11D48')
                .fontWeight(FontWeight.Medium)
            }
            .width('100%')
            .margin({ top: 20 })

            // 分割线
            Row() {
              Divider()
                .strokeWidth(1)
                .color('rgba(0, 0, 0, 0.08)')
              Text('其他登录方式')
                .fontSize(12)
                .fontColor('#999999')
                .margin({ left: 12, right: 12 })
              Divider()
                .strokeWidth(1)
                .color('rgba(0, 0, 0, 0.08)')
            }
            .width('100%')
            .margin({ top: 32 })

            // 第三方登录
            Row() {
              this.SocialLoginButton('微信', '#07C160')
              this.SocialLoginButton('QQ', '#12B7F5')
              this.SocialLoginButton('微博', '#E6162D')
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceEvenly)
            .margin({ top: 24 })

            // 协议
            Row() {
              Checkbox()
                .select(this.isAgreed)
                .width(18)
                .height(18)
                .selectedColor('#E11D48')
                .onChange((value) => {
                  animateTo({ duration: 200 }, () => {
                    this.isAgreed = value;
                  });
                })

              Text() {
                Span('我已阅读并同意')
                  .fontSize(12)
                  .fontColor('#666666')
                Span('《用户协议》')
                  .fontSize(12)
                  .fontColor('#E11D48')
                  .decoration({ type: TextDecorationType.Underline })
                Span(' 和 ')
                  .fontSize(12)
                  .fontColor('#666666')
                Span('《隐私政策》')
                  .fontSize(12)
                  .fontColor('#E11D48')
                  .decoration({ type: TextDecorationType.Underline })
              }
              .margin({ left: 8 })
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
            .margin({ top: 32, bottom: 24 })
          }
          .width('100%')
          .padding(28)
          .backgroundColor('rgba(255, 255, 255, 0.95)')
          .borderRadius(24)
          .shadow({
            radius: 40,
            color: 'rgba(0, 0, 0, 0.1)',
            offsetY: 20
          })
          .backdropBlur(20)
          .opacity(this.cardOpacity)
          .translate({ y: this.cardTranslateY })
        }
        .width('100%')
        .padding({ left: 24, right: 24, bottom: 40 })
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  LoginForm() {
    Column({ space: 16 }) {
      // 手机号输入框
      Column() {
        Row() {
          Text('📱')
            .fontSize(20)
            .margin({ right: 12 })

          TextInput({ placeholder: '请输入手机号', text: $$this.username })
            .type(InputType.PhoneNumber)
            .maxLength(11)
            .layoutWeight(1)
            .backgroundColor(Color.Transparent)
            .border({ width: 0 })
            .padding(0)
            .placeholderColor('#CCCCCC')
            .onFocus(() => {
              animateTo({ duration: 200 }, () => {
                this.usernameFocused = true;
              });
            })
            .onBlur(() => {
              animateTo({ duration: 200 }, () => {
                this.usernameFocused = false;
              });
            })
        }
        .width('100%')
        .height(56)
        .padding({ left: 16, right: 16 })
        .backgroundColor('#F7F8FA')
        .borderRadius(16)
        .border({
          width: 2,
          color: this.usernameFocused ? '#E11D48' : Color.Transparent
        })
        .shadow({
          radius: this.usernameFocused ? 12 : 0,
          color: 'rgba(225, 29, 72, 0.15)',
          offsetY: 4
        })
      }

      // 密码输入框
      Column() {
        Row() {
          Text('🔒')
            .fontSize(20)
            .margin({ right: 12 })

          TextInput({ placeholder: '请输入密码', text: $$this.password })
            .type(InputType.Password)
            .maxLength(20)
            .layoutWeight(1)
            .backgroundColor(Color.Transparent)
            .border({ width: 0 })
            .padding(0)
            .placeholderColor('#CCCCCC')
            .onFocus(() => {
              animateTo({ duration: 200 }, () => {
                this.passwordFocused = true;
              });
            })
            .onBlur(() => {
              animateTo({ duration: 200 }, () => {
                this.passwordFocused = false;
              });
            })
        }
        .width('100%')
        .height(56)
        .padding({ left: 16, right: 16 })
        .backgroundColor('#F7F8FA')
        .borderRadius(16)
        .border({
          width: 2,
          color: this.passwordFocused ? '#E11D48' : Color.Transparent
        })
        .shadow({
          radius: this.passwordFocused ? 12 : 0,
          color: 'rgba(225, 29, 72, 0.15)',
          offsetY: 4
        })
      }
    }
    .width('100%')
  }

  @Builder
  SocialLoginButton(name: string, color: string) {
    Column() {
      Circle()
        .width(50)
        .height(50)
        .fill(color)
        .shadow({
          radius: 12,
          color: `${color}40`,
          offsetY: 4
        })

      Text(name)
        .fontSize(12)
        .fontColor('#666666')
        .margin({ top: 8 })
    }
  }
}