# macbook-setup
scripts to set up new apple silicon MacBooks for the lab

Currently only the `install_software.zsh` script is correct.

## Process
1. on new machine, create your account
2. update OS X
3. Open terminal and run the following commands:
    1. `mkdir -p repos/bchcohenlab`
    2. `cd repos/bchcohenlab`
    3. `git clone gh repo clone bchcohenlab/macbook-setup`
    4. `cd macbook-setup`
    5. `./install_software.zsh`



## To-do List
- [ ] Make an Intel Mac version
- [ ] Double check that you can re-run the script without breaking things
