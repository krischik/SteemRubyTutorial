#!/opt/local/bin/zsh
############################################################## {{{1 ##########
#  Copyright © 2015 … 2019 KPT/CPT
#  Author Martin Krischik «krischik.martin@kpt.ch»
############################################################## }}}1 ##########

if test -z "${PROJECT_HOME}"; then
    source "${0:h}/Setup.command"
fi

setopt Err_Exit
setopt No_XTrace

if test ${#} -eq 2; then
    local in_Task="${1}"
    local in_Comment="${2}"

    local Task_Type="${in_Task%%[0-9]*}"
    local   Task_No="${in_Task#${Task_Type}}"

    pushd "${PROJECT_HOME}"
        git status
        git submodule foreach git status

        echo "Task Type   : ${Task_Type}"
        echo "Task Number : ${Task_No}"
        read -sk1 "? add, commit and publish (Y/N): "
        echo

        if test "${REPLY:u}" = "Y"; then
            for I in "Frameworks/steem-ruby" "Wiki" "."; do
                pushd "${I}"
                    echo "### Publish ${Task_Type} «${Task_No}» for «${I}»"

                    git add "."
                    if ! git commit -m"${Task_Type} #${Task_No} : ${in_Comment}"; then
                        echo "nothing to commit but we publish anyway"
                    fi
                    if ! git flow feature publish "${in_Task}"; then
                        echo "publish failed, try a simple push instead"
                        git push
                    fi
                popd
            done; unset I
        fi
    popd
else
   echo '
Git-Publish-Feature Task Comment

    Task    Task to publish
    Comment Comment for publish
'
fi

############################################################## {{{1 ##########
# vim: set nowrap tabstop=8 shiftwidth=4 softtabstop=4 expandtab :
# vim: set textwidth=0 filetype=zsh foldmethod=marker nospell :
