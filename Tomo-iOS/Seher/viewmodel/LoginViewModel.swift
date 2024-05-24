//
//  LoginViewModel.swift
//  Seher
//
//  Created by Dayem Saeed on 3/23/21.
//

import Foundation
import Supabase

class LoginViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var text = ""
    
    private let supabaseClient: SupabaseClient

    init(supabaseClient: SupabaseClient) {
        self.supabaseClient = supabaseClient
    }

    func login(email: String, password: String) async throws -> User {
        do {
            let session = try await
            supabaseClient.auth.signIn(email: email, password: password)
            DispatchQueue.main.async {
                self.isLoggedIn = true
            }
            return session.user
        } catch {
            throw error
        }
    }
    
    func isUserLoggedIn() -> Session? {
        return supabaseClient.auth.currentSession
    }
}

