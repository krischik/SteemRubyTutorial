#!/opt/local/bin/zsh
############################################################# {{{1 ##########
#  Copyright © 2019 Martin Krischik «krischik@users.sourceforge.net»
#############################################################################
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or ENDIFFTNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see «http://www.gnu.org/licenses/».
############################################################# }}}1 ##########

setopt No_XTrace
setopt Err_Exit

git lfs update
git flow init || true

git config "credential.helper"  "store"
git config "push.default"       "current"
git config "pull.rebase"        "false"
git config "user.name"          "Martin Krischik"
git config "user.email"         "krischik@users.sourceforge.net"

git branch --set-upstream-to="remotes/origin/master"            "master"
git branch --set-upstream-to="remotes/origin/develop"           "develop"

pushd "Wiki"
    git config "credential.helper"  "store"
    git config "push.default"       "current"
    git config "pull.rebase"        "false"
    git config "user.name"          "Martin Krischik"
    git config "user.email"         "krischik@users.sourceforge.net"

    # Important: Don't add lfs or flow support for the Wiki!
popd

pushd "Frameworks/radiator"
    git config "credential.helper"  "store"
    git config "push.default"       "current"
    git config "pull.rebase"        "false"
    git config "user.name"          "Martin Krischik"
    git config "user.email"         "krischik@users.sourceforge.net"

    git remote add upstream "https://github.com/inertia186/radiator.git" || true
    git fetch upstream 

    git checkout --track "remotes/origin/master" || true

    git lfs update
    git flow init || true
popd

pushd "Frameworks/steem-ruby"
    git config "credential.helper"  "store"
    git config "push.default"       "current"
    git config "pull.rebase"        "false"
    git config "user.name"          "Martin Krischik"
    git config "user.email"         "krischik@users.sourceforge.net"

    git remote add upstream "https://github.com/inertia186/steem-ruby.git" || true
    git fetch upstream 

    git checkout --track "remotes/origin/master" || true

    git lfs update
    git flow init || true
popd

pushd "Frameworks/steem-mechanize"
    git config "credential.helper"  "store"
    git config "push.default"       "current"
    git config "pull.rebase"        "false"
    git config "user.name"          "Martin Krischik"
    git config "user.email"         "krischik@users.sourceforge.net"

    git remote add upstream "https://github.com/inertia186/steem-mechanize.git" || true
    git fetch upstream 

    git checkout --track "remotes/origin/master" || true

    git lfs update
    git flow init || true
popd

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=4 softtabstop=4 expandtab :
# vim: set textwidth=0 filetype=zsh foldmethod=marker nospell :
