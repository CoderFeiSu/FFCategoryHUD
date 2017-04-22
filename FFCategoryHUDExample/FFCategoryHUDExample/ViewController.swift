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
        
        let categoryHUDFrame = CGRect(x: 0, y: 64, width: 375, height: 603)
        let titles = ["哈哈df","哈哈哈sdfas","哈哈哈333","哈","134124哈哈哈","说就撒了开发商"]
        var style = FFCategoryTitleStyle()
        style.isShowBottomLine = true
        style.isNeedScale = true
        style.bottomLineColor = UIColor.green
      
        var childVCs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.random
            childVCs.append(vc)
        }
        let categoryHUD = FFCategoryHUD.init(frame: categoryHUDFrame, titles: titles, childVCs: childVCs, parentVC: self, style: style)
        view.addSubview(categoryHUD)
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

