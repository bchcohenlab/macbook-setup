# macbook-setup
scripts to set up new apple silicon MacBooks for the lab

Currently only the `install_software.zsh` script is correct.

## Process
1. on new machine, create your account
2. update OS X
3. Open terminal and run the following commands:
```
mkdir -p ~/repos/bchcohenlab
cd ~/repos/bchcohenlab
git clone https://github.com/bchcohenlab/macbook-setup.git
cd ~/repos/bchcohenlab/macbook-setup
./install_software.zsh
```



## To-do List
- [ ] Make an Intel Mac version
- [ ] Install Xcode Command Line tools FIRST
