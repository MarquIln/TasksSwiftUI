//
//  Task.swift
//  TasksSwiftUI
//
//  Created by Marcos on 05/08/25.
//

import Foundation
import SwiftData

@Model
class Task: Identifiable, Hashable, Encodable {
    var id: UUID = UUID()
    var name: String
    var details: String
    var category: TaskCategory
    var isCompleted: Bool = false
    
    init(name: String, details: String, category: TaskCategory, isCompleted: Bool) {
        self.name = name
        self.details = details
        self.category = category
        self.isCompleted = isCompleted
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case details
        case category
        case isCompleted
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(details, forKey: .details)
        try container.encode(category, forKey: .category)
        try container.encode(isCompleted, forKey: .isCompleted)
    }
}
