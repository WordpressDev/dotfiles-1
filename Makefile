rcFiles =  .vim .vimrc .gitconfig .hgrc .screenrc .Xresources .dircolors .bashrc .ctags .bash_completion.d .zshrc .aliases .gitexcludes
LOCAL=$(PWD)
install:
	git remote add bitbucket git@bitbucket.org:juanpablo/dotfiles.git
	git submodule init
	git submodule update
	@[ -d $(HOME)/opt/bin ] || mkdir -vp $(HOME)/opt/bin
	mkdir -p .vim/autoload
	mkdir -p .vim/tmp/undo
	@[ -f $(PWD)/.vim/autoload/pathogen.vim ] || ln -v -s $(PWD)/.vim/bundle/vim-pathogen/autoload/pathogen.vim $(PWD)/.vim/autoload/
	cd $(PWD)/utils/git-prompt; make install
	-cd utils/git-prompt ; git remote add lvv git://github.com/lvv/git-prompt.git
	-cd utils/oh-my-zsh ; git remote add robbyrussell https://github.com/robbyrussell/oh-my-zsh.git
	-cd .vim/bundle/snipmate-snippets ; git remote add honza https://github.com/honza/snipmate-snippets.git
	-cd .vim/bundle/vim-snipmate ; git remote add garbas https://github.com/garbas/vim-snipmate.git
	-cd .vim/bundle/vim-extradite ; git remote add adamreeve https://github.com/adamreeve/vim-extradite.git
	-cd .vim/bundle/vim-extradite ; git remote add int3 https://github.com/int3/vim-extradite.git
	mkdir -p .bash_completion.d
	cd .bash_completion.d ; [ -e git-completion.bash ] || wget -c http://repo.or.cz/w/git.git/blob_plain/HEAD:/contrib/completion/git-completion.bash
	@$(foreach f,$(rcFiles), [ -e $(HOME)/$f ] || ln -s -fvn  $(PWD)/$f $(HOME)/ ;  )
	cd .vim/spell; bash spell.sh
	cd utils/git-map ; ln -v -s -f $(PWD)/utils/git-map/git-map $(HOME)/opt/bin/
	cd utils/git-remote-init ; ln -v -s -f $(PWD)/utils/git-remote-init/bin/* $(HOME)/opt/bin/
	cd utils/oh-my-zsh ; [ -d $(HOME)/.oh-my-zsh ] || ln -vf -s $(PWD)/utils/oh-my-zsh $(HOME)/.oh-my-zsh
	# TODO install rvm and ruby
	# TODO if installed then update : git submodule, etc
	# TODO a option for only relink
clean:
	$(foreach f,$(vimFiles),unlink $(f);)
	cd $(PWD)/utils/git-prompt; make clean
	$(foreach f,$(rcFiles), [ -L $(HOME)/$f ] && unlink $(HOME)/$f;)
	cd $(HOME)/opt/bin ; [ -h git-map ] && unlink git-map
	cd $(HOME) ; [ -h .oh-my-zsh ] &&  unlink .oh-my-zsh
pull:
	cd $(PWD)/.vim/bundle/vim-pathogen ; git map co master ; git map pull
