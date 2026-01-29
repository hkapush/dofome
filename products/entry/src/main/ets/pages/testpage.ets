import { HMRouter } from "@hadss/hmrouter";
import { LoginPage } from "login";


@HMRouter({ pageUrl: "TwoPage" })
@Component
export struct testPage{
  build() {

    Column(){
      LoginPage()
    }
    .height('100%')
    .width('100%')

  }
}