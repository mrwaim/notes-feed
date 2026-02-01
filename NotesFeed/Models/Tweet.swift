import Foundation

struct Tweet: Codable, Identifiable {
    let tweetId: String
    let character: String
    let text: String
    let createdAt: Date

    var id: String { tweetId }

    enum CodingKeys: String, CodingKey {
        case tweetId = "tweet_id"
        case character
        case text
        case createdAt = "created_at"
    }
}
