
//Credit to: https://developer.huawei.com/consumer/cn/forum/topic/0204805622017320105?fid=0102683795438680754
@Entry
@Component
struct PullToRefreshDemo2 {
  private arr: string[] = ["A", "B", "C", "D", "E", "F", "G", "H"] //todo 当前数据源
  private AllData: string[] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
  private firstIndex: number = 0;
  //-1 代表正常状态 0代表下拉刷新 1 代表上拉加载
  @State loadingText: string = '正在刷新' //文本
  @State IsShowLoading: boolean = false //动画显示隐藏 默认是显示状态
  private rotateTimeOut: any //计时器
  @State rotateAngle: number = 0;
  //加载图标旋转
  loadingRotate() {
    this.rotateTimeOut = setInterval(() => {
      this.rotateAngle = 0
      animateTo({ duration: 800 }, () => {
        this.rotateAngle = 360
      })
    }, 800)
  }

  public ActionStart(event) {
    this.clearRotate()
    if (this.firstIndex === 0 && this.arr.length > 0) { //判断是否刷新
      this.IsShowLoading = true;
      this.loadingText = "开始刷新"
    }
  }

  private ActionUpdate() {
    this.clearRotate()
    this.loadingText = "正在刷新"
    console.log(this.loadingText)
  }

  private ActionEnd() {
    this.loadingText = "开始刷新数据"
    console.log(this.loadingText)
    //开始刷新数据
    this.loadingRotate();
    this.loadingData(); //加载数据
  }

  private ActionCancel() {
    //取消动画
    this.IsShowLoading = false;
    this.loadingText = "刷新取消"
    console.log(this.loadingText)

  }
  //网络加载数据
  private loadingData() {
    console.log("loadingData=====")
    var that = this;
    //延迟几秒执行这个代码 取消动画
    setTimeout(function () {
      console.log("loadingData=====开始")
      var random = Math.ceil(Math.random() * 10);
      ;
      that.arr.splice(0, 8)
      for (var i = random;i < random + 8; i++) {
        that.arr.push(that.AllData[i])
      }
      console.log("loadingData=====clearInterval")
      that.clearRotate()
      console.log("loadingData===取消动画")
      that.IsShowLoading = false
    }, 5000)
  }

  private clearRotate() {
    console.log(`zcf clearRotate: ${this.rotateTimeOut}`)
    if (this.rotateTimeOut) {
      clearInterval(this.rotateTimeOut)
    }
  }

  build() {
    Column() {
      List({ space: 20, initialIndex: 0 }) {
        ListItem() {
          Column() {
            Image($r("app.media.icon"))
              .objectFit(ImageFit.Contain)
              .height(40)
              .aspectRatio(1)
              .width(40)
              .margin({ bottom: 5 })
              .rotate({ x: 0, y: 0, z: 1, angle: this.rotateAngle })
            Text(this.loadingText)
              .fontSize(14)
              .fontColor("#ed6262")
              .backgroundColor(Color.White)
          }
          .alignItems(HorizontalAlign.Center)
          .padding({ top: 10, right: 0, bottom: 10, left: 0 })
          .width("100%")
          .padding({ top: 10, right: 0, bottom: 10, left: 0 })
          .backgroundColor(Color.White)
        }
        .visibility((this.IsShowLoading ? Visibility.Visible : Visibility.None)) //Todo 动画显示隐藏

        ForEach(this.arr, (item) => {
          ListItem() {
            Text('' + item)
              .width('100%')
              .height(100)
              .fontSize(16)
              .textAlign(TextAlign.Center)
              .borderRadius(10)
              .backgroundColor(0xFFFFFF)
          }
        }, item => item)
      }
      .listDirection(Axis.Vertical) // 排列方向
      .onScrollIndex((firstIndex: number, lastIndex: number) => {
        //Todo firstIndex屏幕第一个可见条目索引
        //todo lastIndex屏幕最后可见索引
        this.firstIndex = firstIndex;
      })
      .parallelGesture(
        PanGesture({ distance: 150, direction: PanDirection.Down })
          .onActionStart(this.ActionStart.bind(this))
          .onActionUpdate(this.ActionUpdate.bind(this))
          .onActionEnd(this.ActionEnd.bind(this))
          .onActionCancel(this.ActionCancel.bind(this))
      )
    }.width('100%')

  }
}