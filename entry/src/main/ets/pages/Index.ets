import router from '@ohos.router';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)


        Button('Webview', { type: ButtonType.Normal, stateEffect: true})
          .margin({top: 20})
          .onClick(() => {
            router.pushUrl({ url: "pages/WebviewDemo"})
          })

        Button('HttpRequest', { type: ButtonType.Capsule, stateEffect: true})
          .margin({top: 20})
          .onClick(() => {
            router.pushUrl({ url: 'pages/HttpRequestDemo'})
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}