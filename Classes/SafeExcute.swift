//
//  SafeExcute.swift
//  MultiDelegate
//
//  Created by Shangen Zhang on 2019/11/28.
//  Copyright © 2019 Shangen Zhang. All rights reserved.
//

import UIKit


/// 安全执行对象
open class SafeExcute {
    
    /// Specific key
    private static let queueKey = DispatchSpecificKey<Int>()
    /// 串行队列
    private lazy var safeQueue = DispatchQueue.init(label: "\(self)_queue")
    /// 线程上下文
    private lazy var queueContext: Int = unsafeBitCast(self, to: Int.self)

    public init() {
        /// 设置线程上下文
        safeQueue.setSpecific(key: Self.queueKey, value: queueContext)
    }
}

/// 安全执行方法
public extension SafeExcute {
    
    /// 同步执行 可以防止递归调用
    /// - Parameter block: 同步执行代码块
    func excute<T>(_ block: () throws -> T) rethrows -> T {
        /// 相同队列 直接执行
        if queueContext == DispatchQueue.getSpecific(key: Self.queueKey) {
            return try block()
        }
        /// 其他的队列 串行执行
        return try safeQueue.sync(execute: block)
    }
}

/// 安全执行包裹
public protocol SafeExcuteWrapper {
    /// 安全执行对象
    var safeExcute: SafeExcute { get }
}

public extension SafeExcuteWrapper {
    /// 安全执行方法拓展
    func excute<T>(_ block: () throws -> T) rethrows -> T {
        try safeExcute.excute(block)
    }
}
