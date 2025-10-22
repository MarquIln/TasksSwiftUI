//
//  WatchConnection.swift
//  TasksSwiftUI
//
//  Created by Marcos on 21/10/25.
//

import Foundation
import WatchConnectivity

@available(iOS 17, *)
class WatchConnection: NSObject, WCSessionDelegate {
    @MainActor static let shared = WatchConnection()

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
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }

    func sessionDidDeactivate(_ session: WCSession) {
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        let tasksData: Data? = applicationContext["tasks"] as? Data

        Task { @MainActor in
            guard let tasksData else { return }

            let taskManager = TasksAppManager.shared
            if let decodedTasks = try? JSONDecoder().decode([AppTask].self, from: tasksData) {
                taskManager.tasks = decodedTasks
                taskManager.selectedTask = decodedTasks.first
            } else {
                print("Failed to decode tasks from Watch applicationContext")
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

    func sendUpdatedTasks(tasks: [AppTask]) {
        let tasks = tasks.map { AppTask(
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

