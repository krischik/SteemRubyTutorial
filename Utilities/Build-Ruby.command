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

pushd "${PROJECT_HOME}/Frameworks/steem-ruby" 
    # tests known to work. There are quite a few who don't work
    # and only the original maintainer can fix them.

    # for I in				\
        # "account_history_api_test"	\
	# "account_by_key_api_test"	\
	# "amount_test"                   \
	# "api_test"                      \
	# "block_api_test"
    # do
	# ruby -I "lib" -I "test" "test/steem/${I}.rb"
    # done; unset I

    gem build "steem-ruby.gemspec"
    gem install "steem-ruby"
popd

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=4 softtabstop=4 noexpandtab :
# vim: set textwidth=0 filetype=zsh foldmethod=marker nospell :
