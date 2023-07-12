import http from '@ohos.net.http';
import { requestWebData } from '../web/WebRequest';

@Entry
@Component
struct HttpRequestDemo {
  @State result: string = "Loading..."
  @State error: string = ""

  dialogController = new CustomDialogController({
    builder: CustomDialogExample({
      message: this.error,
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true
  })

  requestData() {
    requestWebData(
      "https://jsonplaceholder.typicode.com/users",
      (data) => {
        this.result = data
      },
      (error) => {
        this.error = error
        this.dialogController.open()
      }
    )
  }

  aboutToAppear() {
    setTimeout(this.requestData.bind(this), 1000)
  }

  build() {
    Scroll(new Scroller()) {
      Column() {
        Text(this.result)
      }
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.On)
  }
}

@CustomDialog
struct CustomDialogExample {
  controller: CustomDialogController
  message: string
  cancel: () => void
  confirm: () => void

  build() {
    Column() {
      Text(this.message).fontSize(20).margin({ top: 10, bottom: 10 })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('cancel', { type: ButtonType.Normal })
          .onClick(() => {
            this.controller.close()
            if (this.cancel != null) {
              this.cancel()
            }
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button('confirm')
          .onClick(() => {
            this.controller.close()
            if (this.confirm != null) {
              this.confirm()
            }
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10 })
    }
    .backgroundColor(0x88000000)
  }
}