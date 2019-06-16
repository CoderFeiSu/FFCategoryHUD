
//
//  FFCategoryTitleView.swift
//  FFCategoryHUDExample
//
//  Created by Freedom on 2017/4/20.
//  Copyright © 2017年 Freedom. All rights reserved.
//

import UIKit
protocol FFSegmentBarDelegate: class {
    func segmentBar(_ segmentBar: FFSegmentBar, sourceIndex: Int, targetIndex: Int)
}


class FFSegmentBar: UIView {
    
//    weak var delegate: FFSegmentBarDelegate?
    var delegates: [AnyObject] = [AnyObject]() {
        didSet {
            weakObjs = FFSegmentWeakArray(delegates)
        }
    }
    
    fileprivate var weakObjs: FFSegmentWeakArray<AnyObject> = FFSegmentWeakArray([])
    fileprivate var style: FFSegmentBarStyle
    fileprivate var items: [FFSegmentItem]
    fileprivate var titleLbls: [UILabel] = [UILabel]()
    /** 选中的Lbl */
    fileprivate var selectedLbl: UILabel?
    fileprivate var sourceIndex: Int = -1
   /** 是否可以滚动 */
    fileprivate lazy var isScrollEnable: Bool = false
    // 颜色渐变
    fileprivate lazy var sourceRGB: (CGFloat, CGFloat, CGFloat) =  self.style.selectColor.rgbValue
    fileprivate lazy var targetRGB: (CGFloat, CGFloat, CGFloat) =  self.style.normalColor.rgbValue
    fileprivate lazy var deltaRGB: (CGFloat, CGFloat, CGFloat) = {
        let deltaR = self.sourceRGB.0 - self.targetRGB.0
        let deltaG = self.sourceRGB.1 - self.targetRGB.1
        let deltaB = self.sourceRGB.2 - self.targetRGB.2
        return  (deltaR, deltaG, deltaB)
    }()
    fileprivate lazy var scrollView: UIScrollView = {
       let scrollView = UIScrollView()
       scrollView.frame = self.bounds
       scrollView.showsHorizontalScrollIndicator = false
       scrollView.isScrollEnabled = false
       scrollView.backgroundColor = self.style.barColor
       return scrollView
    }()
    /** 底部线条 */
    fileprivate lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLine.color
        bottomLine.frame.size.height =  self.style.bottomLine.height
        bottomLine.frame.origin.y = self.style.height - self.style.bottomLine.height
        return bottomLine
    }()
    
    init(frame: CGRect, items: [FFSegmentItem],style: FFSegmentBarStyle) {
        self.style = style
        self.items = items
        super.init(frame: frame)
        
        addSubview(scrollView)
        
        addAllLbls()
        
        if style.bottomLine.isShow {
            scrollView.addSubview(bottomLine)
            handlerBottomLineLocation(lbl: self.titleLbls.first!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension FFSegmentBar {
    
    private func addAllLbls() {
        let lblH = self.style.height
        let lblY: CGFloat = 0
        var lblX: CGFloat = 0
        var lblW: CGFloat = 0
        // 添加Lbl到scrollView
        for (i, item) in items.enumerated() {
            let lbl = UILabel()
            lbl.tag = i
            lbl.text = item.title
            lbl.font = style.normalFont
            lbl.textColor = style.normalColor
            lbl.textAlignment = .center
            lbl.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(lblClick))
            lbl.addGestureRecognizer(tapGesture)
            scrollView.addSubview(lbl)
            titleLbls.append(lbl)

            // 计算X和W
            lblW = lbl.text!.width(font: lbl.font)
            i == 0 ? (lblX =  style.leftMargin) : (lblX = titleLbls[i - 1].frame.maxX + style.margin)
            // 设置尺寸
            lbl.frame = CGRect(x: lblX, y: lblY, width: lblW, height: lblH)
            // 设置默认选中
            if i == 0 {
                lbl.textColor = style.selectColor
                selectedLbl = lbl
                sourceIndex = lbl.tag
                if style.isNeedScale {
                    lbl.transform = CGAffineTransform(scaleX: style.maxScale, y: style.maxScale)
                }
            }
        }
        
        let contentWidth = (titleLbls.last?.frame.maxX)! + style.rightMargin
        // 如果超过屏幕宽度就要滚动，没有超过屏幕宽度需要平分,不能滚动
        if (contentWidth > bounds.width) {
            isScrollEnable = true
        }
        
        if isScrollEnable { // 滚动
            scrollView.contentSize = CGSize(width: (titleLbls.last?.frame.maxX)! + style.rightMargin, height: 0)
        }
        
        if !isScrollEnable { // 不滚动
            lblW = bounds.width / CGFloat(titleLbls.count)
            for (i, lbl) in titleLbls.enumerated() {
                let lblX = CGFloat(i) * lblW
                lbl.frame.origin.x = lblX
                lbl.frame.size.width = lblW
            }
        }
    
    }
    
    
   @objc private func lblClick(tapGesture: UITapGestureRecognizer) {
    
        // 选中和不选中颜色的变换
        let lbl = tapGesture.view as! UILabel
    
        handlerLblColorAndScale(lbl: lbl)
    
        // 如果可以滚动，就需要设置滚动的偏移量
        if isScrollEnable {
           handlerLblScroll(lbl: lbl)
        }
    
        // 改变位置
        handlerBottomLineLocation(lbl: lbl)
    
        // 通知滚动内容视图
        for obj in self.weakObjs {
            guard let delegate: FFSegmentBarDelegate = obj as? FFSegmentBarDelegate else {return}
            delegate.segmentBar(self, sourceIndex: sourceIndex, targetIndex: lbl.tag)
        }
    
        let item = items[lbl.tag]
        if !item.isPushVC {
            sourceIndex = lbl.tag
        }
    
   }

}


// MARK: - 处理滚动\颜色切换\底部线条位置\文字缩放
extension FFSegmentBar {

    fileprivate func handlerLblScroll(lbl: UILabel) {
        var offsetX = lbl.center.x - bounds.width * 0.5
        let maxOffsetX = scrollView.contentSize.width - bounds.width
        if (offsetX <= 0 ) {
            offsetX = 0
        } else if (offsetX > maxOffsetX) {
            offsetX = maxOffsetX
        }
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    fileprivate func handlerLblColorAndScale(lbl: UILabel) {
    
        UIView.animate(withDuration: 0.25) { 
            self.selectedLbl?.textColor = self.style.normalColor
            lbl.textColor = self.style.selectColor
            
            if self.style.isNeedScale {
                self.selectedLbl?.transform = CGAffineTransform.identity
                lbl.transform = CGAffineTransform(scaleX: self.style.maxScale, y: self.style.maxScale)
            }
            self.selectedLbl = lbl
        }
    }
    
    fileprivate func handlerBottomLineLocation(lbl: UILabel) {
        UIView.animate(withDuration: 0.25) {
            if !self.style.bottomLine.isFitTitle {
                self.bottomLine.frame.origin.x = lbl.frame.origin.x
                self.bottomLine.frame.size.width  = lbl.frame.width
                return
            }
            self.bottomLine.frame.size.width  = lbl.text!.width(font: lbl.font)
            self.bottomLine.frame.origin.x = lbl.frame.origin.x + (lbl.frame.width - self.bottomLine.frame.width) * 0.5
        }
    }
    

}


extension FFSegmentBar: FFSegmentContentDelegate {

    // 一直滚动
    func segmentContent(_ segmentContent: FFSegmentContent, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        // 颜色渐变
        let sourceLbl = titleLbls[sourceIndex]
        let targetLbl = titleLbls[targetIndex]
        sourceLbl.textColor = UIColor(red: sourceRGB.0 - deltaRGB.0 * progress , green: sourceRGB.1 - deltaRGB.1 * progress, blue: sourceRGB.2 - deltaRGB.2 * progress, alpha: 1.0)
        targetLbl.textColor = UIColor(red: targetRGB.0 + deltaRGB.0 * progress , green: targetRGB.1 + deltaRGB.1 * progress, blue: targetRGB.2 + deltaRGB.2 * progress, alpha: 1.0)
        //  print(sourceIndex, targetIndex, progress)
        // 文字缩放
        if style.isNeedScale {
            let deltaScale = style.maxScale - 1
            sourceLbl.transform = CGAffineTransform(scaleX: style.maxScale - deltaScale * progress , y: style.maxScale - deltaScale * progress)
            targetLbl.transform = CGAffineTransform(scaleX: 1 + deltaScale * progress , y: 1 + deltaScale * progress)
        }
        // 底部线条移动
        if style.bottomLine.isShow && !style.bottomLine.isFitTitle {
            let deltaX = targetLbl.frame.origin.x - sourceLbl.frame.origin.x
            let deltaW = targetLbl.frame.width - sourceLbl.frame.width
            self.bottomLine.frame.origin.x = sourceLbl.frame.origin.x + deltaX * progress
            self.bottomLine.frame.size.width = sourceLbl.frame.width + deltaW * progress
        }
   }
    
    // 结束滚动
    func segmentContent(_ segmentContent: FFSegmentContent, didEndScrollAt index: Int) {
        let lbl = titleLbls[index]
        handlerLblColorAndScale(lbl: lbl)
        handlerBottomLineLocation(lbl: lbl)
        guard isScrollEnable else { return }
        handlerLblScroll(lbl: lbl)
    }

}
