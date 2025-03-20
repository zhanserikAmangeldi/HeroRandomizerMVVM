import Foundation

struct Appearance: Codable {
    let gender: String
    let race: String?
    let height: [String]
    let weight: [String]
    let eyeColor: String
    let hairColor: String
    
    enum CodingKeys: String, CodingKey {
        case gender, race, height, weight, eyeColor, hairColor
    }
}
