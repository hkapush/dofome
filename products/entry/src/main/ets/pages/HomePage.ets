import { HomePage } from 'home'

@Entry
@Component
struct HomePageEntry {
  build() {
    Column() {
      HomePage()
    }
    .width('100%')
    .height('100%')
  }
}
