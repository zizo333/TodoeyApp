//
//  ViewController.swift
//  TodoeyApp
//
//  Created by Zizo Adel on 1/10/20.
//  Copyright © 2020 Zizo Adel. All rights reserved.
//

import UIKit

class TodoeyViewController: UITableViewController {

    var itemArray = ["Zizo", "Ali", "Hosam"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibCell = UINib(nibName: "TodoeyCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "Cell")
    }

    // MARK: - cofigure table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TodoeyCell
        cell.titleLbl.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}

