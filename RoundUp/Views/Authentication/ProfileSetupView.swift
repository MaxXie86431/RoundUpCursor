import SwiftUI

struct ProfileSetupView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var displayName = ""
    @State private var graduationYear: Int?
    @State private var clubs: [String] = []
    @State private var videoGames: [String] = []
    @State private var hobbies: [String] = []
    @State private var school = ""
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
        NavigationView {
            Form {
                Section(header: Text("Basic Information")) {
                    TextField("Display Name", text: $displayName)
                    
                    if authViewModel.currentUser?.isStudent == true {
                        TextField("Graduation Year", value: $graduationYear, format: .number)
                            .keyboardType(.numberPad)
                    }
                    
                    TextField("School/Organization/Company", text: $school)
                }
                
                Section(header: Text("Clubs & Teams")) {
                    ForEach(clubs, id: \.self) { club in
                        Text(club)
                    }
                    .onDelete { indexSet in
                        clubs.remove(atOffsets: indexSet)
                    }
                    
                    HStack {
                        TextField("Add Club", text: $newClub)
                        Button("Add") {
                            if !newClub.isEmpty {
                                clubs.append(newClub)
                                newClub = ""
                            }
                        }
                    }
                }
                
                Section(header: Text("Video Games")) {
                    ForEach(videoGames, id: \.self) { game in
                        Text(game)
                    }
                    .onDelete { indexSet in
                        videoGames.remove(atOffsets: indexSet)
                    }
                    
                    HStack {
                        TextField("Add Game", text: $newVideoGame)
                        Button("Add") {
                            if !newVideoGame.isEmpty {
                                videoGames.append(newVideoGame)
                                newVideoGame = ""
                            }
                        }
                    }
                }
                
                Section(header: Text("Hobbies")) {
                    ForEach(hobbies, id: \.self) { hobby in
                        Text(hobby)
                    }
                    .onDelete { indexSet in
                        hobbies.remove(atOffsets: indexSet)
                    }
                    
                    HStack {
                        TextField("Add Hobby", text: $newHobby)
                        Button("Add") {
                            if !newHobby.isEmpty {
                                hobbies.append(newHobby)
                                newHobby = ""
                            }
                        }
                    }
                }
                
                Section(header: Text("Career Aspirations")) {
                    ForEach(careerAspirations, id: \.self) { career in
                        Text(career)
                    }
                    .onDelete { indexSet in
                        careerAspirations.remove(atOffsets: indexSet)
                    }
                    
                    HStack {
                        TextField("Add Career", text: $newCareer)
                        Button("Add") {
                            if !newCareer.isEmpty {
                                careerAspirations.append(newCareer)
                                newCareer = ""
                            }
                        }
                    }
                }
                
                Section(header: Text("Classes/Job Role")) {
                    ForEach(classes, id: \.self) { class_ in
                        Text(class_)
                    }
                    .onDelete { indexSet in
                        classes.remove(atOffsets: indexSet)
                    }
                    
                    HStack {
                        TextField("Add Class/Role", text: $newClass)
                        Button("Add") {
                            if !newClass.isEmpty {
                                classes.append(newClass)
                                newClass = ""
                            }
                        }
                    }
                }
                
                Section(header: Text("Pets")) {
                    ForEach(pets, id: \.self) { pet in
                        Text(pet)
                    }
                    .onDelete { indexSet in
                        pets.remove(atOffsets: indexSet)
                    }
                    
                    HStack {
                        TextField("Add Pet", text: $newPet)
                        Button("Add") {
                            if !newPet.isEmpty {
                                pets.append(newPet)
                                newPet = ""
                            }
                        }
                    }
                }
                
                Section(header: Text("Sports")) {
                    ForEach(sports, id: \.self) { sport in
                        Text(sport)
                    }
                    .onDelete { indexSet in
                        sports.remove(atOffsets: indexSet)
                    }
                    
                    HStack {
                        TextField("Add Sport", text: $newSport)
                        Button("Add") {
                            if !newSport.isEmpty {
                                sports.append(newSport)
                                newSport = ""
                            }
                        }
                    }
                }
                
                Section {
                    Button("Complete Profile") {
                        Task {
                            if var user = authViewModel.currentUser {
                                user.displayName = displayName
                                user.graduationYear = graduationYear
                                user.clubs = clubs
                                user.videoGames = videoGames
                                user.hobbies = hobbies
                                user.school = school
                                user.careerAspirations = careerAspirations
                                user.classes = classes
                                user.pets = pets
                                user.sports = sports
                                
                                // Update user in Firestore
                                let encodedUser = try? Firestore.Encoder().encode(user)
                                if let data = encodedUser {
                                    try? await Firestore.firestore()
                                        .collection("users")
                                        .document(user.id!)
                                        .setData(data)
                                }
                                
                                authViewModel.currentUser = user
                                dismiss()
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
            .navigationTitle("Profile Setup")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
} 