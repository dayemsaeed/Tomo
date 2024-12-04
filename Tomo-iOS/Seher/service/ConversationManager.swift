class ConversationManager {
    private let supabaseClient: SupabaseClient
    
    init(supabaseClient: SupabaseClient) {
        self.supabaseClient = supabaseClient
    }
    
    func createNewConversation(with id: UUID? = nil) async throws -> UUID {
        let conversation = Conversation(id: id ?? UUID())
        try await supabaseClient.database
            .from("conversations")
            .insert(value: conversation)
            .execute()
        return conversation.id
    }
    
    func getLatestConversation() async throws -> UUID {
        let query = supabaseClient.database
            .from("conversations")
            .select()
            .order("created_at", ascending: false)
            .limit(1)
        
        let conversations: [Conversation] = try await query.execute().value
        if let conversation = conversations.first {
            return conversation.id
        }
        // If no conversation exists, create a new one
        return try await createNewConversation()
    }
    
    func conversationExists(id: UUID) async throws -> Bool {
        let query = supabaseClient.database
            .from("conversations")
            .select()
            .eq("id", id)
            .limit(1)
        
        let conversations: [Conversation] = try await query.execute().value
        return !conversations.isEmpty
    }
} 