//
//  SharedTask.swift
//  TasksSwiftUI
//
//  Created by Marcos on 22/10/25.
//

import Foundation

class SharedTask {
    static let defaultsGroup: UserDefaults? = UserDefaults(suiteName: "group.br.academy.marcos.TasksApp")
    static let key = "task"
    
    static func update(task: AppTask?) {
        if let task {
            if let taskData = try? JSONEncoder().encode(task) {
                let taskJSON = String(data: taskData, encoding: .utf8)
                
                defaultsGroup?.set(taskJSON, forKey: key)
            }
        }
    }
    
    static func getTask() -> AppTask? {
        if let taskJSON = defaultsGroup?.string(forKey: key) {
            let taskData = Data(taskJSON.utf8)
            
            return try? JSONDecoder().decode(AppTask.self, from: taskData)
        }
        
        return nil
    }
}
