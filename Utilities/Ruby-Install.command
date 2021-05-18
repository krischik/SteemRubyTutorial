#!/opt/local/bin/zsh
############################################################# {{{1 ##########
#  Copyright © 2019 … 2020 Martin Krischik «krischik@users.sourceforge.net»
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

function Install ()
{
    local in_Gem="${1}"

    if test -x "${in_Gem}"; then
        echo "##### Update for ${in_Gem}"

        ${in_Gem} install awesome_print
        ${in_Gem} install bundler
        ${in_Gem} install bundler
        ${in_Gem} install colorize
        ${in_Gem} install contracts
        ${in_Gem} install faraday
        ${in_Gem} install faraday_middleware
        ${in_Gem} install gems
        ${in_Gem} install irb
        ${in_Gem} install minitest
        ${in_Gem} install minitest-line
        ${in_Gem} install minitest-proveit
        ${in_Gem} install net-http-persistent
        ${in_Gem} install ntlm-http
        ${in_Gem} install pry
        ${in_Gem} install rake
        ${in_Gem} install rb-readline
        ${in_Gem} install rubocop
        ${in_Gem} install ruby-debug-ide
        ${in_Gem} install rubygems-update
        ${in_Gem} install simplecov
        ${in_Gem} install vcr
        ${in_Gem} install webmock
        ${in_Gem} install yard

        ${in_Gem} install steem-mechanize
        ${in_Gem} install steem-ruby
        ${in_Gem} install radiator
    fi
}

if test "${USER}" = "root"; then
    for I in "gem2.5" "gem2.6" "gem2.6" "gem2.7"; do
        Install "/opt/local/bin/${I}"
    done; unset I

    chgrp -R _developer "/Library/Ruby"
    chmod -R g=u "/Library/Ruby"
else
    sudo ${0:a} 1>&1 2>&2 &>~/Library/Logs/${0:r:t}.out

    for I in "/usr/local/opt/ruby/bin/gem" "/usr/bin/gem"; do
        Install "${I}"
    done; unset I
fi

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=4 softtabstop=4 expandtab :
# vim: set textwidth=0 filetype=zsh foldmethod=marker nospell :
