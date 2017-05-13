//
//  FFCategoryTitleStyle.swift
//  FFCategoryHUDExample
//
//  Created by 苏飞 on 2017/4/20.
//  Copyright © 2017年 苏飞. All rights reserved.
//

import UIKit

public class FFSegmentBarStyle {
    /** 文字视图高度 */
    public var height: CGFloat = 44
    /** 普通文字颜色 */
    public var normalColor: UIColor = .black
    /** 选中文字颜色 */
    public  var selectColor: UIColor = .red
    public var normalFont: UIFont = UIFont.systemFont(ofSize: 13.0)
    /** 文字区背景颜色 */
    public var barColor: UIColor = UIColor.lightGray
    /** 内容背景颜色 */
    public var contentColor: UIColor = UIColor.groupTableViewBackground
    /** 默认文字之间的间距是10 */
    public var margin: CGFloat = 10
    /** 默认文字到屏幕左边的间距是5 */
    public  var leftMargin: CGFloat = 5
    /** 默认文字到屏幕右边的间距是5 */
    public  var rightMargin: CGFloat = 5
    /** 是否显示底部指示条 */
    public var isShowBottomLine: Bool = false
    public  var bottomLineHeight: CGFloat = 2.0
    public var bottomLineColor: UIColor = UIColor.blue
    /** 是否可以缩放 */
    public var isNeedScale: Bool = false
    /** 放大到的比例 */
    public var maxScale: CGFloat = 1.2
}


