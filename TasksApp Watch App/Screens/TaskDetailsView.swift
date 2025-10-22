//
//  TaskDetailsView.swift
//  TasksSwiftUI
//
//  Created by Marcos on 21/10/25.
//

import SwiftUI

struct TaskDetailView: View {
    @State var task: Task
    var connectivity = WatchConnection.shared
    @Environment(TasksAppManager.self) var taskManager
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: task.category.imageName)
                .font(.title2)
                .foregroundStyle(.blue)
            Text(task.name)
                .font(.headline)
                .multilineTextAlignment(.center)
            if !task.details.isEmpty {
                Text(task.details)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical)
        .navigationTitle("Task")
    }
}
