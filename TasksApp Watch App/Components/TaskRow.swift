//
//  TaskRow.swift
//  TasksSwiftUI
//
//  Created by Marcos on 21/10/25.
//

import SwiftUI
import TasksSwiftUIShared

struct TaskRow: View {
    let task: Task
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: task.category.imageName)
                .foregroundStyle(.blue)
            VStack(alignment: .leading, spacing: 2) {
                Text(task.name)
                    .font(.headline)
                    .lineLimit(1)
                if !task.details.isEmpty {
                    Text(task.details)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            Spacer(minLength: 4)
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(task.isCompleted ? .blue : .secondary)
        }
    }
}
