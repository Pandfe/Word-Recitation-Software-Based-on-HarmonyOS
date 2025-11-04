@Component
export struct MyOptions {
  build() {
    Column() {
      Text('我的')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.Blue)
  }
}