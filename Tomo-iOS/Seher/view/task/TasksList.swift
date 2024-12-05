//
//  TasksList.swift
//  Seher
//
//  Created by Dayem Saeed on 5/24/24.
//

import SwiftUI

struct TasksList: View {
    var size: CGSize
    @Binding var currentDate: Date
    @EnvironmentObject private var viewModel: TaskViewModel

    var body: some View {
        let tasks = viewModel.tasks
            .filter { isSameDay($0.creationDate, currentDate) }
            .sorted { task1, task2 in
                if task1.isCompleted != task2.isCompleted {
                    return !task1.isCompleted
                }
                return task1.creationDate < task2.creationDate
            }

        VStack(alignment: .leading, spacing: 35) {
            ForEach(Array(tasks.enumerated()), id: \.element.id) { index, task in
                TaskRowView(task: task)
                    .background(alignment: .leading) {
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
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: tasks)
        .overlay {
            if tasks.isEmpty {
                Text("No Tasks Found")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .frame(width: 150)
                    .offset(y: (size.height - 50) / 2)
            }
        }
    }
    
    func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}
