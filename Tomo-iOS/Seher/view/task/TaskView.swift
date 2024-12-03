//
//  TaskView.swift
//  Tomo
//
//  Created by Dayem Saeed on 10/3/23.
//

import SwiftUI

/// `TaskView` is the main view for displaying a list of tasks along with a calendar view.
/// It allows users to create, edit, and manage tasks.
/// This version presents `NewTaskView` as a full-screen view using navigation,
/// with the navigation button constrained to the bottom of the view.
struct TaskView: View {
    // Environment object for accessing task data from TaskViewModel
    @EnvironmentObject private var viewModel: TaskViewModel

    // Tracks the currently selected date
    @State private var currentDate: Date = Date()

    var body: some View {
        NavigationView {
            ZStack {
                // Main content
                VStack(alignment: .leading, spacing: 0) {
                    // Displays the calendar header with the currently selected date
                    CalendarHeader(currentDate: $currentDate)

                    // Displays the list of tasks
                    TasksListView()
                        .layoutPriority(1)  // Gives priority to the task list when laying out the views
                }
                .vSpacing(.top)  // Custom vertical spacing modifier (ensure this is defined in your project)
                .onAppear {
                    // Fetch tasks when the view appears
                    Task {
                        await viewModel.fetchTasks()
                    }
                }

                // Plus button overlayed at the bottom right as a NavigationLink
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: NewTaskView().environmentObject(viewModel)) {
                            // Plus button content
                            Image(systemName: "plus")
                                .fontWeight(.semibold)
                                .foregroundStyle(.seherCircle)  // Custom foreground style (define `.seherCircle`)
                                .frame(width: 55, height: 55)
                                .background(
                                    Circle()
                                        .fill(Color.seherCircle)  // Custom color (define `Color.seherCircle`)
                                        .shadow(color: .black.opacity(0.25), radius: 5, x: 5, y: 5)
                                )
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitle("Tasks", displayMode: .inline)
            .navigationBarHidden(true)  // Hide navigation bar if you prefer custom styling
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
                        .environmentObject(viewModel)
                }
                .hSpacing(.center)  // Custom horizontal spacing modifier (define `.hSpacing`)
                .vSpacing(.center)  // Custom vertical spacing modifier (define `.vSpacing`)
            }
            .scrollIndicators(.hidden)  // Hides scroll indicators for a cleaner UI
        }
    }
}
