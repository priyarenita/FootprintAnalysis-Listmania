//
//  MyListsViewController.swift
//  Listmania
//
//  Created by Renita Priya on 11/19/16.
//  Copyright © 2016 Renita Priya. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import FootprintAnalytics

class MyListsViewController: UITableViewController {
    
    
    // MARK: Properties
    var items: [ListItem] = []
    let ref = FIRDatabase.database().reference(withPath: "list-items")
    let refUniqueList = FIRDatabase.database().reference(withPath: "unique-list-items")
    let footprint:FootprintAnalytics = FootprintAnalytics(appName: "iPhone6", view: "MyListsViewController")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ref.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
            var newItems: [ListItem] = []
            
            for item in snapshot.children {
                let listItem = ListItem(snapshot: item as! FIRDataSnapshot)
                newItems.append(listItem)
            }
            
            self.items = newItems
            self.tableView.reloadData()
        })
        
    

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: UITableView Delegate methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let listItem = items[indexPath.row]
        
        cell.textLabel?.text = listItem.name
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            footprint.addTracking(name: "delete swipe left", type: "swipe", time: Date())
            
            let listItem = items[indexPath.row]
            let listItemName = listItem.name
            refUniqueList.child(listItemName).removeValue()
            listItem.ref?.removeValue()
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        footprint.addTracking(name: "table cell selected", type: "tap", time: Date())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        
        let destinationVC = segue.destination as? UniqueListViewController
        let selectedRow = self.tableView.indexPath(for: cell)?.row
        let selectedListName = items[selectedRow!].name
        destinationVC?.uniqueListName = selectedListName
        
    }
    
    

    
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.black
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor.gray
        }
    }
    
    
    
     // MARK: Add Item
    
    @IBAction func addButtonTouched(_ sender: Any) {
        footprint.addTracking(name: "add new list button", type: "tap", time: Date())
        
        let alert = UIAlertController(title: "Create new List",
                                      message: "Type the name of your list",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
               self.footprint.addTracking(name: "new list saved", type: "tap", time: Date())
                                        
                guard let textField = alert.textFields?.first,
                let text = textField.text else { return }

                let listItem = ListItem(name: text,
                                        completed: false)

                let listItemRef = self.ref.child(text.lowercased())

                listItemRef.setValue(listItem.toAnyObject())
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default){
                                            action in
            self.footprint.addTracking(name: "new list canceled", type: "tap", time: Date())
                             
        }
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)

        
        
    }
    
    
    
    
}


