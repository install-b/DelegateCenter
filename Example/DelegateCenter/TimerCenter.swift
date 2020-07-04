//
//  TimerCenter.swift
//  DelegateCenter
//
//  Created by install-b. on 2019/1/17.
//  Copyright © 2019 Mi Cheng. All rights reserved.
//

import UIKit
import DelegateCenter

@objc public protocol TimerCenterProtocol: NSObjectProtocol {
    func timerInvoke(timer: Timer)
}

/// 定时器中心管理
public class TimerCenter: MultiProxyObjectExcute {
    public static let sharedTimer: TimerCenter = TimerCenter()
    
    public typealias MTP = TimerCenterProtocol
    public lazy var proxyObject: MultiProxyObject<TimerCenterProtocol> = {
       let object = MultiProxyObject<TimerCenterProtocol>()
        object.delegate = self
        return object
    }()
    
    public init() {}
    private var timer: Timer?
    
    private func loadTimer() {
        if self.timer == nil {
            if #available(iOS 10.0, *) {
                let t = Timer.init(timeInterval: 1, repeats: true) { (invokeTimer) in
                    self.enumerateDelegate(using: { (delegate, _) in
                        delegate.timerInvoke(timer: invokeTimer)
                    })
                }
                RunLoop.main.add(t, forMode: RunLoopMode.commonModes)
                self.timer = t
            } else {
                // Fallback on earlier versions
                let t = Timer.init(timeInterval: 1, target: self, selector: #selector(timeInvoke(_:)), userInfo: nil, repeats: true)
                RunLoop.main.add(t, forMode: RunLoopMode.commonModes)
                self.timer = t
            }
            
        }
    }
    
    @objc func timeInvoke(_ t: Timer) {
        enumerateDelegate(using: { (delegate, _) in
            delegate.timerInvoke(timer: t)
        })
    }
    
    private func stopATimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
}

extension TimerCenter: MultiProxyObjectDelegate {
    public func delegateCountDidChange(_ obj: Any, count: Int) {
        if count == 0 {
            self.stopATimer()
        } else {
            self.loadTimer()
        }
    }
}
