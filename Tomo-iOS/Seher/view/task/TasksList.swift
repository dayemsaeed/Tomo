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
        let tasks = viewModel.tasks.filter { isSameDay($0.creationDate, currentDate) }

        VStack(alignment: .leading, spacing: 35) {
            ForEach(tasks) { task in
                TaskRowView(task: task)
                    .environmentObject(viewModel)
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
