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

Scripts/Steem-Print-Accounts.rb		    "steem" "busy.org" "steempeak"
Scripts/Steem-Print-Balances.rb		    "steem" "busy.org" "steempeak"
Scripts/Steem-Print-Global-Properties.rb 
Scripts/Steem-Print-Median-History-Price.rb
Scripts/Steem-Print-Posting-Votes.rb	    "https://steempeak.com/@krischik/using-steem-api-with-ruby-part-7"
Scripts/Steem-To-VEST.rb		    "500" "5000" "50000" "50000"
Scripts/Steem-Print-Vesting.rb		    "busy.org" "steempeak"

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=4 softtabstop=4 noexpandtab :
# vim: set textwidth=0 filetype=zsh foldmethod=marker nospell :
