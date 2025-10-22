//
//  TasksSwiftUIApp.swift
//  TasksSwiftUI
//
//  Created by Marcos on 05/08/25.
//

import SwiftUI
import SwiftData

@main
struct TasksSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            TabBar()
        }
        .modelContainer(for: Task.self)
    }
}

#Preview {
    TabBar()
}
