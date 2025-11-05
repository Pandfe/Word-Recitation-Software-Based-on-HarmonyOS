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
  // 当前选中的导航索引
  @State currentIndex: number = 0

  // 当前单词数据，使用@Watch监听变化
  @State @Watch('updateAction') whichWord: WhichWord = {
    word: 'water',
    answers: ['火', '土地', '风', '水'],
    example: 'I always carry a bottle of water with me'
  }

  // 当whichWord变化时重置currentIndex为0（切换到答题页）
  updateAction() {
    console.info('切换到了答题页')
    this.currentIndex = 0
  }



  build() {
    Column() {
      // 使用Stack布局，底部放置导航栏
      Stack({ alignContent: Alignment.Bottom }) {
        // 页面内容区域
        if (this.currentIndex == 0) {
          Answer({ whichWord: $whichWord })
            .transition({
              type: TransitionType.All,
              scale: {
                x: 0,
                y: 0
              }
            })


        } else if (this.currentIndex == 1) {
          WordList({ whichWord: $whichWord })
            .transition({
              type: TransitionType.All,
              scale: {
                x: 0,
                y: 0
              }
            })
        } else {
          MyOptions()
            .transition({
              type: TransitionType.All,
              scale: {
                x: 0,
                y: 0
              }
            })
        }

        Row(){
          this.barBuilder(0, '答题', $r('app.media.ic_answer'), $r('app.media.ic_answer_selected'))
          this.barBuilder(1, '列表', $r('app.media.ic_word_list'), $r('app.media.ic_word_list_selected'))
          this.barBuilder(2, '我的', $r('app.media.ic_mine'), $r('app.media.ic_mine_selected'))
        }
        .width('100%')
        .height(60)
        .justifyContent(FlexAlign.SpaceAround)
        .backgroundColor(Color.White)

      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  // 构建导航栏按钮
  @Builder barBuilder(index: number, title: string, icon: Resource, iconSelected: Resource) {
    Column() {
      // 导航图标
      Image(this.currentIndex === index ? iconSelected : icon)
        .width(25)
        .height(25)
      // 导航标题
      Text(title)
        .fontColor(this.currentIndex === index ? '#0401d1' : '#8a8a8a')
        .fontWeight(FontWeight.Medium)
    }
    .onClick(() => {
      // 点击时添加动画效果
      animateTo({
        duration: 2000
      }, () => {
        this.currentIndex = index
      })
    })
  }

}