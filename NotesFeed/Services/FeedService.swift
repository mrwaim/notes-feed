import Foundation

class FeedService: ObservableObject {
    @Published var tweets: [Tweet] = []
    @Published var characters: [Character] = []
    @Published var likedTweetIds: Set<String> = []

    private let likedTweetsKey = "likedTweetIds"

    init() {
        loadLikedTweets()
        loadFeed()
        loadCharacters()
    }

    private func loadFeed() {
        guard let url = Bundle.main.url(forResource: "feed", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Could not load feed.json")
            return
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            tweets = try decoder.decode([Tweet].self, from: data)
        } catch {
            print("Error decoding feed: \(error)")
        }
    }

    private func loadCharacters() {
        guard let url = Bundle.main.url(forResource: "characters", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Could not load characters.json")
            return
        }

        do {
            characters = try JSONDecoder().decode([Character].self, from: data)
        } catch {
            print("Error decoding characters: \(error)")
        }
    }

    private func loadLikedTweets() {
        if let savedIds = UserDefaults.standard.array(forKey: likedTweetsKey) as? [String] {
            likedTweetIds = Set(savedIds)
        }
    }

    private func saveLikedTweets() {
        UserDefaults.standard.set(Array(likedTweetIds), forKey: likedTweetsKey)
    }

    func isLiked(_ tweetId: String) -> Bool {
        likedTweetIds.contains(tweetId)
    }

    func toggleLike(_ tweetId: String) {
        if likedTweetIds.contains(tweetId) {
            likedTweetIds.remove(tweetId)
        } else {
            likedTweetIds.insert(tweetId)
        }
        saveLikedTweets()
    }

    func character(for slug: String) -> Character? {
        characters.first { $0.slug == slug }
    }

    func tweets(for characterSlug: String) -> [Tweet] {
        tweets.filter { $0.character == characterSlug }
    }
}
