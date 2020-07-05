//
//  UIColor-Extension.swift
//  MCPhotoSwift
//
//  Created by MCPhotosiOS on 2019/1/9.
//  Copyright © 2019 MCPhotosiOS. All rights reserved.
//

import UIKit

public protocol ColorProvider {
    var uiColor: UIColor { get }
    var cgColor: CGColor { get }
}

extension ColorProvider {
   public var cgColor: CGColor {
        return uiColor.cgColor
    }
}

/// 16进制颜色
public struct HexAColor {
   public let hex: Int
   public let alpha: CGFloat
   public init(hex: Int, alpha: CGFloat = 1) {
        self.alpha = alpha
        self.hex = hex
    }
}

/// 16进制颜色
public struct StrHexColor {
   public let hex: String
   public let alpha: CGFloat
   public init(hex: String, alpha: CGFloat = 1) {
        self.alpha = alpha
        self.hex = hex
    }
}

/// RGB 颜色
public struct RGBAColor {
   let red: Int
   let green: Int
   let blue: Int
   let alpha: CGFloat
   public init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1) {
        self.alpha = alpha
        self.blue = blue
        self.green = green
        self.red = red
    }
}

/// HEX 16进制
extension HexAColor: ColorProvider {
    public var uiColor: UIColor {
        
        let red   =  Double((hex & 0xFF0000) >> 16) / 255.0
        let green =  Double((hex & 0xFF00)   >> 8 ) / 255.0
        let blue  =  Double( hex & 0xFF   ) / 255.0
        return UIColor.init(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: alpha)
    }
}

extension StrHexColor: ColorProvider {
    public var uiColor: UIColor {
        return hex.getColor(alpha: alpha)
    }
}

extension RGBAColor: ColorProvider {
    public var uiColor: UIColor {
        UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}

extension UIColor: ColorProvider {
    public var uiColor: UIColor {
        return self
    }
}

extension String: ColorProvider {
    public var uiColor: UIColor {
        return getColor(alpha: 1)
    }
    
    func getColor(alpha: CGFloat) -> UIColor {
        var cstr = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased() as NSString
        if cstr.length < 6 { return .clear }
        if cstr.hasPrefix("0X") {
            cstr = cstr.substring(from: 2) as NSString
        } else if cstr.hasPrefix("#") {
          cstr = cstr.substring(from: 1) as NSString
        }
         if cstr.length != 6 { return .clear }
        var range = NSRange.init()
        range.location = 0
        range.length = 2
        //r
        let rStr = cstr.substring(with: range);
        //g
        range.location = 2
        let gStr = cstr.substring(with: range)
        //b
        range.location = 4
        let bStr = cstr.substring(with: range)
        var r :UInt32 = 0x0
        var g :UInt32 = 0x0
        var b :UInt32 = 0x0
        Scanner.init(string: rStr).scanHexInt32(&r)
        Scanner.init(string: gStr).scanHexInt32(&g)
        Scanner.init(string: bStr).scanHexInt32(&b)
        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
}

extension Int: ColorProvider {
    public var uiColor: UIColor {
        let red   =  Double((self & 0xFF0000) >> 16) / 255.0
        let green =  Double((self & 0xFF00)   >> 8 ) / 255.0
        let blue  =  Double( self & 0xFF   ) / 255.0
        return UIColor.init(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
    }
}

// MARK: - HexColor
extension UIColor {
    /// 动态颜色
    public typealias DynamicProvider = ( (_: UserInterfaceStyle) -> ColorProvider? )
    
    /// 当前颜色模式
    public enum UserInterfaceStyle: Int {
        case unspecified
        case light
        case dark
    }

    /// 多颜色适配
    /// - Parameter hex: 正常颜色
    /// - Parameter darkHex: 暗黑模式颜色
    /// - Parameter alpha: 透明度
    public static func getColor(with normal: ColorProvider, dynamic provider: DynamicProvider? = nil ) -> UIColor {
    
        if #available(iOS 13.0, *) {
            return  UIColor.init { (traitCollection) -> UIColor in
                if let provider = provider, let style = UserInterfaceStyle(rawValue: traitCollection.userInterfaceStyle.rawValue), let hexC = provider(style)  {
                    return hexC.uiColor
                }
                return normal.uiColor
            }
        } else {
             return normal.uiColor
        }
    }
    
//    /// 设置动态颜色
//    /// - Parameter light: 浅色模式下的颜色
//    /// - Parameter dark: 深色模式下的颜色
//    public static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
//        if #available(iOS 13.0, *) {
//            return UIColor.init { (traitCollection) -> UIColor in
//                return traitCollection.userInterfaceStyle == .light ? light : dark
//            }
//        } else {
//            return light
//        }
//    }
    
    /// 设置动态颜色,直接设置Int类型的hex值
    /// - Parameter light: 浅色模式下的颜色
    /// - Parameter dark: 深色模式下的颜色
    public static func dynamicColor(light: ColorProvider, dark: ColorProvider, alphaComponent alpha: CGFloat? = nil) -> UIColor {
       
        if #available(iOS 13.0, *) {
            return UIColor.init { (traitCollection) -> UIColor in
                if let alpha = alpha {
                    return traitCollection.userInterfaceStyle != .light ? dark.uiColor.withAlphaComponent(alpha) : light.uiColor.withAlphaComponent(alpha)
                }
                return traitCollection.userInterfaceStyle != .light ? dark.uiColor : light.uiColor
            }
        } else {
            if let alpha = alpha {
                return light.uiColor.withAlphaComponent(alpha)
            }
            return light.uiColor
        }
    }
    
    /// rgb来颜色,不用再除255, 如  UIColor(red: 129, green: 21, blue: 12)
    ///
    /// - Parameters:
    ///   - red: red component.
    ///   - green: green component.
    ///   - blue: blue component.
    ///   - transparency: optional transparency value (default is 1).
    convenience public init?(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
        guard red >= 0 && red <= 255 else { return nil }
        guard green >= 0 && green <= 255 else { return nil }
        guard blue >= 0 && blue <= 255 else { return nil }
        
        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
    
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
    }

    /// 随机色
    public static var random: UIColor {
        
        let red = Int.random(in: 0...255)
        let green = Int.random(in: 0...255)
        let blue = Int.random(in: 0...255)
        return UIColor(red: red, green: green, blue: blue)!
    }
}
