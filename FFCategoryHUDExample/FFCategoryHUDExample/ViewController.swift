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
        let titles = ["哈哈哈1","哈哈哈2","哈哈哈3","哈哈哈4","哈哈哈5","哈哈哈6","哈哈哈7"]
        var style = FFCategoryTitleStyle()
        var childVCs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            addChildViewController(vc)
            vc.view.backgroundColor = UIColor.random
            childVCs.append(vc)
        }
        let categoryHUD = FFCategoryHUD.init(frame: categoryHUDFrame, titles: titles, childVCs: childVCs, parentVC: self, style: style)
        categoryHUD.backgroundColor = UIColor.random
        view.addSubview(categoryHUD)
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

