import Foundation

struct Response: Codable {
    let data: [User]
}

struct User: Codable {
    let id: Int
    let email: String
    let first_name: String
    let last_name: String
    let avatar: String
    
    var avatarURL: URL? {
        URL(string: avatar)
    }
}
