//
//  Header.swift
//  TasksSwiftUI
//
//  Created by Marcos on 06/08/25.
//

import SwiftUI
import TasksSwiftUIShared

struct Header: View {
    var taskCategory: TaskCategory
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: taskCategory.imageName)
                .foregroundStyle(.gray1)
                .frame(width: 28, height: 21)
            
            Text(taskCategory.rawValue.uppercased())
                .foregroundStyle(.labelSecondary)
                .font(.system(.subheadline, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 11)
        .padding(.horizontal)
        .background(.backgroundSecondary)
    }
}

#Preview {
    Header(taskCategory: .education)
}
