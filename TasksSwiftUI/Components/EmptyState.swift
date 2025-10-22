//
//  EmptyState.swift
//  TasksSwiftUI
//
//  Created by Marcos on 05/08/25.
//

import SwiftUI

struct EmptyState: View {
    
    @Binding var addTask: Bool
    
    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 8) {
                Image(.emptyState)
                    .resizable()
                    .frame(width: 92, height: 72)
                
                VStack(spacing: 16) {
                    Text("No tasks yet!")
                        .foregroundStyle(.labelPrimary)
                        .font(.system(.title2, weight: .semibold))

                    Text("add a new task and it will show up here!")
                        .foregroundStyle(.labelSecondary)
                }
            }
            
            Button {
                addTask = true
            } label: {
                Text("Add new Task")
                    .font(.system(.body, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.accent)
                    )
            }
        }
    }
}

#Preview {
    EmptyState(addTask: .constant(false))
}
