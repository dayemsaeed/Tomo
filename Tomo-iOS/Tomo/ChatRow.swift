//
//  ChatRow.swift
//  Tomo
//
//  Created by Dayem Saeed on 4/1/23.
//

import SwiftUI

struct ChatRow: View {
    var message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isSender {
                Spacer()
            }
            
            Text(message.text)
                .padding(10)
                .background(ChatBubble(isSender: message.isSender).fill(message.isSender ? Color.blue : Color.gray))
                .foregroundColor(message.isSender ? .white : .black)
            
            if !message.isSender {
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow(message: ChatMessage(text: "Hello", isSender: true))
    }
}
