//
//  WeakProxyLink.swift
//  MultiDelegate
//
//  Created by Shangen Zhang on 2019/11/28.
//  Copyright © 2019 Shangen Zhang. All rights reserved.
//

import Foundation

/// 链表 弱引用代理节点
class WeakProxyLink<E> where E: NSObjectProtocol {
    /// 弱引用代理
    weak var proxy: E?
    
    /// 下一个代理
    var next: WeakProxyLink<E>?
    
    /// 构造方法
    /// - Parameters:
    ///   - proxy: 代理
    ///   - next: next指针
    init(proxy: E? = nil, next: WeakProxyLink? = nil) {
        self.proxy = proxy
        self.next = next
    }
}
