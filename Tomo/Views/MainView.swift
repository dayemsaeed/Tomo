//
//  ContentView.swift
//  PetSupport
//
//  Created by Dayem Saeed on 12/15/20.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import AVFoundation

struct MainView: View {
    
    @State private var radius = 300
    @Binding var view: String
    @ObservedObject private var viewModel = TaskViewModel()
    let db = Firestore.firestore()
    @Binding var name: String
    //@State var firstView: Bool = false
    let synthesizer = AVSpeechSynthesizer()
    let text = "Welcome! Time to get started on those tasks!"
    
    init(view: Binding<String>, name: Binding<String>) { UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().isScrollEnabled = true
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(identifier: AVSpeechSynthesisVoiceIdentifierAlex)
        //synthesizer.speak(utterance)
        self._view = view
        self._name = name
    }
    
    var body: some View {
//        func getDocumentData(db: Firestore) {
//            let docRef = db.collection("user").document(Auth.auth().currentUser!.uid)
//            docRef.getDocument { (document, error) in
//                if let document = document, document.exists {
//                    let dataDescription = document.get("name") ?? "nil"
//                    print("Document data: \(dataDescription)")
//                    DispatchQueue.main.async {
//                        name = dataDescription as! String
//                    }
//                } else {
//                    print("Document does not exist")
//                }
//            }
//        }
        return NavigationView(content: {
            
            VStack {
                Spacer()
                    .frame(height: 150)
                
                HStack {
                    Image("Minato")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 98, height: 98, alignment: .topLeading)
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 7)
                    
                    Spacer()
                    
                    Image("Naruto")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 128, height: 229)
                }
                .padding(.top, -120)
                Spacer().frame(height: 1)
                Group {
                    HStack {
                        Text("Hi,")
                            .font(Font.custom("Permanent Marker", size: 36))
                            .multilineTextAlignment(.leading)
                        Text(name).foregroundColor(Color.petSupportText)
                            .font(Font.custom("Permanent Marker", size: 36))
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    
                    Spacer().frame(height: 10)
                    
                    HStack {
                        Text("How are we doing today?")
                            .font(Font.custom("Permanent Marker", size: 24))
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
                
                Spacer().frame(height: 20)
                
                Group {
                    VStack {
                        List {
                            if viewModel.taskCellViewModels.isEmpty {
                                Text("No tasks to show")
                            }
                            else {
                                ForEach(viewModel.taskCellViewModels) { item in
                                    TaskCell(taskViewModel: item).onTapGesture {
                                        item.task.completed = !(item.task.completed)
                                        viewModel.taskRepository.updateTask(item.task)
                                    }
                                }
                            }
                        }
                    }
                    .frame(width: 318, height: 350, alignment: .center)
                    .shadow(radius: 7)
                    .cornerRadius(25.0)
                    .listRowBackground(Color.white)
                }
                
                Spacer().frame(height: 20)
                
                Group {
                    HStack {
                        Button(
                            action: {
                                view = "AddTask"
                            },
                            label: {
                                Text("+")
                                    .font(Font.custom("Permanent Marker", size: 48))
                                    .foregroundColor(.white)
                                    .padding(.top, -10)
                            })
                            .frame(width: 50, height: 50, alignment: .center)
                            .background(Color.petSupportBlue)
                            .clipShape(Circle())
                        Button(
                            action: {
                                view = "Tasks"
                            },
                            label: {
                                Text("View all tasks")
                                    .font(Font.custom("Permanent Marker", size: 18))
                                    .foregroundColor(.white)
                                    .padding(.top, -10)
                            })
                            .frame(width: 150, height: 50, alignment: .center)
                            .background(Color.petSupportBlue)
                            .cornerRadius(70.0)
                            .disabled(viewModel.taskCellViewModels.isEmpty)
                        Spacer()
                    }
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

struct TaskCell : View {
    @ObservedObject var taskViewModel : TaskCellViewModel
    
    var body: some View {
        HStack {
            Image(systemName: taskViewModel.task.completed ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 20, height: 20)
            Text(taskViewModel.task.title).font(Font.custom("Permanent Marker", size: 18))
        }
    }
}


#if DEBUG
struct MainView_Previews : PreviewProvider {
    static var previews: some View {
        MainView(view: .constant("Hi"), name: .constant("Hi"))
    }
}
#endif
