import Foundation

struct Images: Codable {
    let xs: String
    let sm: String
    let md: String
    let lg: String
    
    enum CodingKeys: String, CodingKey {
        case xs, sm, md, lg
    }
}
