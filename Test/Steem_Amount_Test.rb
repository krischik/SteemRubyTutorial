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

require_relative '../Scripts/Steem/Amount'

require "test/unit"

class Amount_Test < Test::Unit::TestCase

   def test_to_amount_01
      _test = Steem::Type::Amount.to_amount(1.0, "STEEM", :steem)

      assert_not_nil(_test, "An amount should be created")
      assert_instance_of(Steem::Type::Amount, _test, "The amount should be of type «Steem::Type::Amount»")
      assert_equal("STEEM", _test.asset, "The amount is if a «STEEEM» asset")
   end

   def test_to_amount_05
      _test = Steem::Type::Amount.to_amount(1.0, "HIVE", :hive)

      assert_not_nil(_test, "An amount should be created")
      assert_instance_of(Steem::Type::Amount, _test, "The amount should be of type «Steem::Type::Amount»")
      assert_equal("HIVE", _test.asset, "The amount is if a «HIVE» asset")
   end

   def test_to_steem_01
      _test = Steem::Type::Amount.to_amount(1.0, "STEEM", :steem)

      assert_not_nil(_test, "An amount should be created")
      assert_instance_of(Steem::Type::Amount, _test, "The amount should be of type «Steem::Type::Amount»")
      assert_equal("STEEM", _test.asset, "The amount is if a «STEEEM» asset")

      _steem = _test.to_steem

      assert_not_nil(_steem, "A vests amount should be created")
      assert_instance_of(Steem::Type::Amount, _steem, "The amount should be of type «Rator::Type::Amount»")
      assert_equal("STEEM", _steem.asset, "The amount is if a «STEEM» asset")
   end

   def test_to_steem_02
      _test = Steem::Type::Amount.to_amount(1.0, "SBD", :steem)

      assert_not_nil(_test, "An amount should be created")
      assert_instance_of(Steem::Type::Amount, _test, "The amount should be of type «Steem::Type::Amount»")
      assert_equal("SBD", _test.asset, "The amount is if a «SBD» asset")

      _steem = _test.to_steem

      assert_not_nil(_steem, "A vests amount should be created")
      assert_instance_of(Steem::Type::Amount, _steem, "The amount should be of type «Rator::Type::Amount»")
      assert_equal("STEEM", _steem.asset, "The amount is if a «STEEM» asset")
   end

   def test_to_steem_03
      _test = Steem::Type::Amount.to_amount(1.0, "VESTS", :steem)

      assert_not_nil(_test, "An amount should be created")
      assert_instance_of(Steem::Type::Amount, _test, "The amount should be of type «Steem::Type::Amount»")
      assert_equal("VESTS", _test.asset, "The amount is if a «VESTS» asset")

      _steem = _test.to_steem

      assert_not_nil(_steem, "A vests amount should be created")
      assert_instance_of(Steem::Type::Amount, _steem, "The amount should be of type «Rator::Type::Amount»")
      assert_equal("STEEM", _steem.asset, "The amount is if a «STEEM» asset")
   end

   def test_to_sbd_01
      _test = Steem::Type::Amount.to_amount(1.0, "STEEM", :steem)

      assert_not_nil(_test, "An amount should be created")
      assert_instance_of(Steem::Type::Amount, _test, "The amount should be of type «Steem::Type::Amount»")
      assert_equal("STEEM", _test.asset, "The amount is if a «STEEM» asset")

      _sbd = _test.to_sbd

      assert_not_nil(_sbd, "A sbd amount should be created")
      assert_instance_of(Steem::Type::Amount, _sbd, "The amount should be of type «Steem::Type::Amount»")
      assert_equal("SBD", _sbd.asset, "The amount is if a «SBD» asset")
   end

   def test_to_sbd_02
      _test = Steem::Type::Amount.to_amount(1.0, "SBD", :steem)

      assert_not_nil(_test, "An amount should be created")
      assert_instance_of(Steem::Type::Amount, _test, "The amount should be of type «Steem::Type::Amount»")
      assert_equal("SBD", _test.asset, "The amount is if a «SBD» asset")

      _sbd = _test.to_sbd

      assert_not_nil(_sbd, "A sbd amount should be created")
      assert_instance_of(Steem::Type::Amount, _sbd, "The amount should be of type «Steem::Type::Amount»")
      assert_equal("SBD", _sbd.asset, "The amount is if a «SBD» asset")
   end

   def test_to_sbd_03
      _test = Steem::Type::Amount.to_amount(1.0, "VESTS", :steem)

      assert_not_nil(_test, "An amount should be created")
      assert_instance_of(Steem::Type::Amount, _test, "The amount should be of type «Steem::Type::Amount»")
      assert_equal("VESTS", _test.asset, "The amount is if a «VESTS» asset")

      _sbd = _test.to_sbd

      assert_not_nil(_sbd, "A sbd amount should be created")
      assert_instance_of(Steem::Type::Amount, _sbd, "The amount should be of type «Steem::Type::Amount»")
      assert_equal("SBD", _sbd.asset, "The amount is if a «SBD» asset")
   end

   def test_to_vests_01
      _test = Steem::Type::Amount.to_amount(1.0, "STEEM", :steem)

      assert_not_nil(_test, "An amount should be created")
      assert_instance_of(Steem::Type::Amount, _test, "The amount should be of type «Steem::Type::Amount»")
      assert_equal("STEEM", _test.asset, "The amount is if a «STEEEM» asset")

      _vests = _test.to_vests

      assert_not_nil(_vests, "A vests amount should be created")
      assert_instance_of(Steem::Type::Amount, _vests, "The amount should be of type «Rator::Type::Amount»")
      assert_equal("VESTS", _vests.asset, "The amount is if a «VESTS» asset")
   end

   def test_to_vests_02
      _test = Steem::Type::Amount.to_amount(1.0, "SBD", :steem)

      assert_not_nil(_test, "An amount should be created")
      assert_instance_of(Steem::Type::Amount, _test, "The amount should be of type «Steem::Type::Amount»")
      assert_equal("SBD", _test.asset, "The amount is if a «SBD» asset")

      _vests = _test.to_vests

      assert_not_nil(_vests, "A vests amount should be created")
      assert_instance_of(Steem::Type::Amount, _vests, "The amount should be of type «Rator::Type::Amount»")
      assert_equal("VESTS", _vests.asset, "The amount is if a «VESTS» asset")
   end

   def test_to_vests_03
      _test = Steem::Type::Amount.to_amount(1.0, "VESTS", :steem)

      assert_not_nil(_test, "An amount should be created")
      assert_instance_of(Steem::Type::Amount, _test, "The amount should be of type «Steem::Type::Amount»")
      assert_equal("VESTS", _test.asset, "The amount is if a «VESTS» asset")

      _vests = _test.to_vests

      assert_not_nil(_vests, "A vests amount should be created")
      assert_instance_of(Steem::Type::Amount, _vests, "The amount should be of type «Rator::Type::Amount»")
      assert_equal("VESTS", _vests.asset, "The amount is if a «VESTS» asset")
   end # test_to_vests_03
end # Radiator_Amount_Test

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
