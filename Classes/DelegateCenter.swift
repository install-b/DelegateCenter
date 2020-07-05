//
//  DelegateCenter.swift
//  MultiDelegate
//
//  Created by Shangen Zhang on 2019/11/28.
//  Copyright © 2019 Shangen Zhang. All rights reserved.
//

import UIKit

open class DelegateCenter: SafeExcute {
    
    /// 通用中心
    /// 也可以根据自己的需求创建
    public static let `default` = DelegateCenter()
    
    /// 代理存储集合
    private(set) var delegateCollection: [String: Any] = [String: Any]()
    
    /// 获取代理链表
    private func lazyGetMultiProxyObject<T>() -> MultiProxyObject<T> where T: NSObjectProtocol {
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
    func add<T>(_ delegate: T) where T: NSObjectProtocol {
        let object: MultiProxyObject<T> = lazyGetMultiProxyObject()
        object.add(delegate: delegate)
    }
    
    /// 移除代理
    /// - Parameter delegate: 代理
    func remove<T>(_ delegate: T) where T: NSObjectProtocol {
        let object: MultiProxyObject<T> = lazyGetMultiProxyObject()
        object.remove(delegate: delegate)
    }
    
    typealias EnumerateDelegate<T> = (_: T, _: UnsafeMutablePointer<ObjCBool>) -> Void
    
    /// 遍历代理
    func enumDelegate<T>(_ : T.Type, using block: EnumerateDelegate<T>)
        where T: NSObjectProtocol {
        let object: MultiProxyObject<T>? = excute {  return delegateCollection["\(T.self)"] as? MultiProxyObject<T> }
        object?.enumerateDelegate(using: block)
    }
}
