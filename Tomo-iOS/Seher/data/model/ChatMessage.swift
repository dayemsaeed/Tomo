//
//  ChatMessage.swift
//  Tomo
//
//  Created by Dayem Saeed on 4/1/23.
//

import SwiftUI
import SwiftData

@Model
class ChatMessage: Identifiable, Hashable, Codable {
    var id: UUID
    var content: String
    var isSender: Bool
    var created_at: Date
    var conversation_id: UUID
    
    enum CodingKeys: String, CodingKey {
        case id
        case content
        case isSender = "is_sender"
        case created_at
        case conversation_id
    }
    
    init(id: UUID = .init(), 
         content: String, 
         isSender: Bool, 
         created_at: Date = Date(),
         conversation_id: UUID) {
        self.id = id
        self.content = content
        self.isSender = isSender
        self.created_at = created_at
        self.conversation_id = conversation_id
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        content = try container.decode(String.self, forKey: .content)
        isSender = try container.decode(Bool.self, forKey: .isSender)
        created_at = try container.decode(Date.self, forKey: .created_at)
        conversation_id = try container.decode(UUID.self, forKey: .conversation_id)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(content, forKey: .content)
        try container.encode(isSender, forKey: .isSender)
        try container.encode(created_at, forKey: .created_at)
        try container.encode(conversation_id, forKey: .conversation_id)
    }
}
