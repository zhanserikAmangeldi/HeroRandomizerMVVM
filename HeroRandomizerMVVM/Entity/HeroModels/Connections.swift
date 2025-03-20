import Foundation

struct Connections: Codable {
    let groupAffiliation: String
    let relatives: String
    
    enum CodingKeys: String, CodingKey {
        case groupAffiliation, relatives
    }
}
