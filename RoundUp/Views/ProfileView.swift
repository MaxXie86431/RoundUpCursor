import SwiftUI
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isEditing = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var profileImage: Image?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Header
                VStack(spacing: 15) {
                    // Profile Image
                    ZStack {
                        if let profileImage {
                            profileImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color(hex: "#2fa8fa").opacity(0.1))
                                .frame(width: 120, height: 120)
                            
                            Text(authViewModel.currentUser?.initials ?? "")
                                .font(.system(size: 40))
                                .fontWeight(.bold)
                                .foregroundColor(Color(hex: "#2fa8fa"))
                        }
                        
                        if isEditing {
                            PhotosPicker(selection: $selectedItem) {
                                Image(systemName: "camera.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(Color(hex: "#2fa8fa"))
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                            .offset(x: 40, y: 40)
                        }
                    }
                    
                    // Name and School
                    VStack(spacing: 5) {
                        Text(authViewModel.currentUser?.displayName ?? "")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        if let school = authViewModel.currentUser?.school {
                            Text(school)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.top)
                
                // Edit Button
                Button {
                    isEditing.toggle()
                } label: {
                    Text(isEditing ? "Done" : "Edit Profile")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#2fa8fa"))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                // Profile Sections
                VStack(spacing: 20) {
                    if isEditing {
                        ProfileEditView()
                    } else {
                        ProfileInfoView()
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Profile")
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    profileImage = Image(uiImage: uiImage)
                    // TODO: Upload image to storage
                }
            }
        }
    }
}

struct ProfileInfoView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            if let user = authViewModel.currentUser {
                ProfileSection(title: "Clubs & Teams", items: user.clubs)
                ProfileSection(title: "Video Games", items: user.videoGames)
                ProfileSection(title: "Hobbies", items: user.hobbies)
                ProfileSection(title: "Career Aspirations", items: user.careerAspirations)
                ProfileSection(title: "Classes/Job Role", items: user.classes)
                ProfileSection(title: "Pets", items: user.pets)
                ProfileSection(title: "Sports", items: user.sports)
            }
        }
    }
}

struct ProfileEditView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var displayName = ""
    @State private var school = ""
    @State private var graduationYear: Int?
    @State private var clubs: [String] = []
    @State private var videoGames: [String] = []
    @State private var hobbies: [String] = []
    @State private var careerAspirations: [String] = []
    @State private var classes: [String] = []
    @State private var pets: [String] = []
    @State private var sports: [String] = []
    
    @State private var newClub = ""
    @State private var newVideoGame = ""
    @State private var newHobby = ""
    @State private var newCareer = ""
    @State private var newClass = ""
    @State private var newPet = ""
    @State private var newSport = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // Basic Information
            VStack(alignment: .leading, spacing: 10) {
                Text("Basic Information")
                    .font(.headline)
                
                TextField("Display Name", text: $displayName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("School/Organization/Company", text: $school)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if authViewModel.currentUser?.isStudent == true {
                    TextField("Graduation Year", value: $graduationYear, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
            }
            
            // Interests
            VStack(alignment: .leading, spacing: 10) {
                Text("Clubs & Teams")
                    .font(.headline)
                
                ForEach(clubs, id: \.self) { club in
                    HStack {
                        Text(club)
                        Spacer()
                        Button {
                            clubs.removeAll { $0 == club }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(Color(hex: "#f23a47"))
                        }
                    }
                }
                
                HStack {
                    TextField("Add Club", text: $newClub)
                    Button {
                        if !newClub.isEmpty {
                            clubs.append(newClub)
                            newClub = ""
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color(hex: "#2fa8fa"))
                    }
                }
            }
            
            // Similar sections for other interests...
            // (Video Games, Hobbies, Career Aspirations, Classes, Pets, Sports)
            
            // Save Button
            Button {
                saveProfile()
            } label: {
                Text("Save Changes")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "#2fa8fa"))
                    .cornerRadius(10)
            }
        }
        .onAppear {
            loadCurrentProfile()
        }
    }
    
    private func loadCurrentProfile() {
        if let user = authViewModel.currentUser {
            displayName = user.displayName
            school = user.school ?? ""
            graduationYear = user.graduationYear
            clubs = user.clubs
            videoGames = user.videoGames
            hobbies = user.hobbies
            careerAspirations = user.careerAspirations
            classes = user.classes
            pets = user.pets
            sports = user.sports
        }
    }
    
    private func saveProfile() {
        // TODO: Update profile in Firestore
        if var user = authViewModel.currentUser {
            user.displayName = displayName
            user.school = school
            user.graduationYear = graduationYear
            user.clubs = clubs
            user.videoGames = videoGames
            user.hobbies = hobbies
            user.careerAspirations = careerAspirations
            user.classes = classes
            user.pets = pets
            user.sports = sports
            
            // Update user in Firestore
            let encodedUser = try? Firestore.Encoder().encode(user)
            if let data = encodedUser {
                Task {
                    try? await Firestore.firestore()
                        .collection("users")
                        .document(user.id!)
                        .setData(data)
                }
            }
            
            authViewModel.currentUser = user
        }
    }
}

struct ProfileSection: View {
    let title: String
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            
            if items.isEmpty {
                Text("No \(title.lowercased()) added yet")
                    .foregroundColor(.gray)
            } else {
                FlowLayout(spacing: 8) {
                    ForEach(items, id: \.self) { item in
                        Text(item)
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(hex: "#2fa8fa").opacity(0.1))
                            .foregroundColor(Color(hex: "#2fa8fa"))
                            .cornerRadius(15)
                    }
                }
            }
        }
    }
}

struct FlowLayout: Layout {
    let spacing: CGFloat
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, spacing: spacing, subviews: subviews)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, spacing: spacing, subviews: subviews)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: result.positions[index], proposal: .unspecified)
        }
    }
    
    private struct FlowResult {
        var size: CGSize
        var positions: [CGPoint]
        
        init(in width: CGFloat, spacing: CGFloat, subviews: Subviews) {
            var positions: [CGPoint] = []
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let viewSize = subview.sizeThatFits(.unspecified)
                
                if currentX + viewSize.width > width {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: currentX, y: currentY))
                currentX += viewSize.width + spacing
                lineHeight = max(lineHeight, viewSize.height)
                size.width = max(size.width, currentX)
                size.height = currentY + lineHeight
            }
            
            self.positions = positions
        }
    }
} 