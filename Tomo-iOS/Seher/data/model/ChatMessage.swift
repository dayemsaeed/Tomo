//
//  ChatMessage.swift
//  Tomo
//
//  Created by Dayem Saeed on 4/1/23.
//

import SwiftUI
import SwiftData

@Model
class ChatMessage: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let isSender: Bool
    let messageTimeStamp: Date
    
    init(id: UUID = .init(), text: String, isSender: Bool, date: Date = Date()) {
        self.id = id
        self.text = text
        self.isSender = isSender
        self.messageTimeStamp = date
    }
}
