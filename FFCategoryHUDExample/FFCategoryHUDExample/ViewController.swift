//
//  ViewController.swift
//  FFCategoryHUDExample
//
//  Created by 苏飞 on 2017/4/20.
//  Copyright © 2017年 苏飞. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FFCategoryHUDDataSource,FFCategoryHUDDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
 
        automaticallyAdjustsScrollViewInsets = false
        
        let categoryHUDFrame = CGRect(x: 0, y: 64, width: 375, height: 216)
        let titles = ["哈哈df","哈哈哈sdfas","哈哈哈333","哈","134124哈哈哈","说就撒了开发商"]
        var style = FFCategoryStyle()
        style.contentBackgroundColor = UIColor.blue
        style.title.isShowBottomLine = true
        style.title.isNeedScale = true
        style.title.bottomLineColor = UIColor.red
        style.isImageKeyboard = true
        let layout = FFCategoryKeyboardLayout()
        var childVCs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.random
            childVCs.append(vc)
        }
        let categoryHUD = FFCategoryHUD.init(frame: categoryHUDFrame, titles: titles, style: style, layout: layout )
        categoryHUD.dataSource = self
        categoryHUD.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "h")
        categoryHUD.delegate = self
        view.addSubview(categoryHUD)
        

    }
    
    
    func numberOfSections(in categoryHUD: FFCategoryHUD) -> Int {
        return 6
    }
    
    
    func categoryHUD(_ categoryHUD: FFCategoryHUD, numberOfItemsInSection section: Int) -> Int {
   
        if (section % 2 == 0) {
            return  22
        } else {
            return 50
        }
    }
    
    
    func categoryHUD(_ categoryHUD: FFCategoryHUD, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "h", for: indexPath)
        cell.backgroundColor = UIColor.random
        return cell
    }

    
    func categoryHUD(_ categoryHUD: FFCategoryHUD, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

