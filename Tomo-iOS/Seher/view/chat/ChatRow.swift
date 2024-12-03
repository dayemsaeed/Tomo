//
//  ChatRow.swift
//  Tomo
//
//  Created by Dayem Saeed on 4/1/23.
//

import SwiftUI

/// The `ChatRow` view is responsible for displaying individual chat messages in a conversation.
struct ChatRow: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isSender {
                Spacer()
            }
            
            Text(message.content)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    message.isSender ? Color.seherText : Color(.systemGray5)
                )
                .foregroundColor(message.isSender ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .contextMenu {
                    Button(action: {
                        UIPasteboard.general.string = message.content
                    }) {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                }
            
            if !message.isSender {
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow(message: ChatMessage(content: "Hello", isSender: true, conversation_id: UUID()))
    }
}
