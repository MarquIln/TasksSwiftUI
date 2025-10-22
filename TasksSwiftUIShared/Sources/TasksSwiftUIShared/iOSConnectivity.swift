//
//  iOSConnectivity.swift
//  TasksSwiftUI
//
//  Created by Marcos on 21/10/25.
//

import Foundation
import WatchConnectivity

class iOSConnectivity: NSObject, WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }

    func sessionDidDeactivate(_ session: WCSession) {
    }

    @MainActor static let shared = iOSConnectivity()
    
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
        if activationState == .activated {
            if WCSession.default.isWatchAppInstalled {
                print("Watch app is installed.")
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        let tasksData = applicationContext["tasks"] as? Data
        
        Task { @MainActor in
            let taskManager = TasksAppManager.shared
            
            if let watchTasks = tasksData {
                if let decodedTasks = try? JSONDecoder().decode([AppTask].self, from: watchTasks) {
                    taskManager.tasks = decodedTasks
                    taskManager.selectedTask = decodedTasks.first
                } else {
                    print("Ih, deu ruim.")
                }
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
        if let taskData = try? JSONEncoder().encode(tasks) {
            let tasksPayload: [String: Any] = ["tasks": taskData]
            setContext(to: tasksPayload)
        }
    }
}

