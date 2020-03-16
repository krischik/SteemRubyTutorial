#!/usr/local/opt/ruby/bin/ruby
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
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see «http://www.gnu.org/licenses/».
############################################################# }}}1 ##########

# use the steem.rb file from the radiator gem. This is only
# needed if you have both steem-api and radiator installed.

gem "radiator", :require => "steem"

require 'pp'
require 'colorize'
require 'radiator'

require_relative 'Radiator/Amount'
require_relative 'SCC/Balance'
require_relative 'SCC/Token'

if ARGV.length < 1 then
   puts "
Claim-Rewards — Claim accont rewards

Usage:
   Claim-Rewards account_name active_key …

      account_name account name
"
else
   # read arguments from command line

   Account_Names = ARGV

   # create instance to the steem database API

   Database_Api = Radiator::DatabaseApi.new

   # request the user information for a list of
   # accounts.

   User_Infos = Database_Api.get_accounts(Account_Names)

   if User_Infos.key?('error') then
      Kernel::abort("Error reading accounts:\n".red + error.to_s)
   elsif User_Infos.result.length == 0 then
      puts "No account not found.".yellow
   else
      User_Infos.result.each do |_user_infos|
	 # extract the outstanding rewards
	 # of the main steemit chain for the user

	 _reward_steem = Radiator::Type::Amount.new _user_infos.reward_steem_balance
	 _reward_sdb   = Radiator::Type::Amount.new _user_infos.reward_sbd_balance
	 _reward_vests = Radiator::Type::Amount.new _user_infos.reward_vesting_balance
	 _account_name = _user_infos.name

	 # print the outstanding rewards

	 puts("Rewards to claim for %1$s:" % _account_name)
	 puts("  Reward_Steem   = " + _reward_steem.to_ansi_s)
	 puts("  Reward_SDB     = " + _reward_sdb.to_ansi_s)
	 puts("  Reward_Vests   = " + _reward_vests.to_ansi_s)

	 # get the users steem engine balances

	 _scc_balances = SCC::Balance.account _account_name

	 pp _scc_balances
      end
   end
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: spell spelllang=en_gb fileencoding=utf-8 :
