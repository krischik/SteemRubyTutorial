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

    path=("/opt/local/bin" ${path})

    gem2.7 install --no-document ntlm-http  

    gem2.7 install bundler
    gem2.7 install colorize
    gem2.7 install contracts
    gem2.7 install gems
    gem2.7 install ruby-debug-ide
    gem2.7 install rubygems-update
    gem2.7 install steem-ruby
    gem2.7 install radiator
    gem2.7 install steem-mechanize
else
    setopt Multi_OS

    path=("/usr/local/opt/ruby/bin" ${path})

    gem install --no-document ntlm-http  

    gem install bundler
    gem install colorize
    gem install contracts
    gem install gems
    gem install ruby-debug-ide
    gem install rubygems-update
    gem install steem-ruby
    gem install radiator
    gem install steem-mechanize

    sudo ${0:a} 1>&1 2>&2 &>~/Library/Logs/${0:r:t}.out
fi

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=4 softtabstop=4 expandtab :
# vim: set textwidth=0 filetype=zsh foldmethod=marker nospell :
