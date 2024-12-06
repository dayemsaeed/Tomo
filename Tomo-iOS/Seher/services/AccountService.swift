import Foundation
import Alamofire

protocol AccountServiceProtocol {
    func deleteAccount(userId: UUID) async throws
}

class AccountService: AccountServiceProtocol {
    private let supabaseClient: SupabaseClient
    
    init(supabaseClient: SupabaseClient) {
        self.supabaseClient = supabaseClient
    }
    
    func deleteAccount(userId: UUID) async throws {
        guard let apiKey = Bundle.main.infoDictionary?["SUPABASE_KEY"] as? String,
              let baseUrl = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String else {
            throw NSError(domain: "AccountService", code: 500, userInfo: [NSLocalizedDescriptionKey: "Missing API configuration"])
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + apiKey,
            "Content-Type": "application/json"
        ]
        
        let parameters: Parameters = [
            "user_id": userId.uuidString
        ]
        
        let url = baseUrl + "/functions/v1/seher-accounts-api"
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url,
                      method: .delete,
                      parameters: parameters,
                      encoding: JSONEncoding.default,
                      headers: headers)
            .responseDecodable(of: DeleteAccountResponse.self) { response in
                switch response.result {
                case .success(let deleteResponse):
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