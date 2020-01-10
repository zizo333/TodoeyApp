//
//  ViewController.swift
//  TodoeyApp
//
//  Created by Zizo Adel on 1/10/20.
//  Copyright © 2020 Zizo Adel. All rights reserved.
//

import UIKit
import CoreData

class TodoeyViewController: UITableViewController {

    // MARK: - Variables
    var itemArray: [Item] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
                
        addCustomCell()
        loadItems()
    }

    // MARK: - Actions
    @IBAction func addNewItemBarButtonAction(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            let newItem = textField.text!
            let item = Item(context: self.context)
            item.title = newItem
            item.done = false
            self.itemArray.append(item)
            self.saveNewItem()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField { (alertTF) in
            alertTF.placeholder = "Enter the name of item"
            textField = alertTF
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Helper methods
    /*** add custom cell to the table view ***/
    func addCustomCell() {
        let nibCell = UINib(nibName: "TodoeyCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "Cell")
    }
    
    /*** save new item the itemArray ***/
    func saveNewItem() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        self.tableView.reloadData()
    }
    
    /*** load all items ***/
    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - cofigure table view
extension TodoeyViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TodoeyCell
        let currentItem = itemArray[indexPath.row]
        cell.titleLbl.text = currentItem.title
        cell.accessoryType = currentItem.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveNewItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
