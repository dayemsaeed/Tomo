//
//  TaskView.swift
//  Tomo
//
//  Created by Dayem Saeed on 10/3/23.
//

import SwiftUI

struct TaskView: View {
    @State private var showEditView = false
    //@Binding var oldTitle: String
    @ObservedObject private var viewModel = TaskViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(content: {
            Spacer()
            CalendarView()
            
            List {
                if viewModel.taskCellViewModels.isEmpty {
                    Text("No tasks to show")
                }
                else {
                    ForEach(viewModel.taskCellViewModels) { listItem in
                        TaskCell(taskViewModel: listItem)
                            .onTapGesture {
                                listItem.task.completed.toggle()
                                viewModel.taskRepository.updateTask(listItem.task)
                            }
                            /*.onLongPressGesture {
                                self.item = listItem
                                self.oldTitle = listItem.task.title
                                showEditView = true
                            }
                            .background(
                                NavigationLink("", destination: EditTaskView(item: $item), isActive: $showEditView)
                                    .hidden()
                            )*/
                    }
                    .onDelete(perform: deleteTasks)
                }
            }
            
            navigationButtons
            Spacer()
        })
        .frame(minWidth: 318, idealWidth: 318, minHeight: 350, idealHeight: 750, alignment: .center)
        .shadow(radius: 7)
        .cornerRadius(25.0)
        .listRowBackground(Color.white)
        .padding(.horizontal, 30)
    }
    
    private func deleteTasks(at offsets: IndexSet) {
        let tasksToDelete = offsets.map { viewModel.taskCellListViewModels[$0] }
        tasksToDelete.forEach { viewModel.taskRepository.deleteTask($0.task) }
    }
    
    private var navigationButtons: some View {
        HStack {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("<")
                    .font(.system(size: 48))
                    .foregroundColor(.white)
                    .padding(.top, -10)
            }
            .frame(width: 50, height: 50, alignment: .center)
            .background(Color.petSupportBlue)
            .clipShape(Circle())
            .navigationBarBackButtonHidden(true)
            
            Spacer()
            NavigationLink(destination: AddTaskView()) {
                Text("+")
                    .font(.system(size: 48))
                    .foregroundColor(.white)
                    .padding(.top, -10)
            }
            .frame(width: 50, height: 50, alignment: .center)
            .background(Color.petSupportBlue)
            .clipShape(Circle())
            .navigationBarBackButtonHidden(true)
        }
    }
    
}
