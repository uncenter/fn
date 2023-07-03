#!/usr/bin/env bash

program_name="feed"
program_file="$program_name.sh"
install_locations=(
    "$HOME/.local/bin"
    "$HOME/bin"
)

for location in "${install_locations[@]}"; do
    if [ -f "$location/$program_name" ]; then
        echo "A file named $program_name already exists in $location or $program_name is already installed."
        read -r -n 1 -p "Do you want to [r]einstall, [u]ninstall, or [e]xit? " REPLY
        echo
        if [[ $REPLY =~ ^[Rr]$ ]]; then
            rm "$location/$program_name"
            echo "Uninstalled $program_name."
        elif [[ $REPLY =~ ^[Uu]$ ]]; then
            rm "$location/$program_name"
            echo "Uninstalled $program_name."
            exit 0
        else
            echo "Installation cancelled."
            exit 0
        fi
    fi
done

if [ -f "./$program_file" ]; then
    echo "A file named $program_file already exists in the current directory."
    echo "Please remove or rename it before installing."
    exit 1
fi

curl --silent --show-error --output $program_file https://raw.githubusercontent.com/uncenter/feed-newsboat/main/$program_file

chmod +x $program_file

for location in "${install_locations[@]}"; do
    if [ -d "$location" ]; then
        mv $program_file "$location/$program_name" && echo "Installed $program_name in $location. Run \`$program_name help\` for usage." || echo "Installation failed."
        install_location="$location"
        break
    fi
done
[ -z "$install_location" ] && echo "Installation failed. No suitable install location found." && exit 1

echo $PATH | grep -q "$install_location" || echo "WARNING: $install_location is not in your PATH. You will need to add it manually to use $program_name.\n\texport PATH=\"\$PATH:$install_location\""
