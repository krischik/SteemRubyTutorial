#!/opt/local/bin/ruby
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

require_relative 'Radiator/Chain'
require_relative 'Radiator/Amount'
require_relative 'Radiator/Price'
require_relative 'SCC/Metric'

##
# Store the chain name for convenience.
#
Chain = Chain_Options[:chain]

_metrics = SCC::Metric.all

puts("Token        |               highes Bid |               last price |            lowest asking |")
puts("-------------+--------------------------+--------------------------+--------------------------+")

_metrics.each do |_metric|
   puts _metric.to_ansi_s
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
