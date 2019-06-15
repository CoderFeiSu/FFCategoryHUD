//
//  FFCategoryKeyboardView.swift
//  FFCategoryHUDExample
//
//  Created by Freedom on 2017/4/25.
//  Copyright © 2017年 Freedom. All rights reserved.
//

import UIKit

@objc protocol FFKeyboardContentActionDelegate: class {
   @objc optional func keyboardContent(_ keyboardContent: FFKeyboardContent, didEndScrollAt index: Int)
}

@objc protocol FFKeyboardContentDelegate: class {
    @objc optional func keyboardContent(_ keyboardContent: FFKeyboardContent, didSelectItemAt indexPath: IndexPath)
    @objc optional func keyboardContent(_ keyboardContent: FFKeyboardContent, didDeselectItemAt indexPath: IndexPath)
}

protocol FFKeyboardContentDataSource : class {
    func numberOfSections(in keyboardContent: FFKeyboardContent) -> Int
    func keyboardContent(_ keyboardContent: FFKeyboardContent, numberOfItemsInSection section: Int) -> Int
    func keyboardContent(_ keyboardContent: FFKeyboardContent, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

class FFKeyboardContent: UIView {

    weak var actionDelegate: FFKeyboardContentActionDelegate?
    weak var dataSource: FFKeyboardContentDataSource?
    weak var delegate: FFKeyboardContentDelegate?
    
    fileprivate var  style: FFKeyboardBarStyle
    fileprivate var  layout: FFCategoryKeyboardLayout
    fileprivate lazy var lastSection: Int = 0
    fileprivate lazy var isAutoScoll: Bool = false
    fileprivate lazy var pageControl: UIPageControl = UIPageControl()
    fileprivate lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
        cv.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height - self.style.pageControlHeight)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.bounces = false
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = self.style.contentColor
        return cv
    }()
    fileprivate lazy var pageControlView: UIView = {
        let pageControlView = UIView()
        pageControlView.frame = CGRect(x: 0, y: self.collectionView.frame.height, width: self.bounds.width, height: self.style.pageControlHeight)
        pageControlView.backgroundColor = self.style.contentColor
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.pageIndicatorTintColor = UIColor.lightGray
        pc.currentPageIndicatorTintColor = UIColor.gray
        var pcY: CGFloat = 0
        self.style.pageControlAlignment == .top ? (pcY = 4) : (pcY = self.style.pageControlHeight - 4)
        pc.frame = CGRect(x: 0, y: pcY, width: self.bounds.width, height: 0)
        pageControlView.addSubview(pc)
        self.pageControl = pc
        return pageControlView
    }()
    
    
    init(frame: CGRect, style: FFKeyboardBarStyle, layout: FFCategoryKeyboardLayout) {
        self.style = style
        self.layout = layout
        super.init(frame: frame)
        addSubview(collectionView)
        addSubview(pageControlView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension FFKeyboardContent {
    open func register(_ cellClass: Swift.AnyClass?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    open func reloadData() {
        collectionView.reloadData()
    }
    
    open func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
     return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
    open func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
      return collectionView.cellForItem(at: indexPath)
    }
    
}


extension FFKeyboardContent: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections(in: self) ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            let items = dataSource?.keyboardContent(self, numberOfItemsInSection: section) ?? 0
            if section == 0 {
                pageControl.numberOfPages = ((items - 1) / (layout.rows * layout.cols) + 1)
        }
      return items
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let  cell = dataSource?.keyboardContent(self, cellForItemAt: indexPath)
         return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.delegate?.keyboardContent?(self,didSelectItemAt: indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.delegate?.keyboardContent?(self, didDeselectItemAt: indexPath)
    }
    
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (!decelerate) {
            scrollViewDidEndDecelerating(scrollView)
     }
 }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let offsetX = scrollView.contentOffset.x
            let point = CGPoint(x: layout.sectionInset.left + 1 + offsetX, y: layout.sectionInset.top + 1)
            guard let indexPath = collectionView.indexPathForItem(at: point) else {return}
            handlerPageControl(indexPath: indexPath)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isAutoScoll {
           isAutoScoll = false
           var offsetX = scrollView.contentOffset.x - 10
           let sections = dataSource?.numberOfSections(in: self) ?? 0
            if lastSection == sections - 1 {
                guard let items  = dataSource?.keyboardContent(self, numberOfItemsInSection: sections - 1 ) else {return}
                let pages  = Int((items - 1) / (layout.rows * layout.cols)) + 1
                if pages == 1 {
                  offsetX = scrollView.contentOffset.x
                }
            }
           let point = CGPoint(x: offsetX, y: 0)
           scrollView.setContentOffset(point, animated: false)
        }
    }
}



extension FFKeyboardContent: FFKeyboardBarDelegate {
    
    func keyboardBar(_ keyboardBar: FFKeyboardBar, didClickedLblAt index: Int) {
        
         isAutoScoll = true
        // 滚动内容部分
        let indexPath = IndexPath(item: 0, section: index)
        handlerPageControl(indexPath: indexPath)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}


extension FFKeyboardContent {

    fileprivate func handlerPageControl(indexPath: IndexPath) {
        let items = collectionView.numberOfItems(inSection: indexPath.section)
        if (lastSection != indexPath.section) {
            pageControl.numberOfPages = ((items - 1) / (layout.rows * layout.cols) + 1)
            lastSection = indexPath.section
            self.actionDelegate?.keyboardContent?(self, didEndScrollAt: indexPath.section)
        }
        pageControl.currentPage = indexPath.item  / (layout.rows * layout.cols)
    }
}

