//
//  CategoryiewController.swift
//  Todoey
//
//  Created by Zizo Adel on 1/10/20.
//  Copyright © 2020 Zizo Adel. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryiewController: UITableViewController {

    // MARK: - Variables
    var categoryArray: Results<Category>?
    let realm = try! Realm()
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCotegories()
//        navigationController?.navigationBar.tintColor = .white
    }

    // MARK: - Actions
    @IBAction func addCategoryBarButtonAction(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            let categoryName = textField.text!
            let newCategory = Category()
            newCategory.name = categoryName
            self.save(category: newCategory)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField { (alertTF) in
            textField = alertTF
            textField.placeholder = "Enter name of category"
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Helper methods
    /*** save categories to database ***/
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    /*** load categories from database ***/
    func loadCotegories() {
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
}

// MARK: - Table view configure
extension CategoryiewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")!
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Add Yet"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItemsVC", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! TodoeyViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
}
