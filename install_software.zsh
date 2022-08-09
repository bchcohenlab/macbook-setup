#!/bin/zsh
# Script to set up Alex's neuroimaging environment on a mac

echo "This will set up your zsh environment and install a bunch of useful software on an Apple Silicon Mac"

if [[ `arch` = "i386" ]]; then
  echo "This is an Intel Mac or a Rosetta terminal"
  exit
else
  echo "This is an Apple Silicon mac/terminal"
fi

# Install the Apple Silicon Homebrew if needed
echo ""
if [ ! -f /opt/homebrew/bin/brew ]; then
	echo "1) Found Apple Silicon brew"
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

# Install the Intel/Rosetta Homebrew if needed
if [ ! -f /usr/local/bin/brew ]; then
	echo "2) Found Intel brew"
else
	echo "2) Installing Intel/Rosetta brew and aliasing to brow (old brew)"
	/usr/sbin/softwareupdate --install-rosetta --agree-to-license
	arch --x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo "alias brow='arch --x86_64 /usr/local/Homebrew/bin/brew'" >> ~/.zshrc
fi

# Install ITK-SNAP if needed (Intel version)
echo ""
if hash itksnap; then
	echo "3) Found ITK-SNAP"
else
	echo "3) Installing ITK-SNAP"
	brow install --cask itk-snap
	echo 'export PATH=$PATH:/Applications/ITK-SNAP.app/Contents/bin' >> ~/.zshenv
fi

# Install basic utilities
echo ""
echo "4) Installing python and octave as Intel apps for compatibility"
brow upgrade
brow upgrade --cask 
brow install \
  git-annex \
  octave
brow install --cask \
	anaconda \

# Initialize conda
/usr/local/anaconda3/bin/conda init zsh


# Install FSL if needed
echo ""
if hash fsl; then
	echo "5) Found FSL"
else
	if [ -d "/usr/local/anaconda3/envs/py2" ]; then
		echo "4a) Found python2"
	else
		echo "4a) Creating a python2 conda environment first"
		conda create --name py2 python=2.7 -y
		conda activate py2
	fi
	echo "5) Installing FSL (Intel arch)"
	wget https://fsl.fmrib.ox.ac.uk/fsldownloads/fslinstaller.py
	arch --x86_64 python2 fslinstaller.py -q
	rm fslinstaller.py
fi


# Install PALM if needed
echo ""
if hash palm; then
	echo "5) Found PALM"
else
	echo "5) Installing PALM (Intel arch)"
	git clone https://github.com/andersonwinkler/PALM.git ~/repos/palm
	pushd ~/repos/palm/fileio/@file_array/private
		arch --x86_64 ./compile.sh
	popd
	echo 'export PATH=$PATH:~/repos/palm' >> ~/.zshenv
fi


echo ""
echo "	All done!"
echo ""


