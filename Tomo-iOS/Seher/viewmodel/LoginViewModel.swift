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
    private let accountService: AccountServiceProtocol
    
    init(supabaseClient: SupabaseClient, accountService: AccountServiceProtocol? = nil) {
        self.supabaseClient = supabaseClient
        self.accountService = accountService ?? AccountService(supabaseClient: supabaseClient)
        if let _ = supabaseClient.auth.currentSession {
            self.isLoggedIn = true
        }
    }

    func login(email: String, password: String) async throws -> User {
        do {
            let session = try await supabaseClient.auth.signIn(email: email, password: password)
            
            DispatchQueue.main.async {
                self.isLoggedIn = true
            }
            
            _ = supabaseClient.auth.currentSession
            
            return session.user
        } catch {
            print("Login error: \(error)")
            throw error
        }
    }
    
    func isUserLoggedIn() -> Session? {
        return supabaseClient.auth.currentSession
    }

    func logout() async throws {
        try await supabaseClient.auth.signOut()
        DispatchQueue.main.async {
            self.isLoggedIn = false
        }
    }

    func signOut() async throws {
        do {
            try await supabaseClient.auth.signOut()
            DispatchQueue.main.async {
                self.isLoggedIn = false
            }
        } catch {
            print("Error signing out: \(error)")
            throw error
        }
    }

    func deleteAccount() async throws {
        do {
            guard let userId = supabaseClient.auth.currentSession?.user.id else {
                throw NSError(domain: "LoginViewModel", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
            }
            
            try await accountService.deleteAccount(userId: userId)
            
            DispatchQueue.main.async {
                self.isLoggedIn = false
            }
        } catch {
            print("Error deleting account: \(error)")
            throw error
        }
    }
}

