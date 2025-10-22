//
//  ContentView.swift
//  TasksSwiftUI
//
//  Created by Marcos on 05/08/25.
//

import SwiftData
import SwiftUI

struct Tasks: View {

    @Environment(\.modelContext) var modelContext

    @State var editTask: AppTask?
    @State private var addTask: Bool = false

    @Query var tasks: [AppTask]

    private let connectivity = IOSConnection.shared

    var groupedTasks: [TaskCategory: [AppTask]] {
        Dictionary(grouping: tasks, by: { $0.category })
    }

    var sortedCategories: [TaskCategory] {
        groupedTasks.keys.sorted(by: { $0.rawValue < $1.rawValue })
    }

    @State private var id = UUID()

    var body: some View {
        VStack {
            if tasks.isEmpty {
                EmptyState(addTask: $addTask)
                    .padding(.horizontal)
            } else {
                List(sortedCategories) { category in
                    if let categoriesTask = self.groupedTasks[category] {

                        Header(taskCategory: category)
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden, edges: .bottom)
                            .padding(.top, 20)

                        ForEach(categoriesTask) { task in
                            Button {
                                editTask = task
                            } label: {
                                TaskView(task: task)
                            }
                            .listRowInsets(EdgeInsets())
                            .swipeActions(edge: .trailing) {
                                Button("Delete", systemImage: "trash", role: .destructive) {
                                    modelContext.delete(task)
                                    try? modelContext.save()
                                }
                            }
                            .onChange(of: task.isCompleted) { _, _ in
                                connectivity.sendUpdatedTasks(tasks: tasks)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Tasks")
        .navigationBarTitleDisplayMode(.large)
        .background(.backgroundPrimary)
        .toolbarBackground(.backgroundSecondary, for: .tabBar)
        .toolbarBackgroundVisibility(.visible, for: .tabBar)
        .toolbarBackground(.backgroundPrimary, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    addTask = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $addTask) {
            AddTask()
                .presentationDragIndicator(.visible)
        }
        .sheet(item: $editTask) { task in
            AddTask(selectedTask: task)
        }
        .onChange(of: tasks) { _, newTasks in
            connectivity.sendUpdatedTasks(tasks: tasks)
        }
        .task {
            connectivity.sendUpdatedTasks(tasks: tasks)
        }
    }
}

#Preview {
    TabBar()
}
