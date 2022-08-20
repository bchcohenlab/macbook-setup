#!/bin/zsh
# Script to set up Alex's neuroimaging environment on a mac

echo "This will set up software that is not compiled for apple silicon yet"

if [[ `arch` = "i386" ]]; then
  echo "This is a Rosetta terminal"
else
  echo "This is an Apple Silicon terminal"
  exit
fi


# Install Homebrew if needed
echo ""
if hash brew; then
	echo "1) Found brew"
else
	echo "1) Installing brew"
	echo "   FYI: The Command Line Tools for Xcode step can take a looong time :-("
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi


# Install basic utilities
echo ""
echo "2) Installing python"
brew upgrade
brew upgrade --cask 
brew install \
  octave
brew install --cask \
	anaconda \

# Initialize conda
/usr/local/anaconda3/bin/conda init zsh


# Install FSL if needed
echo ""
if hash fsl; then
	echo "4) Found FSL"
else
	if hash python2; then
		echo "4a) Found python2"
	else
		echo "4a) Creating a python2 conda environment first"
		conda create --name py2 python=2.7 -y
		conda activate py2
	fi
	echo "4) Installing FSL"
	wget https://fsl.fmrib.ox.ac.uk/fsldownloads/fslinstaller.py
	python2 fslinstaller.py -q
	rm fslinstaller.py
fi


# Install PALM if needed
echo ""
if hash palm; then
	echo "5) Found PALM"
else
	echo "5) Installing PALM"
	git clone https://github.com/andersonwinkler/PALM.git ~/repos/palm
	pushd ~/repos/palm/fileio/@file_array/private
		./compile.sh
	popd
	echo 'export PATH=$PATH:~/repos/palm' >> ~/.zshenv
fi


# # Build NIMLAB conda environment if needed
# echo ""
# eval "$(conda shell.zsh hook)"
# conda init zsh
# conda update --all -y
# conda install -y mamba
# if [ -d "/usr/local/anaconda3/envs/nimlab_py310" ]; then
# 	echo "6) Found NIMLAB conda environment"
# else
# 	echo "6) Building NIMLAB conda environment"
# 	conda create -p /usr/local/anaconda3/envs/nimlab_py310 python=3
# fi

# conda activate nimlab_py310
# echo "The current conda environment is `conda info --envs | grep \*`"
# conda config --add channels conda-forge 
# conda config --set channel_priority strict
# mamba install -y \
# 	fslpy \
# 	h5py \
# 	hdf5 \
# 	jupyterlab \
# 	matplotlib \
# 	natsort \
# 	ncdu \
# 	nibabel \
# 	nilearn \
# 	numba \
# 	numpy \
# 	pandas \
# 	scikit-learn \
# 	scipy \
# 	seaborn \
# 	sshpass \
# 	statsmodels \
# 	tqdm

# python -m pip install python_modules/nimlab
# python -m pip install python_modules/meta_editor
# python -m pip install datalad --upgrade

# # (re)connect conda env to ipykernel if needed
# python -m ipykernel install --user --name nimlab_py310 --display-name "Python3.10 (nimlab)"

echo ""
echo "	All done!"
echo ""
echo "	Close and Re-open this terminal window, or open a new terminal window"
echo "	and try running some of the following commands:"
echo "	'itksnap'"
echo "	'fsl'"
echo "	'palm'"
echo "	'jupyter lab'"
echo ""
echo "	The Slicer GUI program is also now installed as well."
echo ""
echo "	If you want to use the python environment OUTSIDE of jupyter, run:"
echo "	'conda activate nimlab'"
echo "	then run: 'conda deactivate' when you are done."
echo ""


