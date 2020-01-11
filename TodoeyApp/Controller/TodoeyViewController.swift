//
//  ViewController.swift
//  TodoeyApp
//
//  Created by Zizo Adel on 1/10/20.
//  Copyright © 2020 Zizo Adel. All rights reserved.
//

import UIKit
import RealmSwift

class TodoeyViewController: UITableViewController {

    // MARK: - Variables
    let realm = try! Realm()
    var itemsData: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomCell()
    }

    // MARK: - Actions
    @IBAction func addNewItemBarButtonAction(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = textField.text!
                        let item = Item()
                        item.title = newItem
                        item.dateCreated = Date()
                        currentCategory.items.append(item)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            self.tableView.reloadData()
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
    
    /*** load all items ***/
    func loadItems() {
        itemsData = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

// MARK: - cofigure table view
extension TodoeyViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsData?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TodoeyCell
        if let items = itemsData {
            let currentItem = items[indexPath.row]
            cell.titleLbl.text = currentItem.title
            cell.accessoryType = currentItem.done ? .checkmark : .none
        } else {
            cell.titleLbl.text = "No Items Added Yet"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = itemsData?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

 // MARK: - Configure search bar
extension TodoeyViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        makeSearchRequest(from: searchBar)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func makeSearchRequest(from searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            itemsData = itemsData?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        } else {
            loadItems()
        }
        tableView.reloadData()
    }
    
}
