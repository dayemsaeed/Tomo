//
//  TaskView.swift
//  Tomo
//
//  Created by Dayem Saeed on 10/3/23.
//

import SwiftUI

struct TaskView: View {
    @State private var showEditView = false
    @EnvironmentObject private var viewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var createNewTask: Bool = false
    @State private var currentDate: Date = .init()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CalendarHeader(currentDate: $currentDate)
            TasksListView()
                .layoutPriority(1)
        }
        .vSpacing(.top)
        .overlay(alignment: .bottomTrailing, content: {
            Button(action: {
                createNewTask.toggle()
            }, label: {
                Image(systemName: "plus")
                    .fontWeight(.semibold)
                    .foregroundStyle(.seherCircle)
                    .frame(width: 55, height: 55)
                    .background(.seherCircle.shadow(.drop(color: .black.opacity(0.25), radius: 5, x: 10, y: 10)), in: .circle)
            })
        })
        .sheet(isPresented: $createNewTask, content: {
            NewTaskView(taskDate: $currentDate)
                .presentationDetents([.height(300)])
                .interactiveDismissDisabled()
                .presentationCornerRadius(30)
                .presentationBackground(.BG)
        })
    }
    
    @ViewBuilder
    func TasksListView() -> some View {
        GeometryReader {
            let size = $0.size
            ScrollView(.vertical) {
                VStack {
                    TasksList(size: size, currentDate: $currentDate)
                }
                .hSpacing(.center)
                .vSpacing(.center)
            }
            .scrollIndicators(.hidden)
        }
    }

    
    
//    private func deleteTasks(at offsets: IndexSet) {
//        viewModel.removeTasks(atOffsets: offsets)
//    }
}
