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

gem "radiator", :require => "steem"

require 'pp'
require 'colorize'
require 'contracts'
require 'radiator'

##
# steem-ruby comes with a helpful Radiator::Type::Price
# class to handle the SDB price. However
# Radiator::Type::Price won't let you access any
# attributes which makes using the class quite cumbersome.
#
# This class expands Radiator::Type::Price to add the
# missing functions making it super convenient.

module Radiator
   module Type
      class Price
         include Contracts::Core
         include Contracts::Builtin

         ##
         # add the missing attribute reader.
         #
         attr_reader :amount, :base, :quote

         public

            def sbd_median_price ()
               return @base.amount.to_f / @quote.amount.to_f
            end
   
      end # Price
   end # Type
end # Radiator

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=marker nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
