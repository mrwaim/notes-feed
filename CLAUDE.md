# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

**Regenerate feed data (required after adding/modifying tweets or characters):**
```bash
source venv/bin/activate && python scripts/build_feed.py
```

**Build iOS app:**
```bash
xcodebuild -project NotesFeed.xcodeproj -scheme NotesFeed -destination 'platform=iOS Simulator,name=iPhone 16' build
```

**Python environment setup (first time only):**
```bash
python3 -m venv venv && source venv/bin/activate && pip install pyyaml
```

## Architecture

This is a SwiftUI iOS app that displays a social media feed from simulated character tweets.

### Data Flow

1. **Source data** lives in `characters/`:
   - `characters/*.yaml` - Character profiles with name, worldview (beliefs, blind_spots)
   - `characters/tweets/*.jsonl` - Tweet data (tweet_id, character, text, created_at)

2. **Build script** (`scripts/build_feed.py`) reads source data and generates:
   - `NotesFeed/Resources/feed.json` - All tweets merged and randomized
   - `NotesFeed/Resources/characters.json` - Character profiles for the app

3. **iOS app** loads JSON at runtime via `FeedService`

### Key Components

- **FeedService** (`Services/FeedService.swift`): ObservableObject that loads feed/character JSON and manages likes via UserDefaults. Likes persist separately from feed data and survive feed regeneration.

- **Views**: FeedView (main scrollable feed) → TweetCard (individual tweet with like button) → ProfileView (character profile + their tweets). Tapping author name navigates to ProfileView.

- **Models**: Tweet and Character structs with Codable conformance. Character includes nested Worldview (beliefs, blindSpots arrays).

### Adding New Content

1. Add character profile: Create `characters/{slug}.yaml`
2. Add tweets: Create/edit `characters/tweets/{slug}.jsonl` (one JSON object per line)
3. Run build script to regenerate feed
4. Rebuild app
