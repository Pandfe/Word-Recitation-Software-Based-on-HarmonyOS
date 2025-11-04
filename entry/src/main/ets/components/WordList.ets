// 单词列表项接口
interface ArrWordsItem {
  img: Resource
  word: string
  answers: string[]
  example?: string
}

interface WhichWord {
  word: string // 单词
  answers: string[] // 答案选项
  example?: string // 例句（可选）
}



@Component
export struct WordList {

  // 单词数组
  @State arrWords: ArrWordsItem[] = [
    {
      img: $r('app.media.img_run'),
      word: "run | running | runs",
      answers: ["跑", "不跑", "慢跑", "快跑"],
      example: "I like to run in the morning."
    },
    {
      img: $r('app.media.img_bike'),
      word: "bike | bikes",
      answers: ["单车", "自行车", "车", "跑车"],
      example: "I ride my bike to school every day."
    },
    {
      img: $r('app.media.img_car'),
      word: "car | cars",
      answers: ["汽车", "小汽车", "轿车", "摩托车"],
      example: "My father bought a new car last week."
    },
    {
      img: $r('app.media.img_aircraft'),
      word: "aircraft",
      answers: ["飞机", "客机", "飞船", "小飞机"],
      example: "The aircraft took off on time."
    },
    {
      img: $r('app.media.img_ship'),
      word: "ship",
      answers: ["船", "小船", "大船", "轮船"],
      example: "The ship sailed across the ocean."
    },
    {
      img: $r('app.media.img_football'),
      word: "football",
      answers: ["球", "球球", "地球", "足球"],
      example: "We played football in the park."
    },
    {
      img: $r('app.media.img_badminton'),
      word: "badminton",
      answers: ["棒球", "地球", "月球", "羽毛球"],
      example: "Badminton is my favorite sport."
    }
  ]

  // 使用@Link接父组件传来的数据
  @Link whichWord: WhichWord

  build() {
    Column() {
      // 使用滚动布局
      Scroll() {
        // 使用弹性布局
        Flex({
          wrap: FlexWrap.Wrap
        }) {
          // 循环渲染单词卡片
          ForEach(this.arrWords, (item: ArrWordsItem) => {
            Column() {
              // 单词图片
              Image(item.img)
                .width(120)
                .height(120)
                .objectFit(ImageFit.Contain)
                .borderRadius({
                  topLeft: 5,
                  topRight: 5
                })
              // 单词文本
              Text(item.word)
                .height(60)
                .fontSize(14)
                .fontWeight(600)
                .textAlign(TextAlign.Center)
                .lineHeight(22)
                .padding({
                  left: 10,
                  right: 10
                })
              // 底部操作区
              Row(){
                // 分享按钮
                Row({
                  space: 5
                }) {
                  Image($r('app.media.ic_share'))
                    .width(16)
                    .borderRadius(8)
                  Text('分享')
                    .fontSize(10)
                    .fontColor('#999')
                }
                .layoutWeight(1)
                // 打卡按钮
                Row({
                  space: 5
                }) {
                  Image($r('app.media.ic_do'))
                    .width(16)
                    .borderRadius(8)
                  Text('打卡')
                    .fontSize(10)
                    .fontColor('#999')
                }
              }
              .padding({
                left: 15,
                right: 15
              })
            }
            .width('45%')
            .height(220)
            .padding({
              bottom: 15
            })
            .backgroundColor(Color.White)
            .borderRadius(5)
            .margin('2.5%')
            .onClick(() => {
              console.info(`[WordCheckIn] Selected word: ${item.word}`)
              this.whichWord = {
                word: item.word,
                answers: item.answers,
                example: item.example
              }
            })

          })
        }
        .width('100%')
      }
      .scrollable(ScrollDirection.Vertical)
    }
    .width('100%')
    .height('100%')
    .padding(10)
    .backgroundImage($r('app.media.img_bg'))
    .backgroundImageSize({
      width: '100%',
      height: '100%'
    })
  }
}