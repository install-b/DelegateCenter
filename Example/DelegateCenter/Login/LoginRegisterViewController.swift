//
//  LoginRegisterViewController.swift
//  PhotoGallery
//
//  Created by Shangen Zhang on 2019/10/25.
//  Copyright © 2019 Mi Cheng. All rights reserved.
//

import UIKit
import SnapKit

class LoginRegisterViewController: UIViewController {
    

    private lazy var mobelCell: LoginInputCell = {
        let item = LoginInputCell.InputConfig(placeholder: "请输入手机号码", text: nil, maxIntputLegnth: 11, showRightButton: false)
        let cell = LoginInputCell(config: item)
        cell.delegate = self
        return cell
    }()

    private lazy var codeCell: LoginInputCell = {
        let item = LoginInputCell.InputConfig(placeholder: "请输入验证码", text: nil, maxIntputLegnth: 6, showRightButton: true)
        let cell = LoginInputCell(config:item )
        cell.delegate = self
        return cell
    }()

    lazy var loginRegisterBtn: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage.colorImage(0xFF6906.uiColor), for: .normal)
        var norColor = UIImage.colorImage(0xF6F6F6.uiColor)
        
        btn.setBackgroundImage(norColor, for: .disabled)
        btn.setTitle("登录", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(0xFFFFFF.uiColor, for: .normal)
        btn.setTitleColor(UIColor.dynamicColor(light: 0xCFCFCF.uiColor, dark: 0x414142.uiColor), for: .disabled)
        btn.isEnabled = false
        btn.layer.cornerRadius = 7.5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(loginClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubViews()
    }
  
    @objc func loginClick(_ sender: UIButton) {
        /// 登录
       
    }
}

extension LoginRegisterViewController: LoginInputCellDelegate {
    func rightBtnClick(_ cell: LoginInputCell) {
        guard let mobile = mobelCell.inputTextField.text, !mobile.isEmpty else {
            print( "手机号不能为空")
            return
        }
        
        guard let btn = cell.getCodeButton else {
             print("未知点击事件")
            return
        }
        
        getMsgCode(sender: btn, mobile: mobile)
        // getMsgCode
    }
    
    func cellTextFeilddidChanged(_ cell: LoginInputCell) {
       
    }
}

extension LoginRegisterViewController {
    
    func getMsgCode(sender: TimeCountDownButton, mobile: String) {
        // 获取验证码
        sender.timeState = .disable
        
        /// 请求验证码
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            sender.reStartTimeCountDown()
        }
    }

}

extension LoginRegisterViewController {

    private func setupSubViews() {

        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        let size = UIScreen.main.bounds.size
        
        let contentView = UIView(frame: view.bounds)
        scrollView.addSubview(contentView)
        scrollView.contentSize = CGSize.init(width: size.width, height: size.height)
        
        contentView.addSubview(mobelCell)
        contentView.addSubview(codeCell)

        contentView.addSubview(loginRegisterBtn)
       
        
        contentView.snp.makeConstraints { (make) in
            make.left.top.equalTo(scrollView)
            make.width.height.equalTo(self.view)
        }
        
  
        let inputH: CGFloat = 60

        mobelCell.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(25)
            make.left.right.equalToSuperview()
            make.height.equalTo(inputH)
        }

        codeCell.snp.makeConstraints { (make) in
            make.top.equalTo(mobelCell.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(inputH)
        }


        loginRegisterBtn.snp.makeConstraints { (make) in
            make.top.equalTo(codeCell.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.height.equalTo(48)
        }
    }
}

extension LoginRegisterViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
