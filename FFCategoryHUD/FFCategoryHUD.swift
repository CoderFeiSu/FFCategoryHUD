//
//  FFCategoryHUD.swift
//  FFCategoryHUDExample
//
//  Created by 苏飞 on 2017/4/20.
//  Copyright © 2017年 苏飞. All rights reserved.
//

import UIKit

class FFCategoryHUD: UIView {
    
    fileprivate var titles: [String]
    fileprivate var childVCs: [UIViewController]
    fileprivate var parentVC: UIViewController
    fileprivate var style: FFCategoryTitleStyle
    

    init(frame: CGRect, titles: [String], childVCs: [UIViewController], parentVC: UIViewController, style: FFCategoryTitleStyle) {
        assert(titles.count == childVCs.count, "文字标题数量必须和子控制器数量相等")
        // 记录属性
        self.titles = titles
        self.childVCs = childVCs
        self.parentVC = parentVC
        self.style = style
        super.init(frame: frame)
        // 添加子控件
        addChildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


extension FFCategoryHUD {

    fileprivate func addChildView() {
        addTitleView()
        addContentView()
    }
    
    // 添加文字标题
    private func addTitleView() {
        let titleViewFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.height)
        let titleView = FFCategoryTitleView.init(frame: titleViewFrame, titles: titles,style: style)
        titleView.backgroundColor = UIColor.orange
        addSubview(titleView)
    }
    
    // 添加内容
    private func addContentView() {
        let contentViewFrame = CGRect(x: 0, y: style.height, width: bounds.width, height: bounds.height - style.height)
        let contentView = FFCategoryContentView.init(frame:contentViewFrame, childVCs: childVCs, parentVC: parentVC)
        contentView.backgroundColor = UIColor.blue
        addSubview(contentView)
    }

}
