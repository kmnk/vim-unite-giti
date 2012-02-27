# vim-unite-giti

*vim-unite-giti* is unite source for using git.

## Usage

### Install

    NeoBundle 'git://github.com/kmnk/vim-unite-giti.git'


### Sources

- giti/status
- giti/branch
- giti/config


### Kinds

#### *giti/status* actions

- add
- rm\_cached
- reset
- commit
- amend
- checkout
- diff
- diff\_cached


#### *giti/branch* actions

- switch
- delete


#### *giti/config* actions

- yank\_value
- write
- remove


### CUSTOM ACTION

#### on *file* kind

- git\_rm


## SEE ALSO

- [unite.vim][unite.vim]
- [neobundle.vim][neobundle.vim]


## TODO

- implement *giti/log* source
- implement *git merge* function
- and other ...

[unite.vim]: https://github.com/Shougo/unite.vim "unite.vim"
[neobundle.vim]: https://github.com/Shougo/neobundle.vim "neobundle.vim"
