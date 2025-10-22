//
//  AddItem.swift
//  TasksSwiftUI
//
//  Created by Marcos on 05/08/25.
//

import SwiftUI
import TasksSwiftUIShared

struct AddTask: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    var selectedTask: AppTask?

    @State var name: String = ""
    @State var description: String = ""
    @State var selectedCategory: TaskCategory?
    @State var isCompleted: Bool = false
    @State var showAlert: Bool = false

    var isEditing: Bool {
        selectedTask != nil
    }

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Task")
                                .font(.system(.callout, weight: .semibold))

                            TextField("Your task name here", text: $name)
                                .padding(.horizontal)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundStyle(.backgroundTertiary)
                                )
                        }

                        HStack(spacing: 12) {
                            Image(systemName: "list.bullet")
                                .foregroundStyle(.white)
                                .frame(width: 30, height: 30)
                                .background(
                                    RoundedRectangle(cornerRadius: 7)
                                        .foregroundStyle(.accent)
                                )

                            Text("Category")
                                .padding(.vertical, 11)

                            Spacer()

                            Menu {
                                ForEach(TaskCategory.allCases) { category in
                                    Button(category.rawValue, systemImage: category.imageName) {
                                        selectedCategory = category
                                    }
                                }

                            } label: {
                                HStack {
                                    Text(selectedCategory?.rawValue ?? "Select")
                                    Image(systemName: "chevron.up.chevron.down")
                                }
                            }
                        }
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(.backgroundTertiary)
                        )

                        if isEditing {
                            HStack(spacing: 16) {
                                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(isCompleted ? .accent : .gray3)
                                    .frame(width: 20, height: 20)

                                Text("Status")
                                    .padding(.vertical, 11)

                                Spacer()
                            }
                            .padding(.horizontal)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.backgroundTertiary)
                            )
                            .onTapGesture {
                                isCompleted.toggle()
                            }
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.system(.callout, weight: .semibold))

                            TextField("More details about the task", text: $description, axis: .vertical)
                                .lineLimit(5...10)
                                .padding(.horizontal)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundStyle(.backgroundTertiary)
                                )
                        }
                    }
                }

                if isEditing {
                    Spacer()

                    Button {
                        if let selectedTask {
                            modelContext.delete(selectedTask)
                            dismiss()
                        }
                    } label: {
                        Text("Delete Task")
                            .fontWeight(.semibold)
                            .foregroundStyle(.error)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundStyle(.backgroundTertiary)
                            )
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 40)
            .background(.backgroundSecondary)
            .navigationTitle(!isEditing ? "New Task" : "Task Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.backgroundSheet, for: .navigationBar)
            .toolbarBackgroundVisibility(.visible, for: .navigationBar)
            .alert("Missing Infos", isPresented: $showAlert) {
                Button("Ok", role: .cancel) {}
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    let isUnchanged: Bool = {
                        guard isEditing, let existingTask = selectedTask else { return false }
                        return selectedCategory == existingTask.category
                            && name == existingTask.name
                            && description == existingTask.details
                            && isCompleted == existingTask.isCompleted
                    }()

                    Button(isEditing ? "Done" : "Add") {
                        if let selectedCategory, !name.isEmpty && !description.isEmpty {

                            if let selectedTask {
                                selectedTask.name = name
                                selectedTask.details = description
                                selectedTask.category = selectedCategory
                                selectedTask.isCompleted = isCompleted

                            } else {
                                let newTask = Task(
                                    name: name,
                                    details: description,
                                    category: selectedCategory,
                                    isCompleted: isCompleted
                                )
                                modelContext.insert(newTask)
                                
                            }
                            
                            try? modelContext.save()
                            
                            dismiss()

                        } else {
                            showAlert = true
                        }
                    }
                    .disabled(isUnchanged)
                }

            }
            .onAppear {
                if let selectedTask {
                    name = selectedTask.name
                    description = selectedTask.details
                    selectedCategory = selectedTask.category
                    isCompleted = selectedTask.isCompleted
                }
            }
        }
    }
}
