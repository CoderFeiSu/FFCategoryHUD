
//
//  FFKeyboardBarStyle.swift
//  FFCategoryHUDExample
//
//  Created by 苏飞 on 2017/5/12.
//  Copyright © 2017年 苏飞. All rights reserved.
//

import UIKit

struct FFKeyboardBarStyle {
    
    /** 文字标题是否是在显示内容上面 */
    var isTitleOnTop: Bool = true
    /** pageControl高度 */
    var pageControlHeight: CGFloat = 20
    var pageControlAlignment: FFAlignment = .top
    /** 文字视图高度 */
    var height: CGFloat = 44
    /** 普通文字颜色 */
    var normalColor: UIColor = .black
    /** 选中文字颜色 */
    var selectColor: UIColor = .red
    var normalFont: UIFont = UIFont.systemFont(ofSize: 13.0)
    /** 文字区背景颜色 */
    var barColor: UIColor = UIColor.lightGray
    /** 内容背景颜色 */
    var contentColor: UIColor = UIColor.groupTableViewBackground
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
}


enum FFAlignment {
    case top
    case bottom
}
