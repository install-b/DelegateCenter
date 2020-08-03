//
//  DelegateCenter.swift
//  MultiDelegate
//
//  Created by Shangen Zhang on 2019/11/28.
//  Copyright © 2019 Shangen Zhang. All rights reserved.
//

import UIKit


/// 代理中心
/// 一个面向协议的代理分发中心
/// 即满足了像通知一样的无耦合的消息传递机制,又同时满足了代理协议限定代码规范性
open class DelegateCenter: SafeExcuteWrapper {
    
    /// 通用中心
    /// 也可以根据自己的需求创建
    public static let `default` = DelegateCenter()
    /// 安全执行
    public let safeExcute: SafeExcute = SafeExcute()
    /// 代理存储集合 代理池
    private(set) var delegateCollection: [String: Any] = [String: Any]()
    
    /// 获取代理链表
    private func lazyGetMultiProxyObject<T>() -> MultiProxyObject<T> where T: ObjectClass {
        excute {
            let name = "\(T.self)"
            if let mProxy = delegateCollection[name] as? MultiProxyObject<T> {
                return mProxy
            }
            let obj = MultiProxyObject<T>()
            delegateCollection[name] = obj
            return obj
        }
    }
}



public extension DelegateCenter {
    
    /// 添加代理
    /// - Parameter delegate: 代理
    func add<T>(_ delegate: T) where T: ObjectClass {
        let object: MultiProxyObject<T> = lazyGetMultiProxyObject()
        object.add(delegate: delegate)
    }
    
    /// 移除代理
    /// - Parameter delegate: 代理
    func remove<T>(_ delegate: T) where T: ObjectClass {
        let object: MultiProxyObject<T> = lazyGetMultiProxyObject()
        object.remove(delegate: delegate)
    }
    
    typealias EnumerateDelegate<T> = (_: T, _: UnsafeMutablePointer<ObjCBool>) -> Void
    
    /// 遍历代理
    func enumDelegate<T>(_ : T.Type, using block: EnumerateDelegate<T>)
        where T: ObjectClass {
        let object: MultiProxyObject<T>? = excute {  return delegateCollection["\(T.self)"] as? MultiProxyObject<T> }
        object?.enumerateDelegate(using: block)
    }
}
