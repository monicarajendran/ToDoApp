//
//  TaskListViewController.swift
//  ToDoApp
//
//  Created by Monica on 09/10/19.
//  Copyright © 2019 Monica. All rights reserved.
//

import UIKit
import RealmSwift

class TaskListViewController: UIViewController {

    var realm: Realm!
    var lists: Results<TaskList>!
    var taskListTitleTextField: String?
    
    @IBOutlet weak var taskListTableView: UITableView! {
        didSet {
            taskListTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.initRealm()
//        self.adddummyTask()
        self.readTaskAndUpdateUI()
    }
    
    func setup() {
        self.navigationController?.navigationBar.topItem?.title = "Task Lists"
    }
    
    func readTaskAndUpdateUI() {
        lists = realm.objects(TaskList.self)
        taskListTableView.reloadData()
    }
    
    func adddummyTask() {
        let listOne = TaskList()
        listOne.title = "Introduction to Realm"
        listOne.createdAt = Date()
        
        let taskOne = Task(value: ["name": "Basics", "notes": "Reading Documentation", "createdAt": Date()])
        
        listOne.tasks.append(taskOne)
        
        try? realm.write { () -> Void in
            realm.add(listOne)
        }
    }
    
    func addTaskList(withTitle title: String) {
        let taskList = TaskList()
        taskList.title = title
        taskList.createdAt = Date()
        
        do {
            try realm.write { () -> Void in
                realm.add(taskList)
            }
        } catch {
            print("Failed to save")
        }
    }
    
    func deleteTaskList(list: TaskList) {
        do {
            try realm.write { () -> Void in
                realm.delete(list)
            }
        } catch  {
            print("Failed to delete")
        }
    }
    
    func initRealm() {
        do {
            realm = try Realm()
        } catch {
            print("Failed to init Realm")
        }
    }
    
    @IBAction func addNewTaskList(_ sender: Any) {
        let alert = UIAlertController(title: "New Task List", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            
            let textField = alert.textFields?.first
            textField?.autocapitalizationType = .sentences
            
            self.taskListTitleTextField = textField?.text
            
            guard let taskListTitle = self.taskListTitleTextField else { return }
            self.addTaskList(withTitle: taskListTitle)
            self.taskListTableView.reloadData()
        }))
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter title"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

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
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexPath) in
            let listToDelete = self.lists[indexPath.row]
            self.deleteTaskList(list: listToDelete)
            self.taskListTableView.reloadData()
        }
        return [deleteAction]
    }
    
}
