import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var phoneNumber = ""
    @State private var dateOfBirth = Date()
    @State private var isStudent = true
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showProfileSetup = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account Information")) {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $password)
                        .textContentType(.newPassword)
                    
                    TextField("Phone Number", text: $phoneNumber)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                }
                
                Section(header: Text("Personal Information")) {
                    DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                    
                    Picker("Account Type", selection: $isStudent) {
                        Text("Student").tag(true)
                        Text("Adult").tag(false)
                    }
                }
                
                Section {
                    Button("Create Account") {
                        Task {
                            do {
                                try await authViewModel.createUser(
                                    withEmail: email,
                                    password: password,
                                    phoneNumber: phoneNumber,
                                    dateOfBirth: dateOfBirth,
                                    isStudent: isStudent
                                )
                                showProfileSetup = true
                            } catch {
                                showError = true
                                errorMessage = error.localizedDescription
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(hex: "#2fa8fa"))
                    .cornerRadius(10)
                }
            }
            .navigationTitle("Sign Up")
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
            .sheet(isPresented: $showProfileSetup) {
                ProfileSetupView()
            }
        }
    }
} 