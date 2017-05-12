//
//  FFCategoryKeyboardLayout.swift
//  FFCategoryHUDExample
//
//  Created by 苏飞 on 2017/4/23.
//  Copyright © 2017年 苏飞. All rights reserved.
//

import UIKit

class FFCategoryKeyboardLayout: UICollectionViewLayout {

    var sectionInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var rowMargin: CGFloat = 10
    var colMargin: CGFloat = 10
    var rows: Int = 3
    var cols: Int = 7
    fileprivate lazy var totalPages = 0
    fileprivate lazy var attributes: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate lazy var attrsWH: (CGFloat, CGFloat) = {
        let attrsW = ((self.collectionView?.bounds.width)! - self.sectionInset.left - self.sectionInset.right - CGFloat(self.cols - 1) *  self.colMargin) / CGFloat(self.cols)
        let attrsH: CGFloat = ((self.collectionView?.bounds.height)! - self.sectionInset.top - self.sectionInset.bottom - CGFloat(self.rows - 1) *  self.rowMargin) / CGFloat(self.rows)
        return (attrsW, attrsH)
    }()
}



extension FFCategoryKeyboardLayout {

    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {return}
        
       let sections =  collectionView.numberOfSections 
       var previousTotalPages = 0
        for section in 0..<sections {
            let items = collectionView.numberOfItems(inSection: section) 
            for item in 0..<items {
                let indexPath = IndexPath(item: item, section: section)
                let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let currentPage = item / (rows * cols)
                let currentIndex = item % (rows * cols)
                let attrsX = CGFloat(previousTotalPages + currentPage) * collectionView.bounds.width + sectionInset.left + CGFloat(currentIndex %  cols) * (colMargin + attrsWH.0)
                let attrsY = sectionInset.top + CGFloat(currentIndex / cols) * (rowMargin + attrsWH.1)
                attrs.frame = CGRect(x: attrsX, y: attrsY, width: attrsWH.0, height: attrsWH.1)
                attributes.append(attrs)                
            }
         previousTotalPages += ((items - 1) / (rows * cols) + 1)
     }
        totalPages = previousTotalPages
   }

}



extension FFCategoryKeyboardLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElements(in: rect)
        return attributes
    }
}


extension FFCategoryKeyboardLayout {

    override var collectionViewContentSize: CGSize {
        return CGSize(width: CGFloat(totalPages) * (collectionView?.bounds.width ?? 1), height: 0)
    }
}
