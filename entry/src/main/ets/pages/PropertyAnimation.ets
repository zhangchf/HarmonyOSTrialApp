
interface AnimateIcon {
  imgRes: Resource,
  delay: number
}

@Entry
@Component
struct PropertyAnimation {
  private animateIcons: AnimateIcon[] = [
    {
      imgRes: $r('app.media.ic_loading_game'),
      delay: 400
    },
    {
      imgRes: $r('app.media.ic_loading_heart'),
      delay: 800
    },
    {
      imgRes: $r('app.media.ic_loading_louder'),
      delay: 1200
    },
    {
      imgRes: $r('app.media.ic_loading_bag'),
      delay: 1600
    },
    {
      imgRes: $r('app.media.ic_loading_file'),
      delay: 2000
    }
  ]

  private animateIconsArray = [
    $r('app.media.ic_loading_game'),
    $r('app.media.ic_loading_heart'),
    $r('app.media.ic_loading_louder'),
    $r('app.media.ic_loading_bag'),
    $r('app.media.ic_loading_file'),
  ]

  @State iconWidth: number = 30

  @Builder
  AnimatedIcon(iconRes: Resource, delay: number) {
    Image(iconRes)
      .width(`${this.iconWidth}vp`)
      .aspectRatio(1)
      .objectFit(ImageFit.Contain)
      .animation({
        duration: 2000,
        tempo: 3,
        delay: delay,
        curve: Curve.Linear,
        playMode: PlayMode.Alternate,
        iterations: -1
      })
      .onAppear(() => {
        this.iconWidth = 50
      })

  }

  build() {
    Row() {
      // ForEach(this.animateIcons, (item, index) => {
      //   this.AnimatedIcon(item.imgRes, 400*index)
      // }, (item) => JSON.stringify(item))

      ForEach(this.animateIconsArray, (item: Resource, index) => {
        this.AnimatedIcon(item, 400*index)
      }, (item: Resource) => item.id.toString())
    }
    .width("100%")
    .height("100vp")
    .backgroundColor(Color.Gray)
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}