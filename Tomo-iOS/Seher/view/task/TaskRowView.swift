//
//  TaskRowView.swift
//  Seher
//
//  Created by Dayem Saeed on 5/23/24.
//

import SwiftUI

/// `TaskRowView` represents an individual row in a task list, allowing users to view and interact with tasks.
struct TaskRowView: View {
    @ObservedObject var task: TaskItem  // Observing the TaskItem object
    @EnvironmentObject private var viewModel: TaskViewModel  // Accessing TaskViewModel

    /// Direct TextField binding causing SwiftData to crash.
    /// Workaround: Use a separate @State variable to store the task title.
    @State private var taskTitle: String = ""
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            // Restored original circle indicator
            Circle()
                .fill(indicatorColor)
                .frame(width: 10, height: 10)
                .padding(4)
                .background(
                    Circle()
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 3)
                )
                .overlay {
                    Circle()
                        .foregroundStyle(.clear)
                        .contentShape(.circle)
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            withAnimation(.snappy) {
                                task.isCompleted.toggle()
                                // Update in Supabase
                                Task {
                                    await viewModel.updateTaskCompletion(task: task)
                                }
                            }
                        }
                }

            // Task content with new styling
            VStack(alignment: .leading, spacing: 4) {
                Text(taskTitle)
                    .font(.system(size: 16))
                    .strikethrough(task.isCompleted)
                    .onAppear {
                        taskTitle = task.taskTitle
                    }
                    .bold()
                
                Text(task.creationDate, style: .time)
                    .font(.caption)
                    .strikethrough(task.isCompleted)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(task.tintColor.opacity(0.65))
            )
        }
    }
    
    private var indicatorColor: Color {
        task.isCompleted ? .green : .gray
    }
}
