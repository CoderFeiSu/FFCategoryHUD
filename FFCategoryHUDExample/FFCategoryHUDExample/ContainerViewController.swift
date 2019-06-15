//
//  ViewController.swift
//  FFCategoryHUDExample
//
//  Created by Freedom on 2017/4/20.
//  Copyright © 2017年 Freedom. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
 
        // 不要增加内边距
        automaticallyAdjustsScrollViewInsets = false
        
        // 分类视图
        let frame = CGRect(x: 0, y: kNavigationBarH, width: 375, height: view.bounds.height - kNavigationBarH)
        let titles = ["第一个控制器","第二个控制器"]
        let barStyle = FFSegmentBarStyle()
        barStyle.isShowBottomLine = true
//        barStyle.isNeedScale = true
        barStyle.bottomLineColor = UIColor.red
        barStyle.contentColor = UIColor.red
        let childVCs = [FirstViewController(), SecondViewController()]
        let segmentContainer = FFSegmentContainer(frame: frame, barTitles: titles, barStyle: barStyle, childVCs: childVCs, parentVC: self)
        view.addSubview(segmentContainer)
        
        
        // 后面都属于图片键盘
//        let frame = CGRect(x: 0, y: view.bounds.height - 216, width: view.bounds.width, height: 216)
//        let titles = ["低级", "初级", "中级", "高级"]
//        let  barStyle = FFKeyboardBarStyle()
//        barStyle.isShowBottomLine = true
//        barStyle.bottomLineColor = UIColor.red
//        let layout = FFCategoryKeyboardLayout()
//        let keyboardContainer = FFKeyboardContainer.init(frame: frame, barTitles: titles, barStyle: barStyle, layout: layout)
//        keyboardContainer.delegate = self
//        keyboardContainer.dataSource = self
//        keyboardContainer.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "abc")
//        view.addSubview(keyboardContainer)
        
        
    }
    
    


}



//extension ViewController: FFKeyboardContainerDataSource, FFKeyboardContainerDelegate {
//
//    func numberOfSections(in keyboardContainer: FFKeyboardContainer) -> Int {
//        return 4
//    }
//    
//    func keyboardContainer(_ keyboardContainer: FFKeyboardContainer, numberOfItemsInSection section: Int) -> Int {
//        if (section == 0) {
//        return 1
//        } else if (section == 1) {
//          return 50
//        } else if (section == 2) {
//            return 22
//        } else {
//          return 10
//        }
//    }
//    
//    func keyboardContainer(_ keyboardContainer: FFKeyboardContainer, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = keyboardContainer.dequeueReusableCell(withReuseIdentifier: "abc", for: indexPath)
//        cell.backgroundColor = UIColor.random
//        return cell
//    }
//    
//}
