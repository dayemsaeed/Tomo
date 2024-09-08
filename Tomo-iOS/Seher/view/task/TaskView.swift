//
//  TaskView.swift
//  Tomo
//
//  Created by Dayem Saeed on 10/3/23.
//

import SwiftUI

/// `TaskView` is the main view for displaying a list of tasks along with a calendar view.
/// It allows users to create, edit, and manage tasks.
struct TaskView: View {
    @State private var showEditView = false  // Controls the visibility of the task edit view
    @EnvironmentObject private var viewModel: TaskViewModel  // Environment object for accessing task data
    @Environment(\.presentationMode) var presentationMode  // Used to control the presentation mode of the view
    @State private var createNewTask: Bool = false  // Controls the visibility of the "New Task" sheet
    @State private var currentDate: Date = .init()  // Tracks the currently selected date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Displays the calendar header with the currently selected date
            CalendarHeader(currentDate: $currentDate)
            
            // Displays the list of tasks
            TasksListView()
                .layoutPriority(1)  // Ensures the task list gets priority when laying out
        }
        .vSpacing(.top)
        .overlay(alignment: .bottomTrailing, content: {
            // Button to add a new task
            Button(action: {
                createNewTask.toggle()  // Toggles the visibility of the "New Task" sheet
            }, label: {
                Image(systemName: "plus")
                    .fontWeight(.semibold)
                    .foregroundStyle(.seherCircle)
                    .frame(width: 55, height: 55)
                    .background(.seherCircle.shadow(.drop(color: .black.opacity(0.25), radius: 5, x: 10, y: 10)), in: .circle)
            })
        })
        .sheet(isPresented: $createNewTask, content: {
            // Presents the "New Task" sheet when `createNewTask` is true
            NewTaskView(taskDate: $currentDate)
                .presentationDetents([.height(300)])  // Set the height of the presentation
                .interactiveDismissDisabled()  // Prevents dismissing by dragging
                .presentationCornerRadius(30)  // Rounded corners for the sheet
                .presentationBackground(.BG)  // Custom background for the sheet
        })
    }

    /// A view that displays a scrollable list of tasks for the selected date.
    @ViewBuilder
    func TasksListView() -> some View {
        GeometryReader { geometry in
            let size = geometry.size
            ScrollView(.vertical) {
                VStack {
                    // Custom task list component
                    TasksList(size: size, currentDate: $currentDate)
                }
                .hSpacing(.center)
                .vSpacing(.center)
            }
            .scrollIndicators(.hidden)  // Hides scroll indicators for a cleaner UI
        }
    }
}
