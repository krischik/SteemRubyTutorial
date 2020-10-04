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

# use the "steem.rb" file from the radiator gem. This is
# only needed if you have both steem-api and radiator
# installed.

gem "radiator", :version=>'1.0.0', :require => "steem"

require 'pp'
require 'colorize'
require 'contracts'

##
# Class handling the date from the reward pool.
#
module Radiator
   module Type
      class Reward_Fund
         include Contracts::Core
         include Contracts::Builtin

         class << self
            @@condenser_api         = ::Hash.new

            ##
            # create instance to the steem condenser API
            # which will give us access to to the global
            # properties and median history.
            #
            # @param [Symbol] chain
            #     chain for which to create an api instance
            # @return [Steem::CondenserApi]
            #     The condenser API
            #
            #            Contract ::Symbol => Radiator::CondenserApi
            def condenser_api(chain)
               unless @@condenser_api.key? chain then
                  @@condenser_api.store(chain, Radiator::CondenserApi.new({chain: chain}))
               end

               return @@condenser_api[chain]
            rescue => error
               Kernel::abort("Error creating condenser API :\n".red + error.to_s)
            end

            ##
            # read the reward funds used to
            # calculate the voting values
            #
            # @param [Symbol] chain
            #     chain for which to create an api instance
            # @return [Radiator::Type::Reward_Fund]
            #    Conversion rate Steem ⇔ SBD
            #
            Contract Symbol => Radiator::Type::Reward_Fund
            def get(chain)
               # read the reward funds. `get_reward_fund` takes one
               # parameter is always "post".
               #

               _reward_fund = self.condenser_api(chain).get_reward_fund("post").result

               return Radiator::Type::Reward_Fund.new(_reward_fund, chain)
            end
         end # self
      end # Reward_Fund
   end # Type
end # Radiator

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
