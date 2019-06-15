//
//  String+FFExtension.swift
//  FFCategoryHUDExample
//
//  Created by 飞飞 on 2019/6/14.
//  Copyright © 2019 苏飞. All rights reserved.
//

import UIKit

var width: CGFloat {
    
    return 0.0
}

extension String {
    
    func size(font: UIFont , maxSize : CGSize) -> CGSize {
        return self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font : font], context: nil).size
    }
    
    func width(font: UIFont) -> CGFloat {
        return size(font: font, maxSize: CGSize(width: CGFloat(MAXFLOAT), height: 0)).width
    }
}
