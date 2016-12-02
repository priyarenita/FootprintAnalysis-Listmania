//
//  UniqueListViewController.swift
//  Listmania
//
//  Created by Renita Priya on 11/19/16.
//  Copyright © 2016 Renita Priya. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import FootprintAnalytics

class UniqueListViewController: UITableViewController {
    
    
    
    // MARK: Properties
    var items: [UniqueListItem] = []
    var uniqueListName:String?
    let ref = FIRDatabase.database().reference(withPath: "list-items")
    let refUniqueList = FIRDatabase.database().reference(withPath: "unique-list-items")
    
    let footprint:FootprintAnalytics = FootprintAnalytics(appName: "iPhone6",view: "UniqueListsViewController")

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = uniqueListName
        
        refUniqueList.child(uniqueListName!).queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
            var newItems: [UniqueListItem] = []
            
            for item in snapshot.children{
                let uniqueListItem = UniqueListItem(snapshot: item as! FIRDataSnapshot)
                newItems.append(uniqueListItem)
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
        
        toggleCellCheckbox(cell, isCompleted: listItem.completed)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            footprint.addTracking(name: "delete swipe left", type: "swipe", time: Date())
            let listItem = items[indexPath.row]
            listItem.ref?.removeValue()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        footprint.addTracking(name: "table cell toggled", type: "tap", time: Date())

        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let listItem = items[indexPath.row]
        let toggledCompletion = !listItem.completed
        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        listItem.ref?.updateChildValues([
            "completed": toggledCompletion
            ])
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
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        footprint.addTracking(name: "add new list button", type: "tap", time: Date())
        let alert = UIAlertController(title: "New Item",
                                      message: "Add an item to your \(uniqueListName) list",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
            self.footprint.addTracking(name: "new list saved", type: "tap", time: Date())

            guard let textField = alert.textFields?.first,
            let text = textField.text else { return }
                                        
            let uniqueListItem = UniqueListItem(name: text,
                                                completed: false)
                                        
           let uniquelistItemRef = self.refUniqueList.child((self.uniqueListName?.lowercased())!).child(text.lowercased())

                                        
            uniquelistItemRef.setValue(uniqueListItem.toAnyObject())
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default){action in
             self.footprint.addTracking(name: "new list canceled", type: "tap", time: Date())
                                            
        }
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        

    }
    
    
    
    
    
}
