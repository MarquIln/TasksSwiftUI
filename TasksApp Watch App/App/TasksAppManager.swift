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
    
    var tasks: [WatchTask] = []
    var selectedTask: WatchTask?
    
    func updatedTasks(tasks: [WatchTask]) {
        self.tasks = tasks
        self.selectedTask = tasks.first
    }
    
    func toggleTask() {
        if let index = tasks.firstIndex(where: { $0.name == selectedTask?.name}) {
            tasks[index].isCompleted.toggle()
        }
    }
}
