//
//  ViewController.swift
//  Todoey
//
//  Created by Роман Цветков on 06.05.2020.
//  Copyright © 2020 Roman Tsvetkov. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [ToDoItem]()
    var selectedCategory: CategoryItem? {
        didSet {
            loadStoredItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnBackground))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func tapOnBackground() {
        searchBar.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //        to delete items order is matter
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        saveData()
        tableView.reloadData()
    }
    
    // MARK: - Add new items
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter the name..."
            textField = alertTextField
        }
        
        let submit = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            guard let newItemTitle = textField.text else { return }
            
            let newToDoItem = ToDoItem(context: self.context)
            newToDoItem.title = newItemTitle
            newToDoItem.done = false
            newToDoItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newToDoItem)
            self.saveData()
            
            self.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(submit)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Model manipulation methods
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadStoredItems(with request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest(), predicate: NSPredicate? = nil) {
        guard let selectedCategoryName = selectedCategory?.name else { return }
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategoryName)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("loadStoredItems -> error", error)
        }
    }
}

// MARK: - UISearchBarDelegate

extension ToDoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.contains(" ") { return }
        
        if searchText.count == 0 {
            loadStoredItems()
            return
        }
        
        let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        
        loadStoredItems(with: request, predicate: predicate)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

