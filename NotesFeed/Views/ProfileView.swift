import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var feedService: FeedService
    let characterSlug: String

    private var character: Character? {
        feedService.character(for: characterSlug)
    }

    private var characterTweets: [Tweet] {
        feedService.tweets(for: characterSlug)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let character = character {
                    ProfileHeader(character: character)
                }

                Divider()
                    .padding(.horizontal)

                Text("Tweets")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                LazyVStack(spacing: 12) {
                    ForEach(characterTweets) { tweet in
                        TweetCard(
                            tweet: tweet,
                            characterName: character?.name ?? characterSlug,
                            isLiked: feedService.isLiked(tweet.id),
                            onLikeTapped: {
                                feedService.toggleLike(tweet.id)
                            },
                            onAuthorTapped: { }
                        )
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(character?.name ?? characterSlug)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProfileHeader: View {
    let character: Character

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(character.name)
                .font(.largeTitle)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: 8) {
                Text("Beliefs")
                    .font(.headline)
                    .foregroundColor(.secondary)

                ForEach(character.worldview.beliefs, id: \.self) { belief in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 6))
                            .padding(.top, 6)
                        Text(belief)
                            .font(.subheadline)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Blind Spots")
                    .font(.headline)
                    .foregroundColor(.secondary)

                ForEach(character.worldview.blindSpots, id: \.self) { blindSpot in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 6))
                            .padding(.top, 6)
                        Text(blindSpot)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        ProfileView(characterSlug: "the_architect")
            .environmentObject(FeedService())
    }
}
