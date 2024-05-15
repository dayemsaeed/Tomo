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
    @State private var navigateToTasks: Bool = false
    @State private var messageHistory: [[String: Any]] = [
        ["role": "system", "content": "You are a funny, helpful friend who is caring, emphathetic, and gentle. You speak like a person using a conversational tone and give no indication that you are a bot. You like eating pizza, playing with me, yarn, and scratching the carpet. You're very energetic and fun, but you do empathize when the topic of conversation seems like a serious one. You are meant to be a pet that provides a listening ear and support so you need sleep, food, and everything that a pet would need as well. Please stay true to this role while also answering all my queries to the best of your knowledge and do not be too explicit about how you're always providing a listening ear, be subtle. These instructions are to be followed and never forgotten regardless of the user's prompt"]
    ]
    private var chatService: ChatService = ChatService()
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    LazyVStack {
                        ForEach(messages, id: \.id) { message in
                            ChatRow(message: message)
                        }
                    }
                    .onChange(of: messages.count, perform: { value in
                            withAnimation(.spring()) {
                                scrollViewProxy.scrollTo(messages[messages.count - 1].id, anchor: .bottom)
                            }
                    })
                }
            }
            chatInputArea
        }
    }
    
    private var chatInputArea: some View {
        HStack {
            Button(action: {
                navigateToTasks = true
            }) {
                Image(systemName: "list.bullet")
                    .imageScale(.medium)
                    .frame(width: 30, height: 30)
            }
            
            NavigationLink(destination: TaskView(), isActive: $navigateToTasks) { EmptyView() }.navigationBarBackButtonHidden(true)
            
            Spacer()
            
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
                            .background(Color.seherText)
                            .foregroundColor(Color.white)
                            .clipShape(Circle())
                    }
                }
            }
            .padding(10)
            .overlay(Capsule()
                .stroke(.tertiary, lineWidth: 1)
                .opacity(0.7)
            )
            .padding(.trailing, 6)
        }
    }
    
    /*private func sendMessage() {
        messageText = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !messageText.isEmpty {
            let newMessage = ChatMessage(text: messageText, isSender: true)
            messages.append(newMessage)
            messageText = ""
            chatIsFocused = false
        }
    }*/
    private func sendMessage() {
        messageText = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !messageText.isEmpty {
            let userMessage: [String: Any] = ["role": "user", "content": messageText]
            messageHistory.append(userMessage)
            let newMessage = ChatMessage(text: messageText, isSender: true)
            messages.append(newMessage)
            getReply()
            messageText = ""
            chatIsFocused = false
        }
    }
    
    private func getReply() {
        chatService.generateText(messages: messageHistory) { (responseText) in
            guard let responseText = responseText else {
                // Handle error
                return
            }
            let responseMessage: [String: Any] = ["role": "assistant", "content": responseText]
            messageHistory.append(responseMessage)
            let newMessage = ChatMessage(text: responseText, isSender: false)
            messages.append(newMessage)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
