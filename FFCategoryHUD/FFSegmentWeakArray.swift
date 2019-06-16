//
//  FFSegmentWeakArray.swift
//  FFCategoryHUDExample
//
//  Created by 飞飞 on 2019/6/16.
//  Copyright © 2019 Freedom. All rights reserved.
//

import UIKit

final class FFSegmentWeakObj<T: AnyObject> {
    weak var obj: T?
    init(_ value: T) {
        obj = value
    }
}

struct FFSegmentWeakArray<Element: AnyObject> {
    private var items: [FFSegmentWeakObj<Element>] = []
    init(_ elements: [Element]) {
        items = elements.map { FFSegmentWeakObj($0) }
    }
}

extension FFSegmentWeakArray: Collection {
    
    var startIndex: Int { return items.startIndex }
    var endIndex: Int { return items.endIndex }
    
    subscript(_ index: Int) -> Element? {
        return items[index].obj
    }
    
    func index(after idx: Int) -> Int {
        return items.index(after: idx)
    }
}
