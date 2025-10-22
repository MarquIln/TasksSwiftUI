//
//  TaskDetailsView.swift
//  TasksSwiftUI
//
//  Created by Marcos on 21/10/25.
//

import SwiftUI
import WidgetKit

struct TaskDetailView: View {
    @State var task: AppTask
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
//            Button {
//                task.isCompleted.toggle()
//            } label: {
//                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
//                    .foregroundStyle(task.isCompleted ? .blue : .gray)
//                    .frame(width: 22, height: 22)
//            }
        }
        .padding(.vertical)
        .navigationTitle("Task")
        .onTapGesture {
            withAnimation {
                connectivity.updatedSelectedTask(selectedTask: taskManager.selectedTask)
                SharedTask.update(task: taskManager.selectedTask)
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
}
