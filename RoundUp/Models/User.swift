import Foundation

struct User: Codable, Identifiable {
    let id: String
    let email: String
    var phoneNumber: String?
    var dateOfBirth: Date?
    var isStudent: Bool
    var displayName: String?
    var graduationYear: Int?
    var clubs: [String]
    var videoGames: [String]
    var hobbies: [String]
    var school: String?
    var careerAspirations: [String]
    var classes: [String]
    var pets: [String]
    var sports: [String]
    var avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case phoneNumber = "phone_number"
        case dateOfBirth = "date_of_birth"
        case isStudent = "is_student"
        case displayName = "display_name"
        case graduationYear = "graduation_year"
        case clubs
        case videoGames = "video_games"
        case hobbies
        case school
        case careerAspirations = "career_aspirations"
        case classes
        case pets
        case sports
        case avatarUrl = "avatar_url"
    }
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: displayName ?? "") {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return String(displayName?.prefix(2) ?? "").uppercased()
    }
} 