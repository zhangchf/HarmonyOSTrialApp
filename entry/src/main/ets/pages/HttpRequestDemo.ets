import http from '@ohos.net.http';
import { User } from '../model/User';
import { requestWebData } from '../web/WebRequest';
import router from '@ohos.router';
import { userRepo } from "../repo/UserRepo"

@Entry
@Component
struct HttpRequestDemo {
  @State error: string = ""
  @State users: User[] = null

  dialogController = new CustomDialogController({
    builder: CustomDialogExample({
      message: this.error,
      cancel: () => {
        router.back()
      },
      confirm: () => {
        this.requestData()
      }
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true
  })

  requestData() {
    userRepo.getUsers()
      .then((users) => {
        this.users = users
      })
    .catch((error) => {
      this.error = error.message
      this.dialogController.open()
    })
  }

  aboutToAppear() {
    setTimeout(this.requestData.bind(this), 1000)
  }

  build() {
    if (this.users) {
      Scroll(new Scroller()) {
        Column() {
          ForEach(this.users, (user) => {
            // Text(`${user.name}, ${user.email}`)
            UserCell({user: user})
          }, (user) => user.id)

          Divider()
        }
      }
      .matchParentSize()
      .viewBorders()
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.On)
    } else {
      Text("Loading")
        .matchParentSize()
        .viewBorders()
        .textAlign(TextAlign.Center)
    }
  }
}

@Styles
function viewBorders() {
  .border({
    width: 50,
    color: Color.Black
  })
}

@Styles
function matchParentSize() {
  .size({width: "100%", height: "100%"})
}

@Component
struct UserCell {
  user: User

  build() {
    Row() {
      Text(this.user.name).borderColor(Color.Pink).borderWidth(2)
      Divider().vertical(true).color(Color.Red).strokeWidth(5).lineCap(LineCapStyle.Butt).height(20)
      Text(this.user.email).borderColor(Color.Blue).borderWidth(2)
    }
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
      Text(this.message).fontSize(20).margin({ top: "60px", bottom: "20vp" }).fontColor(Color.Red)
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('Cancel', { type: ButtonType.Normal })
          .onClick(() => {
            this.controller.close()
            if (this.cancel != null) {
              this.cancel()
            }
          }).backgroundColor(0xffffff).fontColor(Color.Black).opacity(0.5)
        Button('Refresh')
          .onClick(() => {
            this.controller.close()
            if (this.confirm != null) {
              this.confirm()
            }
          }).backgroundColor(0xffffff).fontColor(Color.Black)
      }.margin({ bottom: 20 })
    }
    .backgroundColor(0x88000000)
  }
}