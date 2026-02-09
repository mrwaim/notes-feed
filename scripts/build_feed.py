#!/usr/bin/env python3
"""
Build script for NotesFeed app.
Reads character YAML profiles and tweet JSONL files,
generates feed.json and characters.json for the iOS app.
"""

import json
import os
import random
from datetime import datetime
from pathlib import Path

import yaml

# Paths relative to script location
SCRIPT_DIR = Path(__file__).parent
PROJECT_ROOT = SCRIPT_DIR.parent
CHARACTERS_DIR = PROJECT_ROOT / "characters"
TWEETS_DIR = CHARACTERS_DIR / "tweets"
OUTPUT_DIR = PROJECT_ROOT / "output"


def load_character_profiles():
    """Load all character YAML profiles."""
    characters = []
    for yaml_file in CHARACTERS_DIR.glob("*.yaml"):
        with open(yaml_file, "r") as f:
            data = yaml.safe_load(f)
            slug = yaml_file.stem  # e.g., "the_architect"
            character = {
                "name": data.get("name", slug),
                "slug": slug,
                "worldview": data.get("worldview", {}),
            }
            characters.append(character)
    return characters


def load_all_tweets():
    """Load all tweets from JSONL files."""
    tweets = []
    for jsonl_file in TWEETS_DIR.glob("*.jsonl"):
        with open(jsonl_file, "r") as f:
            for line in f:
                line = line.strip()
                if line:
                    tweet = json.loads(line)
                    tweets.append(tweet)
    return tweets


def main():
    # Ensure Resources directory exists
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    # Load data
    print("Loading character profiles...")
    characters = load_character_profiles()
    print(f"  Found {len(characters)} characters")

    print("Loading tweets...")
    tweets = load_all_tweets()
    print(f"  Found {len(tweets)} tweets")

    # Sort by date (newest first), randomize within the same date
    for tweet in tweets:
        dt = datetime.fromisoformat(tweet["created_at"])
        tweet["_date"] = dt.date()
    random.shuffle(tweets)  # shuffle first so within-date order is random
    tweets.sort(key=lambda t: t["_date"], reverse=True)
    for tweet in tweets:
        del tweet["_date"]

    # Write characters.json
    characters_path = OUTPUT_DIR / "characters.json"
    with open(characters_path, "w") as f:
        json.dump(characters, f, indent=2)
    print(f"Wrote {characters_path}")

    # Write feed.json
    feed_path = OUTPUT_DIR / "feed.json"
    with open(feed_path, "w") as f:
        json.dump(tweets, f, indent=2)
    print(f"Wrote {feed_path}")

    print("Done!")


if __name__ == "__main__":
    main()
