import webview from '@ohos.web.webview';

@Entry
@Component
struct WebviewDemo {
  controller: WebviewController = new webview.WebviewController()
  build() {
    Column() {
      Web({
        src: "https://developer.harmonyos.com",
        controller: this.controller
      })
    }
  }
}