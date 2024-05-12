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

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var messageText: String = ""
    @FocusState private var chatIsFocused: Bool

    var body: some View {
        VStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.messages, id: \.id) { message in
                            ChatRow(message: message)
                        }
                    }
                }
                .onChange(of: viewModel.messages.count) { count in
                    scrollViewProxy.scrollTo(viewModel.messages[viewModel.messages.count - 1].id, anchor: .bottom)
                }
            }
            chatInputArea
        }
    }

    private var chatInputArea: some View {
        HStack(alignment: .center, spacing: 10) {
                        TextField("Message", text: $messageText)
                            .multilineTextAlignment(.leading)
                            .lineLimit(0)
                            .focused($chatIsFocused)
                        
                        if !messageText.isEmpty {
                            Button(action: {
                                viewModel.sendMessage(messageText)
                                messageText = ""
                                chatIsFocused = false
                            }) {
                                Image(systemName: "arrow.up")
                                    .imageScale(.medium)
                                    .frame(width: 30, height: 30)
                                    .background(Color.blue)
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

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
