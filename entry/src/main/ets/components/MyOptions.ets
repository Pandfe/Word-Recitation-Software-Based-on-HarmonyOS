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
        // 用户头像 - 添加圆角和边框
        Image($r('app.media.img_avatar'))
          .width(100)
          .height(100)
          .borderRadius(50)
          .border({ width: 3, color: '#5D8AA8' })
          .margin({ top: 120 })

        // 用户名
        Text(this.username)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#2C3E50') // 改为深灰色
          .margin({ top: 20 })

        // 显示登录时间
        if (this.isLoggedIn && this.loginTime) {
          Text(`登录时间: ${this.loginTime}`)
            .fontSize(14)
            .fontColor('#7F8C8D') // 改为浅灰色
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

      // 底部选项列表区域 - 轻微优化
      Column({
        space: 12 // 稍微增加间距
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
        .backgroundColor('#FFFFFF') // 添加白色背景
        .borderRadius(12) // 添加圆角
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
        .backgroundColor('#FFFFFF') // 添加白色背景
        .borderRadius(12) // 添加圆角
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
        .backgroundColor('#FFFFFF') // 添加白色背景
        .borderRadius(12) // 添加圆角
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

        // 退出登录按钮 - 优化样式
        Row() {
          Button(this.isLoggedIn ? '退出登录' : '登录')
            .width('100%')
            .height(44) // 固定高度
            .margin({
              bottom: 150
            })
            .backgroundColor(this.isLoggedIn ? '#95a5a6' : '#5D8AA8') // 使用和谐的颜色
            .fontColor(Color.White)
            .borderRadius(22) // 圆角按钮
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .onClick(() => {
              if (this.isLoggedIn) {
                // 弹出确认对话框
                AlertDialog.show({
                  title: '温馨提示',
                  message: '退出登录无法打卡，是否退出？',
                  primaryButton: {
                    value: '退出',
                    fontColor: '#e74c3c', // 使用红色
                    backgroundColor: '#fff',
                    action: () => {
                      // 退出登录
                      this.isLoggedIn = false
                      this.username = '未登录'
                      this.loginTime = ''

                      promptAction.showToast({
                        message: '已退出登录',
                        duration: 2000,
                        bottom: 100
                      })
                    }
                  },secondaryButton: {
                    value: '取消',
                    fontColor: '#5D8AA8', // 使用主色调
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
                this.setLoginTime()
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
        topLeft: 30, // 增加圆角
        topRight: 30
      })
      .backgroundColor('#F8F9FA') // 改为浅灰色背景
      .padding({
        top: 30,
        left: 20, // 调整内边距
        right: 20
      })

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F8F9FA') // 整体背景色
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
  .height(50) // 增加高度
  .padding({
    top: 8,
    bottom: 8,
    left: 16, // 增加左右内边距
    right: 16
  })
}