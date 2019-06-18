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

require_relative '../Scripts/SCC/Contract'
require_relative '../Scripts/SCC/Balance'
require "test/unit"
 
class Balance_Test < Test::Unit::TestCase
   def test_account_01
      _test = SCC::Balance.account "krischik"

      assert_not_nil(_test, "There should be ballaces for account “krischik”" )
      assert_instance_of(Array, _test, "The balances should be an array")
   end

   def test_symbol_01
      _test = SCC::Balance.symbol "BEER"

      assert_not_nil(_test, "There should be ballaces for token “BEER”" )
      assert_instance_of(Array, _test, "Result should be of type «SCC::Balance»")
   end
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
