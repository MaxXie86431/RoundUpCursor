import SwiftUI

struct CreateGroupView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var groupName = ""
    @State private var groupDescription = ""
    @State private var interests: [String] = []
    @State private var newInterest = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Group Information")) {
                    TextField("Group Name", text: $groupName)
                    TextEditor(text: $groupDescription)
                        .frame(height: 100)
                }
                
                Section(header: Text("Interests")) {
                    ForEach(interests, id: \.self) { interest in
                        HStack {
                            Text(interest)
                            Spacer()
                            Button {
                                interests.removeAll { $0 == interest }
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(Color(hex: "#f23a47"))
                            }
                        }
                    }
                    
                    HStack {
                        TextField("Add Interest", text: $newInterest)
                        Button {
                            if !newInterest.isEmpty {
                                interests.append(newInterest)
                                newInterest = ""
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(Color(hex: "#2fa8fa"))
                        }
                    }
                }
                
                Section {
                    Button("Create Group") {
                        createGroup()
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(hex: "#2fa8fa"))
                    .cornerRadius(10)
                }
            }
            .navigationTitle("Create Group")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func createGroup() {
        guard !groupName.isEmpty else {
            showError = true
            errorMessage = "Please enter a group name"
            return
        }
        
        guard let currentUser = authViewModel.currentUser else {
            showError = true
            errorMessage = "User not found"
            return
        }
        
        let group = Group(
            id: UUID().uuidString,
            name: groupName,
            description: groupDescription,
            creatorId: currentUser.id!,
            members: [currentUser.id!],
            interests: interests,
            createdAt: Date()
        )
        
        // TODO: Save group to Firestore
        Task {
            do {
                let encodedGroup = try Firestore.Encoder().encode(group)
                try await Firestore.firestore()
                    .collection("groups")
                    .document(group.id)
                    .setData(encodedGroup)
                
                dismiss()
            } catch {
                showError = true
                errorMessage = error.localizedDescription
            }
        }
    }
}

struct Group: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let creatorId: String
    var members: [String]
    let interests: [String]
    let createdAt: Date
} 