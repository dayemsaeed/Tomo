struct Conversation: Identifiable, Codable {
    let id: UUID
    let created_at: Date
    
    init(id: UUID = UUID(), created_at: Date = Date()) {
        self.id = id
        self.created_at = created_at
    }
} 