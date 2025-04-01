import Foundation
import Supabase

class SupabaseService: ObservableObject {
    static let shared = SupabaseService()
    private let client: SupabaseClient
    
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    
    private init() {
        client = SupabaseClient(
            supabaseURL: AppConfig.supabaseURL,
            supabaseKey: AppConfig.supabaseAnonKey
        )
        Task {
            await checkAuth()
        }
    }
    
    // MARK: - Authentication
    
    func signUp(email: String, password: String) async throws -> User {
        let auth = try await client.auth.signUp(
            email: email,
            password: password
        )
        currentUser = auth.user
        isAuthenticated = true
        return auth.user
    }
    
    func signIn(email: String, password: String) async throws -> User {
        let auth = try await client.auth.signIn(
            email: email,
            password: password
        )
        currentUser = auth.user
        isAuthenticated = true
        return auth.user
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
        currentUser = nil
        isAuthenticated = false
    }
    
    func resetPassword(email: String) async throws {
        try await client.auth.resetPasswordForEmail(email)
    }
    
    private func checkAuth() async {
        do {
            let session = try await client.auth.session
            currentUser = session.user
            isAuthenticated = true
        } catch {
            currentUser = nil
            isAuthenticated = false
        }
    }
    
    // MARK: - User Profile
    
    func updateProfile(userId: String, data: [String: Any]) async throws {
        try await client.database
            .from("profiles")
            .update(data)
            .eq("id", value: userId)
            .execute()
    }
    
    func getProfile(userId: String) async throws -> Profile {
        let response = try await client.database
            .from("profiles")
            .select()
            .eq("id", value: userId)
            .single()
            .execute()
        
        return try response.decoded()
    }
    
    // MARK: - Groups
    
    func createGroup(name: String, description: String, interests: [String]) async throws -> Group {
        guard let userId = currentUser?.id else {
            throw SupabaseError.userNotFound
        }
        
        let group = Group(
            id: UUID().uuidString,
            name: name,
            description: description,
            creatorId: userId,
            members: [userId],
            interests: interests,
            createdAt: Date()
        )
        
        try await client.database
            .from("groups")
            .insert(group)
            .execute()
        
        return group
    }
    
    func joinGroup(groupId: String) async throws {
        guard let userId = currentUser?.id else {
            throw SupabaseError.userNotFound
        }
        
        try await client.database
            .from("group_members")
            .insert(["group_id": groupId, "user_id": userId])
            .execute()
    }
    
    func getGroups() async throws -> [Group] {
        guard let userId = currentUser?.id else {
            throw SupabaseError.userNotFound
        }
        
        let response = try await client.database
            .from("groups")
            .select("""
                *,
                group_members!inner(user_id)
            """)
            .eq("group_members.user_id", value: userId)
            .execute()
        
        return try response.decoded()
    }
    
    // MARK: - Messages
    
    func sendMessage(groupId: String, content: String) async throws -> Message {
        guard let userId = currentUser?.id else {
            throw SupabaseError.userNotFound
        }
        
        let message = Message(
            id: UUID().uuidString,
            groupId: groupId,
            senderId: userId,
            content: content,
            createdAt: Date()
        )
        
        try await client.database
            .from("messages")
            .insert(message)
            .execute()
        
        return message
    }
    
    func getMessages(groupId: String) async throws -> [Message] {
        let response = try await client.database
            .from("messages")
            .select("""
                *,
                profiles!inner(display_name, avatar_url)
            """)
            .eq("group_id", value: groupId)
            .order("created_at")
            .execute()
        
        return try response.decoded()
    }
    
    // MARK: - Real-time Subscriptions
    
    func subscribeToMessages(groupId: String, onMessage: @escaping (Message) -> Void) {
        client.realtime
            .channel("messages:\(groupId)")
            .on("INSERT", filter: "group_id=eq.\(groupId)") { [weak self] payload in
                if let message = try? payload.decoded(as: Message.self) {
                    onMessage(message)
                }
            }
            .subscribe()
    }
    
    func subscribeToGroupUpdates(groupId: String, onUpdate: @escaping (Group) -> Void) {
        client.realtime
            .channel("groups:\(groupId)")
            .on("UPDATE", filter: "id=eq.\(groupId)") { [weak self] payload in
                if let group = try? payload.decoded(as: Group.self) {
                    onUpdate(group)
                }
            }
            .subscribe()
    }
}

// MARK: - Error Handling

enum SupabaseError: Error {
    case userNotFound
    case invalidResponse
    case networkError
    case unknown
} 