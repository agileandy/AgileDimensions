#!/bin/bash

# Check if curl is installed
if ! command -v curl &> /dev/null
then
    echo "curl could not be found. Please install it." >&2
    exit 1
fi

# Create the images directory if it doesn't exist.  -p ensures it only creates if needed.
mkdir -p images

# Extract image URLs from index.html using grep and sed
image_urls=$(grep -oP '(?<=src=")[^"]*' index.html)

# Determine the base directory (where index.html is located)
base_dir=$(dirname "$(readlink -f "index.html")")


# Loop through the extracted image URLs
while read -r relative_url; do
    # Construct the full URL by combining the base directory and the relative URL
    full_url="${base_dir}/${relative_url}"
    echo "Copying: ${full_url}"  # Log the full URL
    local filename=$(basename "${relative_url##*/}")
    local output_file="images/${filename}"

    # Copy the file
    if cp "${full_url}" "${output_file}"; then
        echo "Successfully copied: ${full_url} to ${output_file}"
    else
        echo "Error copying: ${full_url} to ${output_file}" >&2
    fi
done <<< "$image_urls"

echo "Image downloads complete. Check the 'images' directory."
