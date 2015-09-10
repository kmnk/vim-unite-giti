# vim-unite-giti

*vim-unite-giti* is unite source for using git.

## Usage

### Install

    NeoBundle 'git://github.com/kmnk/vim-unite-giti.git'


### Sources

- giti
    - view sources of giti
- giti/branch
    - view branches on current repository
- giti/config
    - view config
- giti/log
    - view log on current repository
- giti/remote
    - view remotes
- giti/status
    - view status of current repository
- giti/grep
    - view grep results and jump to line


### Kinds

#### *giti/branch* actions

- switch
- delete
- delete\_force
- merge


#### *giti/config* actions

- yank\_value
- write
- remove


#### *giti/log* actions

- view
- diff
- revert
- vimdiff
- reset


#### *giti/remote* actions

- fetch
- rename
- rm


#### *giti/status* actions

- add
- add\_patch
- reset
- commit
- amend
- checkout
- diff
- diff\_cached
- diff\_head
- vimdiff\_head
- rm\_cached
- ignore


### CUSTOM ACTION

#### on *file* kind

- git\_rm


## SEE ALSO

- [unite.vim][unite.vim]
- [neobundle.vim][neobundle.vim]


## TODO

- extend *giti/log* source (and write document about it)
- implement *giti/stash* source and kind
- implement *giti/blame* source and kind (use scrollbind)
- implement *giti/tag* source and kind
- implement *git_pull* and *git_pull_squash* custom actions
- and other ...

[unite.vim]: https://github.com/Shougo/unite.vim "unite.vim"
[neobundle.vim]: https://github.com/Shougo/neobundle.vim "neobundle.vim"
