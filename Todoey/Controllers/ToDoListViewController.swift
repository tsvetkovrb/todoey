//
//  ViewController.swift
//  Todoey
//
//  Created by Роман Цветков on 06.05.2020.
//  Copyright © 2020 Roman Tsvetkov. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    var itemArray = [TodoItem]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let value = defaults.array(forKey: "ToDoListArray") as? [TodoItem] else { return }
        itemArray = value
        
        let newItem1 = TodoItem()
        newItem1.title = "New item 1"
        itemArray.append(newItem1)
        
        let newItem2 = TodoItem()
        newItem2.title = "New item 2"
        itemArray.append(newItem2)
        
        let newItem3 = TodoItem()
        newItem3.title = "New item 3"
        itemArray.append(newItem3)
        
        let newItem4 = TodoItem()
        newItem4.title = "New item 4"
        newItem4.done = true
        itemArray.append(newItem4)
        
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
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

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
            let newToDoItem = TodoItem()
            newToDoItem.title = newItemTitle
            self.itemArray.append(newToDoItem)
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(submit)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}

