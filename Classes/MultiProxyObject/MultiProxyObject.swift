//
//  MultiProxyObject.swift
//  MultiDelegate
//
//  Created by Shangen Zhang on 2019/11/28.
//  Copyright © 2019 Shangen Zhang. All rights reserved.
//

import Foundation

public typealias ObjectClass = Any


/// 多代理链表  代理变化协议
@objc public protocol MultiProxyObjectDelegate {
    /// 代理数量变化监听方法
    func delegateCountDidChange(_ obj: Any, count: Int)
}

/// 多代理对象 链表
open class MultiProxyObject<T>: SafeExcuteWrapper where T: ObjectClass {
    public let safeExcute: SafeExcute = SafeExcute()
    
    /// 代理数量 
    public private(set) var proxyCount: Int = 0 {
        didSet {
            if oldValue == proxyCount { return }
            delegate?.delegateCountDidChange(self, count: proxyCount)
        }
    }
    
    /// 代理集合 链表
    private var proxyLink: WeakLinkNode<AnyObject>?
    
    /// 代理
    public weak var delegate: MultiProxyObjectDelegate?
    
    public init() { }
}

public extension MultiProxyObject {
    
    /// 添加一个代理
    /// - Parameter delegate: 代理
    @discardableResult
    func add(delegate: T) -> Bool {
        let del = delegate as AnyObject
        return excute {
            guard proxyLink != nil else {
                proxyLink = WeakLinkNode<AnyObject>(val: del)
                /// 代理数为1
                proxyCount = 1
                return true
            }
            var has = false
            proxyCount = enumrate(addNext: delegate, using: { (proxy) -> Bool in

                if del === proxy  {
                    has = true
                    return true
                }
                return false
            })
            return !has
        }
    }
    
    /// 移除一个代理
    /// - Parameter delegate: 从链表中删除一个代理
    @discardableResult
    func remove(delegate: T) -> Bool {
        let del = delegate as AnyObject
        return excute {
            guard proxyLink != nil else {  proxyCount = 0; return false }
            var result = false
            proxyCount = enumrate(using: { (proxy) -> Bool in
                if  del === proxy   {
                    result = true
                    return true
                }
                return false
            })
            return result
        }
    }
    
    /// 遍历代理
    /// - Parameter block: 遍历的block
    func enumerateDelegate(using block:((_ delegate: T, _ stop: UnsafeMutablePointer<ObjCBool>) -> Void)) {
        return excute {
            guard proxyLink != nil else { return }
            
            let stop = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1)
            defer {
                stop.deallocate()
            }
            stop.pointee = false
            proxyCount = enumrate(using:  { (proxy) -> Bool in
                if stop.pointee.boolValue == false, let delegate = proxy as? T {
                    block(delegate, stop)
                }
                print("ccccc \(proxy)")
                return false
            })
        }
    }
}

extension MultiProxyObject {
    /// 边遍历边删除销毁的proxy 和 需要删除的proxy
    /// - Parameters:
    ///   - proxyLink: 传入得
    ///   - block: 这个回调是
    ///   - addObj: 最后添加的代理 可以为空即结束遍历不做操作
    private func enumrate(addNext add: T? = nil, using block:((_ delegate: AnyObject) -> Bool)) -> Int {
        guard var link = proxyLink else {
            proxyLink = WeakLinkNode<AnyObject>(val: add as AnyObject)
            return 1
        }
        
        var preLink: WeakLinkNode<AnyObject>?
        var addObj = add
        func returnValue(_ count: Int) -> Int {
            guard let addObj = addObj else {
                return count
            }
            guard let preLink = preLink else {
                proxyLink = WeakLinkNode<AnyObject>(val: addObj as AnyObject)
                return 1
            }
            if let next = preLink.next {
                next.next = WeakLinkNode<AnyObject>(val: addObj as AnyObject)
            } else {
                preLink.next = WeakLinkNode<AnyObject>(val: addObj as AnyObject)
            }
            return count + 1
        }
        
        var c = 0
        

        func removeCurrentProxy() -> Int? {
            /// 删除无用的代理
            guard let next = link.next else {
                preLink?.next = nil;
                
               if preLink == nil {
                   proxyLink = nil
               }
               return returnValue(c)
            }
            link = next
            if preLink == nil {
                proxyLink = link
            } else {
                preLink?.next = link
            }
            
            return nil
        }
        
        
        
        while true {
             /// 过滤已经释放的代理
            guard let proxy = link.val else {
                if let count = removeCurrentProxy() { return returnValue(count) }
                continue
            }
            
            
            /// 这里返回YES 将其删除
            if block(proxy) {
                if addObj != nil {
                    addObj = nil
                    c += 1
                } else {
                    if let count = removeCurrentProxy() {
                        return returnValue(count)
                    }
                }
                
            } else {
                c += 1
            }
            
            preLink = link
            guard let next = link.next else { return returnValue(c) }
            link = next
        }
    }
}
