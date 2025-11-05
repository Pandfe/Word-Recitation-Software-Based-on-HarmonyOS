import { Answer } from '../components/Answer'
import { MyOptions } from '../components/MyOptions'
import { WordList } from '../components/WordList'

interface WhichWord {
  word: string // 单词
  answers: string[] // 答案选项
  example?: string // 例句（可选）
}

// 单词列表项接口
interface ArrWordsItem {
  img: Resource // 单词图片
  word: string // 单词
  answers: string[] // 答案选项
  example?: string // 例句（可选）
}

@Entry
@Component
struct Index {
  @State currentIndex: number = 0
  @State @Watch('updateAction') whichWord: WhichWord = {
    word: 'water',
    answers: ['火', '土地', '风', '水'],
    example: 'I always carry a bottle of water with me'
  }

  updateAction() {
    console.info('切换到了答题页')
    this.currentIndex = 0
  }

  build() {
    Column() {
      // 主要内容区域 - 占用大部分空间
      Column() {
        if (this.currentIndex == 0) {
          Answer({ whichWord: $whichWord })
            .transition({
              type: TransitionType.All,
              scale: { x: 0, y: 0 }
            })
        } else if (this.currentIndex == 1) {
          WordList({ whichWord: $whichWord })
            .transition({
              type: TransitionType.All,
              scale: { x: 0, y: 0 }
            })
        } else {
          MyOptions()
            .transition({
              type: TransitionType.All,
              scale: { x: 0, y: 0 }
            })
        }
      }
      .width('100%')
      .layoutWeight(1) // 使用权重占据剩余空间

      // 导航栏 - 刚好放在底部
      Row() {
        this.barBuilder(0, '答题', $r('app.media.ic_answer'), $r('app.media.ic_answer_selected'))
        this.barBuilder(1, '列表', $r('app.media.ic_word_list'), $r('app.media.ic_word_list_selected'))
        this.barBuilder(2, '我的', $r('app.media.ic_mine'), $r('app.media.ic_mine_selected'))
      }
      .width('100%')
      .height(72)
      .justifyContent(FlexAlign.SpaceAround)
      .backgroundColor('#FFFFFF')
      .borderRadius({
        topLeft: 24,
        topRight: 24
      })
      .shadow({
        radius: 16,
        color: '#E8E6F2',
        offsetX: 0,
        offsetY: -4 // 阴影向上
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F8F9FA')
  }

  @Builder barBuilder(index: number, title: string, icon: Resource, iconSelected: Resource) {
    Column() {
      Column() {
        Image(this.currentIndex === index ? iconSelected : icon)
          .width(24)
          .height(24)
      }
      .width(48)
      .height(48)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(this.currentIndex === index ? '#667EEA' : '#00000000')
      .borderRadius(16)

      Text(title)
        .fontSize(12)
        .fontColor(this.currentIndex === index ? '#667EEA' : '#9CA3AF')
        .fontWeight(this.currentIndex === index ? FontWeight.Medium : FontWeight.Normal)
        .margin({ top: 4 })
    }
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      animateTo({
        duration: 500,
        curve: Curve.EaseOut
      }, () => {
        this.currentIndex = index
      })
    })
  }
}