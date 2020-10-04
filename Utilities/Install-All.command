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
setopt Multi_OS

function Do_Install ()
{
    local in_Gem="${1}"

    echo "##### Install for ${in_Gem}"

    pushd "Frameworks/radiator" 
	${in_Gem} build	"radiator.gemspec"
	${in_Gem} install "radiator"
    popd

    pushd "Frameworks/steem-ruby" 
	${in_Gem} build	"steem-ruby.gemspec"
	${in_Gem} install "steem-ruby"
    popd

    pushd "Frameworks/steem-mechanize" 
	${in_Gem} build "steem-mechanize.gemspec"
	${in_Gem} install "steem-mechanize"
    popd
}

if test "${USER}" = "root"; then
    Do_Install "/opt/local/bin/gem2.5"
#   Do_Install "/opt/local/bin/gem2.6"
    Do_Install "/opt/local/bin/gem2.7"
else
    pushd "${PROJECT_HOME}" 
	Do_Install "/usr/local/opt/ruby/bin/gem"

	sudo ${0:a} 1>&1 2>&2 &>~/Library/Logs/${0:r:t}.out
    popd
fi
    
############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=4 softtabstop=4 noexpandtab :
# vim: set textwidth=0 filetype=zsh foldmethod=marker nospell :
