import { refresh } from "./RefreshList"

@Entry
@Component
struct ArkUIClubRefreshListTest {

  @State dataSet: Array<string> = undefined;
  @State refreshing: boolean = false;

  @Builder itemLayout(item: any, index: number) {
    Text("item：" + item + ", index: " + index)
      .width('100%')
      .height(100)
      .margin({top: 10})
      .fontSize(16)
      .textAlign(TextAlign.Center)
      .borderRadius(10)
      .backgroundColor('#bbccaa')
  }

  build() {
    Column() {
      Row({space: 10}) {
        Button("开始刷新")
          .onClick(() => {
            this.refreshing = true;
          })
        Button("结束刷新")
          .onClick(() => {
            this.refreshing = false;
          })
      }
      .width("100%")
      .height(50)

      Column() {
        refresh.RefreshList({
          refreshing: $refreshing,
          dataSet: $dataSet,
          itemLayout: (item: any, index: number) => {
            this.itemLayout(item, index);
          },
          onRefresh: () => {
            this.doRefresh();
          },
          onStatusChanged: (status) => {
            console.log("current status: " + status);
          }
        })
      }
      .width("100%")
      .layoutWeight(1)
    }
    .width("100%")
    .width('100%')
  }

  aboutToAppear() {
    this.initDataSet(0, 10);
  }

  private doRefresh() {
    setTimeout(() => {
      console.log("finish refresh")
      this.initDataSet((Math.random() * 100), 30);
      this.refreshing = false;
    }, 2500);
  }

  private initDataSet(start: number, count: number) {
    var dataSet = new Array<string>();
    for (var i = 0; i < count; i++) {
      dataSet.push((i + start).toFixed(2));
    }
    this.dataSet = dataSet;
  }

}