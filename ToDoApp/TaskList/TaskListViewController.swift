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
    var taskListTitle: String?
    
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
        listOne.modifiedAt = Date()
        
        let taskOne = Task(value: ["name": "Basics", "notes": "Reading Documentation", "createdAt": Date()])
        
        listOne.tasks.append(taskOne)
        
        try? realm.write { () -> Void in
            realm.add(listOne)
        }
    }
    
    func initRealm() {
        do { realm = try Realm() }
        catch { print("Failed to init Realm") }
    }
    
    func addTaskList(withTitle title: String) {
        let taskList = TaskList()
        taskList.title = title
        taskList.createdAt = Date()
        taskList.modifiedAt = Date()
        
        do {
            try realm.write { () -> Void in
                realm.add(taskList)
            }
        } catch { print("Failed to save") }
        self.taskListTableView.reloadData()
    }
    
    func updateTaskList(forList list: TaskList) {
        guard let taskTitle = self.taskListTitle, !taskTitle.isEmpty else { return }
        
        do {
            try realm.write {
                list.title = taskTitle
                list.modifiedAt = Date()
            }
        } catch { print("Failed to update") }
        self.taskListTableView.reloadData()
    }
    
    func deleteTaskList(list: TaskList) {
        do {
            try realm.write { () -> Void in
                realm.delete(list)
            }
        } catch  { print("Failed to delete") }
        self.taskListTableView.reloadData()
    }
    
    func showAlert(forList list: TaskList?) {
        
        var alerttitle: String = ""
        var alertActionTitle: String = ""
        if list != nil {
            alerttitle = "Edit Task List"
            alertActionTitle = "Update"
        } else {
            alerttitle = "New Task List"
            alertActionTitle = "Add"
        }
        let alert = UIAlertController(title: alerttitle, message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: alertActionTitle, style: .default, handler: { (action) in
            
            let textField = alert.textFields?.first
            textField?.autocapitalizationType = .sentences
            
            self.taskListTitle = textField?.text
            
            guard let taskListTitle = self.taskListTitle else { return }
            if let listToEdit = list {
                self.updateTaskList(forList: listToEdit)
            } else {
                self.addTaskList(withTitle: taskListTitle)
            }
        }))
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter title"
            textField.text = list?.title
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addNewTaskList(_ sender: Any) {
        self.showAlert(forList: nil)
    }
    
}
