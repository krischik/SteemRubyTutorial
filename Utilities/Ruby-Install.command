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

if test "${USER}" = "root"; then

    gem install --no-document ntlm-http

    gem install awesome_print
    gem install bundler
    gem install colorize
    gem install contracts
    gem install gems
    gem install minitest
    gem install minitest-line
    gem install minitest-proveit
    gem install pry
    gem install radiator
    gem install rake
    gem install ruby-debug-ide
    gem install rubygems-update
    gem install simplecov
    gem install steem-mechanize
    gem install steem-ruby
    gem install vcr
    gem install webmock
    gem install yard

    update_rubygems
else
    setopt Multi_OS
    sudo ${0:a} 1>&1 2>&2 &>~/Library/Logs/${0:r:t}.out
fi

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=4 softtabstop=4 expandtab :
# vim: set textwidth=0 filetype=zsh foldmethod=marker nospell :
