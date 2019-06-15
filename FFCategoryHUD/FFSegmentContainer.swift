//
//  FFCategoryHUD.swift
//  FFCategoryHUDExample
//
//  Created by Freedom on 2017/4/20.
//  Copyright © 2017年 Freedom. All rights reserved.
//

import UIKit


public class FFSegmentContainer: UIView {
    
    fileprivate var barStyle: FFSegmentBarStyle 
    fileprivate var items: [FFSegmentItem]
    fileprivate var parentVC: UIViewController
    
     /**
     barTitles: 工具条文字
     barStyle:  工具条样式
     childVCs:  所有视图所在的控制器
     parentVC:  父视图所在的控制器
     */
   public init(frame: CGRect, barStyle: FFSegmentBarStyle, items: [FFSegmentItem], parentVC: UIViewController) {
    
        // 记录属性
        self.barStyle = barStyle
        self.items = items
        self.parentVC = parentVC
        
        super.init(frame: frame)
        
        // 添加文字标题
        let barFrame = CGRect(x: 0, y: 0, width: bounds.width, height: barStyle.height)
        let bar = FFSegmentBar(frame: barFrame, items: items, style: barStyle)
        addSubview(bar)
        // 添加内容
        let contentFrame = CGRect(x: 0, y: barStyle.height, width: bounds.width, height: bounds.height - barStyle.height)
        let content = FFSegmentContent(frame:contentFrame, items: items, parentVC: parentVC, style: barStyle)
        bar.delegate = content
        content.delegate = bar
        addSubview(content)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

