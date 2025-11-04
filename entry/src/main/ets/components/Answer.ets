@Component
export struct Answer {
  build() {
    Column() {
      Text('答题')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.Red)
  }
}