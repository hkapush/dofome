import { router } from '@kit.ArkUI';
import { LoginPage } from 'login';

@Entry
@Component
struct LoginPageEntry {
  build() {
    Column() {
      LoginPage()
    }
    .width('100%')
    .height('100%')
  }
}
