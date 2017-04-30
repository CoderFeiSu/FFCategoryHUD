//
//  FFCategoryHUD.swift
//  FFCategoryHUDExample
//
//  Created by 苏飞 on 2017/4/20.
//  Copyright © 2017年 苏飞. All rights reserved.
//

import UIKit

protocol FFCategoryHUDDelegate : class {
   func categoryHUD(_ categoryHUD: FFCategoryHUD, didSelectItemAt indexPath: IndexPath)
}

protocol FFCategoryHUDDataSource : class {
    func numberOfSections(in categoryHUD: FFCategoryHUD) -> Int
    func categoryHUD(_ categoryHUD: FFCategoryHUD, numberOfItemsInSection section: Int) -> Int
    func categoryHUD(_ categoryHUD: FFCategoryHUD, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

class FFCategoryHUD: UIView {
    
    weak var dataSource: FFCategoryHUDDataSource?
    weak var delegate: FFCategoryHUDDelegate?
    
    // 如果为分图片键盘childVCs和parentVC都为nil
    fileprivate var style: FFCategoryStyle
    fileprivate var titles: [String]
    fileprivate var childVCs: [UIViewController]?
    fileprivate var parentVC: UIViewController?
    fileprivate var keyboardView: FFCategoryKeyboardView?
    fileprivate var layout: FFCategoryKeyboardLayout? 
    
    /// 生成一个分类视图
    ///
    /// - Parameters:
    ///   - frame: 分类视图的尺寸
    ///   - titles: 文字标题数组
    ///   - childVCs: 所有要显示视图的控制器
    ///   - parentVC: 要显示视图的父视图的控制器
    ///   - style: 标题文字样式
    init(frame: CGRect, titles: [String],style: FFCategoryStyle, childVCs: [UIViewController], parentVC: UIViewController) {
        
        assert(style.isImageKeyboard == false, "请设置isImageKeyboard为false")
        assert(titles.count == childVCs.count, "文字标题数量必须和子控制器数量相等")

        // 记录属性
        self.titles = titles
        self.style = style
        self.childVCs = childVCs
        self.parentVC = parentVC
        super.init(frame: frame)
    
        // 添加子控件
        addChildView()
    }
    
    
    /// 生成一个图片键盘（表情键盘或礼物键盘）
    ///
    /// - Parameters:
    ///   - frame: 图片键盘Frame
    ///   - titles: 图片键盘文字标题
    ///   - style: 图片键盘样式
    ///   - layout: 图片键盘布局
    init(frame: CGRect, titles: [String], style: FFCategoryStyle, layout: FFCategoryKeyboardLayout) {
        
        assert(style.isImageKeyboard == true, "请设置isImageKeyboard为true")
        
        self.titles = titles
        self.style = style
        self.layout = layout
        super.init(frame: frame)
        
        addChildView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FFCategoryHUD {
     func register(_ cellClass: Swift.AnyClass?, forCellWithReuseIdentifier identifier: String) {
        self.keyboardView?.register(cellClass, forCellWithReuseIdentifier: identifier)
        
    }
    
     func reloadData() {
       self.keyboardView?.reloadData()
    }
    
}



extension FFCategoryHUD {

    fileprivate func addChildView() {
        // 添加文字标题
        let titleX: CGFloat = 0
        let titleW: CGFloat = bounds.width
        let titleH: CGFloat = style.title.height
        var titleY: CGFloat = 0
        style.isTitleOnTop ? (titleY = 0) : (titleY = bounds.height - titleH)
        let titleViewFrame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
        let titleView = FFCategoryTitleView.init(frame: titleViewFrame, titles: titles, style: style)
        titleView.backgroundColor = style.title.backgroundColor
        addSubview(titleView)
        // 添加内容
        let contentX: CGFloat = 0
        let contentW: CGFloat = bounds.width
        let contentH: CGFloat = bounds.height - style.title.height
        var contentY: CGFloat = 0
        style.isTitleOnTop ? (contentY = style.title.height) : (contentY = 0)
        let frame = CGRect(x: contentX, y: contentY, width: contentW, height: contentH)
        if style.isImageKeyboard {
          guard let layout = layout else {return}
          let keyboardView = FFCategoryKeyboardView.init(frame: frame, style: style, layout: layout)
          titleView.delegate = keyboardView
          keyboardView.delegate = titleView
          keyboardView.dataSource = self
          keyboardView.action = self
          self.keyboardView = keyboardView
           addSubview(keyboardView)
        } else {
            guard let childVCs = childVCs,
                  let parentVC = parentVC else {
                return
        }
          let contentView = FFCategoryContentView.init(frame:frame, style: style, childVCs: childVCs, parentVC: parentVC)
          contentView.backgroundColor = style.contentBackgroundColor
          titleView.delegate = contentView
          contentView.delegate = titleView
          addSubview(contentView)
        }
    }
    
    
    

}


extension FFCategoryHUD: FFCategoryKeyboardViewDataSource, FFCategoryKeyboardViewAction {
   
    func numberOfSections(in categoryKeyboardView: FFCategoryKeyboardView) -> Int {
        assert(dataSource != nil, "dataSource不能为空")
        let sections = dataSource?.numberOfSections(in: self) ?? 0
        assert(titles.count == sections, "文字标题数量必须和section数量相等")
        return sections
    }
    
    
    func categoryKeyboardView(_ categoryKeyboardView: FFCategoryKeyboardView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.categoryHUD(self, numberOfItemsInSection: section) ?? 0
    }
    
    
    func categoryKeyboardView(_ categoryKeyboardView: FFCategoryKeyboardView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dataSource?.categoryHUD(self, collectionView: collectionView, cellForItemAt: indexPath)
        return cell!
    }
    
    func categoryKeyboardView(_ categoryKeyboardView: FFCategoryKeyboardView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.categoryHUD(self, didSelectItemAt: indexPath)
    }

}




