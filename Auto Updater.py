import requests
import os
import zipfile
import io

# URL of the GitHub releases page for the mod
REPO_URL = "https://api.github.com/repos/JordanLeich/Ultimate-Controller-Support/releases/latest"
# URL to download the source code zip for the latest release
ZIP_URL = "https://github.com/JordanLeich/Ultimate-Controller-Support/archive/refs/tags/{tag_name}.zip"
# Path to the file where the saved version is stored
SAVED_VERSION_FILE = "saved_version.txt"

def get_latest_version():
    """Fetch the latest version from the GitHub API."""
    print("Fetching the latest version information from GitHub...")
    try:
        response = requests.get(REPO_URL)
        response.raise_for_status()
        latest_release = response.json()
        latest_version = latest_release["tag_name"]
        print(f"Latest version found: {latest_version}")
        return latest_version
    except requests.RequestException as e:
        print(f"Error fetching the latest version: {e}")
        return None

def get_saved_version():
    """Read the saved version from the file."""
    print("Checking for saved version...")
    try:
        with open(SAVED_VERSION_FILE, "r") as file:
            version = file.read().strip()
            print(f"Saved version found: {version}")
            return version
    except FileNotFoundError:
        print("No saved version file found.")
        return None

def save_version(version):
    """Save the latest version to the file."""
    print(f"Saving version {version} to file...")
    with open(SAVED_VERSION_FILE, "w") as file:
        file.write(version)
    print("Version saved successfully.")

def download_and_extract_zip(latest_version):
    """Download and extract the latest version of the repository as a ZIP file."""
    zip_url = ZIP_URL.format(tag_name=latest_version)
    print(f"Downloading and extracting: {zip_url}")

    try:
        response = requests.get(zip_url)
        response.raise_for_status()

        zip_content = io.BytesIO(response.content)
        with zipfile.ZipFile(zip_content, "r") as zip_ref:
            # Extract all files while ignoring the top-level directory
            for member in zip_ref.namelist():
                # Remove the top-level directory from the file path
                extracted_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), *member.split('/')[1:])
                if member.endswith('/'):  # if it's a directory
                    os.makedirs(extracted_path, exist_ok=True)
                else:
                    with zip_ref.open(member) as source, open(extracted_path, 'wb') as target:
                        target.write(source.read())

        print(f"Downloaded and extracted the latest version: {latest_version}")
    except requests.RequestException as e:
        print(f"Failed to download the latest version: {e}")
    except zipfile.BadZipFile as e:
        print(f"Failed to extract the ZIP file: {e}")

def check_for_updates():
    """Check if the latest version matches the saved version."""
    print("Starting update check...")
    latest_version = get_latest_version()
    if not latest_version:
        print("Could not retrieve the latest version. Exiting.")
        return
    
    saved_version = get_saved_version()
    
    if saved_version is None:
        print(f"No saved version found. Saving the latest version ({latest_version}).")
        save_version(latest_version)
    elif latest_version != saved_version:
        print(f"Update available! Latest version: {latest_version}. Your version: {saved_version}.")
        print("Downloading the latest version...")
        download_and_extract_zip(latest_version)
        save_version(latest_version)
        print("Update process completed successfully.")
    else:
        print(f"Your version ({saved_version}) is up to date.")

    print("Update check completed.")

if __name__ == "__main__":
    check_for_updates()
    input("Press Enter to exit...")
