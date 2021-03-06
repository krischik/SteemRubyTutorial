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

require_relative '../Scripts/Radiator/Reward_Fund'
require "test/unit"

class Reward_Fund_Test < Test::Unit::TestCase
   def test_get_01
      _test = Radiator::Type::Reward_Fund.get

      assert_not_nil(_test, "There should be a reward funds.")
      assert_instance_of(Radiator::Type::Reward_Fund, _test, "result should be a Reward_Fund")
      assert_instance_of(String, _test.name, "name should be a String")
      assert_instance_of(Radiator::Type::Amount, _test.reward_balance, "reward_balance should be an Amount")
      assert_instance_of(Integer, _test.recent_claims, "recent_claims should be a Number")
   end
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
