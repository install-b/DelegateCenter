//
//  ForwardProxy.swift
//  DelegateCenter
//
//  Created by apple on 2020/8/13.
//

import Foundation


/// 代理转发 只能转发 Objc代理
open class ForwardProxy<T: NSObjectProtocol>: WeakProxyArray {
    @nonobjc public convenience init(delegates: [T]) {
        self.init(__delegates: delegates)
    }
}
