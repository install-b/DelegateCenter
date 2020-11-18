//
//  WeakLinkNode.swift
//  MultiDelegate
//
//  Created by Shangen Zhang on 2019/11/28.
//  Copyright © 2019 Shangen Zhang. All rights reserved.
//

import Foundation

/// 链表 弱引用代理节点
class WeakLinkNode<E> where E: AnyObject  {
    /// 弱引用代理
    weak var val: E?
     /// 下一个代理
    var next: WeakLinkNode<E>?
    
    /// 构造方法
    /// - Parameters:
    ///   - proxy: 代理
    ///   - next: next指针
    init(val: E, next: WeakLinkNode? = nil) {
        self.val = val
        self.next = next
    }
}
