import { HMRouter } from "@hadss/hmrouter";


@HMRouter({ pageUrl: "TwoPage" })
@Component
export struct testPage{
  build() {

    Column(){
      Text('第二个界面')
    }
    .height('100%')
    .width('100%')

  }
}