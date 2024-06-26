
export class Constant {
  static readonly REFRESH_PULL_TO_REFRESH = "下拉刷新";
  static readonly REFRESH_FREE_TO_REFRESH = "释放立即刷新";
  static readonly REFRESH_REFRESHING      = "正在刷新";
  static readonly REFRESH_SUCCESS         = "刷新成功";
}

@Component
export struct RefreshList {

  @BuilderParam
  itemLayout?: (item: string, index: number) => void;

  @Watch("notifyRefreshingChanged")
  @Link refreshing: boolean;
  @Link dataSet: Array<string>;

  onRefresh?: () => void;
  onStatusChanged?: (status: RefreshStatus) => void;

  private headHeight: number = 55;
  private lastX: number = 0;
  private lastY: number = 0;
  private downY: number = 0;

  private flingFactor: number = 0.75;
  private touchSlop: number = 2;
  private offsetStep: number = 10;
  private intervalTime: number = 20;
  private listScrollable: boolean = true;
  private dragging: boolean = false;

  private refreshStatus: RefreshStatus = RefreshStatus.Inactive;

  @Watch("notifyOffsetYChanged")
  @State offsetY: number = -this.headHeight;

  @State refreshHeadIcon: Resource = $r("app.media.icons8_down_24");
  @State refreshHeadText: string = Constant.REFRESH_PULL_TO_REFRESH;
  @State refreshContentH: number = 0;
  @State touchEnabled: boolean = true;
  @State headerVisibility: Visibility = Visibility.None;

  private listScroller: Scroller = new Scroller();

  private notifyRefreshingChanged() {
    if (this.refreshing) {
      this.showRefreshingStatus();
    } else {
      this.finishRefresh();
    }
  }

  private notifyOffsetYChanged() {
    this.headerVisibility = (this.offsetY == -this.headHeight) ? Visibility.None : Visibility.Visible;
  }

  @Builder headLayout() {
    Row() {
      Blank()
      Image(this.refreshHeadIcon)
        .width(30)
        .aspectRatio(1)
        .objectFit(ImageFit.Contain)

      Text(this.refreshHeadText)
        .fontSize(16)
        .width(150)
        .textAlign(TextAlign.Center)

      Blank()
    }
    .width("100%")
    .height(this.headHeight)
    .backgroundColor("#44bbccaa")
    .visibility(this.headerVisibility)
    .position({
      x: 0,
      y: this.offsetY
    })
  }

  build() {
    Column() {
      this.headLayout()

      Column() {
        List({scroller: this.listScroller}) {
          if (this.dataSet) {
            ForEach(this.dataSet, (item: string, index) => {
              ListItem() {
                if (this.itemLayout) {
                  this.itemLayout(item, index)
                }
              }
              .width("100%")
            }, (item: string) => item)
          }
        }
        .width("100%")
        .height("100%")
        .edgeEffect(EdgeEffect.None)
        // .onScrollBegin((dx: number, dy: number) => {
        //   dy = this.listScrollable ? dy : 0;
        //   return {dxRemain: dx, dyRemain: dy}
        // })
        .onScrollFrameBegin((offset, state) => {
            let dy = this.listScrollable ? offset : 0;
            return { offsetRemain: dy }
        })
      }
      .width("100%")
      .layoutWeight(1)
      .backgroundColor(Color.Pink)
      .position({
        x: 0,
        y: this.offsetY + this.headHeight
      })

    }
    .width("100%")
    .height("100%")
    .enabled(this.touchEnabled)
    .onAreaChange((oldArea, newAre) => {
      console.log("Refresh height: " + newAre.height);
      this.refreshContentH = Number(newAre.height);
    })
    .clip(true)
    .onTouch((event) => {
      if (event.touches.length != 1) {
        this.logD("TOUCHES LENGTH INVALID: " + JSON.stringify(event.touches))
        event.stopPropagation();
        return
      }
      switch (event.type) {
        case TouchType.Down:
          this.onTouchDown(event);
          break;
        case TouchType.Move:
          this.onTouchMove(event);
          break;
        case TouchType.Up:
        case TouchType.Cancel:
          this.onTouchUp(event);
          break;
      }
      event.stopPropagation();
    })
  }

  private setRefreshStatus(status: RefreshStatus) {
    this.refreshStatus = status;
    this.refreshing = (status == RefreshStatus.Refresh);
    this.touchEnabled = (status != RefreshStatus.Refresh && status != RefreshStatus.Done);
    this.notifyStatusChanged();
  }

  private canRefresh(): boolean {
    return this.isListOffsetZero(this.listScroller.currentOffset().yOffset)
  }

  private onTouchDown(event: TouchEvent) {
    this.lastX = event.touches[0].screenX;
    this.lastY = event.touches[0].screenY;
    this.downY = this.lastY;
    this.dragging = false;
    this.listScrollable = true;

    this.logD("Touch DOWN: " + event.touches[0].screenX.toFixed(2) + " x " + event.touches[0].screenY.toFixed(2) + ", offset: " + this.offsetY);
  }

  private onTouchMove(event: TouchEvent) {
    let currentX = event.touches[0].screenX;
    let currentY = event.touches[0].screenY;
    let deltaX = currentX - this.lastX;
    let deltaY = currentY - this.lastY;
    if (this.dragging) {
      this.logD("offsetY: " + this.offsetY.toFixed(2) + ",  head: " + (-this.headHeight));
      if (deltaY < 0) {
        if (this.offsetY > -this.headHeight) {
          this.offsetY = this.offsetY + px2vp(deltaY) * this.flingFactor;
          this.listScrollable = false;
        } else {
          this.offsetY = -this.headHeight;
          this.listScrollable = true;
          this.downY = this.lastY;
        }
      } else {
        if (this.canRefresh()) {
          this.offsetY = this.offsetY + px2vp(deltaY) * this.flingFactor;
          this.listScrollable = false;
        } else {
          this.listScrollable = true;
        }
      }
      this.lastX = currentX;
      this.lastY = currentY;
    } else {
      if (Math.abs(deltaX) < Math.abs(deltaY) && Math.abs(deltaY) > this.touchSlop) {
        if (deltaY > 0 && this.canRefresh()) {
          this.dragging = true;
          this.listScrollable = false
          this.lastX = currentX;
          this.lastY = currentY;
        }
      }
    }

    if(this.dragging) {
      if (currentY >= this.downY) {
        if (this.offsetY >= 0 || (this.headHeight - Math.abs(this.offsetY)) > this.headHeight * 4 / 5) {
          this.refreshHeadText = Constant.REFRESH_FREE_TO_REFRESH;
          this.refreshHeadIcon = $r("app.media.icons8_up_24");
          this.setRefreshStatus(RefreshStatus.OverDrag);
        } else {
          this.refreshHeadText = Constant.REFRESH_PULL_TO_REFRESH;
          this.refreshHeadIcon = $r("app.media.icons8_down_24");
          this.setRefreshStatus(RefreshStatus.Drag);
        }
      }
    }

    // this.logD("Touch MOVE: " + event.touches[0].screenX + " x " + event.touches[0].screenY + ", offset: " + this.offsetY);
  }

  private onTouchUp(event: TouchEvent) {
    this.logD("Touch   UP: " + event.touches[0].screenX.toFixed(2) + " x " + event.touches[0].screenY.toFixed(2) + ", offset: " + this.offsetY);

    if (this.dragging) {
      if (this.offsetY >= 0 || (this.headHeight - Math.abs(this.offsetY)) > this.headHeight * 4 / 5) {
        this.refreshHeadIcon = $r("app.media.icons8_loading");
        this.refreshHeadText = Constant.REFRESH_REFRESHING;
        this.setRefreshStatus(RefreshStatus.Refresh);
        this.scrollToTop();

        this.notifyRefreshStart();
      } else {
        this.refreshHeadIcon = $r("app.media.icons8_down_24");
        this.refreshHeadText = Constant.REFRESH_PULL_TO_REFRESH;
        this.setRefreshStatus(RefreshStatus.Drag);
        this.scrollByTop();
      }
    }
  }

  private scrollToTop() {
    this.offsetY = 0;
  }

  private scrollByTop() {
    if (this.offsetY != -this.headHeight) {
      this.logD("scrollByTop() start, offsetY: " + this.offsetY.toFixed(2));
      let intervalId = setInterval(() => {
        if(this.offsetY <= -this.headHeight) {
          this.resetRefreshStatus();
          clearInterval(intervalId);
          this.logD("scrollByTop() finish, offsetY: " + this.offsetY.toFixed(2));
        } else {
          this.offsetY = ((this.offsetY - this.offsetStep) < -this.headHeight) ? (-this.headHeight) : (this.offsetY - this.offsetStep);
        }
      }, this.intervalTime);
    } else {
      this.logD("scrollByTop(): already scrolled to top edge")
    }
  }

  private resetRefreshStatus() {
    this.offsetY = -this.headHeight;
    this.refreshHeadIcon = $r("app.media.icons8_down_24");
    this.refreshHeadText = Constant.REFRESH_PULL_TO_REFRESH;
    this.setRefreshStatus(RefreshStatus.Inactive);
  }

  private finishRefresh(): void {
    this.refreshHeadText = Constant.REFRESH_SUCCESS;
    this.refreshHeadIcon = $r("app.media.icons8_success_32");
    this.setRefreshStatus(RefreshStatus.Done);
    setTimeout(() => {
      this.scrollByTop();
    }, 1500);
  }

  aboutToAppear() {
    if (this.refreshing) {
      this.showRefreshingStatus();
    }
  }

  private showRefreshingStatus() {
    this.offsetY = 0;
    this.refreshHeadIcon = $r("app.media.icons8_loading");
    this.refreshHeadText = Constant.REFRESH_REFRESHING;
    this.setRefreshStatus(RefreshStatus.Refresh);
  }

  private notifyRefreshStart() {
    if (this.onRefresh) {
      this.onRefresh();
    }
  }

  private notifyStatusChanged() {
    if (this.onStatusChanged) {
      this.onStatusChanged(this.refreshStatus);
    }
  }

  private logD(msg: string) {
    console.log(msg + ", canRefresh: " + this.canRefresh() + ", dragging: " + this.dragging + ", listScrollable: " + this.listScrollable + ", refreshing: " + this.refreshing);
  }

  private isListOffsetZero(offset: number) {
    return Math.abs(offset) < 0.0001
  }
}