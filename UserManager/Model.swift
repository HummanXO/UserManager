import Foundation

struct Response: Codable {
    let data: [User]
}

enum IDType: Codable {
    case int(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.typeMismatch(IDType.self, DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "ID must be Int or String"
            ))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        }
    }
}

struct User: Codable {
    let id: IDType
    let email: String
    let first_name: String
    let last_name: String?
    let avatar: String?
    
    var avatarURL: URL? {
        URL(string: avatar ?? "")
    }
}
