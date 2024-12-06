//
//  AccountServiceProtocol.swift
//  Seher
//
//  Created by Dayem Saeed on 12/6/24.
//


import Foundation
import Alamofire
import Supabase

protocol AccountServiceProtocol {
    // Remove completion handler since we're using async/throw
    func deleteAccount(userId: UUID) async throws
}

class AccountService: AccountServiceProtocol {
    private let supabaseClient: SupabaseClient
    
    init(supabaseClient: SupabaseClient) {
        self.supabaseClient = supabaseClient
    }
    
    func deleteAccount(userId: UUID) async throws {
        guard let apiKey = Bundle.main.infoDictionary?["SUPABASE_KEY"] as? String,
              let baseUri = Bundle.main.infoDictionary?["ACCOUNT_API_URI"] as? String else {
            throw NSError(domain: "AccountService",
                         code: 500,
                         userInfo: [NSLocalizedDescriptionKey: "App configuration error: Missing API key or URI."])
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + apiKey,
            "Content-Type": "application/json"
        ]
        
        let parameters: Parameters = [
            "user_id": userId.uuidString
        ]
        
        let url = "https://xzcmehrmmnstqrovwabx.supabase.co/" + baseUri
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url,
                      method: .delete,
                      parameters: parameters,
                      encoding: JSONEncoding.default,
                      headers: headers)
            .responseDecodable(of: DeleteAccountResponse.self) { response in
                switch response.result {
                case .success(_):
                    continuation.resume(returning: ())
                case .failure(let error):
                    print("Error in delete account request: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

struct DeleteAccountResponse: Decodable {
    let message: String
}
