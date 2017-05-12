## FFCategoryHUd
* 里面有两个框架，一个类似于网易新闻顶部的滚动条，一个是图片键盘
* 简单易用

## 怎样使用
* 手动拖入FFCategoryHUD文件夹到项目中
* 示例代码:

```objc

        let frame = CGRect(x: 0, y: 64, width: 375, height: view.bounds.height - 64)
        let titles = ["哈哈df","哈哈哈sdfas","哈哈哈333","哈","134124哈哈哈","说就撒了开发商"]
        var barStyle = FFSegmentBarStyle()
        barStyle.isShowBottomLine = true
        barStyle.isNeedScale = true
        barStyle.bottomLineColor = UIColor.red
        var childVCs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.random
            childVCs.append(vc)
        }
        let segmentContainer = FFSegmentContainer.init(frame: frame, barTitles: titles, barStyle: barStyle, childVCs: childVCs, parentVC: self)
        view.addSubview(segmentContainer)

```

## 效果图
<img src="http://s15.sinaimg.cn/mw690/003uLCdEzy7b1mRO6aG6e&amp;690" width="279" height="491" id="image_operate_56541494594904791">

## 支持版本
iOS7及以上
