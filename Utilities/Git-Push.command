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

if test -z "${PROJECT_HOME}"; then
    source "${0:h}/Setup.command"
fi

setopt Err_Exit
setopt No_XTrace


pushd "${PROJECT_HOME}"
    git status
    git submodule foreach git status

    read -sk1 "? push (Y/N): "
    echo

    if test "${REPLY:u}" = "Y"; then
        for I in				\
            "Frameworks/radiator"		\
            "Frameworks/steem-ruby"		\
            "Frameworks/steem-mechanize"	\
            "Wiki"				\
            "."
        do
            pushd "${I}"
                echo "### Push ${Task_Type} «${Task_No}» for «${I}»"

# local Current_Branch=$(git branch | grep "*" | cut -d ' ' -f2)
# git stash push
# git fetch --all
# git fetch --prune
# git fetch --tags

# git checkout    "master"
# git merge       "FETCH_HEAD"
# git push        "origin"

# git checkout    "develop"
# git merge       "FETCH_HEAD"
# git push         "origin"

# git checkout    "${Current_Branch}"
# git push 
# git stash pop

# git push --tags

                git push "origin"
            popd
        done; unset I
    fi
popd

############################################################## {{{1 ##########
# vim: set nowrap tabstop=8 shiftwidth=4 softtabstop=4 noexpandtab :
# vim: set textwidth=0 filetype=zsh foldmethod=marker nospell :
#!/opt/local/bin/zsh
