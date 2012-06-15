# vim-unite-giti

*vim-unite-giti* is unite source for using git.

## Usage

### Install

    NeoBundle 'git://github.com/kmnk/vim-unite-giti.git'


### Sources

- giti
    - view sources of giti
- giti/status
    - view status of current repository
- giti/branch
    - view branches on current repository
- giti/log
    - view log on current repository
- giti/config
    - view config


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
- diff\_head
- ignore


#### *giti/branch* actions

- switch
- delete
- delete\_force
- merge


#### *giti/log* actions

- view
- diff
- revert
- reset


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

- write document
- extend *giti/log* source (and write document about it)
- implement *git_pull* and *git_pull_squash* custom actions
- implement *giti/stash* source
- implement *giti/blame* source
- and other ...

[unite.vim]: https://github.com/Shougo/unite.vim "unite.vim"
[neobundle.vim]: https://github.com/Shougo/neobundle.vim "neobundle.vim"
