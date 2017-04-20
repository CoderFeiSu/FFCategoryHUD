//
//  FFCategoryTitleView.swift
//  FFCategoryHUDExample
//
//  Created by 苏飞 on 2017/4/20.
//  Copyright © 2017年 苏飞. All rights reserved.
//

import UIKit

class FFCategoryTitleView: UIView {
    
   fileprivate var style: FFCategoryTitleStyle
   fileprivate var titles: [String]
    
   fileprivate lazy var scrollView: UIScrollView = {
       let scrollView = UIScrollView()
       scrollView.frame = self.bounds
       scrollView.backgroundColor = UIColor.purple
       scrollView.showsHorizontalScrollIndicator = false
       return scrollView
    }()
    
    init(frame: CGRect, titles: [String],style: FFCategoryTitleStyle) {
        self.style = style
        self.titles = titles
        super.init(frame: frame)
        
        setUpScollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension FFCategoryTitleView {

    fileprivate func setUpScollView() {
    
        addSubview(scrollView)
        
        let lblH = style.height
        let lblY = CGFloat(0)
        var lblX = CGFloat(0)
        for (i, title) in titles.enumerated() {
            let lbl = UILabel()
            lbl.tag = i
            lbl.text = title
            lbl.font = style.normalFont
            lbl.textColor = style.normalColor
            lbl.textAlignment = .center
            scrollView.addSubview(lbl)
            
            let lblW = (title as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:  lbl.font], context: nil).width
            i == 0 ? (lblX =  style.margin * 0.5) : (lblX = scrollView.subviews[i - 1].frame.maxX + style.margin)
            lbl.frame = CGRect(x: lblX, y: lblY, width: lblW, height: lblH)
        }
        
        scrollView.contentSize = CGSize(width: (scrollView.subviews.last?.frame.maxX)! + style.margin * 0.5, height: 0)
  }

}
