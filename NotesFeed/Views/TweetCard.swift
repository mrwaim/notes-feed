import SwiftUI

struct TweetCard: View {
    let tweet: Tweet
    let characterName: String
    let isLiked: Bool
    let onLikeTapped: () -> Void
    let onAuthorTapped: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button(action: onAuthorTapped) {
                    Text(characterName)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                .buttonStyle(.plain)

                Spacer()

                Text(tweet.createdAt, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text(tweet.text)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)

            HStack {
                Button(action: onLikeTapped) {
                    HStack(spacing: 4) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .secondary)
                    }
                }
                .buttonStyle(.plain)

                Spacer()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}
