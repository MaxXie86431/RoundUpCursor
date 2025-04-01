import SwiftUI

struct RoundMeetView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var searchText = ""
    @State private var recommendedUsers: [User] = []
    @State private var searchResults: [User] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search users", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    if searchText.isEmpty {
                        // Recommended Friends Section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Recommended Friends")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(recommendedUsers) { user in
                                        UserCard(user: user)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    } else {
                        // Search Results
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Search Results")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ForEach(searchResults) { user in
                                UserCard(user: user)
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("RoundMeet")
            .onChange(of: searchText) { newValue in
                if !newValue.isEmpty {
                    searchUsers(query: newValue)
                } else {
                    searchResults = []
                }
            }
            .onAppear {
                loadRecommendedUsers()
            }
        }
    }
    
    private func loadRecommendedUsers() {
        // TODO: Implement friend matching algorithm
        // For now, just load some sample users
        recommendedUsers = [
            User(id: "1", email: "user1@example.com", phoneNumber: "1234567890", dateOfBirth: Date(), isStudent: true, displayName: "John Doe", graduationYear: 2024, clubs: ["Math Club"], videoGames: ["Minecraft"], hobbies: ["Reading"], school: "High School", careerAspirations: ["Engineering"], classes: ["Math"], pets: ["Dog"], sports: ["Soccer"]),
            User(id: "2", email: "user2@example.com", phoneNumber: "0987654321", dateOfBirth: Date(), isStudent: true, displayName: "Jane Smith", graduationYear: 2024, clubs: ["Science Club"], videoGames: ["Fortnite"], hobbies: ["Gaming"], school: "High School", careerAspirations: ["Computer Science"], classes: ["Physics"], pets: ["Cat"], sports: ["Basketball"])
        ]
    }
    
    private func searchUsers(query: String) {
        // TODO: Implement user search
        // For now, just filter the recommended users
        searchResults = recommendedUsers.filter { user in
            user.displayName.localizedCaseInsensitiveContains(query)
        }
    }
}

struct UserCard: View {
    let user: User
    @State private var showProfile = false
    
    var body: some View {
        Button {
            showProfile = true
        } label: {
            HStack(spacing: 15) {
                // Profile Image
                ZStack {
                    Circle()
                        .fill(Color(hex: "#2fa8fa").opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    Text(user.initials)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#2fa8fa"))
                }
                
                // User Info
                VStack(alignment: .leading, spacing: 5) {
                    Text(user.displayName)
                        .font(.headline)
                    
                    if let school = user.school {
                        Text(school)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    // Common Interests
                    HStack {
                        ForEach(user.hobbies.prefix(2), id: \.self) { hobby in
                            Text(hobby)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(hex: "#2fa8fa").opacity(0.1))
                                .foregroundColor(Color(hex: "#2fa8fa"))
                                .cornerRadius(8)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 5)
        }
        .sheet(isPresented: $showProfile) {
            UserProfileView(user: user)
        }
    }
} 