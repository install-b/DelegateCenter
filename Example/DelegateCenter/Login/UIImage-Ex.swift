//
//  UIImage-Ex.swift
//  DelegateCenter_Example
//
//  Created by Shangen Zhang on 2020/7/5.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

public extension UIImage {
    static func colorImage(_ color: UIColor) -> UIImage {
        return colorImage(color, size: CGSize(width: 1, height: 1))
    }
    static func colorImage(_ color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
}
