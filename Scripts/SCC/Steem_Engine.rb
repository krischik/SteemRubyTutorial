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

gem "radiator", :require => "steem"

require 'pp'
require 'colorize'
require 'contracts'
require 'radiator'

module SCC
   ##
   #
   class Steem_Engine < Radiator::Type::Serializer
      include Contracts::Core
      include Contracts::Builtin

      class << self
         attr_reader :Query_Limit        

         ##
         # amount of rows read from database in a single query. If
         # the overall results exceeds this limit then make multiple
         # queries. 1000 seem to be the standard for Steem queries.
         #
         Query_Limit = 1000

         @api = nil

         ##
         # Access to contracts interface
         #
         # @return ~
         #
         Contract None => Radiator::SSC::Contracts
         def contracts_api
            # create instance to the steem condenser API which
            # will give us access to the median history price

            if @api == nil then
               @api = Radiator::SSC::Contracts.new
            end

            return @api
         rescue => error
            # I am using Kernel::abort so the code snipped
            # including error handler can be copy pasted into other
            # scripts

            Kernel::abort("Error creating contracts API :\n".red + error.to_s)
         end #contracts
      end # self
   end # Token
end # SCC

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
