//
//  iOSConnectivity.swift
//  TasksSwiftUI
//
//  Created by Marcos on 21/10/25.
//

import Foundation
import WatchConnectivity

class iOSConnectivity: NSObject, WCSessionDelegate {
    static let shared = iOSConnectivity()
    
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
        DispatchQueue.main.async {
            if activationState == .activated {
                if session.isWatchAppInstalled {
                    print("Watch as the app.")
                }
            }
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
    }

    func sessionDidDeactivate(_ session: WCSession) {
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
        if let taskData = try? JSONEncoder().encode(tasks) {
            let tasksPayload: [String: Any] = ["tasks": taskData]
            setContext(to: tasksPayload)
        }
    }
}

