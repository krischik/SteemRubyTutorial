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
require "test/unit"

class Contract_Test < Test::Unit::TestCase
   def test_new_01
      _test = SCC::Steem_Engine.new(:test, "test")

      assert_not_nil(_test, "Steem_Engine was createed" )
      assert_instance_of(SCC::Steem_Engine, _test, "Result should be of type «SCC::Steem_Engine»")
      assert_equal(:test, _test.key, "The key should be «:test»")
      assert_equal("test", _test.value, "The value should be “test”")
   end

   def test_contracts_api_01
      _test = SCC::Steem_Engine.contracts_api

      assert_not_nil(_test, "Contracts API was createed" )
      assert_instance_of(Radiator::SSC::Contracts, _test, "Contracts API should be of type «Radiator::SSC::Contracts»")
   end


   def test_query_limit_01
      _test = SCC::Steem_Engine::QUERY_LIMIT

      assert_equal(1000, _test, "The value of query_limit should be 1000")
   end

   def test_query_all_01
      _test = SCC::Steem_Engine::QUERY_ALL

      assert_equal({}, _test, "The value of query_all should be «{}»")
   end
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
