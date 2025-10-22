//
//  TasksAppManager.swift
//  TasksSwiftUI
//
//  Created by Marcos on 21/10/25.
//

import Foundation

@Observable
class TasksAppManager {
    static let shared = TasksAppManager()
    
    var tasks: [AppTask] = []
    var selectedTask: AppTask?

    func updatedTasks(tasks: [AppTask]) {
        self.tasks = tasks
        self.selectedTask = tasks.first
    }
}
