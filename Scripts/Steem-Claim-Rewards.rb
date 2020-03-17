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

if ARGV.length < 2 then
   puts "
Claim-Rewards — Claim accont rewards

Usage:
   Claim-Rewards account_name active_key

      account_name account name
      active_key   accounts active key
"
else
   # read arguments from command line

   Account_Name = ARGV[0]
   Active_Key   = ARGV[1]

   # create instance to the steem database API

   Database_Api = Radiator::DatabaseApi.new

   # request account information from the steem database
   # and print out the accounts found using pretty print
   # (pp) or print out error information when an error
   # occurred.

   User_Infos = Database_Api.get_accounts([Account_Name])

   if User_Infos.key?('error') then
      Kernel::abort("Error reading accounts:\n".red + error.to_s)
   elsif User_Infos.result.length != 1 then
      puts "Account not found.".red
   else
      User_Info = User_Infos.result[0]

      Reward_Steem = Radiator::Type::Amount.new User_Info.reward_steem_balance
      Reward_SDB   = Radiator::Type::Amount.new User_Info.reward_sbd_balance
      Reward_Vests = Radiator::Type::Amount.new User_Info.reward_vesting_balance

      puts("Rewards to claim for %1$s:" % Account_Name)
      puts("  Reward_Steem   = " + Reward_Steem.to_ansi_s)
      puts("  Reward_SDB     = " + Reward_SDB.to_ansi_s)
      puts("  Reward_Vests   = " + Reward_Vests.to_ansi_s)

      if Reward_SDB.to_f == 0 && Reward_SDB.to_f == 0 && Reward_Vests.to_f == 0 then
	 puts("Nothing to claim.".yellow)
      else
	 puts("Start claiming.")

	 Chain = Radiator::Chain.new(
	    chain:        :steem,
	    account_name: Account_Name,
	    wif:          Active_Key)

	 Chain.claim_reward_balance(
            reward_steem: Reward_Steem,
	    reward_sbd:   Reward_SDB,
	    reward_vests: Reward_Vests)
	 Chain.broadcast!

	 puts("Finished claiming.")
      end
   end
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: spell spelllang=en_gb fileencoding=utf-8 :
