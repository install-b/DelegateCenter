//
//  MultiProxyObjectWrapper.swift
//  DelegateCenter
//
//  Created by Shangen Zhang on 2020/7/5.
//

import Foundation



/// 组合模式拓展
public protocol MultiProxyObjectWrapper {
    /// 指定协议类型
    associatedtype MPT: ObjectClass
    /// 多代理链表
    var proxyObject: MultiProxyObject<MPT> { get }
}

/// 添加移除遍历通用操作
public extension MultiProxyObjectWrapper {
    @discardableResult
    func add(delegate: MPT) -> Bool {
        proxyObject.add(delegate: delegate)
    }
    
    @discardableResult
    func remove(delegate: MPT) -> Bool {
        proxyObject.remove(delegate: delegate)
    }

    func enumerateDelegate(using block:((_ delegate: MPT, _ stop: UnsafeMutablePointer<ObjCBool>) -> Void)) {
        proxyObject.enumerateDelegate(using: block)
    }
}

