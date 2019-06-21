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

require_relative '../Scripts/SCC/Metric'
require "test/unit"

class Metric_Test < Test::Unit::TestCase
   def test_all_01
      # Thee “all” tests but considerable strain on the
      # Steem Engine server so we only do them when
      # explicitly requested
      #
      if Test_All then
         _test = SCC::Metric.all

         assert_not_nil(_test, "There should be metrics")
         assert_instance_of(Array, _test, "metric should be an array")

         _metric = _test[0]

         assert_not_nil(_metric, "First metric should exist")
         assert_instance_of(SCC::Metric, _metric, "First metric should be of type «SCC::Metric»")
         assert_equal(:symbol, _metric.key, "First metric key should be «:symbol»")
         assert_equal("ENG", _metric.value, "First metric value should be “ENG”")
      end
   end

   def test_symbol_01
      _test = SCC::Metric.symbol "BEER"

      assert_not_nil(_test, "There should be a metric for metric “BEER”")
      assert_instance_of(SCC::Metric, _test, "Result should be of type «SCC::Metric»")
      assert_equal(:symbol, _test.key, "The metric key should be «:symbol»")
      assert_equal("BEER", _test.value, "The metric value should be “BEER”")
   end
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
