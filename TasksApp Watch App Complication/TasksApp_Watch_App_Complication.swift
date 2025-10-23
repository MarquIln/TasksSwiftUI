//
//  TasksApp_Watch_App_Complication.swift
//  TasksApp Watch App Complication
//
//  Created by Marcos on 22/10/25.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WatchTaskEntry {
        WatchTaskEntry(date: Date(), task: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (WatchTaskEntry) -> Void) {
        let currentDate = Date.now
        let task = SharedTask.getTask()
        
        let entry = WatchTaskEntry(date: currentDate, task: task)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let currentDate = Date()
        
        let task = SharedTask.getTask()
        
        let entry = WatchTaskEntry(date: currentDate, task: task)
        
        let timelineEntry = Timeline(entries: [entry], policy: .never)
        
        completion(timelineEntry)
    }
}

struct WatchTaskEntry: TimelineEntry {
    let date: Date
    let task: AppTask?
}

struct TasksApp_Watch_App_ComplicationEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        if entry.task == nil {
            Image(.smallComplication)
        } else {
            Image(systemName: "\(entry.task!.category.imageName)")
                .padding()
        }
    }
}

struct TasksApp_Watch_App_Complication: Widget {
    let kind: String = "TasksApp_Watch_App_Complication"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TasksApp_Watch_App_ComplicationEntryView(entry: entry)
                .containerBackground(.fill.secondary, for: .widget)
        }
        .configurationDisplayName("My Tasks")
        .description("Launch my Tasks from the watch")
        .supportedFamilies([.accessoryCircular])
    }
}

#Preview(as: .accessoryRectangular) {
    TasksApp_Watch_App_Complication()
} timeline: {
    WatchTaskEntry(date: .now, task: nil)
}
