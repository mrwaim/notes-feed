#!/bin/bash
# Sync characters and tweets from ~/Claude/notes to this project

SOURCE_DIR="$HOME/Claude/notes/characters"
DEST_DIR="$(dirname "$0")/../characters"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory not found: $SOURCE_DIR"
    exit 1
fi

# Copy character YAML files
cp "$SOURCE_DIR"/*.yaml "$DEST_DIR/"

# Copy tweets
cp "$SOURCE_DIR"/tweets/*.jsonl "$DEST_DIR/tweets/"

# Copy thoughts
cp "$SOURCE_DIR"/thoughts/*.jsonl "$DEST_DIR/thoughts/"

echo "Synced characters from $SOURCE_DIR"
