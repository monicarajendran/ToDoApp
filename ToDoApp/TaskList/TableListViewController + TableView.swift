//
//  TableViewController + TableView.swift
//  ToDoApp
//
//  Created by Monica on 11/10/19.
//  Copyright © 2019 Monica. All rights reserved.
//

import Foundation
import UIKit

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let listsTasks = lists {
            return listsTasks.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListTableViewCell", for: indexPath)
        let list = lists[indexPath.row]
        cell.textLabel?.text = list.title
        cell.detailTextLabel?.text = "\(list.tasks.count) Tasks"
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //Delete Action
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexPath) in
            let listToDelete = self.lists[indexPath.row]
            self.deleteTaskList(list: listToDelete)
        }
        
        //Edit Action
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            let listToEdit = self.lists[indexPath.row]
            self.showAlert(forList: listToEdit)
        }
        
        return [deleteAction, editAction]
    }
    
}
