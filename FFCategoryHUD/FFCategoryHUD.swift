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

    
    /// 生成一个分类视图
    ///
    /// - Parameters:
    ///   - frame: 分类视图的尺寸
    ///   - titles: 文字标题数组
    ///   - childVCs: 所有要显示视图的控制器
    ///   - parentVC: 显示视图的父视图的控制器
    ///   - style: 标题文字样式
    init(frame: CGRect, titles: [String], childVCs: [UIViewController], parentVC: UIViewController, style: FFCategoryTitleStyle) {
        assert(titles.count == childVCs.count, "文字标题数量必须和子控制器数量相等")
//        let isHaveNavigationController = (parentVC.navigationController == nil ? false : true)
//        let isTip = (isHaveNavigationController) && (!parentVC.automaticallyAdjustsScrollViewInsets)
//        assert(isTip == true, "父控制器存在于导航控制器下,若不能显示文字标题，请设置automaticallyAdjustsScrollViewInsets为false")
        
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
        // 添加文字标题
        let titleViewFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleViewHeight)
        let titleView = FFCategoryTitleView.init(frame: titleViewFrame, titles: titles,style: style)
        titleView.backgroundColor = style.titleViewColor
        addSubview(titleView)
        // 添加内容
        let contentViewFrame = CGRect(x: 0, y: style.titleViewHeight, width: bounds.width, height: bounds.height - style.titleViewHeight)
        let contentView = FFCategoryContentView.init(frame:contentViewFrame, childVCs: childVCs, parentVC: parentVC)
        contentView.backgroundColor = style.contentViewColor
        addSubview(contentView)
        // 代理
        titleView.delegate = contentView
        contentView.delegate = titleView
    }

}
