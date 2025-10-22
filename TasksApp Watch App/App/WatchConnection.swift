//
//  WatchConnection.swift
//  TasksSwiftUI
//
//  Created by Marcos on 21/10/25.
//

import Foundation
import WatchConnectivity

class WatchConnection: NSObject, WCSessionDelegate {
    static let shared = WatchConnection()

    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: (any Error)?
    ) {
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        let taskManager = TasksAppManager.shared

        if let watchTasks = applicationContext["tasks"] as? Data {
            if let decodedTasks = try? JSONDecoder().decode([WatchTask].self, from: watchTasks) {
                taskManager.tasks = decodedTasks
                taskManager.selectedTask = decodedTasks.first
            } else {
                print("Ih, deu ruim.")
            }
        }
    }

    func setContext(to payload: [String: Any]) {
        let session = WCSession.default

        if session.activationState == .activated {
            do {
                try session.updateApplicationContext(payload)
            } catch {
                print("Error updating context")
            }
        }
    }

    func sendUpdatedTasks(tasks: [WatchTask]) {
        let tasks = tasks.map { Task(
            name: $0.name,
            details: $0.details,
            category: $0.category,
            isCompleted: $0.isCompleted
        )}
        
        if let taskData = try? JSONEncoder().encode(tasks) {
            let tasksPayload: [String: Any] = ["tasks": taskData]
            setContext(to: tasksPayload)
        } else {
            print("Failed to encode WatchTask array")
        }
    }
}
