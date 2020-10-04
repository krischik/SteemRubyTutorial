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

function Do_Intall ()
{
    local in_Gem="${1}"

    echo "##### Update for ${in_Gem}"

    gem install --no-document ntlm-http
    gem install awesome_print
    gem install bundler
    gem install colorize
    gem install contracts
    gem install gems
    gem install irb
    gem install minitest
    gem install minitest-line
    gem install minitest-proveit
    gem install pry
    gem install rake
    gem install rb-readline
    gem install ruby-debug-ide
    gem install rubygems-update
    gem install simplecov
    gem install vcr
    gem install webmock
    gem install yard

    gem update --system
}

if test "${USER}" = "root"; then
    Do_Intall "/opt/local/bin/gem2.5"
    Do_Intall "/opt/local/bin/gem2.6"
    Do_Intall "/opt/local/bin/gem2.7"
else
    setopt Multi_OS

    Do_Intall "/usr/local/opt/ruby/bin/gem"

    sudo ${0:a} 1>&1 2>&2 &>~/Library/Logs/${0:r:t}.out
fi

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=4 softtabstop=4 expandtab :
# vim: set textwidth=0 filetype=zsh foldmethod=marker nospell :
