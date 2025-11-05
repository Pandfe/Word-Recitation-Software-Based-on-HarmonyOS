import { promptAction } from "@kit.ArkUI"


interface WhichWord {
  word: string // 单词
  answers: string[] // 答案选项
  example?: string // 例句（可选）
}

@Component
export struct Answer {
  // 使用@Link接收父组件传递的数据
  @Link whichWord: WhichWord

  // 状态变量
  // 准确率
  @State accuracy: number = 0
  // 速度
  @State progress: number = 0
  // 单词个数
  @State count: number = 10
  // 用时
  @State time: string = '00:00:00:00'
  // 是否开始测试
  @State isStarted: boolean = false
  // 选中的答案
  @State selectedAnswer: string = ''

  build() {
    Column() {
      // 顶部统计信息区域
      List() {
        // 准确率
        ListItem(){
          Row(){
            // 左侧
            this.ListItemLeft($r('app.media.ic_right'), "准确率")
            Blank()

            // 右侧
            Text(`${this.accuracy}%`)
              .width(100)
              .textAlign(TextAlign.Center)

          }
          .width('90%')
        }
        .width('100%')
        .height('25%')

        // 进度
        ListItem(){
          Row(){
            // 左侧
            this.ListItemLeft($r('app.media.ic_progress'), "进度")
            Blank()

            // 右侧
            Progress({
              value: this.progress,
              total: 100,
              type: ProgressType.Linear
            })
              .width(100)
          }
          .width('90%')
        }
        .width('100%')
        .height('25%')

        // 个数
        ListItem(){
          Row(){
            // 左侧
            this.ListItemLeft($r('app.media.ic_num'), "个数")
            Blank()

            // 右侧
            Button(`${this.count}`)
              .width(100)
              .height(30)
              .fontColor('#000')
              .backgroundColor('#EBEBEB')

          }
          .width('90%')
        }
        .width('100%')
        .height('25%')

        // 用时
        ListItem(){
          Row(){
            // 左侧
            this.ListItemLeft($r('app.media.ic_time'), "用时")
            Blank()

            // 右侧
            Text(`${this.time}%`)
              .width(100)
              .textAlign(TextAlign.Center)

          }
          .width('90%')
        }
        .width('100%')
        .height('25%')

      }
      .width('90%')
      .height(150)
      .borderRadius(10)
      .margin({
        top: 40
      })
      .backgroundColor(Color.White)

      // 单词展示区域
      Column() {
        // 单词
        Text(this.whichWord.word)
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)

        // 例句
        if (this.whichWord.example) {
          Text(this.whichWord.example)
            .fontColor(Color.Gray)
            .margin({
              top: 15
            })
            .textAlign(TextAlign.Center)
        }
      }
      .width('90%')
      .margin({
        top: 40
      })

      // 选项按钮区域
      Column({
        space: 10
      }) {
        // 使用ForEach循环渲染选项按钮
        ForEach(this.whichWord.answers, (item: string, index: number) => {
          Button(item)
            .type(ButtonType.Normal)
            .width('100%')
            .borderRadius(10)
            .fontColor(this.selectedAnswer === item ? Color.White : Color.Black)
            .backgroundColor(this.selectedAnswer === item ? '#0491d1' : Color.White)
            .onClick(() => {
              if (this.isStarted) {
                this.selectedAnswer = item
                // 判断答案是否正确
                if (item === this.whichWord.answers[0]) {
                  // 正确答案通常是数组的第一个元素
                  this.accuracy = Math.min(100, this.accuracy + 10)
                  this.progress = Math.min(100, this.progress + 10)

                  promptAction.showToast({
                    message: '回答正确！',
                    duration: 2000,
                    bottom: 100
                  })
                } else{
                  promptAction.showToast({
                    message: '回答错误，请再试一次',
                    duration: 2000,
                    bottom: 100
                  })
                }
              } else{
                promptAction.showToast({
                  message: '请先点击"开始测试"按钮',
                  duration: 2000,
                  bottom: 100
                })
              }
            })
        })
      }
      .width('70%')
      .margin({
        top: 40
      })

      // 底部操作按钮
      Row(){
        // 结束测试按钮
        Button('结束测试')
          .borderWidth(1)
          .borderColor(Color.Gray)
          .fontColor(Color.Gray)
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            if (this.isStarted) {
              // 弹出确认对话框
              AlertDialog.show({
                title: '温馨提示',
                message: '结束测试无法记录打卡，是否结束？',
                primaryButton: {
                  value: '结束',
                  fontColor: '#ffe31313',
                  backgroundColor: '#fff',
                  action: () => {
                    // 重置状态
                    this.isStarted = false
                    this.selectedAnswer = ''
                    this.accuracy = 0
                    this.progress = 0
                    this.time = '00:00:00:00'

                    promptAction.showToast({
                      message: '已结束测试',
                      duration: 2000,
                      bottom: 100
                    })
                  }
                },
                secondaryButton: {
                  value: '取消',
                  fontColor: '#ff1366e3',
                  backgroundColor: '#fff',
                  action: () => {
                    // 取消操作，不做任何处理
                  }
                },
                alignment: DialogAlignment.Center,
                offset: {
                  dx: 0,
                  dy: -20
                }
              })
            } else {
              promptAction.showToast({
                message: '测试尚未开始',
                duration: 2000,
                bottom: 100
              })
            }
          })

        // 开始测试按钮
        Button(this.isStarted ? '继续测试' : '开始测试')
          .backgroundColor(Color.Black)
          .onClick(() => {
            if (!this.isStarted) {
              this.isStarted = true
              this.selectedAnswer = ''

              // 启动计时器（实际项目中可以使用定时器更新时间）
              // 这里简单模拟
              this.time = '00:00:00:01'

              promptAction.showToast({
                message: '请选择答案',
                duration: 2000,
                bottom: 100
              })
            } else {
              promptAction.showToast({
                message: '测试已开始，请选择答案',
                duration: 2000,
                bottom: 100
              })
            }
          })
      }
      .width('80%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({
        top: 40
      })
    }
    .width('100%')
    .height('100%')
    .linearGradient({
      direction: GradientDirection.RightBottom,
      colors: [[0xD9FDD5, 0.0], [0xE9F8F2, 1.0]]
    })
  }

  // 列表项左侧构建器
  @Builder ListItemLeft(icon: Resource, title: string) {
    Row() {
      Image(icon)
        .width(20)
        .height(20)
      Text(title)
        .padding({
          left: 5
        })
    }
  }

}