//
//  ViewController.swift
//  MyInventory
//
//  Created by Jack Pettit on 4/14/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import UIKit

class ItemListViewController: UITableViewController, AddItemDelegate {

    var user: User = User()
    
    private let UPDATEITEMID: String = "updateItem"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.rowHeight = 64
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addItemdest = segue.destination as? AddItemViewController {
            addItemdest.delegate = self
        }
        /*
        else if let updateItemDest = segue.destination as? {
            
        }
         */
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.getItemCount()
    }
    
    // Decorate cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as? ItemTableCell
        else { return UITableViewCell() }
        
        
        
        let item: Item? = user.item(at: indexPath.row)
            
        cell.decorate(with: item)
        
        return cell
    }
    
    // For table row actions
    
    /*
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let update = UITableViewRowAction(style: .normal, title: "Update") { action, index in
            //action.backgroundColor = UIColor.green
            print("Updating item at index \(index.row)")
            //performSe
        }
        update.backgroundColor = UIColor.green
        return [update]
    }
     */
    
    // For updating an item
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: UPDATEITEMID, sender: indexPath.row)
    }
    
    func refreshTable() {
        tableView.reloadData()
    }
    
    func addItem(item: Item) {
        user.add(item: item)
        refreshTable()
    }
}
