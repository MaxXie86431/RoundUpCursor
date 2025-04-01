import SwiftUI

struct JoinGroupView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var searchText = ""
    @State private var groups: [Group] = []
    @State private var filteredGroups: [Group] = []
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search groups", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding()
                
                // Groups List
                List(filteredGroups) { group in
                    GroupRow(group: group) {
                        joinGroup(group)
                    }
                }
            }
            .navigationTitle("Join Group")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onChange(of: searchText) { newValue in
                if newValue.isEmpty {
                    filteredGroups = groups
                } else {
                    filteredGroups = groups.filter { group in
                        group.name.localizedCaseInsensitiveContains(newValue) ||
                        group.description.localizedCaseInsensitiveContains(newValue) ||
                        group.interests.contains { interest in
                            interest.localizedCaseInsensitiveContains(newValue)
                        }
                    }
                }
            }
            .onAppear {
                loadGroups()
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func loadGroups() {
        // TODO: Load groups from Firestore
        // For now, just load sample data
        groups = [
            Group(id: "1", name: "Math Enthusiasts", description: "A group for people who love mathematics", creatorId: "1", members: ["1"], interests: ["Mathematics", "Problem Solving"], createdAt: Date()),
            Group(id: "2", name: "Gaming Squad", description: "Connect with fellow gamers", creatorId: "2", members: ["2"], interests: ["Gaming", "Video Games"], createdAt: Date())
        ]
        filteredGroups = groups
    }
    
    private func joinGroup(_ group: Group) {
        guard let currentUser = authViewModel.currentUser else {
            showError = true
            errorMessage = "User not found"
            return
        }
        
        // Check if user is already a member
        if group.members.contains(currentUser.id!) {
            showError = true
            errorMessage = "You are already a member of this group"
            return
        }
        
        // TODO: Update group in Firestore
        Task {
            do {
                var updatedGroup = group
                updatedGroup.members.append(currentUser.id!)
                
                let encodedGroup = try Firestore.Encoder().encode(updatedGroup)
                try await Firestore.firestore()
                    .collection("groups")
                    .document(group.id)
                    .setData(encodedGroup)
                
                // Update local state
                if let index = groups.firstIndex(where: { $0.id == group.id }) {
                    groups[index] = updatedGroup
                    filteredGroups[index] = updatedGroup
                }
            } catch {
                showError = true
                errorMessage = error.localizedDescription
            }
        }
    }
}

struct GroupRow: View {
    let group: Group
    let onJoin: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(group.name)
                        .font(.headline)
                    
                    Text(group.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button("Join") {
                    onJoin()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Color(hex: "#2fa8fa"))
                .cornerRadius(15)
            }
            
            // Interests
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(group.interests, id: \.self) { interest in
                        Text(interest)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(hex: "#2fa8fa").opacity(0.1))
                            .foregroundColor(Color(hex: "#2fa8fa"))
                            .cornerRadius(15)
                    }
                }
            }
            
            // Member Count
            Text("\(group.members.count) members")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
} 