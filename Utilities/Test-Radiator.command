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
setopt Multi_OS
setopt Err_Exit

pushd "${PROJECT_HOME}/Frameworks/steem-ruby"
    gem build "steem-ruby.gemspec"
    gem install "steem-ruby"
popd

pushd "${PROJECT_HOME}"
    (
	for I in "steem" "hive"; do
	    CHAIN_ID="${I}" Scripts/Steem-Print-Config.rb
	    CHAIN_ID="${I}" Scripts/Steem-Print-Accounts.rb		"steem" "busy.org" "steempeak"
	    CHAIN_ID="${I}" Scripts/Steem-Print-Balances.rb		"steem" "busy.org" "steempeak"
	    CHAIN_ID="${I}" Scripts/Steem-Print-Global-Properties.rb
	    CHAIN_ID="${I}" Scripts/Steem-Print-Median-History-Price.rb
	    CHAIN_ID="${I}" Scripts/Steem-Print-Posting-Votes.rb	"https://steempeak.com/@krischik/using-steem-api-with-ruby-part-7"
	    CHAIN_ID="${I}" Scripts/Steem-To-VEST.rb			"500" "5000" "50000" "50000"
	    CHAIN_ID="${I}" Scripts/Steem-Print-Vesting.rb		"busy.org" "steempeak"
	    CHAIN_ID="${I}" Scripts/Steem-Print-SSC-Contract.rb		"tokens" "market" "steempegged"
	    CHAIN_ID="${I}" Scripts/Steem-Print-SSC-Table-First.rb	"tokens" "tokens"
	    CHAIN_ID="${I}" Scripts/Steem-Print-SSC-Table-First.rb	"market" "metrics"
	    CHAIN_ID="${I}" Scripts/Steem-Print-SSC-Table-All.rb	"tokens" "balances" "account" "krischik"
	    CHAIN_ID="${I}" Scripts/Steem-Print-SSC-Table-All.rb	"tokens" "params"
	    CHAIN_ID="${I}" Scripts/Steem-Print-SSC-Table-All.rb	"tokens" "balances" "symbol"  "BEER" "balance" "10.0000"
	    CHAIN_ID="${I}" Scripts/Steem-Print-SSC-Table-All.rb	"tokens" "tokens"   "symbol"  "BEER"
	done
    ) 1>&1 2>&2 &>"Logs/Test-Radiator.log"
    

    gview "Logs/Test-Radiator.log"
popd

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=4 softtabstop=4 noexpandtab :
# vim: set textwidth=0 filetype=zsh foldmethod=marker nospell :
