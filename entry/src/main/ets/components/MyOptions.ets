import { promptAction } from "@kit.ArkUI"

@Component
export struct MyOptions {
  // 用户信息
  @State username: string = '张三'
  @State isLoggedIn: boolean = true
  @State loginTime: string = '' // 存储登录时间

  aboutToAppear() {
    // 组件初始化时，如果有登录状态，设置登录时间
    if (this.isLoggedIn) {
      this.setLoginTime()
    }
  }

  // 设置登录时间的方法
  setLoginTime() {
    const now = new Date()
    const year = now.getFullYear()
    const month = (now.getMonth() + 1).toString().padStart(2, '0')
    const day = now.getDate().toString().padStart(2, '0')
    const hours = now.getHours().toString().padStart(2, '0')
    const minutes = now.getMinutes().toString().padStart(2, '0')
    const seconds = now.getSeconds().toString().padStart(2, '0')

    this.loginTime = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
  }

  build() {
    Column() {
      // 顶部个人信息区域
      Column() {
        // 用户头像
        Image($r('app.media.img_avatar'))
          .width(100)
          .height(100)
          .borderRadius(50)
          .margin({
            top: 120
          })

        // 用户名
        Text(this.username)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .margin({
            top: 20
          })

        // 显示登录时间
        if (this.isLoggedIn && this.loginTime) {
          Text(`登录时间: ${this.loginTime}`)
            .fontSize(14)
            .fontColor('#666666')
            .margin({ top: 8 })
        }
      }
      .width('100%')
      .height('50%')
      .backgroundImage($r('app.media.img_avatar'))
      .backgroundImageSize({
        width: '100%',
        height: '100%'
      })
      .backgroundBlurStyle(BlurStyle.Regular)

      // 底部选项列表区域
      Column({
        space: 10
      }) {
        // 打卡记录选项
        Row() {
          Image($r('app.media.ic_record'))
            .mineImageStyle()
          Text('打卡记录')
            .mineTextStyle()
          Blank()
          Image($r('app.media.ic_go'))
            .mineImageStyle()
        }
        .mineItemStyle()
        .onClick(() => {
          promptAction.showToast({
            message: '打卡记录功能开发中...',
            duration: 2000,
            bottom: 100
          })
        })

        // 检查更新选项
        Row() {
          Image($r('app.media.ic_renew'))
            .mineImageStyle()
          Text('检查更新')
            .mineTextStyle()
          Blank()
          Image($r('app.media.ic_go'))
            .mineImageStyle()
        }
        .mineItemStyle()
        .onClick(() => {
          promptAction.showToast({
            message: '当前已是最新版本',
            duration: 2000,
            bottom: 100
          })
        })

        // 关于选项
        Row() {
          Image($r('app.media.ic_about'))
            .mineImageStyle()
          Text('关于')
            .mineTextStyle()
          Blank()
          Image($r('app.media.ic_go'))
            .mineImageStyle()
        }
        .mineItemStyle()
        .onClick(() => {
          AlertDialog.show({
            title: '关于单词背诵软件',
            message: '单词背诵 v1.0.0\n一个帮助您学习英语单词的应用\n@2025',
            confirm: {
              value: '确定',
              action: () => {
                console.info('点击了确定')
              }
            },
            alignment: DialogAlignment.Center
          })
        })

        Blank()

        // 退出登录按钮
        Row() {
          Button(this.isLoggedIn ? '退出登录' : '登录')
            .width('100%')
            .margin({
              bottom: 150
            })
            .backgroundColor(this.isLoggedIn ? Color.Gray : '#0491d1')
            .onClick(() => {
              if (this.isLoggedIn) {
                // 弹出确认对话框
                AlertDialog.show({
                  title: '温馨提示',
                  message: '退出登录无法打卡，是否退出？',
                  primaryButton: {
                    value: '退出',
                    fontColor: '#ff31313',
                    backgroundColor: '#fff',
                    action: () => {
                      // 退出登录
                      this.isLoggedIn = false
                      this.username = '未登录'
                      this.loginTime = '' // 清空登录时间

                      promptAction.showToast({
                        message: '已退出登录',
                        duration: 2000,
                        bottom: 100
                      })
                    }
                  },secondaryButton: {
                    value: '取消',
                    fontColor: '#1366e3',
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
                // 模拟登录
                this.isLoggedIn = true
                this.username = '张三'
                this.setLoginTime() // 设置登录时间

                promptAction.showToast({
                  message: '登录成功',
                  duration: 2000,
                  bottom: 100
                })
              }

            })
        }

      }
      .width('100%')
      .height('60%')
      .offset({
        y: '-10%'
      })
      .borderRadius({
        topLeft: 50,
        topRight: 50
      })
      .backgroundColor(Color.White)
      .padding({
        top: 30,
        left: 30,
        right: 30
      })

    }
    .width('100%')
    .height('100%')
  }
}

// 使用@Extend扩展组件样式
@Extend(Image) function mineImageStyle() {
  .width(24)
  .height(24)
}

@Extend(Text) function mineTextStyle() {
  .height(24)
  .fontSize(16)
  .fontWeight(FontWeight.Medium)
  .margin({
    left: '20px'
  })
}

@Extend(Row) function mineItemStyle() {
  .width('100%')
  .height(40)
  .padding({
    top: 8,
    bottom: 8
  })
}