//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [TodoItem]()
    
    var dataFilePath: URL? {
        get {
            return FileManager.default.urls(
                for: .documentDirectory, in: .userDomainMask).first?
                .appendingPathComponent("todoItems.plist")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemArray.append(contentsOf: [
            TodoItem(title: "Testing 1", done: true),
            TodoItem(title: "Testing 2"),
            TodoItem(title: "Testing 3")
        ])
        
        loadItems()
    }
    
    // MARK: - UITableViewDataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]

        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected item: \(itemArray[indexPath.row])")
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item: ", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            if let text = textField.text, (text != "") {
                print("Added item with text: \(text)")
                
                let item = TodoItem(title: text)
                self.itemArray.append(item)
                
                self.saveItems()
                
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item:"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    // MARK: - Model Manipulation Methods
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            return
        }
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([TodoItem].self, from: data)
            } catch {
                return
            }
        }
    }
}
