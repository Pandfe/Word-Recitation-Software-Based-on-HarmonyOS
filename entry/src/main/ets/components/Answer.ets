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
  @State accuracy: number = 0
  @State progress: number = 0
  @State count: number = 10
  @State time: string = '00:00:00:00'
  @State isStarted: boolean = false
  @State selectedAnswer: string = ''

  build() {
    Column() {
      // 顶部统计信息区域 - 简单优化
      List() {
        // 准确率
        ListItem(){
          Row(){
            this.ListItemLeft($r('app.media.ic_right'), "准确率")
            Blank()
            Text(`${this.accuracy}%`)
              .width(100)
              .textAlign(TextAlign.Center)
              .fontColor('#1F2937') // 深灰色文字
          }
          .width('90%')
        }
        .width('100%')
        .height('25%')

        // 进度
        ListItem(){
          Row(){
            this.ListItemLeft($r('app.media.ic_progress'), "进度")
            Blank()
            Progress({
              value: this.progress,
              total: 100,
              type: ProgressType.Linear
            })
              .width(100)
              .color('#667EEA') // 和谐蓝色
          }
          .width('90%')
        }
        .width('100%')
        .height('25%')

        // 个数
        ListItem(){
          Row(){
            this.ListItemLeft($r('app.media.ic_num'), "个数")
            Blank()
            Button(`${this.count}`)
              .width(100)
              .height(30)
              .fontColor('#1F2937') // 深灰色文字
              .backgroundColor('#F3F4F6') // 浅灰色背景
          }
          .width('90%')
        }
        .width('100%')
        .height('25%')

        // 用时
        ListItem(){
          Row(){
            this.ListItemLeft($r('app.media.ic_time'), "用时")
            Blank()
            Text(this.time) // 移除多余的%符号
              .width(100)
              .textAlign(TextAlign.Center)
              .fontColor('#1F2937') // 深灰色文字
          }
          .width('90%')
        }
        .width('100%')
        .height('25%')
      }
      .width('90%')
      .height(150)
      .borderRadius(10)
      .margin({ top: 40 })
      .backgroundColor(Color.White)
      .shadow({ // 添加柔和阴影
        radius: 4,
        color: '#F3F4F6',
        offsetX: 0,
        offsetY: 2
      })

      // 单词展示区域 - 简单优化
      Column() {
        Text(this.whichWord.word)
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
          .fontColor('#1F2937') // 深灰色文字

        if (this.whichWord.example) {
          Text(this.whichWord.example)
            .fontColor('#6B7280') // 浅灰色文字
            .margin({ top: 15 })
            .textAlign(TextAlign.Center)
        }
      }
      .width('90%')
      .margin({ top: 40 })

      // 选项按钮区域 - 简单优化
      Column({ space: 10 }) {
        ForEach(this.whichWord.answers, (item: string, index: number) => {
          Button(item)
            .type(ButtonType.Normal)
            .width('100%')
            .borderRadius(10)
            .fontColor(this.selectedAnswer === item ? Color.White : '#1F2937') // 深灰色文字
            .backgroundColor(this.selectedAnswer === item ? '#667EEA' : Color.White) // 和谐蓝色
            .onClick(() => {
              if (this.isStarted) {
                this.selectedAnswer = item
                if (item === this.whichWord.answers[0]) {
                  this.accuracy = Math.min(100, this.accuracy + 10)
                  this.progress = Math.min(100, this.progress + 10)
                  promptAction.showToast({
                    message: '回答正确！',
                    duration: 2000,
                    bottom: 100
                  })
                } else {
                  promptAction.showToast({
                    message: '回答错误，请再试一次',
                    duration: 2000,
                    bottom: 100
                  })
                }
              } else {
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
      .margin({ top: 40 })

      // 底部操作按钮 - 简单优化
      Row() {
        Button('结束测试')
          .borderWidth(1)
          .borderColor('#D1D5DB') // 和谐灰色
          .fontColor('#6B7280') // 和谐灰色
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            if (this.isStarted) {
              AlertDialog.show({
                title: '温馨提示',
                message: '结束测试无法记录打卡，是否结束？',
                primaryButton: {
                  value: '结束',
                  fontColor: '#EF4444', // 和谐红色
                  backgroundColor: '#fff',
                  action: () => {
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
                  fontColor: '#667EEA', // 和谐蓝色
                  backgroundColor: '#fff',
                  action: () => {}
                },
                alignment: DialogAlignment.Center,
                offset: { dx: 0, dy: -20 }
              })
            } else {
              promptAction.showToast({
                message: '测试尚未开始',
                duration: 2000,
                bottom: 100
              })
            }
          })

        Button(this.isStarted ? '继续测试' : '开始测试')
          .backgroundColor('#667EEA') // 和谐蓝色
          .fontColor(Color.White)
          .onClick(() => {
            if (!this.isStarted) {
              this.isStarted = true
              this.selectedAnswer = ''
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
        top: 40,
        bottom: 80  // 增加底部边距，确保不被导航栏遮挡
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
        .padding({ left: 5 })
        .fontColor('#6B7280') // 浅灰色文字
    }
  }
}