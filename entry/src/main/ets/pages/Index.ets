import router from '@ohos.router';
import resourceManager from '@ohos.resourceManager';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'

  onPageShow() {
    console.log('zcf Index: onPageShow')
    myAsyncFunction().then((result) => {
      console.log(`zcf: ${result}`)
    })
  }

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

        Button('PullToRefresh, extra top view', { type: ButtonType.Capsule, stateEffect: true})
          .margin({top: 20})
          .onClick(() => {
            router.pushUrl({ url: 'pages/PullToRefreshDemo'})
          })

        Button('PullToRefresh, top list item', { type: ButtonType.Capsule, stateEffect: true})
          .margin({top: 20})
          .onClick(() => {
            router.pushUrl({ url: 'pages/PullToRefreshDemo2'})
          })

        Button('Refresh Container', { type: ButtonType.Capsule, stateEffect: true})
          .margin({top: 20})
          .onClick(() => {
            router.pushUrl({ url: 'pages/RefreshContainer'})
          })

        Button('RefreshList Test', { type: ButtonType.Capsule, stateEffect: true})
          .margin({top: 20})
          .onClick(() => {
            router.pushUrl({ url: 'pages/RefreshListTest'})
          })

        Button('Lottie Animation', { type: ButtonType.Capsule, stateEffect: true})
          .margin({top: 20})
          .onClick(() => {
            router.pushUrl({ url: 'pages/LottieDemo'})
          })

        Button('Property Animation', { type: ButtonType.Capsule, stateEffect: true})
          .margin({top: 20})
          .onClick(() => {
            router.pushUrl({ url: 'pages/PropertyAnimation'})
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}

async function myAsyncFunction() {
  const result = await new Promise((resolve: (value: string) => void) => {
    setTimeout(() => {
      resolve('zcf Hello, world!');
    }, 3000);
  });
  console.info(String(result)); // 输出： Hello, world!
  return new Promise((resolve : (number: number) => void, reject : (reason: string) => void) => {
    resolve(1000)
  })
}