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

require_relative '../Scripts/SCC/Token'
require "test/unit"

class Tokent_Test < Test::Unit::TestCase
   def test_all_01
      # Thee “all” tests but considerable strain on the
      # Steem Engine server so we only do them when
      # explicitly requested
      #
      if Test_All then
         _test = SCC::Token.all

         assert_not_nil(_test, "There should be tokens" )
         assert_instance_of(Array, _test, "Tokens should be an array")

         _token = _test[0]

         assert_not_nil(_token, "First token should exist" )
         assert_instance_of(SCC::Token, _token, "First token should be of type «SCC::Token»")
         assert_equal(:symbol, _token.key, "First token key should be «:symbol»")
         assert_equal("ENG", _token.value, "First token value should be “ENG”")
      end
   end

   def test_symbol_01
      _test = SCC::Token.symbol "BEER"

      assert_not_nil(_test, "Token “BEER” should exist" )
      assert_instance_of(SCC::Token, _test, "Result should be of type «SCC::Token»")
      assert_equal(:symbol, _test.key, "The token key should be «:symbol»")
      assert_equal("BEER", _test.value, "The value value should be “BEER”")
   end

   def test_metric_01
      _test = SCC::Token.symbol "BEER"

      assert_not_nil(_test, "Token “BEER” should exist" )
      assert_instance_of(SCC::Token, _test, "Result should be of type «SCC::Token»")
      assert_equal(:symbol, _test.key, "The token key should be «:symbol»")
      assert_equal("BEER", _test.value, "The value value should be “BEER”")

      _metric = _test.metric

      assert_not_nil(_metric, "Metric for token “BEER” should exist" )
      assert_instance_of(SCC::Metric, _metric, "Metric should be of type «SCC::Metric»")
      assert_equal(:symbol, _metric.key, "The metric key should be «:symbol»")
      assert_equal("BEER", _metric.value, "The metric value should be “BEER”")
   end
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
