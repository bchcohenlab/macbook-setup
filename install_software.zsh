#!/bin/zsh
# Script to set up Alex's neuroimaging environment on a mac

echo "This will set up your zsh environment and install a bunch of useful software"

if [[ `arch` = "i386" ]]; then
  echo "This is a Rosetta terminal"
  exit
else
  echo "This is an Apple Silicon terminal"
fi

# Install the Apple Silicon Homebrew if needed
echo ""
if [ ! -f /opt/homebrew/bin/brew ]; then
	echo "1) Found brew"
	eval "$(/opt/homebrew/bin/brew shellenv)"
else
	echo "1) Installing brew"
	echo "   FYI: The Command Line Tools for Xcode step can take a looong time :-("
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshenv
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi


# Install basic utilities
echo ""
echo "2) Updating brew maintained packages then installing some basic unix utilities"
brew upgrade
brew upgrade --cask
brew install \
	bash \
	csvkit \
	dcm2niix \
	gh \
	git \
	htop \
	parallel \
	rclone \
	rsync \
	tig \
	tree \
	wget
brew install --cask \
	docker \
	github \
	google-drive \
	horos \
	iterm2 \
	lepton \
	microsoft-office \
	obsidian \
	osirix-quicklook \
	qlmarkdown \
	quicklook-csv \
	quicklook-json \
	r \
	rectangle \
	rstudio \
	slack \
	slicer \
	sublime-text \
	sublime-merge \
	syntax-highlight \
	visual-studio-code \
	xquartz \
	zoom \
	zotero
qlmanage -r


# programs that don't have Universal Binaries yet
echo "Building programs from source, this may take up to 30 minutes"
brew install --build-from-source \
	git-annex


# Install ITK-SNAP if needed
echo ""
if hash itksnap; then
	echo "3) Found ITK-SNAP"
else
	echo "3) Installing ITK-SNAP"
	brew install --cask itk-snap
	echo 'export PATH=$PATH:/Applications/ITK-SNAP.app/Contents/bin' >> ~/.zshenv
fi


echo ""
echo "	All done!"
echo ""


