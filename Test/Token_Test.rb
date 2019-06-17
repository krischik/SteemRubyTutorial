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
require_relative '../Scripts/SCC/Token'
require "test/unit"
 
class Tokent_Test < Test::Unit::TestCase
   def test_all
      _test = SCC::Token.all

      assert_not_nil(_test, "There should be tokens" )
      assert_instance_of(Array, _test, "Tokens should be an array")
   end

   def test_find
      _test = SCC::Token.find "BEER"

      assert_not_nil(_test, "Token “BEER” should exist" )
      assert_instance_of(SCC::Token, _test, "Result should be of type «SCC::Token»")
      assert_equal(:symbol, _test.key, "The token key should be «:symbol»")
      assert_equal("BEER", _test.value, "The value value should be “BEER”")
   end
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=marker nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
