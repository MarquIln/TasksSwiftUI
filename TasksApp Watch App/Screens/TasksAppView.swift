//
//  ContentView.swift
//  TasksApp Watch App
//
//  Created by Marcos on 21/10/25.
//

import SwiftUI

struct TasksAppView: View {
    private var connectivity = WatchConnection.shared

    @Environment(TasksAppManager.self) var taskManager

    var body: some View {
        NavigationStack {
            Group {
                if taskManager.tasks.isEmpty {
                    ContentUnavailableView("Launch the app on the iPhone", systemImage: "plus.circle.fill")
                } else {
                    List(taskManager.tasks) { task in
                        NavigationLink(value: task) {
                            TaskRow(task: task)
                        }
                    }
                }
            }
            .navigationDestination(for: Task.self) { task in
                TaskDetailView(task: task)
            }
        }
    }
}

#Preview {
    TasksAppView()
        .environment(TasksAppManager())
}
