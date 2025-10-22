//
//  WatchTask.swift
//  TasksSwiftUI
//
//  Created by Marcos on 21/10/25.
//

import Foundation

struct WatchTask: Identifiable, Hashable, Codable {
    var id: UUID
    var name: String
    var details: String
    var category: TaskCategory
    var isCompleted: Bool
    
    init(id: UUID = UUID(), name: String, details: String, category: TaskCategory, isCompleted: Bool) {
        self.id = id
        self.name = name
        self.details = details
        self.category = category
        self.isCompleted = isCompleted
    }
}
