//
//  AllLists.swift
//  PetSupport
//
//  Created by Dayem Saeed on 5/19/21.
//

import SwiftUI

struct AllLists: View {
    @Binding var view: String
    @Binding var item: TaskCellViewModel
    @Binding var oldTitle: String
    @ObservedObject private var viewModel = TaskViewModel()
    var body: some View {
        func deleteTask(at offsets: IndexSet) {
            // preserve all ids to be deleted to avoid indices confusing
            let idsToDelete = offsets.map { self.viewModel.taskCellListViewModels[$0].id }

                // schedule remote delete for selected ids
                _ = idsToDelete.compactMap { [self] id in
                            DispatchQueue.main.async {
                                // update on main queue
                                offsets.sorted(by: > ).forEach { (i) in
                                    viewModel.taskRepository.deleteTask(viewModel.taskCellListViewModels[i].task)
                                }
                                self.viewModel.taskCellListViewModels.removeAll { $0.id == id }
                                self.viewModel.taskCellViewModels.removeAll { $0.id == id }
                    }
            }
        }
        return VStack (content: {
            Spacer()
            Group {
                List {
                    if viewModel.taskCellViewModels.isEmpty {
                        Text("No tasks to show")
                    }
                    else {
                        ForEach(viewModel.taskCellListViewModels) { item in
                            TaskCell(taskViewModel: item).onTapGesture {
                                item.task.completed = !(item.task.completed)
                                viewModel.taskRepository.updateTask(item.task)
                            }.onLongPressGesture {
                                self.item = item
                                self.oldTitle = item.task.title
                                view = "Edit"
                            }
                        }.onDelete(perform: deleteTask)
                    }
                }
            }
            Group {
                HStack {
                    Button(
                        action: {
                            view = "Main"
                        },
                        label: {
                            Text("<")
                                .font(Font.custom("Permanent Marker", size: 48))
                                .foregroundColor(.white)
                                .padding(.top, -10)
                        })
                        .frame(width: 50, height: 50, alignment: .center)
                        .background(Color.petSupportBlue)
                        .clipShape(Circle())
                    Spacer()
                }
                Spacer()
                Spacer()
            }
            Spacer()
            
        })
            .frame(width: 318, height: 350, alignment: .center)
            .shadow(radius: 7)
            .cornerRadius(25.0)
            .listRowBackground(Color.white)
            .padding(.horizontal, 30)
            .background(bubble, alignment: .topLeading)
            .background(bubble.rotationEffect(Angle(degrees: 180)), alignment: .bottomTrailing)
            .ignoresSafeArea()
    }
    
    @State private var startAnimation: Bool = false

    var bubble: some View {

        ZStack {

            Circle()
                .fill(Color(UIColor.systemTeal).opacity(0.4))
                .frame(width: 300, height: 300, alignment: .center)
                .offset(x: startAnimation ? -110 : -100, y: startAnimation ? -180 : -150)


            Circle()
                .fill(Color(UIColor.systemTeal).opacity(0.4))
                .frame(width: 300, height: 300, alignment: .center)
                .offset(x: startAnimation ? -180 : -150, y: startAnimation ? -90 : -100)

        }
        .onAppear() { startAnimation = true }
        .animation(Animation.easeInOut(duration: 3.0).repeatForever(autoreverses: true))

    }
}

struct AllLists_Previews: PreviewProvider {
    static var previews: some View {
        AllLists(view: .constant("Hi"), item: .constant(TaskCellViewModel(task: Task(id: "", title: "", date: "", completed: false, completedIcon: ""))), oldTitle: .constant("Hi"))
    }
}
