//
//  ViewController.swift
//  Todoey
//
//  Created by Ruslan Malinovsky on 22.04.2022.
//

import UIKit
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var itemModel: ItemModel!
    
    var selectedCategory: Category? {
        didSet {
            self.itemModel = ItemModel(parentCategory: selectedCategory!)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let category = selectedCategory, let color = UIColor(hexString: category.hexColor) {
            guard let navBar = navigationController?.navigationBar else {
                fatalError("Navigation controller does not exist.")
            }
            
            title = category.name
            
            navBar.barTintColor = color
            navBar.backgroundColor = color
            searchBar.barTintColor = color
            view.backgroundColor = color
            
            let contrastColor = ContrastColorOf(color, returnFlat: true)
            navBar.tintColor = contrastColor
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: contrastColor]
        }
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField?
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let addItemAction = UIAlertAction(title: "Add Item", style: .default) { alertAction in
            guard let safeTextField = textField else { return }
            guard let safeText = safeTextField.text else { return }
            
            if safeText.isEmpty {
                return
            }
            
            self.itemModel.appendItem(title: safeText)
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(addItemAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Delete from swipes
    override func upadateModel(at indexPath: IndexPath) {
        super.upadateModel(at: indexPath)
        
        itemModel.removeItem(at: indexPath.row)
    }
}

//MARK: - TableView DataSource Methods

extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemModel.itemsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = itemModel.getItem(at: indexPath.row), let category = selectedCategory {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.cellType
            
            let lastItemIndex = itemModel.itemsCount <= 1 ? 1 : itemModel.itemsCount - 1
            let percentage = CGFloat(indexPath.row) / CGFloat(lastItemIndex)
            if let generatedColor = UIColor(hexString: category.hexColor)?.darken(byPercentage: percentage) {
                cell.backgroundColor = generatedColor
                
                let contrastColor = ContrastColorOf(generatedColor, returnFlat: true)
                cell.textLabel?.textColor = contrastColor
                cell.tintColor = contrastColor
            }
        }
        
        return cell
    }
}

//MARK: - TableView Delegate Methods

extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            itemModel.inverseItemMark(at: indexPath.row)
            cell.accessoryType = itemModel.getItem(at: indexPath.row)?.cellType ?? .none
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - Search Bar

extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        
        if searchText.isEmpty {
            return
        }
        
        itemModel.searchItems(searchText: searchText)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            itemModel.loadAllItems()
            tableView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
