//
//  ViewController.swift
//  Todoey
//
//  Created by Роман Цветков on 06.05.2020.
//  Copyright © 2020 Roman Tsvetkov. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    var temp = ["Test", "Hello"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temp.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = temp[indexPath.row]
        return cell
    }

}

