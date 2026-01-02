#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_DIR="$HOME/.cache/wallpaper-rofi"

# Create the cache directory if it doesn't exist
mkdir -p "$CACHE_DIR"

# Function to generate the Rofi menu
generate_menu() {
    for img in "$WALLPAPER_DIR"/*.{jpg,jpeg,png,gif}; do
        [ -f "$img" ] || continue
        filename=$(basename "$img")
        cached_thumb="$CACHE_DIR/${filename%.*}.png"
        
        # Generate a cached thumbnail if it doesn't exist or if the image has been modified
        if [ ! -f "$cached_thumb" ] || [ "$img" -nt "$cached_thumb" ]; then
            if [[ "$img" == *.gif ]]; then
                convert "$img[0]" -thumbnail 160x160^ -gravity center -extent 160x160 "$cached_thumb"
            else
                convert "$img" -thumbnail 160x160^ -gravity center -extent 160x160 "$cached_thumb"
            fi
        fi
        
        # Output the image and its thumbnail for Rofi
        printf "%s\0icon\x1f%s\n" "$filename" "$cached_thumb"
    done
}

# Function to change the wallpaper
change_wallpaper() {
    local wallpaper="$WALLPAPER_DIR/$1"
    
    # Set wallpaper using awww
    if command -v awww &> /dev/null; then
        if [[ "$wallpaper" == *.gif ]]; then
            awww img "$wallpaper" \
                --transition-type grow \
                --transition-angle 30 \
                --transition-step 90 \
                --transition-duration 2 \
                --transition-fps 60 \
                --transition-bezier .65,.05,.36,1 \
                --gif
        else
            awww img "$wallpaper" \
                --transition-type grow \
                --transition-angle 30 \
                --transition-step 90 \
                --transition-duration 2 \
                --transition-fps 60 \
                --transition-bezier .65,.05,.36,1
        fi
    else
        echo "Error: awww not found. Please install awww."
        exit 1
    fi
    
    # Generate color scheme using pywal
    if command -v wal &> /dev/null; then
        wal -i "$wallpaper" -n
        pywalfox update
    fi
}

# Main function to display the Rofi menu and change the wallpaper
main() {
    # Show Rofi menu to select wallpaper
    chosen=$(generate_menu | rofi -dmenu -theme ~/.config/rofi/style-wallpaper.rasi -show-icons -matching fuzzy -sort -sorting-method fzf -i)
    
    # If a wallpaper was selected, change it
    if [ -n "$chosen" ]; then
        change_wallpaper "$chosen"
    fi
}

# Run the main function
main
