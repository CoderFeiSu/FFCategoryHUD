//
//  UIColor+Extension.swift
//  FFCategoryHUDExample
//
//  Created by Freedom on 2017/4/20.
//  Copyright © 2017年 Freedom. All rights reserved.
//

import UIKit

extension UIColor {

    static var random: UIColor {
        let redRandom = CGFloat(arc4random_uniform(UInt32(256))) / 255.0
        let greenRandom = CGFloat(arc4random_uniform(UInt32(256))) / 255.0
        let blueRandom = CGFloat(arc4random_uniform(UInt32(256))) / 255.0
       return UIColor(red: redRandom, green: greenRandom, blue: blueRandom, alpha: 1.0)
    }
    
    var rgbValue: (CGFloat, CGFloat, CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: nil)
        return (r,g,b)
    }

}
