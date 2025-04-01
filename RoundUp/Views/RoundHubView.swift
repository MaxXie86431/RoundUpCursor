import SwiftUI

struct RoundHubView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showCreateGroup = false
    @State private var showJoinGroup = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Welcome Section
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Welcome,")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(authViewModel.currentUser?.displayName ?? "User")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                        
                        // Profile Button
                        NavigationLink(destination: ProfileView()) {
                            Image(systemName: "person.circle.fill")
                                .font(.title2)
                                .foregroundColor(Color(hex: "#2fa8fa"))
                        }
                        
                        // Notifications Button
                        Button {
                            // Show notifications
                        } label: {
                            Image(systemName: "bell.fill")
                                .font(.title2)
                                .foregroundColor(Color(hex: "#2fa8fa"))
                        }
                    }
                    .padding(.horizontal)
                    
                    // Action Buttons
                    HStack(spacing: 15) {
                        Button {
                            showCreateGroup = true
                        } label: {
                            VStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                                Text("Create Group")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#2fa8fa"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        
                        Button {
                            showJoinGroup = true
                        } label: {
                            VStack {
                                Image(systemName: "person.badge.plus.fill")
                                    .font(.title)
                                Text("Join Group")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#f23a47"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    
                    // My Groups Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("My Groups")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(0..<5) { _ in
                                    GroupCard()
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("RoundHub")
            .sheet(isPresented: $showCreateGroup) {
                CreateGroupView()
            }
            .sheet(isPresented: $showJoinGroup) {
                JoinGroupView()
            }
        }
    }
}

struct GroupCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: "person.3.fill")
                .font(.system(size: 40))
                .foregroundColor(Color(hex: "#2fa8fa"))
                .frame(width: 60, height: 60)
                .background(Color(hex: "#2fa8fa").opacity(0.1))
                .cornerRadius(10)
            
            Text("Group Name")
                .font(.headline)
            
            Text("12 members")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(width: 150)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
} 