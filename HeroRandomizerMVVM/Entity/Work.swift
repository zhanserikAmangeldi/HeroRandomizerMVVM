import Foundation

struct Work: Codable {
    let occupation: String
    let base: String
    
    enum CodingKeys: String, CodingKey {
        case occupation, base
    }
}

