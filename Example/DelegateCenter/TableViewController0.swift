//
//  TableViewController0.swift
//  DelegateCenter_Example
//
//  Created by Shangen Zhang on 2020/7/5.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import DelegateCenter

class TableViewController0: UITableViewController {
    
    
    var dataSource: [Any] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = "\(indexPath.row) -- ddd"
        return cell
    }
}


extension TableViewController0: AddDataSourceProtocol {
    func add() {
        dataSource.append("")
        tableView.reloadData()
    }
}
