//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Роман Цветков on 10.05.2020.
//  Copyright © 2020 Roman Tsvetkov. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categoryItems = [CategoryItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    // MARK: - Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let categoryItem = categoryItems[indexPath.row]
        cell.textLabel?.text = categoryItem.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItems.count
    }
    
    // MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let toDoListVC = segue.destination as! ToDoListViewController
        guard let indexPath = tableView.indexPathForSelectedRow else { return }

        toDoListVC.selectedCategory = categoryItems[indexPath.row]
    }
    
    // MARK: - Add new category
    
    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        var textFieldGlobal = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: nil, preferredStyle: .alert)
        let actionAdd = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let validFieldValue = textFieldGlobal.text else { return }
            let newCategoryItem = CategoryItem(context: self.context)
            newCategoryItem.name = validFieldValue
            self.categoryItems.append(newCategoryItem)
            
            self.saveData()
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
    
    func saveData() {
        do {
            try context.save()
            tableView.reloadData()
        } catch {
            print("Save data error", error)
        }
    }
    
    func loadData() {
        let request: NSFetchRequest<CategoryItem> = CategoryItem.fetchRequest()
        do {
            categoryItems =  try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Loading data error", error)
        }
        
    }
    
}
