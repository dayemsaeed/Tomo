//
//  TasksList.swift
//  Seher
//
//  Created by Dayem Saeed on 5/24/24.
//

import SwiftUI
import SwiftData

/// `TasksList` is responsible for displaying a list of tasks for a selected date.
/// It queries the tasks based on the creation date and displays each task in a `TaskRowView`.
struct TasksList: View {
    var size: CGSize  // The size of the parent view, used for layout adjustments
    @Binding var currentDate: Date  // The currently selected date for which tasks are shown

    /// SwiftData Dynamic Query to fetch the list of tasks for the current date
    @Query private var tasks: [TaskItem]

    /// Initializes the `TasksList` with a size and a binding to the current date.
    /// - Parameters:
    ///   - size: The size of the parent container
    ///   - currentDate: A binding to the selected date, used to filter tasks
    init(size: CGSize, currentDate: Binding<Date>) {
        self._currentDate = currentDate
        self.size = size
        
        /// Predicate to filter tasks by the selected date
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: currentDate.wrappedValue)  // Start of the selected day
        let endOfDate = calendar.date(byAdding: .day, value: 1, to: startOfDate)!  // End of the selected day
        
        let predicate = #Predicate<TaskItem> {
            return $0.creationDate >= startOfDate && $0.creationDate < endOfDate
        }
        
        /// Sorting the tasks by creation date
        let sortDescriptor = [
            SortDescriptor(\TaskItem.creationDate, order: .forward)  // Sort in ascending order of creation date
        ]
        
        /// Query to fetch tasks based on the predicate and sort order, with animation for smooth updates
        self._tasks = Query(filter: predicate, sort: sortDescriptor, animation: .snappy)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 35) {
            // Iterating over the tasks and displaying each one in a `TaskRowView`
            ForEach(tasks) { task in
                TaskRowView(task: task)
                    .background(alignment: .leading) {
                        // Draws a separator line between tasks except for the last one
                        if tasks.last?.id != task.id {
                            Rectangle()
                                .frame(width: 1)
                                .offset(x: 8)
                                .padding(.bottom, -35)
                        }
                    }
            }
        }
        .padding([.vertical, .leading], 15)
        .padding(.top, 15)
        .overlay {
            // Displays a message if no tasks are found
            if tasks.isEmpty {
                Text("No Tasks Found")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .frame(width: 150)
                    .offset(y: (size.height - 50) / 2)
            }
        }
    }
}
