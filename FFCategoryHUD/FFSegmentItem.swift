//
//  FFSegmentAttrs.swift
//  FFCategoryHUDExample
//
//  Created by 飞飞 on 2019/6/15.
//  Copyright © 2019 Freedom. All rights reserved.
//

import UIKit

public class FFSegmentItem: NSObject {
    
    public var title: String = ""
    public var vc: UIViewController = UIViewController()
    public var isPushVC: Bool = false
    var index: Int = -1
    
    public init(title:String,vc: UIViewController,isPushVC: Bool = false) {
        self.title = title
        self.isPushVC = isPushVC
        self.vc = vc
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
