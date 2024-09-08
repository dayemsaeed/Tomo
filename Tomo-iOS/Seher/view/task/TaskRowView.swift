//
//  TaskRowView.swift
//  Seher
//
//  Created by Dayem Saeed on 5/23/24.
//

import SwiftUI

/// `TaskRowView` represents an individual row in a task list, allowing users to view and interact with tasks.
struct TaskRowView: View {
    @Bindable var task: TaskItem  // Bindable object representing a task
    @Environment(\.modelContext) private var context  // Environment variable for accessing the model context

    /// Direct TextField binding causing SwiftData to crash.
    /// Workaround: Use a separate @State variable to store the task title.
    @State private var taskTitle: String = ""
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            // Indicator circle for task completion
            Circle()
                .fill(indicatorColor)
                .frame(width: 10, height: 10)
                .padding(4)
                .background(.white.shadow(.drop(color: .black.opacity(0.1), radius: 3)), in: .circle)
                .overlay {
                    Circle()
                        .foregroundStyle(.clear)
                        .contentShape(.circle)
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            withAnimation(.snappy) {
                                task.isCompleted.toggle()  // Toggle task completion
                            }
                        }
                }

            // TextField for editing task title
            VStack(alignment: .leading, spacing: 8) {
                TextField("Task Title", text: $taskTitle)
                    .font(.system(size: 16))
                    .textFieldStyle(PlainTextFieldStyle())
            }
        }
    }
    
    /// Returns the color used for the task completion indicator.
    private var indicatorColor: Color {
        task.isCompleted ? .green : .gray
    }
}
