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

require_relative '../Scripts/SCC/Balance'
require "test/unit"

class Balance_Test < Test::Unit::TestCase
   def test_all_01
      # Thee “all” tests but considerable strain on the
      # Steem Engine server so we only do them when
      # explicitly requested
      #
      if Test_All then
         _test = SCC::Balance.all

         assert_not_nil(_test, "There should be balances")
         assert_instance_of(Array, _test, "balances should be an array")

         _balance = _test[0]

         assert_not_nil(_balance, "First balance should exist")
         assert_instance_of(SCC::Balance, _balance, "First balance should be of type «SCC::balance»")
         assert_equal(:symbol, _balance.key, "First balance key should be «:symbol»")
         assert_equal("ENG", _balance.value, "First balance value should be “ENG”")
      end
   end

   def test_account_01
      _test = SCC::Balance.account "krischik"

      assert_not_nil(_test, "There should be ballaces for account “krischik”")
      assert_instance_of(Array, _test, "The balances should be an array")

      _balance = _test[0]

      assert_not_nil(_balance, "First balance should exist")
      assert_instance_of(SCC::Balance, _balance, "First balance should be of type «SCC::Balance»")
      assert_equal("krischik", _balance.account, "First balance  value should be “krischik”")
   end

   def test_symbol_01
      _test = SCC::Balance.symbol "BEER"

      assert_not_nil(_test, "There should be ballaces for token “BEER”")
      assert_instance_of(Array, _test, "Result should be of type «SCC::Balance»")

      _balance = _test[0]

      assert_not_nil(_balance, "First balance should exist")
      assert_instance_of(SCC::Balance, _balance, "First balance should be of type «SCC::Balance»")
      assert_equal(:symbol, _balance.key, "First balance  key should be «:symbol»")
      assert_equal("BEER", _balance.value, "First balance  value should be “BEER”")
   end

   def test_metric_01
      _test = SCC::Balance.symbol "BEER"

      assert_not_nil(_test, "There should be ballaces for token “BEER”")
      assert_instance_of(Array, _test, "Result should be of type «SCC::Balance»")

      _balance = _test[0]

      assert_not_nil(_balance, "First balance should exist")
      assert_instance_of(SCC::Balance, _balance, "First balance should be of type «SCC::Balance»")
      assert_equal(:symbol, _balance.key, "First balance  key should be «:symbol»")
      assert_equal("BEER", _balance.value, "First balance  value should be “BEER”")

      _metric = _balance.metric

      assert_not_nil(_metric, "Metric for first balance should exist")
      assert_instance_of(SCC::Metric, _metric, "Metric for first balance should be of type «SCC::Metric»")
      assert_equal(:symbol, _metric.key, "The metric key for first balance should be «:symbol»")
      assert_equal("BEER", _metric.value, "The metric value for first balance should be “BEER”")
   end

   def test_to_steem_01
      _test = SCC::Balance.account "krischik"

      assert_not_nil(_test, "There should be ballaces for account “krischik”")
      assert_instance_of(Array, _test, "The balances should be an array")

      _balance = _test[0]

      assert_not_nil(_balance, "First balance should exist")
      assert_instance_of(SCC::Balance, _balance, "First balance should be of type «SCC::Balance»")
      assert_equal("krischik", _balance.account, "First balance  value should be “krischik”")

      _steem = _balance.to_steem

      assert_not_nil(_balance, "First balance can be converted into a steem amount ")
      assert_instance_of(Radiator::Type::Amount, _steem, "First balance should be of type «Radiator::Type::Amount»")
   end

   # test_to_steem_01

   def test_to_ansi_s_01
      _test = SCC::Balance.account "krischik"

      assert_not_nil(_test, "There should be ballaces for account “krischik”")
      assert_instance_of(Array, _test, "The balances should be an array")

      _balance = _test[0]

      assert_not_nil(_balance, "First balance should exist")
      assert_instance_of(SCC::Balance, _balance, "First balance should be of type «SCC::Balance»")
      assert_equal("krischik", _balance.account, "First balance  value should be “krischik”")

      _text = _balance.to_ansi_s

      assert_not_nil(_balance, "First balance can be converted into a ansi text")
      assert_instance_of(String, _text, "First balance should be of type «String»")
   end # test_to_ansi_s_01
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
