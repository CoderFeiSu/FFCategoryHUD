//
//  FFCategoryHUD.swift
//  FFCategoryHUDExample
//
//  Created by 苏飞 on 2017/4/20.
//  Copyright © 2017年 苏飞. All rights reserved.
//

import UIKit



class FFSegmentContainer: UIView {
    

    fileprivate var barStyle: FFSegmentBarStyle 
    fileprivate var barTitles: [String]
    fileprivate var childVCs: [UIViewController]
    fileprivate var parentVC: UIViewController

    
    init(frame: CGRect, barTitles: [String],barStyle: FFSegmentBarStyle, childVCs: [UIViewController], parentVC: UIViewController) {
        
        assert(barTitles.count == childVCs.count, "文字标题数量必须和子控制器数量相等")

        // 记录属性
        self.barTitles = barTitles
        self.barStyle = barStyle
        self.childVCs = childVCs
        self.parentVC = parentVC
        super.init(frame: frame)
    
        // 添加子控件
        addChildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}





extension FFSegmentContainer {

    fileprivate func addChildView() {
        // 添加文字标题
        let barFrame = CGRect(x: 0, y: 0, width: bounds.width, height: barStyle.height)
        let bar = FFSegmentBar.init(frame: barFrame, titles: barTitles, style: barStyle)
        addSubview(bar)
        // 添加内容
        let contentFrame = CGRect(x: 0, y: barStyle.height, width: bounds.width, height: bounds.height - barStyle.height)
        let content = FFSegmentContent.init(frame:contentFrame, childVCs: childVCs, parentVC: parentVC)
        bar.delegate = content
        content.delegate = bar
        addSubview(content)
    }
}





