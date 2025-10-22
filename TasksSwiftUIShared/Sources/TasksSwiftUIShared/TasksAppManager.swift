//
//  TasksAppManager.swift
//  TasksSwiftUI
//
//  Created by Marcos on 21/10/25.
//

import Foundation

@Observable
class TasksAppManager {
    @MainActor static let shared = TasksAppManager()
    
    var tasks: [AppTask] = []
    var selectedTask: AppTask?
    
    func updatedTasks(tasks: [AppTask]) {
        self.tasks = tasks
        self.selectedTask = tasks.first
    }
    
    func toggleTask() {
        if let index = tasks.firstIndex(where: { $0.name == selectedTask?.name}) {
            tasks[index].isCompleted.toggle()
        }
    }
}
