//
//  EditTask.swift
//  PetSupport
//
//  Created by Dayem Saeed on 5/19/21.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import AVFoundation

struct EditTask: View {
    @Binding var item : TaskCellViewModel
    @State private var date = Date()
    @State private var isEditing = false
    @Binding var oldTitle: String
    @Binding var view: String
    @ObservedObject private var viewModel = TaskViewModel()
    
    let synthesizer = AVSpeechSynthesizer()
    let text = "Task updated!"
    
    private var canSave: Bool {
        return !item.task.title.isEmpty
    }
    
    let db = Firestore.firestore()
    
    let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter
        }()
    
    let dateToStringFormatter = DateFormatter()
    
    var body: some View {
        return NavigationView(content: {
            VStack {
                Spacer()
                Group {
                    
                    HStack {
                        
                        Text("Title")
                            .font(Font.custom("Permanent Marker", size: 18))
                            .padding(.top, 10)
                        
                        Spacer()
                        
                    }
                    
                    TextField("Task", text: $item.task.title) {
                        isEditing in self.isEditing = isEditing
                    }
                    .autocapitalization(.sentences)
                    .disableAutocorrection(false)
                    .padding(.top, 20)
                    
                    Divider()
                        .foregroundColor(.black)
                    
                }
                
                Spacer()
                
                DatePicker(selection: $date, in: Date()..., displayedComponents: .date) {
                                Text("Date")
                                    .font(Font.custom("Permanent Marker", size: 18))
                            }
                
                Spacer()
                
                Group {
                    
                    Button(action: {
                        dateToStringFormatter.dateFormat = "d MMM y"
                        if (item.task.title == oldTitle) {
                            viewModel.taskRepository.updateTask(item.task)
                        }
                        else {
                            viewModel.taskRepository.updateTaskNewTitle(item.task, title: oldTitle)
                        }
                        print("Document successfully written!")
                        oldTitle = ""
                        let utterance = AVSpeechUtterance(string: text)
                        utterance.voice = AVSpeechSynthesisVoice(identifier: AVSpeechSynthesisVoiceIdentifierAlex)
                        synthesizer.speak(utterance)
                        view = "Tasks"
                    }, label: {
                        Text("Save")
                    })
                        .foregroundColor(.white)
                        .font(Font.custom("Permanent Marker", size: 18.0))
                        .padding(.horizontal, 20)
                        .padding()
                        .background(Color.petSupportBlue)
                        .cornerRadius(70.0)
                        .disabled(!canSave)
                    
                    Button(
                        action: {
                            view = "Tasks"
                        },
                        label: {
                            Text("Cancel")
                        })
                        .padding()
                        .font(Font.custom("Permanent Marker", size: 18.0))
                        .foregroundColor(Color.petSupportText)
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                }
                Spacer()
            }
            .padding(.horizontal, 30)
            .background(bubble, alignment: .topLeading)
            .background(bubble.rotationEffect(Angle(degrees: 180)), alignment: .bottomTrailing)
            .ignoresSafeArea()
            
        })
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

struct EditTask_Previews: PreviewProvider {
    static var previews: some View {
        EditTask(item: .constant(TaskCellViewModel(task: Task(id: "", title: "", date: "", timestamp: "", completed: false, completedIcon: ""))), oldTitle: .constant("Hi"), view: .constant("Hi"))
    }
}
