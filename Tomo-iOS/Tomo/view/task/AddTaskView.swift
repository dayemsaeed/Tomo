//
//  AddTaskView.swift
//  Tomo
//
//  Created by Dayem Saeed on 10/8/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AddTaskView: View {
    
    @State private var task = ""
    @State private var date = Date()
    @State private var isEditing = false
    @State private var navigateToMain = false
    @Environment(\.presentationMode) var presentationMode
    
    private var canSave: Bool {
        return !task.isEmpty
    }
    
    let db = Firestore.firestore()
    
    let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter
        }()
    
    let dateToStringFormatter = DateFormatter()
    
    var body: some View {
        var text = "Task added!"
        
        return VStack {
            Spacer()
            
            Group {
                
                HStack {
                    
                    Text("Title")
                        .font(Font.custom("Permanent Marker", size: 18))
                        .padding(.top, 10)
                    
                    Spacer()
                    
                }
                
                TextField("Task", text: $task) {
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
                    dateToStringFormatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                    db.collection("users").document(Auth.auth().currentUser!.uid).collection("tasks").document(task).setData([
                        "title": task,
                        "startDate": String(dateToStringFormatter.string(from:date).prefix(11)),
                        "completed" : false,
                        "completedIcon" : "circle"
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                            text = "Great job! You just added a task!"
                            navigateToMain = true
                        }
                    }
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
                
                NavigationLink("", destination: MainView(), isActive: $navigateToMain).hidden().navigationBarBackButtonHidden(true)
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                })
                .padding()
                .font(Font.custom("Permanent Marker", size: 18.0))
                .foregroundColor(Color.petSupportText)
            }
            
            Spacer()
        }
    }
}
