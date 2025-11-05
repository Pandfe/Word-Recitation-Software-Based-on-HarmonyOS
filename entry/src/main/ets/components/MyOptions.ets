import { promptAction } from "@kit.ArkUI"

@Component
export struct MyOptions {
  // 用户信息
  @State username: string = '张三'
  @State isLoggedIn: boolean = true
  @State loginTime: string = ''

  aboutToAppear() {
    if (this.isLoggedIn) {
      this.setLoginTime()
    }
  }

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
      // 顶部个人信息区域 - 轻微优化
      Column() {
        // 用户头像 - 和谐美学调整
        Image($r('app.media.img_avatar'))
          .width(80)
          .height(80)
          .borderRadius(40)
          .border({ width: 3, color: '#667EEA' }) // 改为和谐蓝色
          .margin({ top: 40 })

        // 用户名
        Text(this.username)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2937') // 深灰色
          .margin({ top: 16 })

        // 显示登录时间
        if (this.isLoggedIn && this.loginTime) {
          Text(`登录时间: ${this.loginTime}`)
            .fontSize(12)
            .fontColor('#6B7280') // 浅灰色
            .margin({ top: 8 })
            .padding(8)
            .backgroundColor('#F3F4F6') // 添加浅灰背景
            .borderRadius(8)
        }
      }
      .width('100%')
      .height('40%')
      .backgroundImage($r('app.media.img_avatar'))
      .backgroundImageSize({
        width: '100%',
        height: '100%'
      })
      .backgroundBlurStyle(BlurStyle.Thin) // 改为更细的模糊

      // 底部选项列表区域 - 和谐美学调整
      Column({
        space: 12
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
            duration: 2000
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
            duration: 2000
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
              fontColor: '#667EEA', // 改为和谐蓝色
              action: () => {
                console.info('点击了确定')
              }
            },
            alignment: DialogAlignment.Center
          })
        })

        Blank()

        // 退出登录按钮 - 和谐美学调整
        Row() {
          Button(this.isLoggedIn ? '退出登录' : '登录')
            .width('100%')
            .height(48)
            .backgroundColor(this.isLoggedIn ? '#FEF2F2' : '#667EEA') // 和谐配色
            .fontColor(this.isLoggedIn ? '#EF4444' : '#FFFFFF')
            .borderRadius(24)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .shadow({
              radius: 8,
              color: this.isLoggedIn ? '#FECACA' : '#C3DAFE',
              offsetX: 0,
              offsetY: 2
            })
            .onClick(() => {
              if (this.isLoggedIn) {
                AlertDialog.show({
                  title: '温馨提示',
                  message: '退出登录无法打卡，是否退出？',
                  primaryButton: {
                    value: '退出',
                    fontColor: '#EF4444', // 和谐红色
                    backgroundColor: '#FFFFFF',
                    action: () => {
                      this.isLoggedIn = false
                      this.username = '未登录'
                      this.loginTime = ''

                      promptAction.showToast({
                        message: '已退出登录',
                        duration: 2000
                      })
                    }
                  },
                  secondaryButton: {
                    value: '取消',
                    fontColor: '#667EEA', // 和谐蓝色
                    backgroundColor: '#FFFFFF',
                    action: () => {}
                  },
                  alignment: DialogAlignment.Center,
                  offset: { dx: 0, dy: -20 }
                })
              } else {
                this.isLoggedIn = true
                this.username = '张三'
                this.setLoginTime()
                promptAction.showToast({
                  message: '登录成功',
                  duration: 2000
                })
              }
            })
        }
        .width('100%')
        .padding(16)
      }
      .width('100%')
      .height('60%')
      .offset({ y: '-10%' })
      .borderRadius({
        topLeft: 24,
        topRight: 24
      })
      .backgroundColor('#F8F9FA')
      .padding({
        top: 24,
        left: 20,
        right: 20
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F8F9FA')
  }
}

// 使用@Extend扩展组件样式 - 和谐美学调整
@Extend(Image) function mineImageStyle() {
  .width(24)
  .height(24)
}

@Extend(Text) function mineTextStyle() {
  .height(24)
  .fontSize(16)
  .fontWeight(FontWeight.Medium)
  .fontColor('#1F2937') // 深灰色
  .margin({ left: 16 })
}

@Extend(Row) function mineItemStyle() {
  .width('100%')
  .height(56)
  .padding(16)
  .backgroundColor('#FFFFFF')
  .borderRadius(16)
  .shadow({
    radius: 8,
    color: '#F3F4F6',
    offsetX: 0,
    offsetY: 2
  })
}