@Entry
@Component
struct PullToRefreshDemo {
  @State data: number[] = Array.from(Array(20).keys())
  private pullRefreshHeight = 70
  @State pullViewOffsetY: number = 0
  @State listOffsetY: number = this.pullViewOffsetY

  @State isPullRefreshViewVisible: boolean = false

  private scroller = new Scroller()
  private currentOffsetY = 0

  build() {
    Column() {
      Row() {
        Text("Pull down to refresh")
      }
      .width("100%")
      .height(this.pullRefreshHeight)
      .backgroundColor(Color.Green)
      .justifyContent(FlexAlign.Center)
      .visibility(this.isPullRefreshViewVisible ? Visibility.Visible : Visibility.None)
      .offset({ x: 0, y: this.pullViewOffsetY})

      // Divider()

      List({scroller: this.scroller}) {
        ForEach(this.data, (item) => {
          ListItem() {
            Text(`Item ${item}`)
          }
          .height(50)
          .width("100%")
          .backgroundColor(Color.Orange)
        }, (item) => item)
      }
      .divider({strokeWidth: 1})
      .onScroll((scrollOffset, _) => {
        this.currentOffsetY = this.scroller.currentOffset().yOffset
        this.pullViewOffsetY = -this.currentOffsetY
        console.log(`zcf currentOffset: ${this.currentOffsetY}, pullViewOffset: ${this.pullViewOffsetY}`)
      })

    }
    .width("100%")
    .height("100%")
    .offset({x: 0, y: -this.pullRefreshHeight})
    .onTouch((event) => this.handleTouchEvent(event))

  }

  private downY: number = undefined
  private isRefreshing = false

  handleTouchEvent(event: TouchEvent) {
    switch (event.type) {
      case TouchType.Down:
        this.downY = event.touches[0].y
        break
      case TouchType.Move:
        if (this.currentOffsetY < 0 || (this.isPullRefreshViewVisible && this.pullViewOffsetY > -this.pullRefreshHeight)) {
          this.isPullRefreshViewVisible = true
          let moveY = px2vp(event.touches[0].y - this.downY)
          this.pullViewOffsetY = moveY - this.pullRefreshHeight
          this.listOffsetY = this.pullViewOffsetY
        } else {
          this.isPullRefreshViewVisible = false
          this.pullViewOffsetY = 0
          this.listOffsetY = 0
        }
        break
      case TouchType.Up:
      case TouchType.Cancel:
        break

    }
  }
}