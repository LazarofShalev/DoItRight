//
//  TableViewController.swift
//  DoItRight
//
//  Created by Shalev Lazarof on 09/07/2019.
//  Copyright © 2019 Shalev Lazarof. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewConroller: UITableViewController {
    
    // MARK: ViewContext in order to save and read from the persistentContainer
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        // MARK: Once selectedCategory get set with a value the didSet will initiate
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: App FilePath
        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    // MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // MARK: What will happen once the user will press the add button
            
            // MARK: Item entity in Data Model represents a Table in the persistentContainer, by creating new Item(newItem) the Table updated with a new "row" (newItem represents a row) in the persistentContainer view context
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            
            // MARK: Set the parent Category of the newItem in order to filter the results once load items
            newItem.parentCategory = self.selectedCategory
            
            // MARK: Once finish updating the item array, save -> context.save update the persistentContainer than reload data of the table view
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
    
    // MARK: - Table view methods
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
        // MARK: All the Item objects in itemArray are NSmanaged Objects, once changed (done property update from true to false etc..) the context need to save in order to commit the changes to the persistentContainer 
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        
        // MARK: Once finish updating the item array, save -> context.save update the persistentContainer than reload data of the table view
        self.saveItems()
    }
    
    // MARK: Save the data
    func saveItems() {
        do {
            try self.context.save()
        } catch {
           print("error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: Load the data
    // MARK: Default request value is Item.fetchRequest() in case not provided
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        
        // MARK: Set the CategoryPredicate in order to fetch relevant Items (item.parentCategory = self.selectedCategory)
        let CategoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let AdditionPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [CategoryPredicate, AdditionPredicate])
        } else {
            request.predicate = CategoryPredicate
        }
        
        do {
            self.itemArray = try context.fetch(request)
        } catch {
            print("error trying to fetch data from context \(error)")
        }
        tableView.reloadData()
    }
}

// MARK: Search Bar Methods
extension ToDoListViewConroller : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //MARK: Create a request
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // MARK: Create The predicate
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // MARK: Create the sortDescriptor and add to the request
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        // MARK: Call loadItems
        loadItems(with : request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

