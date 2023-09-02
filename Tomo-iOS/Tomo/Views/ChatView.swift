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
                TextField("Type your message", text: $messageText, axis: .vertical)
                    .padding(12)
                    .padding(.trailing, 40)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(Capsule())
                    .focused($chatIsFocused)
                
                Button(action: {
                    sendMessage()
                }) {
                    Image(systemName: "arrow.up")
                        .imageScale(.large)
                        .fontWeight(.semibold)
                        .frame(width: 40, height: 40)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .clipShape(Circle())
                }
                .padding(.trailing)
            }
            .padding(.bottom, 8)
        }
    }
    
    private func sendMessage() {
        if !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
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
