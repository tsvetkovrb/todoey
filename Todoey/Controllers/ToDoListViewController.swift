//
//  ViewController.swift
//  Todoey
//
//  Created by Роман Цветков on 06.05.2020.
//  Copyright © 2020 Roman Tsvetkov. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    
    var toDoItemsArray: Results<ToDoItem>?
    var selectedCategory: CategoryItem? {
        didSet {
            loadStoredItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnBackground))
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)
        
        self.title = selectedCategory?.name
    }
    
    @objc func tapOnBackground() {
        searchBar.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItemsArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = toDoItemsArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let toDoItem = toDoItemsArray?[indexPath.row] else { return }
        do {
            try realm.write {
                toDoItem.done = !toDoItem.done
            }
        } catch {
            print(error)
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
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
            
            guard let currentCategory = self.selectedCategory else { return }
            
            do {
                try self.realm.write {
                    let newToDoItem = ToDoItem()
                    newToDoItem.title = newItemTitle
                    newToDoItem.dateCreated = Date()
                    currentCategory.items.append(newToDoItem)
                    self.tableView.reloadData()
                }
            } catch {
                print("addNewItem error", error)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(submit)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Model manipulation methods
    
    func loadStoredItems() {
        toDoItemsArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        guard let toDoItem = toDoItemsArray?[indexPath.row] else { return }
        
        do {
            try realm.write {
                realm.delete(toDoItem)
            }
        } catch {
            print("ToDoListViewController", error)
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
        
        toDoItemsArray = toDoItemsArray?.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}
