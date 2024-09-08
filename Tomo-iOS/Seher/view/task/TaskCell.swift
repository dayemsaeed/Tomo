//
//  TaskCell.swift
//  Tomo
//
//  Created by Dayem Saeed on 10/9/23.
//

import Foundation
import SwiftUI

/// `TaskCell` is a view that displays an individual task in the form of a cell.
/// It handles the presentation of task details such as the task title and completion state.
struct TaskCell: View {
    @ObservedObject var taskViewModel: TaskCellViewModel  // ObservedObject to keep track of task state

    var body: some View {
        HStack {
            // Display a checkbox and task title (commented for future use)
            // Uncomment and adjust as needed
            /*
            Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 20, height: 20)
            Text(task.title)
                .font(.system(size: 18))
                .strikethrough(task.completed)
            */
        }
    }
}
