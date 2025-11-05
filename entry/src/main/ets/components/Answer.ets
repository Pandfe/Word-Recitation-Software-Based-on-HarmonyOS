import { promptAction } from "@kit.ArkUI"

interface WhichWord {
  word: string // 单词
  answers: string[] // 答案选项
  example?: string // 例句（可选）
}

// 单词列表项接口
interface ArrWordsItem {
  img: Resource
  word: string
  answers: string[]
  example?: string
}

@Component
export struct Answer {
  // 使用@Link接收父组件传递的数据
  @Link whichWord: WhichWord

  // 状态变量
  @State accuracy: number = 0
  @State progress: number = 0
  @State count: number = 10
  @State time: string = '00:00:00'
  @State isStarted: boolean = false
  @State selectedAnswer: string = ''
  @State timerId: number = 0
  @State elapsedSeconds: number = 0
  @State answeredCount: number = 0
  @State correctCount: number = 0
  @State totalQuestions: number = 10

  // 从WordList获取的单词列表
  @State wordList: WhichWord[] = [
    {
      word: "run | running | runs",
      answers: ["跑", "不跑", "慢跑", "快跑"],
      example: "I like to run in the morning."
    },
    {
      word: "bike | bikes",
      answers: ["单车", "自行车", "车", "跑车"],
      example: "I ride my bike to school every day."
    },
    {
      word: "car | cars",
      answers: ["汽车", "小汽车", "轿车", "摩托车"],
      example: "My father bought a new car last week."
    },
    {
      word: "aircraft",
      answers: ["飞机", "客机", "飞船", "小飞机"],
      example: "The aircraft took off on time."
    },
    {
      word: "ship",
      answers: ["船", "小船", "大船", "轮船"],
      example: "The ship sailed across the ocean."
    },
    {
      word: "football",
      answers: ["球", "球球", "地球", "足球"],
      example: "We played football in the park."
    },
    {
      word: "badminton",
      answers: ["棒球", "地球", "月球", "羽毛球"],
      example: "Badminton is my favorite sport."
    }
  ]

  @State currentWordIndex: number = 0

  aboutToDisappear() {
    // 组件销毁时清除定时器
    if (this.timerId) {
      clearInterval(this.timerId)
    }
  }

  // 格式化时间
  formatTime(seconds: number): string {
    const hrs = Math.floor(seconds / 3600).toString().padStart(2, '0')
    const mins = Math.floor((seconds % 3600) / 60).toString().padStart(2, '0')
    const secs = (seconds % 60).toString().padStart(2, '0')
    return `${hrs}:${mins}:${secs}`
  }

  // 开始计时器
  startTimer() {
    this.elapsedSeconds = 0
    this.time = this.formatTime(0)

    this.timerId = setInterval(() => {
      this.elapsedSeconds++
      this.time = this.formatTime(this.elapsedSeconds)
    }, 1000)
  }

  // 停止计时器
  stopTimer() {
    if (this.timerId) {
      clearInterval(this.timerId)
      this.timerId = 0
    }
  }

  // 获取下一个单词
  getNextWord() {
    if (this.currentWordIndex < this.wordList.length - 1) {
      this.currentWordIndex++
      this.whichWord = this.wordList[this.currentWordIndex]
      this.selectedAnswer = ''
    } else {
      // 已经到达最后一个单词
      this.endTest()
    }
  }

  // 处理答案选择
  handleAnswerSelect(item: string) {
    if (!this.isStarted) {
      promptAction.showToast({
        message: '请先点击"开始测试"按钮',
        duration: 2000,
        bottom: 100
      })
      return
    }

    this.selectedAnswer = item
    this.answeredCount++

    // 判断答案是否正确（假设第四个选项是正确答案）
    const isCorrect = item === this.whichWord.answers[3]

    if (isCorrect) {
      this.correctCount++
    }

    // 计算准确率
    this.accuracy = Math.round((this.correctCount / this.answeredCount) * 100)

    // 计算进度
    this.progress = Math.round((this.answeredCount / this.totalQuestions) * 100)

    // 显示反馈
    promptAction.showToast({
      message: isCorrect ? '回答正确！' : '回答错误，请再试一次',
      duration: 2000,
      bottom: 100
    })

    // 延迟一秒后自动切换到下一题
    setTimeout(() => {
      if (this.answeredCount < this.totalQuestions) {
        this.getNextWord()
      } else {
        this.endTest()
      }
    }, 1000)
  }

  // 开始测试
  startTest() {
    if (!this.isStarted) {
      this.isStarted = true
      this.selectedAnswer = ''
      this.accuracy = 0
      this.progress = 0
      this.answeredCount = 0
      this.correctCount = 0
      this.currentWordIndex = 0
      this.whichWord = this.wordList[0]
      this.startTimer()

      promptAction.showToast({
        message: '测试开始，请选择答案',
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
  }

  // 结束测试
  endTest() {
    if (this.isStarted) {
      this.stopTimer()
      AlertDialog.show({
        title: '测试完成',
        message: `测试完成！\n准确率: ${this.accuracy}%\n用时: ${this.time}\n答对题数: ${this.correctCount}/${this.totalQuestions}`,
        primaryButton: {
          value: '确定',
          fontColor: '#667EEA',
          backgroundColor: '#FFFFFF',
          action: () => {
            this.resetTest()
          }
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
  }

  // 重置测试
  resetTest() {
    this.isStarted = false
    this.selectedAnswer = ''
    this.accuracy = 0
    this.progress = 0
    this.answeredCount = 0
    this.correctCount = 0
    this.currentWordIndex = 0
    this.stopTimer()
    this.time = '00:00:00'
    this.elapsedSeconds = 0
    this.whichWord = this.wordList[0]
  }

  build() {
    Column() {
      // 顶部统计信息区域
      List() {
        // 准确率
        ListItem(){
          Row(){
            this.ListItemLeft($r('app.media.ic_right'), "准确率")
            Blank()
            Text(`${this.accuracy}%`)
              .width(100)
              .textAlign(TextAlign.Center)
              .fontColor('#1F2937')
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
              .color('#667EEA')
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
            Button(`${this.answeredCount}/${this.totalQuestions}`)
              .width(100)
              .height(30)
              .fontColor('#1F2937')
              .backgroundColor('#F3F4F6')
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
            Text(this.time)
              .width(100)
              .textAlign(TextAlign.Center)
              .fontColor('#1F2937')
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
      .shadow({
        radius: 4,
        color: '#F3F4F6',
        offsetX: 0,
        offsetY: 2
      })

      // 单词展示区域
      Column() {
        Text(this.whichWord.word)
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
          .fontColor('#1F2937')

        if (this.whichWord.example) {
          Text(this.whichWord.example)
            .fontColor('#6B7280')
            .margin({ top: 15 })
            .textAlign(TextAlign.Center)
        }
      }
      .width('90%')
      .margin({ top: 40 })

      // 选项按钮区域
      Column({ space: 10 }) {
        ForEach(this.whichWord.answers, (item: string, index: number) => {
          Button(item)
            .type(ButtonType.Normal)
            .width('100%')
            .borderRadius(10)
            .fontColor(this.selectedAnswer === item ? Color.White : '#1F2937')
            .backgroundColor(this.selectedAnswer === item ? '#667EEA' : Color.White)
            .onClick(() => {
              this.handleAnswerSelect(item)
            })
        })
      }
      .width('70%')
      .margin({ top: 40 })

      // 底部操作按钮
      Row() {
        Button('结束测试')
          .borderWidth(1)
          .borderColor('#D1D5DB')
          .fontColor('#6B7280')
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            if (this.isStarted) {
              AlertDialog.show({
                title: '温馨提示',
                message: '结束测试无法记录打卡，是否结束？',
                primaryButton: {
                  value: '结束',
                  fontColor: '#EF4444',
                  backgroundColor: '#FFFFFF',
                  action: () => {
                    this.resetTest()
                    promptAction.showToast({
                      message: '已结束测试',
                      duration: 2000,
                      bottom: 100
                    })
                  }
                },
                secondaryButton: {
                  value: '取消',
                  fontColor: '#667EEA',
                  backgroundColor: '#FFFFFF',
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
          .backgroundColor('#667EEA')
          .fontColor(Color.White)
          .onClick(() => {
            this.startTest()
          })
      }
      .width('80%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({
        top: 40,
        bottom: 80
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
        .fontColor('#6B7280')
    }
  }
}