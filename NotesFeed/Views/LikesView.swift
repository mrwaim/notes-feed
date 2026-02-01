import SwiftUI

struct LikesView: View {
    @EnvironmentObject var feedService: FeedService
    @State private var selectedCharacterSlug: String?

    private var likedTweets: [Tweet] {
        feedService.tweets.filter { feedService.isLiked($0.id) }
    }

    var body: some View {
        NavigationStack {
            Group {
                if likedTweets.isEmpty {
                    ContentUnavailableView(
                        "No Likes Yet",
                        systemImage: "heart",
                        description: Text("Tweets you like will appear here")
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(likedTweets) { tweet in
                                let character = feedService.character(for: tweet.character)
                                TweetCard(
                                    tweet: tweet,
                                    characterName: character?.name ?? tweet.character,
                                    isLiked: feedService.isLiked(tweet.id),
                                    onLikeTapped: {
                                        feedService.toggleLike(tweet.id)
                                    },
                                    onAuthorTapped: {
                                        selectedCharacterSlug = tweet.character
                                    }
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Likes")
            .navigationDestination(item: $selectedCharacterSlug) { slug in
                ProfileView(characterSlug: slug)
            }
        }
    }
}

#Preview {
    LikesView()
        .environmentObject(FeedService())
}
