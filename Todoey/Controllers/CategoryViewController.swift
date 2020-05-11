//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Роман Цветков on 10.05.2020.
//  Copyright © 2020 Roman Tsvetkov. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeViewController {
    var categoryItems: Results<CategoryItem>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    // MARK: - Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryItem = categoryItems?[indexPath.row]
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryItem?.name ?? "No categories added yet"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItems?.count ?? 1
    }
    
    // MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let toDoListVC = segue.destination as! ToDoListViewController
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        toDoListVC.selectedCategory = categoryItems?[indexPath.row]
    }
    
    // MARK: - Add new category
    
    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        var textFieldGlobal = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: nil, preferredStyle: .alert)
        let actionAdd = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let validFieldValue = textFieldGlobal.text else { return }
            let newCategoryItem = CategoryItem()
            newCategoryItem.name = validFieldValue
            
            self.saveData(category: newCategoryItem)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter the name of category"
            textFieldGlobal = textField
        }
        
        alert.addAction(actionAdd)
        alert.addAction(actionCancel)
        present(alert, animated: true)
    }
    
    // MARK: - Data Manipulation Methods
    
    func saveData(category: CategoryItem) {
        do {
            try realm.write {
                realm.add(category)
            }
            
            tableView.reloadData()
        } catch {
            print("Save data error", error)
        }
    }
    
    func loadData() {
        categoryItems = realm.objects(CategoryItem.self)
        tableView.reloadData()
    }
    
    // MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        guard let item = self.categoryItems?[indexPath.row] else { return }
        
        do {
            try self.realm.write {
                self.realm.delete(item)
            }
        } catch {
            print("SwipeTableViewCellDelegate error", error)
        }
    }
}
