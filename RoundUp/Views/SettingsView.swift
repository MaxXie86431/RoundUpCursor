import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account")) {
                    NavigationLink(destination: ProfileView()) {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(Color(hex: "#2fa8fa"))
                            Text("Profile")
                        }
                    }
                    
                    Button {
                        authViewModel.signOut()
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(Color(hex: "#f23a47"))
                            Text("Sign Out")
                                .foregroundColor(Color(hex: "#f23a47"))
                        }
                    }
                }
                
                Section(header: Text("Preferences")) {
                    Toggle(isOn: $isDarkMode) {
                        HStack {
                            Image(systemName: "moon.fill")
                                .foregroundColor(Color(hex: "#2fa8fa"))
                            Text("Dark Mode")
                        }
                    }
                    
                    Toggle(isOn: $notificationsEnabled) {
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(Color(hex: "#2fa8fa"))
                            Text("Notifications")
                        }
                    }
                }
                
                Section(header: Text("Security")) {
                    NavigationLink(destination: SecuritySettingsView()) {
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(Color(hex: "#2fa8fa"))
                            Text("Security Settings")
                        }
                    }
                    
                    NavigationLink(destination: PrivacySettingsView()) {
                        HStack {
                            Image(systemName: "hand.raised.fill")
                                .foregroundColor(Color(hex: "#2fa8fa"))
                            Text("Privacy Settings")
                        }
                    }
                }
                
                Section(header: Text("About")) {
                    NavigationLink(destination: AboutView()) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(Color(hex: "#2fa8fa"))
                            Text("About RoundUp")
                        }
                    }
                    
                    Link(destination: URL(string: "https://roundup.app/privacy")!) {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(Color(hex: "#2fa8fa"))
                            Text("Privacy Policy")
                        }
                    }
                    
                    Link(destination: URL(string: "https://roundup.app/terms")!) {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(Color(hex: "#2fa8fa"))
                            Text("Terms of Service")
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SecuritySettingsView: View {
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        Form {
            Section(header: Text("Change Password")) {
                SecureField("Current Password", text: $currentPassword)
                SecureField("New Password", text: $newPassword)
                SecureField("Confirm New Password", text: $confirmPassword)
                
                Button("Update Password") {
                    updatePassword()
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding()
                .background(Color(hex: "#2fa8fa"))
                .cornerRadius(10)
            }
            
            Section(header: Text("Two-Factor Authentication")) {
                Toggle("Enable Two-Factor Authentication", isOn: .constant(false))
            }
        }
        .navigationTitle("Security")
        .alert("Password Update", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
    
    private func updatePassword() {
        // TODO: Implement password update
        alertMessage = "Password updated successfully"
        showAlert = true
    }
}

struct PrivacySettingsView: View {
    @AppStorage("profileVisibility") private var profileVisibility = "Everyone"
    @AppStorage("showOnlineStatus") private var showOnlineStatus = true
    @AppStorage("showReadReceipts") private var showReadReceipts = true
    
    var body: some View {
        Form {
            Section(header: Text("Profile Visibility")) {
                Picker("Who can see your profile?", selection: $profileVisibility) {
                    Text("Everyone").tag("Everyone")
                    Text("Friends Only").tag("Friends Only")
                    Text("Private").tag("Private")
                }
            }
            
            Section(header: Text("Online Status")) {
                Toggle("Show Online Status", isOn: $showOnlineStatus)
                Toggle("Show Read Receipts", isOn: $showReadReceipts)
            }
            
            Section(header: Text("Data Management")) {
                NavigationLink(destination: DataManagementView()) {
                    Text("Manage Your Data")
                }
            }
        }
        .navigationTitle("Privacy")
    }
}

struct AboutView: View {
    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Color(hex: "#2fa8fa"))
                    Spacer()
                }
                
                Text("RoundUp")
                    .font(.title)
                    .frame(maxWidth: .infinity)
                
                Text("Version 1.0.0")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
            }
            
            Section(header: Text("Description")) {
                Text("RoundUp is a social media app designed to help users find new friends based on shared interests and group people into communities to foster closer connections.")
                    .multilineTextAlignment(.center)
            }
            
            Section(header: Text("Contact")) {
                Link(destination: URL(string: "mailto:support@roundup.app")!) {
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("Contact Support")
                    }
                }
            }
        }
        .navigationTitle("About")
    }
}

struct DataManagementView: View {
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        Form {
            Section(header: Text("Data Export")) {
                Button("Export Your Data") {
                    // TODO: Implement data export
                }
            }
            
            Section(header: Text("Account Deletion")) {
                Button("Delete Account") {
                    showDeleteConfirmation = true
                }
                .foregroundColor(Color(hex: "#f23a47"))
            }
        }
        .navigationTitle("Data Management")
        .alert("Delete Account", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                // TODO: Implement account deletion
            }
        } message: {
            Text("Are you sure you want to delete your account? This action cannot be undone.")
        }
    }
} 