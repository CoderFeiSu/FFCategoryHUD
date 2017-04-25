
//
//  FFCategoryTitleView.swift
//  FFCategoryHUDExample
//
//  Created by 苏飞 on 2017/4/20.
//  Copyright © 2017年 苏飞. All rights reserved.
//

import UIKit
protocol FFCategoryTitleViewDelegate: class {
    func categoryTitleView(_ categoryTitleView: FFCategoryTitleView, didClickedLblAt index: Int)
}


class FFCategoryTitleView: UIView {
    
    weak var delegate: FFCategoryTitleViewDelegate?
    
    fileprivate var style: FFCategoryStyle
    fileprivate var titles: [String]
    fileprivate var titleLbls: [UILabel] = [UILabel]()
    /** 选中的Lbl */
    fileprivate var selectedLbl: UILabel?

   /** 是否可以滚动 */
    fileprivate lazy var isScrollEnable: Bool = {
     return false
    }()
    // 颜色渐变
    fileprivate lazy var sourceRGB: (CGFloat, CGFloat, CGFloat) = {
      return self.style.title.selectColor.rgbValue
    }()
    fileprivate lazy var targetRGB: (CGFloat, CGFloat, CGFloat) = {
      return self.style.title.normalColor.rgbValue
    }()
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
       return scrollView
    }()
    /** 底部线条 */
    fileprivate lazy var bottomLine: UIView = {
        let firstLbl = self.titleLbls.first!
        let bottomLineX = firstLbl.frame.origin.x
        let bottomLineW = firstLbl.frame.width
        let bottomLineH = self.style.title.bottomLineHeight
        let bottomLineY = self.style.title.height - self.style.title.bottomLineHeight
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.title.bottomLineColor
        bottomLine.frame = CGRect(x: bottomLineX, y: bottomLineY, width: bottomLineW, height: bottomLineH)
        return bottomLine
    }()
    
    init(frame: CGRect, titles: [String],style: FFCategoryStyle) {
        self.style = style
        self.titles = titles
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension FFCategoryTitleView {

    fileprivate func setUpUI() {
    
        addSubview(scrollView)
        
        addLbl()
        
        if style.title.isShowBottomLine {
          scrollView.addSubview(bottomLine)
        }
    }
    
    
    private func addLbl() {
        let lblH = self.style.title.height
        let lblY = CGFloat(0)
        var lblX = CGFloat(0)
        var lblW = CGFloat(0)
        // 添加Lbl到scrollView
        for (i, title) in titles.enumerated() {
            let lbl = UILabel()
            lbl.tag = i
            lbl.text = title
            lbl.font = style.title.normalFont
            lbl.textColor = style.title.normalColor
            lbl.textAlignment = .center
            lbl.isUserInteractionEnabled = true
//            lbl.backgroundColor = UIColor.random
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(lblClick))
            lbl.addGestureRecognizer(tapGesture)
            scrollView.addSubview(lbl)
            titleLbls.append(lbl)

            // 计算X和W
            lblW = (title as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:  lbl.font], context: nil).width
            i == 0 ? (lblX =  style.title.leftMargin) : (lblX = titleLbls[i - 1].frame.maxX + style.title.margin)
            // 设置尺寸
            lbl.frame = CGRect(x: lblX, y: lblY, width: lblW, height: lblH)
            // 设置默认选中
            if i == 0 {
                lbl.textColor = style.title.selectColor
                selectedLbl = lbl
                if style.title.isNeedScale {
                    lbl.transform = CGAffineTransform(scaleX: style.title.maxScale, y: style.title.maxScale)
             }
          }
            
        }
        
        let contentWidth = (titleLbls.last?.frame.maxX)! + style.title.rightMargin
        // 如果超过屏幕宽度就要滚动，没有超过屏幕宽度需要平分,不能滚动
        if (contentWidth > bounds.width) {
            isScrollEnable = true
        }
        if isScrollEnable { // 滚动
            scrollView.contentSize = CGSize(width: (titleLbls.last?.frame.maxX)! + style.title.rightMargin, height: 0)
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
    self.delegate?.categoryTitleView(self, didClickedLblAt: lbl.tag)
    
   }

}


// MARK: - 处理滚动\颜色切换\底部线条位置\文字缩放
extension FFCategoryTitleView {

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
            self.selectedLbl?.textColor = self.style.title.normalColor
            lbl.textColor = self.style.title.selectColor
            
            if self.style.title.isNeedScale {
                self.selectedLbl?.transform = CGAffineTransform.identity
                lbl.transform = CGAffineTransform(scaleX: self.style.title.maxScale, y: self.style.title.maxScale)
            }
            self.selectedLbl = lbl
        }

    }
    
    fileprivate func handlerBottomLineLocation(lbl: UILabel) {
           UIView.animate(withDuration: 0.25) {
           self.bottomLine.frame.origin.x = lbl.frame.origin.x
           self.bottomLine.frame.size.width  = lbl.frame.width
        }
    }
    

}


extension FFCategoryTitleView: FFCategoryContentViewDelegate, FFCategoryKeyboardViewDelegate {

    // 一直滚动
    func categoryContentView(_ categoryContentView: FFCategoryContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
      didScrolling(sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
   }
    
    // 结束滚动
    func categoryContentView(_ categoryContentView: FFCategoryContentView, didEndScrollAt index: Int) {
        
         didScrollEnd(at: index)
    }
    
    func categoryKeyboardView(_ categoryKeyboardView: FFCategoryKeyboardView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        didScrolling(sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
    }
    
    func categoryKeyboardView(_ categoryKeyboardView: FFCategoryKeyboardView, didEndScrollAt index: Int) {
       didScrollEnd(at: index)
    }
    
    
    private func didScrolling(sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
    
        // 颜色渐变
        let sourceLbl = titleLbls[sourceIndex]
        let targetLbl = titleLbls[targetIndex]
        sourceLbl.textColor = UIColor.init(red: sourceRGB.0 - deltaRGB.0 * progress , green: sourceRGB.1 - deltaRGB.1 * progress, blue: sourceRGB.2 - deltaRGB.2 * progress, alpha: 1.0)
        targetLbl.textColor = UIColor.init(red: targetRGB.0 + deltaRGB.0 * progress , green: targetRGB.1 + deltaRGB.1 * progress, blue: targetRGB.2 + deltaRGB.2 * progress, alpha: 1.0)
        print(sourceIndex, targetIndex, progress)
        
        // 文字缩放
        if style.title.isNeedScale {
            let deltaScale = style.title.maxScale - 1
            sourceLbl.transform = CGAffineTransform(scaleX: style.title.maxScale - deltaScale * progress , y: style.title.maxScale - deltaScale * progress)
            targetLbl.transform = CGAffineTransform(scaleX: 1 + deltaScale * progress , y: 1 + deltaScale * progress)
        }
        
        
        // 底部线条移动
        if style.title.isShowBottomLine {
            let deltaX = targetLbl.frame.origin.x - sourceLbl.frame.origin.x
            let deltaW = targetLbl.frame.width - sourceLbl.frame.width
            self.bottomLine.frame.origin.x = sourceLbl.frame.origin.x + deltaX * progress
            self.bottomLine.frame.size.width = sourceLbl.frame.width + deltaW * progress
        }

    }
    
    
    private func didScrollEnd(at index: Int) {
        let lbl = titleLbls[index]
        handlerLblColorAndScale(lbl: lbl)
        handlerBottomLineLocation(lbl: lbl)
        
        guard isScrollEnable else {
            return
        }
        
        handlerLblScroll(lbl: lbl)
    }
    

}
