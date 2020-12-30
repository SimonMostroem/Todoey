//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Simon Mostrøm Nielsen on 19/11/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    //looking for documents direcotry and creating path for our own .plist
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
            guard let navBar = navigationController?.navigationBar else {
                fatalError("Navigation controller does not exist")
            }
            
            let navBarColor = UIColor(hexString: "1D9BF6")
                navBar.backgroundColor = navBarColor
            
            
        
        
    }
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //returning one row as default if categories is nil
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let category = categories?[indexPath.row]
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        cell.textLabel?.text = category?.name
        //let color = UIColor.randomFlat().hexValue()
//        if let color = category?.color {
        if let uiColor = UIColor(hexString: category?.color ?? "1D9BF6") {
        cell.backgroundColor = uiColor
        cell.textLabel?.textColor = ContrastColorOf(uiColor, returnFlat: true)

}
        //cell.delegate = self
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender:  self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        //Saving the new item to the array
        //let encoder = PropertyListEncoder()
        
        do {
            //try context.save()
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
        // }
    }
    
    func loadCategories() { //= Item.fetchRequest being the default value, if function is called without arguments
        
        categories = realm.objects(Category.self)
        
        //        Core Data
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //
        //        do {
        //            categories = try context.fetch(request)
        //
        //        } catch {
        //            print("There was an error fetching data \(error)")
        //        }
        tableView.reloadData()
    }
    //MARK: - Delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
                
            } catch {
                print("Error deleting category \(error)")
            }
        }
    }
    
    //MARK: - Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            //if textField != nil {
            
            //print("addbuttonpressed - Category")
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            
            //Results type is autoupdating. Below line is irrelevant
            //self.categories.append(newCategory)
            
            self.save(category: newCategory)
            
        }
        alert.addTextField { (field) in
            field.placeholder = "Create catgory"
            textField = field
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
}
//MARK: - SwipeCell
