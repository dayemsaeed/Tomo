//
//  ChatView.swift
//  Tomo
//
//  Created by Dayem Saeed on 4/1/23.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    @FocusState private var chatIsFocused: Bool

    var body: some View {
        VStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    LazyVStack {
                        ForEach(chatViewModel.messages, id: \.id) { message in
                            ChatRow(message: message)
                        }
                    }
                    .onChange(of: chatViewModel.messages.count, perform: { value in
                        withAnimation(.spring()) {
                            scrollViewProxy.scrollTo(chatViewModel.messages[chatViewModel.messages.count - 1].id, anchor: .bottom)
                        }
                    })
                }
            }
            chatInputArea
        }
    }

    private var chatInputArea: some View {
        HStack(alignment: .center, spacing: 10) {
            TextField("Message", text: $chatViewModel.messageText)
                .multilineTextAlignment(.leading)
                .lineLimit(0)
                .focused($chatIsFocused)

            if !chatViewModel.messageText.isEmpty {
                Button(action: {
                    chatViewModel.sendMessage()
                    chatIsFocused = false
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


struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
