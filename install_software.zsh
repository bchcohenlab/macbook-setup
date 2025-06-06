#!/bin/zsh
# Script to set up Alex's neuroimaging environment on a mac

echo "This will set up your zsh environment and install a bunch of useful software on an Apple Silicon Mac"

if [[ `arch` = "i386" ]]; then
  echo "This is an Intel Mac or a Rosetta terminal"
  exit
else
  echo "This is an Apple Silicon mac/terminal"
  # Install Rosetta 2 if not already installed
	echo "0) Installing Rosetta2 if not already installed"
	if [ ! -f /usr/local/bin/brew ]; then
		echo "0b) Intel brew not installed, triggering Rosetta install just in case"
		sudo softwareupdate --install-rosetta
	else
		echo "0b) Found Intel brew, Rosetta must be installed"
	fi
fi

# Install the Apple Silicon Homebrew if needed
echo ""
if [ -f /opt/homebrew/bin/brew ]; then
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
	git-annex \
	htop \
	octave \
	parallel \
	rclone \
	rsync \
	tig \
	tmux \
	tree \
	wget
brew install --cask \
	chatgpt \
	docker \
	github \
	google-drive \
	horos \
	iterm2 \
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
	sublime-text \
	sublime-merge \
	syntax-highlight \
	visual-studio-code \
	xquartz \
	zoom \
	zotero
qlmanage -r

# Install the Intel/Rosetta Homebrew if needed
if [ -f /usr/local/bin/brew ]; then
	echo "2) Found Intel brew"
	alias brow='arch --x86_64 /usr/local/Homebrew/bin/brew'
else
	echo "2) Installing Intel/Rosetta brew and aliasing to brow (old brew)"
	/usr/sbin/softwareupdate --install-rosetta --agree-to-license
	arch --x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo "alias brow='arch --x86_64 /usr/local/Homebrew/bin/brew'" >> ~/.zshrc
	alias brow='arch --x86_64 /usr/local/Homebrew/bin/brew'
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
echo "4) Installing Intel-only apps and python and octave as Intel apps for compatibility"
brow upgrade
brow upgrade --cask 
# brow install \
#  [packages] \
brow install --cask \
	slicer \
	miniforge \
	freesurfer

# Set Freesurfer Paths
echo "4b) Checking freesurfer paths"
if hash freeview; then
	echo "4b) Found freesurfer"
else
	echo "4b) Setting freesurfer paths"
	echo 'export FREESURFER_HOME=/Applications/freesurfer' >> ~/.zshenv
	echo 'export SUBJECTS_DIR=$FREESURFER_HOME/subjects' >> ~/.zshenv
	echo 'source $FREESURFER_HOME/SetUpFreeSurfer.sh' >> ~/.zshenv
fi

# Initialize conda
conda init "$(basename "${SHELL}")"
. ~/.zshrc


# Install FSL if needed
echo ""
if hash fsl; then
	echo "5) Found FSL"
else
	echo "5) Installing FSL (ARM arch)"
	curl -Ls https://fsl.fmrib.ox.ac.uk/fsldownloads/fslconda/releases/getfsl.sh | sh -s -- /usr/local/fsl
fi


# Install PALM if needed
echo ""
if hash palm; then
	echo "6) Found PALM"
else
	echo "6) Installing PALM (Intel arch)"
	git clone https://github.com/andersonwinkler/PALM.git ~/repos/PALM
	pushd ~/repos/palm/fileio/@file_array/private
		arch --x86_64 ./compile.sh
	popd
	echo 'export PATH=$PATH:~/repos/PALM' >> ~/.zshenv
fi


# Install NIMLAB conda environment if needed
if [ -d "/usr/local/Caskroom/mambaforge/base/envs/nimlab_py310" ]; then
	echo "7a) Found nimlab conda env"
else
	echo "7a) Building NIMLAB conda environment"
	mamba create -y -n nimlab_py310 python=3.10
	conda activate nimlab_py310
	mamba install -y fslpy \
	h5py \
	hdf5 \
	jupyterlab \
	matplotlib \
	ncdu \
	nibabel \
	nilearn \
	numba \
	numpy \
	pandas \
	scikit-learn \
	scipy \
	seaborn \
	sshpass \
	statsmodels
	
fi

echo "7b) Installing/Updating nimlab python code from github"
if [[ ! -d ~/repos/nimlab ]]; then
	mkdir -p ~/repos/nimlab
fi
pushd ~/repos/nimlab
	gh auth login
	gh repo clone nimlab/software_env
	python -m pip install software_env/python_modules/nimlab
	python -m pip install software_env/python_modules/meta_editor
popd
python -m ipykernel install --user --name nimlab_py310 --display-name "Python3.10 (nimlab)"
if [[ ! -d ~/setup ]]; then
	mkdir -p ~/setup
fi
cp -f ~/repos/nimlab/software_env/native_install/mac_config.yaml ~/setup/nimlab_config.yaml


echo ""
echo "	All done!"
echo ""


