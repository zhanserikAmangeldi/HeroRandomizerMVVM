import Foundation

struct Biography: Codable {
    let fullName: String
    let alterEgos: String
    let aliases: [String]
    let placeOfBirth: String
    let firstAppearance: String
    let publisher: String
    let alignment: String
    
    enum CodingKeys: String, CodingKey {
        case fullName = "fullName"
        case alterEgos = "alterEgos"
        case aliases, placeOfBirth, firstAppearance, publisher, alignment
    }
}
