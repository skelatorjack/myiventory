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
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.getItemCount()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as? ItemTableCell
        else { return UITableViewCell() }
        
        
        
        let item: Item? = user.item(at: indexPath.row)
            
        cell.decorate(with: item)
        
        return cell
    }
    
    func refreshTable() {
        tableView.reloadData()
    }
    
    func addItem(item: Item) {
        user.add(item: item)
        refreshTable()
    }
}
