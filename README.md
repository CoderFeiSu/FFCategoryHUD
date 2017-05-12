## FFCategoryHUd
* 里面有两个框架，一个类似于网易新闻顶部的滚动条，一个是图片键盘
* 简单易用

## 怎样使用
* 手动拖入FFCategoryHUD文件夹到项目中
* 网易新闻顶部示例代码1:

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

## 网易新闻顶部效果图
<img src="http://s15.sinaimg.cn/mw690/003uLCdEzy7b1mRO6aG6e&amp;690" width="279" height="491" id="image_operate_56541494594904791">



* 图片键盘示例代码2:

```objc

        import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
 
        automaticallyAdjustsScrollViewInsets = false

        
        let frame = CGRect(x: 0, y: view.bounds.height - 216, width: view.bounds.width, height: 216)
        let titles = ["低级", "初级", "中级", "高级"]
        var  barStyle = FFKeyboardBarStyle()
        barStyle.isShowBottomLine = true
        barStyle.bottomLineColor = UIColor.red
        let layout = FFCategoryKeyboardLayout()
        let keyboardContainer = FFKeyboardContainer.init(frame: frame, barTitles: titles, barStyle: barStyle, layout: layout)
        keyboardContainer.delegate = self
        keyboardContainer.dataSource = self
        keyboardContainer.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "abc")
        view.addSubview(keyboardContainer)
        
    }
    
}



extension ViewController: FFKeyboardContainerDataSource, FFKeyboardContainerDelegate {

    func numberOfSections(in keyboardContainer: FFKeyboardContainer) -> Int {
        return 4
    }
    
    func keyboardContainer(_ keyboardContainer: FFKeyboardContainer, numberOfItemsInSection section: Int) -> Int {
        if (section == 0) {
        return 1
        } else if (section == 1) {
          return 50
        } else if (section == 2) {
            return 22
        } else {
          return 10
        }
    }
    
    func keyboardContainer(_ keyboardContainer: FFKeyboardContainer, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = keyboardContainer.dequeueReusableCell(withReuseIdentifier: "abc", for: indexPath)
        cell.backgroundColor = UIColor.random
        return cell
    }
    
}


```

## 图片键盘效果图
<img src="http://s1.sinaimg.cn/mw690/003uLCdEzy7b1pI0iZOa0&amp;690">



## 支持版本
iOS8及以上
