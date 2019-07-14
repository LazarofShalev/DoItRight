//
//  CategoryViewController.swift
//  DoItRight
//
//  Created by Shalev Lazarof on 10/07/2019.
//  Copyright © 2019 Shalev Lazarof. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    // MARK: declare and create a new realm, (!) is because the realm creation in the first time can fail due to limited resources, valid to create like that by realm documentation
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
        
        loadCategories()
        
        super.animate()
        
        // MARK: App FilePath
        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)) 
    }
    
    // MARK: Add new Category
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // MARK: What will happen once the user will press the add button
            
            let newCategory = Category()
            
            newCategory.name = textField.text!
            
            self.saveCategories(category: newCategory)
            super.animate()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // MARK: Return categories.count if categoriec is not nil, else return 1
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "no categories added yet"
        
        if let color = UIColor.flatWhite()?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(categories!.count)) {
            cell.backgroundColor = color
            cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: color, isFlat: true)
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // MARK: Perform the sague
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    // MARK: Prepare the sague, method is initiated before performing the sague in didSelectRowAt method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destenationVC = segue.destination as! ToDoListViewConroller
        
        if let indexPath = tableView.indexPathForSelectedRow {
            // MARK: Set the selectedCategory value in destenationVC to categoryArray[indexPath.row]
            destenationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: Save the data
    func saveCategories(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: Load the data
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    // MARK: Delete data from swipe
    override func updateModels(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryForDeletion)
                }
            } catch {
                print("error when delete \(error)")
            }
        }
    }
}

