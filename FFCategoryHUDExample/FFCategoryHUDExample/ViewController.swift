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
