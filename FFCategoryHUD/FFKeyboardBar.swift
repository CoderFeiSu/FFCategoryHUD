//
//  FFKeyboardBar.swift
//  FFCategoryHUDExample
//
//  Created by 苏飞 on 2017/5/12.
//  Copyright © 2017年 苏飞. All rights reserved.
//

import UIKit
protocol FFKeyboardBarDelegate: class {
    func keyboardBar(_ keyboardBar: FFKeyboardBar, didClickedLblAt index: Int)
}


class FFKeyboardBar: UIView {
    
    weak var delegate: FFKeyboardBarDelegate?
    
    fileprivate var style: FFKeyboardBarStyle
    fileprivate var titles: [String]
    fileprivate var titleLbls: [UILabel] = [UILabel]()
    /** 选中的Lbl */
    fileprivate var selectedLbl: UILabel?
    
    /** 是否可以滚动 */
    fileprivate lazy var isScrollEnable: Bool = {
        return false
    }()

    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = self.bounds
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = self.style.barColor
        return scrollView
    }()
    /** 底部线条 */
    fileprivate lazy var bottomLine: UIView = {
        let firstLbl = self.titleLbls.first!
        let bottomLineX = firstLbl.frame.origin.x
        let bottomLineW = firstLbl.frame.width
        let bottomLineH = self.style.bottomLineHeight
        let bottomLineY = self.style.height - self.style.bottomLineHeight
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        bottomLine.frame = CGRect(x: bottomLineX, y: bottomLineY, width: bottomLineW, height: bottomLineH)
        return bottomLine
    }()
    
    init(frame: CGRect, titles: [String],style: FFKeyboardBarStyle) {
        self.style = style
        self.titles = titles
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension FFKeyboardBar {
    
    fileprivate func setUpUI() {
        
        addSubview(scrollView)
        
        addLbl()
        
        if style.isShowBottomLine {
            scrollView.addSubview(bottomLine)
        }
    }
    
    
    private func addLbl() {
        let lblH = self.style.height
        let lblY = CGFloat(0)
        var lblX = CGFloat(0)
        var lblW = CGFloat(0)
        // 添加Lbl到scrollView
        for (i, title) in titles.enumerated() {
            let lbl = UILabel()
            lbl.tag = i
            lbl.text = title
            lbl.font = style.normalFont
            lbl.textColor = style.normalColor
            lbl.textAlignment = .center
            lbl.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(lblClick))
            lbl.addGestureRecognizer(tapGesture)
            scrollView.addSubview(lbl)
            titleLbls.append(lbl)
            
            // 计算X和W
            lblW = (title as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:  lbl.font], context: nil).width
            i == 0 ? (lblX =  style.leftMargin) : (lblX = titleLbls[i - 1].frame.maxX + style.margin)
            // 设置尺寸
            lbl.frame = CGRect(x: lblX, y: lblY, width: lblW, height: lblH)
            // 设置默认选中
            if i == 0 {
                lbl.textColor = style.selectColor
                selectedLbl = lbl
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
        self.delegate?.keyboardBar(self, didClickedLblAt: lbl.tag)
        
    }
    
}


// MARK: - 处理滚动\颜色切换\底部线条位置\文字缩放
extension FFKeyboardBar {
    
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


extension FFKeyboardBar: FFKeyboardContentActionDelegate {


    func keyboardContent(_ keyboardContent: FFKeyboardContent, didEndScrollAt index: Int) {
        let lbl = titleLbls[index]
        handlerLblColorAndScale(lbl: lbl)
        handlerBottomLineLocation(lbl: lbl)
        
        guard isScrollEnable else {
            return
        }
        
        handlerLblScroll(lbl: lbl)
    }
    

}
