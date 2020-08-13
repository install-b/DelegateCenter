//
//  ForwardProxy.swift
//  DelegateCenter
//
//  Created by apple on 2020/8/13.
//

import Foundation


/// 代理转发
open class ForwardProxy<T: NSObject>: WeakProxyArray {
    @nonobjc public convenience init(delegates: [T]) {
        self.init(__delegates: delegates)
    }
}
