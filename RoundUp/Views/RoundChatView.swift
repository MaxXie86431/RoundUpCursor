import SwiftUI

struct RoundChatView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var searchText = ""
    @State private var conversations: [Conversation] = []
    @State private var searchResults: [Conversation] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search conversations", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding()
                
                if searchText.isEmpty {
                    // Conversations List
                    List(conversations) { conversation in
                        NavigationLink(destination: ChatRoomView(conversation: conversation)) {
                            ConversationRow(conversation: conversation)
                        }
                    }
                } else {
                    // Search Results
                    List(searchResults) { conversation in
                        NavigationLink(destination: ChatRoomView(conversation: conversation)) {
                            ConversationRow(conversation: conversation)
                        }
                    }
                }
            }
            .navigationTitle("RoundChat")
            .onChange(of: searchText) { newValue in
                if !newValue.isEmpty {
                    searchConversations(query: newValue)
                } else {
                    searchResults = []
                }
            }
            .onAppear {
                loadConversations()
            }
        }
    }
    
    private func loadConversations() {
        // TODO: Load conversations from Firestore
        // For now, just load sample data
        conversations = [
            Conversation(id: "1", participants: [
                User(id: "1", email: "user1@example.com", phoneNumber: "1234567890", dateOfBirth: Date(), isStudent: true, displayName: "John Doe", graduationYear: 2024, clubs: ["Math Club"], videoGames: ["Minecraft"], hobbies: ["Reading"], school: "High School", careerAspirations: ["Engineering"], classes: ["Math"], pets: ["Dog"], sports: ["Soccer"]),
                authViewModel.currentUser!
            ], lastMessage: Message(id: "1", senderId: "1", content: "Hey, how are you?", timestamp: Date())),
            Conversation(id: "2", participants: [
                User(id: "2", email: "user2@example.com", phoneNumber: "0987654321", dateOfBirth: Date(), isStudent: true, displayName: "Jane Smith", graduationYear: 2024, clubs: ["Science Club"], videoGames: ["Fortnite"], hobbies: ["Gaming"], school: "High School", careerAspirations: ["Computer Science"], classes: ["Physics"], pets: ["Cat"], sports: ["Basketball"]),
                authViewModel.currentUser!
            ], lastMessage: Message(id: "2", senderId: "2", content: "Want to study together?", timestamp: Date()))
        ]
    }
    
    private func searchConversations(query: String) {
        // TODO: Implement conversation search
        // For now, just filter the conversations
        searchResults = conversations.filter { conversation in
            conversation.participants.contains { user in
                user.displayName.localizedCaseInsensitiveContains(query)
            }
        }
    }
}

struct Conversation: Identifiable {
    let id: String
    let participants: [User]
    let lastMessage: Message
}

struct Message: Identifiable {
    let id: String
    let senderId: String
    let content: String
    let timestamp: Date
}

struct ConversationRow: View {
    let conversation: Conversation
    
    var otherParticipant: User {
        conversation.participants.first { $0.id != Auth.auth().currentUser?.uid } ?? conversation.participants[0]
    }
    
    var body: some View {
        HStack(spacing: 15) {
            // Profile Image
            ZStack {
                Circle()
                    .fill(Color(hex: "#2fa8fa").opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Text(otherParticipant.initials)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#2fa8fa"))
            }
            
            // Conversation Info
            VStack(alignment: .leading, spacing: 5) {
                Text(otherParticipant.displayName)
                    .font(.headline)
                
                Text(conversation.lastMessage.content)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Time
            Text(conversation.lastMessage.timestamp, style: .time)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

struct ChatRoomView: View {
    let conversation: Conversation
    @State private var messageText = ""
    @State private var messages: [Message] = []
    
    var body: some View {
        VStack(spacing: 0) {
            // Messages List
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(messages) { message in
                        MessageBubble(message: message, isCurrentUser: message.senderId == Auth.auth().currentUser?.uid)
                    }
                }
                .padding()
            }
            
            // Message Input
            HStack(spacing: 15) {
                TextField("Type a message...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(Color(hex: "#2fa8fa"))
                }
            }
            .padding()
        }
        .navigationTitle(otherParticipant.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadMessages()
        }
    }
    
    private var otherParticipant: User {
        conversation.participants.first { $0.id != Auth.auth().currentUser?.uid } ?? conversation.participants[0]
    }
    
    private func loadMessages() {
        // TODO: Load messages from Firestore
        // For now, just load sample data
        messages = [
            Message(id: "1", senderId: otherParticipant.id!, content: "Hey, how are you?", timestamp: Date()),
            Message(id: "2", senderId: Auth.auth().currentUser!.uid, content: "I'm good, thanks! How about you?", timestamp: Date()),
            Message(id: "3", senderId: otherParticipant.id!, content: "Great! Want to study together?", timestamp: Date())
        ]
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        // TODO: Send message to Firestore
        let newMessage = Message(
            id: UUID().uuidString,
            senderId: Auth.auth().currentUser!.uid,
            content: messageText,
            timestamp: Date()
        )
        
        messages.append(newMessage)
        messageText = ""
    }
}

struct MessageBubble: View {
    let message: Message
    let isCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isCurrentUser { Spacer() }
            
            Text(message.content)
                .padding()
                .background(isCurrentUser ? Color(hex: "#2fa8fa") : Color(.systemGray6))
                .foregroundColor(isCurrentUser ? .white : .primary)
                .cornerRadius(20)
            
            if !isCurrentUser { Spacer() }
        }
    }
} 