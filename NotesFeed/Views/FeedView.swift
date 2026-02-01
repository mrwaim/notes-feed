import SwiftUI

struct FeedView: View {
    @EnvironmentObject var feedService: FeedService
    @State private var selectedCharacterSlug: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(feedService.tweets) { tweet in
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
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Feed")
            .navigationDestination(item: $selectedCharacterSlug) { slug in
                ProfileView(characterSlug: slug)
            }
        }
    }
}

#Preview {
    FeedView()
        .environmentObject(FeedService())
}
