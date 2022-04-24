//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ruslan Malinovsky on 24.04.2022.
//

import UIKit
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    private var categoryModel = CategoryModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryModel.loadAllCategories()
        
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist.")
        }
        
        navBar.barTintColor = .none
        navBar.backgroundColor = .none
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField?
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let addItemAction = UIAlertAction(title: "Add Category", style: .default) { alertAction in
            guard let safeTextField = textField else { return }
            guard let safeText = safeTextField.text else { return }
            
            if safeText.isEmpty {
                return
            }
            
            self.categoryModel.appendCategory(name: safeText)
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        alert.addAction(addItemAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Delete from swipes
    
    override func upadateModel(at indexPath: IndexPath) {
        super.upadateModel(at: indexPath)
        
        categoryModel.removeCategory(at: indexPath.row)
    }
    
    //MARK: - Prepare for segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != K.Segues.goToItems {
            return
        }
        
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        
        let destinationVC = segue.destination as! ToDoListViewController
        destinationVC.selectedCategory = categoryModel.getCategory(at: indexPath.row)
    }
}

//MARK: - Table view data source

extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryModel.categoryItemsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categoryModel.getCategory(at: indexPath.row) {
            cell.textLabel?.text = category.name
            
            guard let color = UIColor(hexString: category.hexColor) else {
                fatalError("Couldn't convert hex color \(category.hexColor)!")
            }
            
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        
        return cell
    }
}

//MARK: - Table view delegate

extension CategoryViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.Segues.goToItems, sender: self)
    }
}

