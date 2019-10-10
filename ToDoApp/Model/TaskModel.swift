//
//  TaskModel.swift
//  ToDoApp
//
//  Created by Monica on 09/10/19.
//  Copyright © 2019 Monica. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var createdAt = Date()
    @objc dynamic var notes: String = ""
    @objc dynamic var isCompleted = false
}

class TaskList: Object {
    @objc dynamic var title = ""
    @objc dynamic var createdAt = Date()
    let tasks = List<Task>()
}

