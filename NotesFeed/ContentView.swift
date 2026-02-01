//
//  ContentView.swift
//  NotesFeed
//
//  Created by Klsandbox on 1/24/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var feedService = FeedService()

    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Label("Feed", systemImage: "list.bullet")
                }

            LikesView()
                .tabItem {
                    Label("Likes", systemImage: "heart.fill")
                }
        }
        .environmentObject(feedService)
    }
}

#Preview {
    ContentView()
}
