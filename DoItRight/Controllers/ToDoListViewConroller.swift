//
//  TableViewController.swift
//  DoItRight
//
//  Created by Shalev Lazarof on 09/07/2019.
//  Copyright © 2019 Shalev Lazarof. All rights reserved.
//

import UIKit

class ToDoListViewConroller: UITableViewController {
    
    // Create a items plist file -> Items plist File Path in order to store Item class objects
    let ItemsPlistdataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
    // MARK: add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // MARK: What will happen once the user will press the add button
            let newItem = Item()
            newItem.title = textField.text!

            self.itemArray.append(newItem)
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.accessoryType = item.done ? .checkmark : .none
        cell.textLabel?.text = item.title

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        self.saveItems()
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            // MARK: Encode the item array in order to write it to the plist file
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.ItemsPlistdataFilePath!)
        } catch {
            print("error encoding item array")
        }
        tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: ItemsPlistdataFilePath!) {
            let decoder = PropertyListDecoder()
            // MARK: Decode the item array from the items plist file
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("error decoding item array")
            }
        }
    }
}
