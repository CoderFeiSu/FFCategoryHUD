//
//  FFCategoryTitleStyle.swift
//  FFCategoryHUDExample
//
//  Created by 苏飞 on 2017/4/20.
//  Copyright © 2017年 苏飞. All rights reserved.
//

import UIKit

struct FFCategoryStyle {
    
    /** 是否是图片键盘, 当为图片键盘时需要设置dataSource，不为图片键盘时需要设置ChildVCs和ParentVC */
    var isImageKeyboard: Bool = false
    /** 文字样式 */
    lazy var title: FFCategoryTitleStyle = FFCategoryTitleStyle()
    /** 键盘样式 */
    lazy var keyboard: FFCategoryKeyboardStyle = FFCategoryKeyboardStyle()
    /** 文字标题是否是在显示内容上面 */
    var isTitleOnTop: Bool = true
    /** 内容背景颜色 */
    var contentBackgroundColor: UIColor = UIColor.groupTableViewBackground
    /** 内容背景颜色 */
    var contentAlpha: CGFloat = 1.0
    
}



// title样式
struct FFCategoryTitleStyle {
    /** 文字视图高度 */
    var height: CGFloat = 44
    /** 普通文字颜色 */
    var normalColor: UIColor = .black
    /** 选中文字颜色 */
    var selectColor: UIColor = .red
    var normalFont: UIFont = UIFont.systemFont(ofSize: 13.0)
    /** 文字背景颜色 */
    var backgroundColor: UIColor = UIColor.white
    /** 默认文字之间的间距是10 */
    var margin: CGFloat = 10
    /** 默认文字到屏幕左边的间距是5 */
    var leftMargin: CGFloat = 5
    /** 默认文字到屏幕右边的间距是5 */
    var rightMargin: CGFloat = 5
    /** 是否显示底部指示条 */
    var isShowBottomLine: Bool = false
    var bottomLineHeight: CGFloat = 2.0
    var bottomLineColor: UIColor = UIColor.blue
    /** 是否可以缩放 */
    var isNeedScale: Bool = false
    /** 放大到的比例 */
    var maxScale: CGFloat = 1.2
}



// 键盘样式
 struct FFCategoryKeyboardStyle {
 
    /** pageControl高度 */
    var pageControlHeight: CGFloat = 20
}


