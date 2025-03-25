import Foundation

struct HeroListModel: Identifiable, Equatable {
    let id: Int
    let name: String
    let fullName: String
    let race: String
    let publisher: String?
    let alignment: String
    let imageUrl: URL?
    
    let intelligence: Int
    let strength: Int
    let speed: Int
    
    static func == (lhs: HeroListModel, rhs: HeroListModel) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.fullName == rhs.fullName &&
        lhs.race == rhs.race &&
        lhs.publisher == rhs.publisher &&
        lhs.alignment == rhs.alignment &&
        lhs.intelligence == rhs.intelligence &&
        lhs.strength == rhs.strength &&
        lhs.speed == rhs.speed
    }
}
