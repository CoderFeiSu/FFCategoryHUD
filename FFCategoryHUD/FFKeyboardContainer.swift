//  FFImageKeyboardContainer.swift
//  FFCategoryHUDExample
//
//  Created by 苏飞 on 2017/5/12.
//  Copyright © 2017年 苏飞. All rights reserved.
//

import UIKit

@objc public protocol FFKeyboardContainerDelegate : class {
   @objc optional func keyboardContainer(_ keyboardContainer: FFKeyboardContainer,didSelectItemAt indexPath: IndexPath)
   @objc optional func keyboardContainer(_ keyboardContainer: FFKeyboardContainer, didDeselectItemAt indexPath: IndexPath)
}

public protocol FFKeyboardContainerDataSource : class {
    func numberOfSections(in keyboardContainer: FFKeyboardContainer) -> Int
    func keyboardContainer(_ keyboardContainer: FFKeyboardContainer, numberOfItemsInSection section: Int) -> Int
    func keyboardContainer(_ keyboardContainer: FFKeyboardContainer, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

public class FFKeyboardContainer: UIView {

    weak public var dataSource: FFKeyboardContainerDataSource?
    weak public var delegate: FFKeyboardContainerDelegate?
    fileprivate var content: FFKeyboardContent?
    fileprivate var layout: FFCategoryKeyboardLayout
    fileprivate var barStyle: FFKeyboardBarStyle
    fileprivate var barTitles: [String]

    /**
     barTitles: 工具条文字
     barStyle:  工具条样式
     layout: 小格子样式
     
     */
   public init(frame: CGRect, barTitles: [String], barStyle: FFKeyboardBarStyle, layout: FFCategoryKeyboardLayout) {
        
        self.barTitles = barTitles
        self.barStyle = barStyle
        self.layout = layout
        super.init(frame: frame)
        
        addChildView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}


extension FFKeyboardContainer {
    public func register(_ cellClass: Swift.AnyClass?, forCellWithReuseIdentifier identifier: String) {
        self.content?.register(cellClass, forCellWithReuseIdentifier: identifier)
    }

    public func reloadData() {
       self.content?.reloadData()
    }

    public  func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
      return (self.content?.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath))!
    }
    public func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
        return self.content?.cellForItem(at: indexPath)
    }
}


extension FFKeyboardContainer: FFKeyboardContentDataSource, FFKeyboardContentDelegate {
   
    func numberOfSections(in keyboardContent: FFKeyboardContent) -> Int {
        assert(dataSource != nil, "dataSource不能为空")
        let sections = dataSource?.numberOfSections(in: self) ?? 0
        assert(barTitles.count == sections, "文字标题数量必须和section数量相等")
        return sections
    }
    
    
    func keyboardContent(_ keyboardContent: FFKeyboardContent, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.keyboardContainer(self, numberOfItemsInSection: section) ?? 0
    }
    
    
    func keyboardContent(_ keyboardContent: FFKeyboardContent, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dataSource?.keyboardContainer(self, cellForItemAt: indexPath)
        return cell!
    }
    
    func keyboardContent(_ keyboardContent: FFKeyboardContent,didSelectItemAt indexPath: IndexPath) {
        self.delegate?.keyboardContainer?(self, didSelectItemAt: indexPath)
    }
    
    func categoryKeyboardView(_ categoryKeyboardView: FFKeyboardContent, didDeselectItemAt indexPath: IndexPath) {
        self.delegate?.keyboardContainer?(self, didDeselectItemAt: indexPath)
    }
    
}

extension FFKeyboardContainer {
    
    fileprivate func addChildView() {
        // 添加文字标题
        var barY: CGFloat = 0
        barStyle.isTitleOnTop ? (barY = 0) : (barY = bounds.height - barStyle.height)
        let barFrame = CGRect(x: 0, y: barY, width: bounds.width, height: barStyle.height)
        let bar = FFKeyboardBar.init(frame: barFrame, titles: barTitles, style: barStyle)
        addSubview(bar)
        // 添加内容
        var contentY: CGFloat = 0
        barStyle.isTitleOnTop ? (contentY = barStyle.height) : (contentY = 0)
        let contentFrame = CGRect(x: 0, y: contentY, width: bounds.width, height: bounds.height - barStyle.height)
        let content = FFKeyboardContent.init(frame: contentFrame, style: barStyle, layout: layout)
        bar.delegate = content
        content.actionDelegate = bar
        content.delegate = self
        content.dataSource = self
        addSubview(content)
        self.content = content
        
    }
}

