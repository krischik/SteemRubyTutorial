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
setopt No_Err_Exit
setopt Multi_OS

function Update ()
{
    local in_Gem="${1}"

    echo "##### Update for ${in_Gem}"
    ${in_Gem} update $(${in_Gem} list | cut -d ' ' -f 1)
    ${in_Gem} cleanup --verbose 
}

if test "${USER}" = "root"; then
    for I in "gem2.5" "gem2.6" "gem2.6"; do
        if test -x "/opt/local/bin/${I}"; then
            Update "/opt/local/bin/${I}"
        fi
    done; unset I
else
    for I in "/usr/local/opt/ruby/bin/gem" "/usr/bin/gem"; do
        if test -x "${I}"; then
            Update "${I}"
        fi
    done; unset I

    setopt Multi_OS
    sudo ${0:a} 1>&1 2>&2 &>~/Library/Logs/${0:r:t}.out
fi

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=4 softtabstop=4 expandtab :
# vim: set textwidth=0 filetype=zsh foldmethod=marker nospell :
