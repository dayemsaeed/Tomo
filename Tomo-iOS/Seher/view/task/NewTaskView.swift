//
//  NewTaskView.swift
//  Seher
//
//  Created by Dayem Saeed on 5/24/24.
//

import SwiftUI

/// `NewTaskView` is responsible for allowing users to create a new task by entering a title, date, and selecting a color.
struct NewTaskView: View {
    
    @Environment(\.dismiss) private var dismiss  // Environment dismiss handler to close the view
    @Environment(\.modelContext) private var context  // The model context to manage and save data
    @State private var taskTitle: String = ""  // State variable to store the task's title
    @Binding var taskDate: Date  // Binding variable for the task date passed from the parent view
    @State private var taskColor: String = "TaskColor 1"  // Default task color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Close button to dismiss the view
            Button(action: {
                dismiss()  // Close the view when tapped
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .tint(.red)
            })
            .hSpacing(.leading)  // Custom horizontal spacing for alignment
            
            // Task title input
            VStack(alignment: .leading, spacing: 8) {
                Text("Task Title")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                // TextField for user input of task title
                TextField("Go for a Walk!", text: $taskTitle)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .foregroundStyle(.seherText)
                    .background(.white.shadow(.drop(color: .black.opacity(0.25), radius: 2)), in: .rect(cornerRadius: 10))
            }
            .padding(.top, 5)
            
            // Date and color picker section
            HStack(spacing: 12) {
                // Date picker for task date
                VStack(alignment: .leading, spacing: 8) {
                    Text("Task Date")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    DatePicker("", selection: $taskDate)
                        .datePickerStyle(.compact)
                        .scaleEffect(0.9, anchor: .leading)
                }
                .padding(.trailing, -15)  // Adjusts alignment
                
                // Task color selection (currently using a placeholder)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Task Color")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    // Placeholder for color selection (can be extended)
                    ColorPicker("Select Task Color", selection: .constant(Color(.systemBlue)))
                }
            }
            
            Spacer()  // Pushes save button to the bottom
            
            // Save button for creating a task
            Button(action: {
                saveTask()  // Trigger task saving logic
            }, label: {
                Text("Save Task")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            })
            .padding(.bottom, 20)
        }
        .padding()
    }
    
    /// Saves the task to the model context with the provided title, date, and color.
    private func saveTask() {
        // Logic to save the task can be implemented here
        print("Task saved with title: \(taskTitle) on \(taskDate) with color: \(taskColor)")
    }
}
