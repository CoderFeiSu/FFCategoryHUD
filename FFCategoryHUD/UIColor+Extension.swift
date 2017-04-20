//
//  UIColor+Extension.swift
//  FFCategoryHUDExample
//
//  Created by 苏飞 on 2017/4/20.
//  Copyright © 2017年 苏飞. All rights reserved.
//

import UIKit

extension UIColor {

    class var random: UIColor {
        let redRandom = CGFloat(arc4random_uniform(UInt32(256))) / 255.0
        let greenRandom = CGFloat(arc4random_uniform(UInt32(256))) / 255.0
        let blueRandom = CGFloat(arc4random_uniform(UInt32(256))) / 255.0
       return UIColor(red: redRandom, green: greenRandom, blue: blueRandom, alpha: 1.0)
    }

}
