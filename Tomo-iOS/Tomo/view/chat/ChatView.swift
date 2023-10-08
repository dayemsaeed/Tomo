//
//  ChatView.swift
//  Tomo
//
//  Created by Dayem Saeed on 4/1/23.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    
    typealias UIViewType = UITextView
    var configuration = { (view: UIViewType) in }
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIViewType {
        UIViewType()
    }
    
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<Self>) {
        configuration(uiView)
    }
}

struct ChatView: View {
    @State private var messageText: String = ""
    @State private var messages: [ChatMessage] = []
    @FocusState private var chatIsFocused: Bool
    @Binding var view: String
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(messages) { message in
                        ChatRow(message: message)
                    }
                }
            }
            
            HStack {
                Button(action: {
                    view = "Tasks"
                }) {
                    Image(systemName: "list.bullet")
                        .imageScale(.medium)
                        .frame(width: 30, height: 30)
                }
                HStack(alignment: .center, spacing: 10) {
                    TextField("Message", text: $messageText)
                        .multilineTextAlignment(.leading)
                        .lineLimit(0)
                        .focused($chatIsFocused)
                    
                    if !messageText.isEmpty {
                        Button(action: {
                            sendMessage()
                        }) {
                            Image(systemName: "arrow.up")
                                .imageScale(.medium)
                                .frame(width: 30, height: 30)
                                .background(Color.blue)
                                .foregroundColor(Color.white)
                                .clipShape(Circle())
                        }
                        //.padding(.trailing)
                    }
                    // add waveform for audio chat (TO-DO later)
                    /*else {
                        Button(action: {
                            
                        }) {
                            Image(systemName: "waveform")
                                .frame(width: 26, height: 26)
                                .foregroundColor(.red)
                        }
                        .padding(.trailing)
                    }*/
                }
                .padding(10)
                .overlay(Capsule()
                    .stroke(.tertiary, lineWidth: 1)
                    .opacity(0.7)
                )
                .padding(.trailing, 6)
            }
        }
    }
    
    private func sendMessage() {
        messageText = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !messageText.isEmpty {
            let newMessage = ChatMessage(text: messageText, isSender: true)
            messages.append(newMessage)
            messageText = ""
            chatIsFocused = false
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
