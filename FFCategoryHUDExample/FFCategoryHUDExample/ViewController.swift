//
//  ViewController.swift
//  FFCategoryHUDExample
//
//  Created by 苏飞 on 2017/4/20.
//  Copyright © 2017年 苏飞. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
 
        automaticallyAdjustsScrollViewInsets = false
        
        // 分类视图
        let frame = CGRect(x: 0, y: 64, width: 375, height: view.bounds.height - 64)
        let titles = ["哈哈df","哈哈哈sdfas","哈哈哈333","哈","134124哈哈哈","说就撒了开发商"]
        let barStyle = FFSegmentBarStyle()
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
