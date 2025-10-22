//
//  TabBar.swift
//  TasksSwiftUI
//
//  Created by Marcos on 05/08/25.
//

import SwiftUI

struct TabBar: View {
    var body: some View {

        TabView {
            Tab("Tasks", systemImage: "list.bullet.rectangle.portrait.fill") {
                NavigationStack {
                    Tasks()
                }
            }

            Tab("Profile", systemImage: "person.fill") {
                NavigationStack {
                    Profile()
                }
            }
        }
    }
}

#Preview {
    TabBar()
}
