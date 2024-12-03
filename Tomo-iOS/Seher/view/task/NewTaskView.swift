//
//  NewTaskView.swift
//  Seher
//
//  Created by Dayem Saeed on 5/24/24.
//

import SwiftUI

struct NewTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: TaskViewModel
    @State private var taskTitle: String = ""
    @State private var taskDate: Date = Date()
    @State private var taskDescription: String = ""
    @State private var taskColor: String = "TaskColor 1"
    @State private var showColorPicker: Bool = false  // Controls color palette visibility

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Navigation Bar
            HStack {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.blue)
                })
                Spacer()
                Text("New Task")
                    .font(.headline)
                Spacer()
                // Placeholder for alignment
                Spacer().frame(width: 44)
            }
            .padding(.horizontal)

            // Task Title Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Task Title")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("Enter task title", text: $taskTitle)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.seherCircle, lineWidth: 2)
                    )
            }
            .padding(.horizontal)

            // Task Date/Time Picker
            VStack(alignment: .leading, spacing: 8) {
                Text("Task Date & Time")
                    .font(.caption)
                    .foregroundColor(.gray)
                DatePicker("Select Date & Time", selection: $taskDate)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .padding()
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal)

            // Task Description Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Task Description")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextEditor(text: $taskDescription)
                    .frame(height: 100)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.seherCircle, lineWidth: 2)
                    )
            }
            .padding(.horizontal)

            // Color Palette
            VStack(alignment: .leading, spacing: 8) {
                Text("Task Color")
                    .font(.caption)
                    .foregroundColor(.gray)
                HStack(spacing: 15) {
                    ForEach(taskColors, id: \.self) { colorName in
                        Circle()
                            .fill(colorFromName(colorName))
                            .frame(width: 30, height: 30)
                            .overlay(
                                Circle()
                                    .stroke(taskColor == colorName ? Color.seherCircle : Color.clear, lineWidth: 4)
                            )
                            .onTapGesture {
                                taskColor = colorName
                            }
                    }
                }
            }
            .padding(.horizontal)

            Spacer()

            // Save Button
            Button(action: {
                saveTask()
            }, label: {
                Text("Save Task")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.seherCircle)
                    .cornerRadius(10)
            })
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .navigationBarHidden(true)
    }

    // List of available colors
    let taskColors = ["TaskColor 1", "TaskColor 2", "TaskColor 3", "TaskColor 4", "TaskColor 5"]

    // Function to map color names to actual colors
    func colorFromName(_ name: String) -> Color {
        switch name {
        case "TaskColor 1": return .taskColor1
        case "TaskColor 2": return .taskColor2
        case "TaskColor 3": return .taskColor3
        case "TaskColor 4": return .taskColor4
        case "TaskColor 5": return .taskColor5
        default: return .black
        }
    }

    // Function to map color names to color values for storage
    private func colorValueFromName(_ name: String) -> Int64 {
        switch name {
        case "TaskColor 1": return 1
        case "TaskColor 2": return 2
        case "TaskColor 3": return 3
        case "TaskColor 4": return 4
        case "TaskColor 5": return 5
        default: return 1
        }
    }

    // Function to save the task
    private func saveTask() {
        guard let userId = viewModel.getCurrentUserId() else {
            print("Error: User not authenticated")
            return
        }
        
        let newTask = TaskItem(
            taskTitle: taskTitle,
            creationDate: taskDate,
            description: taskDescription,
            isCompleted: false,
            colorValue: colorValueFromName(taskColor),
            createdBy: userId
        )

        Task {
            do {
                try await viewModel.storeTask(task: newTask)
                await viewModel.fetchTasks()
                dismiss()
            } catch {
                print("Error saving task: \(error.localizedDescription)")
                // TODO: Add error handling UI
            }
        }
    }
}
