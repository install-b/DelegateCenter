//
//  ViewController.swift
//  DelegateCenter
//
//  Created by install-b on 07/04/2020.
//  Copyright (c) 2020 install-b. All rights reserved.
//

import UIKit
import DelegateCenter


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let objc = TestClass()
        DelegateCenter.default.add(objc as AddDataSourceProtocol)
        DelegateCenter.default.add(self as AddDataSourceProtocol)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pushAddVc(_ sender: Any) {
        let vc = SubViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func timeDown(_ sender: Any) {
        let vc = LoginRegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: AddDataSourceProtocol {
    func add() {
        
         print("啊~~~")
    }
    
//    func aMethod() {
//        print("啊~~~")
//    }
}

class TestClass: AddDataSourceProtocol {
    func add() {
        
    }
}
