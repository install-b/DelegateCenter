//
//  LoginInputCell.swift
//  PhotoGallery
//
//  Created by Shangen Zhang on 2019/10/25.
//  Copyright © 2019 Mi Cheng. All rights reserved.
//

import UIKit


class TimeCountDownButton: UIButton {
    enum TimeState {
        case waite
        case disable
        case countDowning
    }
    
    var timeCount: Int = 60
    
    var timeState: TimeState = .waite {
        didSet {
            if timeState == oldValue {
                return
            }
            isHighlighted = false
            switch timeState {
            case .waite:
                isSelected = false
                isEnabled = true
                TimerCenter.sharedTimer.remove(delegate: self)
            case .disable:
                isSelected = false
                isEnabled = false
                TimerCenter.sharedTimer.remove(delegate: self)
            case .countDowning:
                
                isEnabled = true
                isSelected = true
                
                setTitle("\(timeCount) s", for: .selected)
               
                TimerCenter.sharedTimer.add(delegate: self)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        setTitleColor(0x797F93.uiColor, for: .normal)
        setTitleColor(0xC7C7C7.uiColor, for: .disabled)
        setTitleColor(0xFF6906.uiColor, for: .selected)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if timeState == .waite {
            super.touchesBegan(touches, with: event)
        }
    }
    
    func reStartTimeCountDown() {
        timeCount = 60
        timeState = .countDowning
    }
}

extension TimeCountDownButton: TimerCenterProtocol {
    func timerInvoke(timer: Timer) {
        timeCount -= 1
        if timeCount <= 0 {
            timeState = .waite
        } else {
            setTitle("\(timeCount) s", for: .selected)
        }
    }
}


@objc protocol LoginInputCellDelegate {
    func rightBtnClick(_ cell: LoginInputCell)
    
    func cellTextFeilddidChanged(_ cell: LoginInputCell)
}

class LoginInputCell: UIView {
    
    typealias RightActionBlock = ( (_: UIButton) -> Void )
    
    struct InputConfig {
        let placeholder: String?
        let text: String?
        let maxIntputLegnth: Int
        let showRightButton: Bool
        //let rightAction: RightActionBlock?
    }
    
    private(set) lazy var inputTextField: RegularTextField = {
        let tf = RegularTextField()
        tf.keyboardType = .numberPad
        tf.clearButtonMode = .whileEditing
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(textChanged(textField:)), for: .editingChanged)
        addSubview(tf)
        return tf
    }()
    
    private(set) var getCodeButton: TimeCountDownButton?
    
    weak var delegate: LoginInputCellDelegate?
    
    init(config: InputConfig) {
        super.init(frame: .zero)
        backgroundColor = .clear
        setupConfig(config)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConfig(_ config: InputConfig) {
        inputTextField.text = config.text
        inputTextField.placeholder = config.placeholder
        inputTextField.maxLength = config.maxIntputLegnth
        inputTextField.tintColor = 0xFF6906.uiColor
        
        let showRightButton: Bool = config.showRightButton
        
        let inputTextFieldRight: CGFloat = showRightButton ? 115 : 25
        inputTextField.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 20, left: 25, bottom: 1, right: inputTextFieldRight))
        }

        if showRightButton {
            let btn = TimeCountDownButton()
            btn.setTitle("获取验证码", for: .normal)
            
            btn.addTarget(self, action: #selector(rightAction(_:)), for: .touchUpInside)
            addSubview(btn)
            self.getCodeButton = btn
            btn.snp.makeConstraints { (make) in
                make.centerY.equalTo(inputTextField)
                make.right.equalToSuperview().offset(-30)
            }
        }
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        UIColor.dynamicColor(light: 0xDEDFE3, dark: 0x242424).set()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.minX + 25, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX  - 25, y: rect.maxY))
        path.lineWidth = 0.5
        path.stroke()
    }
}
extension LoginInputCell {
    
    @objc func rightAction(_ sender: UIButton) {
        delegate?.rightBtnClick(self)
    }
    
    @objc func textChanged(textField: UITextField) {
        delegate?.cellTextFeilddidChanged(self)
    }
}
