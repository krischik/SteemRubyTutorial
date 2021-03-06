#!/opt/local/bin/ruby
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
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see «http://www.gnu.org/licenses/».
############################################################# }}}1 ##########

# use the "steem.rb" file from the radiator gem. This is
# only needed if you have both steem-api and radiator
# installed.

gem "steem-ruby", :version=>'1.0.0', :require => "steem"

require 'pp'
require 'colorize'
require 'contracts'
require 'steem/type/price'

##
# This class expands Radiator::Type::Price to add the
# missing functions making it super convenient.
#
module Steem
   module Type
      class Price
	 include Contracts::Core
	 include Contracts::Builtin

	 class << self
	    @@condenser_api         = Hash.new

	    ##
	    # create instance to the steem condenser API
	    # which will give us access to to the global
	    # properties and median history.
	    #
	    # @param [Symbol] chain
	    # 	  chain for which to create an api instance
	    # @return [Steem::CondenserApi]
	    #     The condenser API
	    #
	    Contract Symbol => Steem::CondenserApi
	    def condenser_api(chain)
	       unless @@condenser_api.key? chain then
		  @@condenser_api.store(chain, Steem::CondenserApi.new({chain: chain}))
	       end

	       return @@condenser_api[chain]
	    rescue => error
	       Kernel::abort("Error creating condenser API :\n".red + error.to_s)
	    end

	    ##
	    # read the  median history value and Calculate
	    # the conversion Rate for Vests to steem backed
	    # dollar. We use the Amount class from Part 2
	    # to convert the string values into amounts.
	    #
	    # @param [Symbol] chain
	    # 	  chain for which to create an api instance
	    # @return [Float]
	    #    Conversion rate Steem ⇔ SBD
	    #
	    Contract Symbol => Steem::Type::Price
	    def get(chain)
	       _median_history_price = condenser_api(chain).get_current_median_history_price.result

	       return Steem::Type::Price.new(_median_history_price, chain)
	    end
	 end # self
      end # Price
   end # Type
end # Radiator

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
