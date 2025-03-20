import Foundation

struct PPowerStats: Codable {
    let intelligence: Int
    let strength: Int
    let speed: Int
    let durability: Int
    let power: Int
    let combat: Int
    
    enum CodingKeys: String, CodingKey {
        case intelligence, strength, speed, durability, power, combat
    }
}

