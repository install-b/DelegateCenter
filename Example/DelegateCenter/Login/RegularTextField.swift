//
//  RegularTextField.swift
//  DelegateCenter_Example
//
//  Created by Shangen Zhang on 2020/7/5.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

open class RegularTextField: UITextField {
    /// 最大输入长度
    public var maxLength: Int = 6
    public var regularStr: String?
    public var fontSize : CGFloat = 0.0
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func textDidChange(_ sender: UITextField) {
        if self.fontSize > 0 {
            let empty = sender.text?.isEmpty ?? true
            sender.font = empty ? UIFont.systemFont(ofSize: self.fontSize) : UIFont.boldSystemFont(ofSize: self.fontSize)
        }
        
        guard let toBeString = text else { return }
        
        if let language = UITextInputMode.activeInputModes.first?.primaryLanguage {
            if language == "zh-Hans" {///中文输入法
                if markedTextRange == nil {
                    if toBeString.count > maxLength {
                        text = toBeString.substring(to: maxLength)
                       
                       
                    }
                }
            } else {///非中文输入法，直接统计字数和限制，这里没有考虑其他语种的情况
                if toBeString.count > maxLength {
                    text = toBeString.substring(to: maxLength)
                    print("最多输入\(maxLength)个字符")
                   
                    
                }
            }
        }
    }
}

extension RegularTextField: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.text?.length ?? 0) + string.length - range.length > maxLength {
           
            return false
        }
        return true
    }
}

extension String {
    var length: Int {
        return utf16.count
    }
    
    ///MARK: - 截取字符串从开始到 index
    func substring(to index: Int) -> String {
        let sub = self[self.startIndex...]
        let subString  = String(sub.prefix(index))
        return subString
    }

}
