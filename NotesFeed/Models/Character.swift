import Foundation

struct Worldview: Codable {
    let beliefs: [String]
    let blindSpots: [String]

    enum CodingKeys: String, CodingKey {
        case beliefs
        case blindSpots = "blind_spots"
    }
}

struct Character: Codable, Identifiable {
    let name: String
    let slug: String
    let worldview: Worldview

    var id: String { slug }
}
