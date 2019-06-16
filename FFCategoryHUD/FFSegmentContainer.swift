//
//  FFCategoryHUD.swift
//  FFCategoryHUDExample
//
//  Created by Freedom on 2017/4/20.
//  Copyright © 2017年 Freedom. All rights reserved.
//

import UIKit

public protocol FFSegmentContainerDelegate: class {
     func segmentContainer(_ segmentContainer: FFSegmentContainer, didClickedlAt index: Int)
}

public class FFSegmentContainer: UIView,FFSegmentBarDelegate {
    
  public weak var delegate: FFSegmentContainerDelegate?
    
     /**
     barStyle:  工具条样式
     items:     item组成的数组
     parentVC:  父视图所在的控制器
     */
   public init(frame: CGRect, barStyle: FFSegmentBarStyle, items: [FFSegmentItem], parentVC: UIViewController) {
        super.init(frame: frame)
    
        // 添加工具条
        let barFrame = CGRect(x: 0, y: 0, width: bounds.width, height: barStyle.height)
        let bar = FFSegmentBar(frame: barFrame, items: items, style: barStyle)
        addSubview(bar)
    
        // 添加内容
        let contentFrame = CGRect(x: 0, y: barStyle.height, width: bounds.width, height: bounds.height - barStyle.height)
        let content = FFSegmentContent(frame:contentFrame, items: items, parentVC: parentVC, style: barStyle)
        addSubview(content)
    
        // 充当代理
        bar.delegates = [content, self]
        content.delegate = bar
    }
    
    func segmentBar(_ segmentBar: FFSegmentBar, sourceIndex: Int, targetIndex: Int) {
        self.delegate?.segmentContainer(self, didClickedlAt: targetIndex)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

