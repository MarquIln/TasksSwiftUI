//
//  TasksAppApp.swift
//  TasksApp Watch App
//
//  Created by Marcos on 21/10/25.
//

import SwiftUI

@main
struct TasksApp_Watch_AppApp: App {
    @State private var tasksManager = TasksAppManager.shared
    
    var body: some Scene {
        WindowGroup {
            TasksAppView()
                .environment(tasksManager)
        }
    }
}
