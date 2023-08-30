import lottie from '@ohos/lottie'


@Entry
@Component
struct LottieDemo {

  private renderingSettings = new RenderingContextSettings(true)
  private renderingContext = new CanvasRenderingContext2D(this.renderingSettings)
  private PATH_LOTTIE_MANHEAD = "animations/animation_manhead.json"

  aboutToDisappear(): void {
    lottie.destroy();
  }

  onPageShow(): void {
    lottie.play();
  }

  onPageHide(): void {
    lottie.pause();
  }

  loadLottie() {
    lottie.loadAnimation({
      container: this.renderingContext,  // 渲染上下文
      renderer: 'canvas',                          // 渲染方式
      loop: true,                                  // 是否循环播放,默认true
      autoplay: true,                              // 是否自动播放，默认true
      path: this.PATH_LOTTIE_MANHEAD,                             // json路径
    })
  }

  build() {
    Canvas(this.renderingContext)
      .width("100%")
      .height("360vp")
      .backgroundColor(Color.Gray)
      .onReady(() => {
        this.loadLottie()
        lottie.play()
      })
      .onDisAppear(() => {
        lottie.destroy()
      })
  }
}