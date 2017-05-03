//
//  FFCategoryKeyboardView.swift
//  FFCategoryHUDExample
//
//  Created by 苏飞 on 2017/4/25.
//  Copyright © 2017年 苏飞. All rights reserved.
//

import UIKit

protocol FFCategoryKeyboardViewDelegate: class {
    func categoryKeyboardView(_ categoryKeyboardView: FFCategoryKeyboardView, didEndScrollAt index: Int)
}

@objc protocol FFCategoryKeyboardViewActionDelegate: class {
    @objc optional func categoryKeyboardView(_ categoryKeyboardView: FFCategoryKeyboardView, didSelectItemAt indexPath: IndexPath)
    @objc optional func categoryKeyboardView(_ categoryKeyboardView: FFCategoryKeyboardView, didDeselectItemAt indexPath: IndexPath)
}

protocol FFCategoryKeyboardViewDataSource : class {
    func numberOfSections(in categoryKeyboardView: FFCategoryKeyboardView) -> Int
    func categoryKeyboardView(_ categoryKeyboardView: FFCategoryKeyboardView, numberOfItemsInSection section: Int) -> Int
    func categoryKeyboardView(_ categoryKeyboardView: FFCategoryKeyboardView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

class FFCategoryKeyboardView: UIView {

    weak var delegate: FFCategoryKeyboardViewDelegate?
    weak var dataSource: FFCategoryKeyboardViewDataSource?
    weak var actionDelegate: FFCategoryKeyboardViewActionDelegate?
    
    fileprivate var  style: FFCategoryStyle
    fileprivate var  layout: FFCategoryKeyboardLayout
    fileprivate lazy var lastSection: Int = 0
    fileprivate lazy var isAutoScoll: Bool = false
    fileprivate lazy var pageControl: UIPageControl = UIPageControl()
    fileprivate lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
        let cvX: CGFloat = 0
        let cvY: CGFloat = 0
        let cvW: CGFloat = self.bounds.width
        let cvH: CGFloat = self.bounds.height - self.style.keyboard.pageControlHeight
        cv.frame = CGRect(x: cvX, y: cvY, width: cvW, height: cvH)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.bounces = false
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = self.style.contentBackgroundColor
        cv.alpha = self.style.contentAlpha
        return cv
    }()
    fileprivate lazy var pageControlView: UIView = {
        let pageControlView = UIView()
        pageControlView.backgroundColor = self.style.contentBackgroundColor
        pageControlView.alpha = self.style.contentAlpha
        let pageControlViewX: CGFloat = 0
        let pageControlViewH: CGFloat = self.style.keyboard.pageControlHeight
        let pageControlViewY: CGFloat = self.collectionView.frame.height
        let pageControlViewW: CGFloat = self.bounds.width
        pageControlView.frame = CGRect(x: pageControlViewX, y: pageControlViewY, width: pageControlViewW, height: pageControlViewH)
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.pageIndicatorTintColor = UIColor.lightGray
        pc.currentPageIndicatorTintColor = UIColor.gray
        let pcX: CGFloat = 0
        let pcH: CGFloat = 0
        var pcY: CGFloat = 0
        self.style.keyboard.pageControlAlignment == .top ? (pcY = 4) : (pcY = pageControlViewH - 4)
        let pcW: CGFloat = self.bounds.width
        pc.frame = CGRect(x: pcX, y: pcY, width: pcW, height: pcH)
        pageControlView.addSubview(pc)
        self.pageControl = pc
        return pageControlView
    }()
    
    
    init(frame: CGRect, style: FFCategoryStyle, layout: FFCategoryKeyboardLayout) {
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


extension FFCategoryKeyboardView {
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


extension FFCategoryKeyboardView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections(in: self) ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            let items = dataSource?.categoryKeyboardView(self, numberOfItemsInSection: section) ?? 0
            if section == 0 {
                pageControl.numberOfPages = ((items - 1) / (layout.rows * layout.cols) + 1)
        }
      return items
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let  cell = dataSource?.categoryKeyboardView(self, cellForItemAt: indexPath)
         return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.actionDelegate?.categoryKeyboardView?(self,didSelectItemAt: indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.actionDelegate?.categoryKeyboardView?(self, didDeselectItemAt: indexPath)
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
                guard let items  = dataSource?.categoryKeyboardView(self, numberOfItemsInSection: sections - 1 ) else {return}
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



extension FFCategoryKeyboardView: FFCategoryTitleViewDelegate {
    
    func categoryTitleView(_ categoryTitleView: FFCategoryTitleView, didClickedLblAt index: Int) {
        
         isAutoScoll = true
        // 滚动内容部分
        let indexPath = IndexPath(item: 0, section: index)
        handlerPageControl(indexPath: indexPath)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}


extension FFCategoryKeyboardView {

    fileprivate func handlerPageControl(indexPath: IndexPath) {
        let items = collectionView.numberOfItems(inSection: indexPath.section)
        if (lastSection != indexPath.section) {
            pageControl.numberOfPages = ((items - 1) / (layout.rows * layout.cols) + 1)
            lastSection = indexPath.section
            self.delegate?.categoryKeyboardView(self, didEndScrollAt: indexPath.section)
        }
        pageControl.currentPage = indexPath.item  / (layout.rows * layout.cols)
    }
}

