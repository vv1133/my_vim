
# Install #

1. clone the repo

  `git clone git://github.com/vv1133/my_vim.git`

2. rename it:

  `mv my_vim ~/.vim`

3. set up ~/.vimrc, have a fake .vimrc in your $HOME

  `ln -s ~/.vim/vimrc ~/.vimrc`

4. install Ctags, cscope, ack-grep

  `sudo apt-get install exuberant-ctags cscope ack-grep # for ubuntu`

5. install jedi

  `sudo pip2 install jedi`

6. set up mycscope.sh

  `sudo ln -s  ~/.vim/mycscope.sh /usr/local/bin/mycscope.sh`
