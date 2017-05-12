//
//  FFCategoryContentView.swift
//  FFCategoryHUDExample
//
//  Created by 苏飞 on 2017/4/20.
//  Copyright © 2017年 苏飞. All rights reserved.
//
import UIKit

protocol FFSegmentContentDelegate: class {
    func segmentContent(_ segmentContent: FFSegmentContent, sourceIndex: Int, targetIndex: Int, progress: CGFloat)
    func segmentContent(_ segmentContent: FFSegmentContent, didEndScrollAt index: Int)
}

private let kSegmentContentCellID = "segmentContentCell"

class FFSegmentContent: UIView {
    
   weak var delegate: FFSegmentContentDelegate?
    
   fileprivate var  childVCs: [UIViewController]
   fileprivate var  parentVC: UIViewController
   fileprivate var  beginOffsetX: CGFloat = 0
   // 当点击Lbl的时候，不执行DidScroll，不然会出现progress大于1的情况，比如 2 3 4
   fileprivate var  isHandlerDidScroll: Bool = true
   fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.bounds.width, height: self.bounds.height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.frame = self.bounds
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.bounces = false
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kSegmentContentCellID)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    init(frame: CGRect, childVCs: [UIViewController], parentVC: UIViewController) {
        
        // 记录属性
        self.childVCs = childVCs;
        self.parentVC = parentVC;
        super.init(frame: frame)
        
            // 添加子控制器到父控制器中
            for childVC in self.childVCs {
                parentVC.addChildViewController(childVC)
        }
            // 添加子视图
            addSubview(collectionView)
    
}
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}





extension FFSegmentContent: UICollectionViewDataSource, UICollectionViewDelegate {

    
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count

    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kSegmentContentCellID, for: indexPath)
            for view in cell.contentView.subviews {
                view.removeFromSuperview()
         }
        
        cell.contentView.addSubview(childVCs[indexPath.item].view)
        
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isHandlerDidScroll = true
        beginOffsetX = scrollView.contentOffset.x
    }
   
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (!decelerate) {
         scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
      self.delegate?.segmentContent(self, didEndScrollAt: Int(scrollView.contentOffset.x / scrollView.bounds.width))
}
    
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard isHandlerDidScroll else {
            return
     }
 
        let offsetX = scrollView.contentOffset.x
        // 判断有没有进行滑动
        guard  offsetX != beginOffsetX  else {
            return
    }
        
        let index = Int(offsetX / scrollView.bounds.width)
        let width = scrollView.bounds.width
        var sourceIndex: Int = 0
        var targetIndex: Int = 0
        var progress: CGFloat = 0.0
        if (offsetX > beginOffsetX) { // 往左滑动
         sourceIndex = index
         targetIndex = index + 1
         progress = (offsetX - beginOffsetX) / width
   
                if targetIndex >= childVCs.count {
                    targetIndex = childVCs.count - 1
                }
            
            
            if (offsetX - beginOffsetX == width) {
              targetIndex = sourceIndex
              sourceIndex = targetIndex - 1
            }
    } else { // 往右滑动
         targetIndex = index
         sourceIndex = index + 1
         progress = (beginOffsetX - offsetX) / width
    }
        // 可以防止快速滚动出现两个选中
        guard progress <= 1 else {
            return
        }
        self.delegate?.segmentContent(self, sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
  }

}



extension FFSegmentContent: FFSegmentBarDelegate {

    func segmentBar(_ segmentBar: FFSegmentBar, didClickedLblAt index: Int) {
        // 不执行DidScroll
        isHandlerDidScroll = false
        // 滚动内容部分
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
}


