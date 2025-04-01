import SwiftUI
import Supabase

class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var error: Error?
    
    private let supabase = SupabaseService.shared
    
    init() {
        currentUser = supabase.currentUser
        isAuthenticated = supabase.isAuthenticated
    }
    
    func signUp(email: String, password: String) async {
        isLoading = true
        error = nil
        
        do {
            currentUser = try await supabase.signUp(email: email, password: password)
            isAuthenticated = true
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func signIn(email: String, password: String) async {
        isLoading = true
        error = nil
        
        do {
            currentUser = try await supabase.signIn(email: email, password: password)
            isAuthenticated = true
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func signOut() async {
        isLoading = true
        error = nil
        
        do {
            try await supabase.signOut()
            currentUser = nil
            isAuthenticated = false
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func resetPassword(email: String) async {
        isLoading = true
        error = nil
        
        do {
            try await supabase.resetPassword(email: email)
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
} 