//
//  Task.swift
//  TasksSwiftUI
//
//  Created by Marcos on 05/08/25.
//

import Foundation
import SwiftData

@available(iOS 17, *)
@Model
public final class AppTask: Identifiable, Hashable, Codable {
    public var id: UUID = UUID()
    public var name: String
    public var details: String
    public var category: TaskCategory
    public var isCompleted: Bool = false
    
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

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.details = try container.decode(String.self, forKey: .details)
        self.category = try container.decode(TaskCategory.self, forKey: .category)
        self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(details, forKey: .details)
        try container.encode(category, forKey: .category)
        try container.encode(isCompleted, forKey: .isCompleted)
    }
}

