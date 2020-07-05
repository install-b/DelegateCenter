//
//  SubViewController.swift
//  DelegateCenter_Example
//
//  Created by Shangen Zhang on 2020/7/5.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import DelegateCenter

class SubViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        let button = UIButton()
        
        view.addSubview(button)
        button.setTitle("add", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(add), for: .touchUpInside)
        button.center = CGPoint(x: view.bounds.width * 0.5, y: view.bounds.height * 0.5)
    }
    
    @objc func add() {
        DelegateCenter.default.enumDelegate(AddDataSourceProtocol.self) { (delegate, _) in
            delegate.add()
        }
    }
}
