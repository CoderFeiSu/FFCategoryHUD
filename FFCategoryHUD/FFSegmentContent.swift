//
//  FFCategoryContentView.swift
//  FFCategoryHUDExample
//
//  Created by Freedom on 2017/4/20.
//  Copyright © 2017年 Freedom. All rights reserved.
//
import UIKit

protocol FFSegmentContentDelegate: class {
    func segmentContent(_ segmentContent: FFSegmentContent, sourceIndex: Int, targetIndex: Int, progress: CGFloat)
    func segmentContent(_ segmentContent: FFSegmentContent, didEndScrollAt index: Int)
}

private let kSegmentContentCellID = "segmentContentCell"

class FFSegmentContent: UIView {
    
   weak var delegate: FFSegmentContentDelegate?
    
   fileprivate var  items: [FFSegmentItem]
   fileprivate var  parentVC: UIViewController
   fileprivate var  beginOffsetX: CGFloat = 0
   fileprivate var  style: FFSegmentBarStyle
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
        cv.backgroundColor = self.style.contentColor
        return cv
    }()
    
    init(frame: CGRect, items: [FFSegmentItem], parentVC: UIViewController, style: FFSegmentBarStyle) {
        
        // 记录属性
        self.items = items;
        self.parentVC = parentVC;
        self.style = style
        super.init(frame: frame)
        
        // 添加子控制器到父控制器中
        var index: Int = 0
        for item in self.items {
            if item.isPushVC { continue }
            item.index = index
            parentVC.addChild(item.vc)
            index += 1
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
        return parentVC.children.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kSegmentContentCellID, for: indexPath)
        for view in cell.contentView.subviews {view.removeFromSuperview()}
        let childVC = parentVC.children[indexPath.item]
        var view = UIView()
        if childVC.isKind(of: UITableViewController.self) {
            guard let tableController = childVC as? UITableViewController else {return cell}
            view = tableController.tableView
        } else if childVC.isKind(of: UICollectionViewController.self) {
            guard let collectionController = childVC as? UICollectionViewController else {return cell}
            guard let collectionView = collectionController.collectionView else {return cell}
            view = collectionView
        } else {
            view = childVC.view
        }
        view.frame = cell.contentView.bounds
        cell.contentView.addSubview(view)
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
       
            if targetIndex >= items.count {
                targetIndex = items.count - 1
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
        guard progress <= 1 else { return }
        self.delegate?.segmentContent(self, sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
    }

}



extension FFSegmentContent: FFSegmentBarDelegate {

   func segmentBar(_ segmentBar: FFSegmentBar, sourceIndex: Int, targetIndex: Int) {
        // 不执行DidScroll
        isHandlerDidScroll = false
        // 滚动内容部分
        let item = items[targetIndex]
        if item.isPushVC {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                self.parentVC.navigationController?.pushViewController(item.vc, animated: true)
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.delegate?.segmentContent(self, didEndScrollAt: sourceIndex)
             }
            return
        }
        let indexPath = IndexPath(item: item.index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        collectionView.reloadItems(at: [indexPath])
    }
    
}


