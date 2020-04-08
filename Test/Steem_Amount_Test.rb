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

require_relative '../Scripts/Steem/Amount'

require "test/unit"

class Contract_Test < Test::Unit::TestCase
   def test_new_00
      _test = Steem::Type::Amount.new({:amount => 1000, :precision => 3, :nai => "@@000000021"})

      assert_equal(1.0, _test.to_f, "float value  should be 1.0")
      assert_equal("1.000", _test.amount, "test amount  should be “1.000”")
      assert_equal(3, _test.precision, "test precision should be 3'")
      assert_equal("STEEM", _test.asset, "test asset should be  “STEEM”")
      assert_equal("@@000000021", _test.nai, "test nai should be “@@000000021”")
      assert_equal(:steem, _test.chain, "test chain should be :steem")
      assert_equal("1.000 STEEM", _test.to_s, "string value should be “1.0 STEEM”")
      assert_equal(["1000", 3, "@@000000021"], _test.to_a, "test array should be [“1000”, 3, “@@000000021”]")
      assert_equal(
	 {:amount => "1000", :nai => "@@000000021", :precision => 3},
	 _test.to_h,
	 "test hash should be {:amount=>“1000”, :nai=>“@@000000021”, :precision=>3}]")
   end

   def test_new_01
      _test = Steem::Type::Amount.new(["1234", 3, "@@000000021"])

      assert_equal(1.234, _test.to_f, "float value  should be 1.234")
      assert_equal("1.234", _test.amount, "test amount  should be “1.234”")
      assert_equal(3, _test.precision, "test precision should be 3'")
      assert_equal("STEEM", _test.asset, "test asset should be  “STEEM”")
      assert_equal("@@000000021", _test.nai, "test nai should be “@@000000021”")
      assert_equal(:steem, _test.chain, "test chain should be :steem")
      assert_equal("1.234 STEEM", _test.to_s, "string value should be “1.234 STEEM”")
      assert_equal(["1234", 3, "@@000000021"], _test.to_a, "test array should be [“1234”, 3, “@@000000021”]")
      assert_equal(
	 {:amount => "1234", :nai => "@@000000021", :precision => 3},
	 _test.to_h,
	 "test array should be {:amount => “1234”, :nai =>  “@@000000021”, :precision =>  3}")
   end

   def test_new_02
      _test = Steem::Type::Amount.new("1234.567 STEEM")

      assert_equal(1234.567, _test.to_f, "float value  should be 1.234456")
      assert_equal("1234.567", _test.amount, "test amount  should be “1234.567”")
      assert_equal(3, _test.precision, "test precision should be 3'")
      assert_equal("STEEM", _test.asset, "test asset should be  “STEEM”")
      assert_equal("@@000000021", _test.nai, "test nai should be “@@000000021”")
      assert_equal(:steem, _test.chain, "test chain should be :steem")
      assert_equal("1234.567 STEEM", _test.to_s, "string value should be “1234.567 STEEM”")
      assert_equal(["1234567", 3, "@@000000021"], _test.to_a, "test array should be [“1234567”, 3, “@@000000021”]")
      assert_equal(
	 {:amount => "1234567", :nai => "@@000000021", :precision => 3},
	 _test.to_h,
	 "test array should be {:amount => “1234567”, :nai =>  “@@000000021”, :precision =>  3}")
   end

   def test_new_03
      _source = Steem::Type::Amount.new("1234.567 STEEM")
      _test   = Steem::Type::Amount.new(_source)

      assert_equal(1234.567, _test.to_f, "float value  should be 1.234456")
      assert_equal("1234.567", _test.amount, "test amount  should be “1234.567”")
      assert_equal(3, _test.precision, "test precision should be 3'")
      assert_equal("STEEM", _test.asset, "test asset should be  “STEEM”")
      assert_equal("@@000000021", _test.nai, "test nai should be “@@000000021”")
      assert_equal(:steem, _test.chain, "test chain should be :steem")
      assert_equal("1234.567 STEEM", _test.to_s, "string value should be “1234.567 STEEM”")
      assert_equal(["1234567", 3, "@@000000021"], _test.to_a, "test array should be [“1234567”, 3, “@@000000021”]")
      assert_equal(
	 {:amount => "1234567", :nai => "@@000000021", :precision => 3},
	 _test.to_h,
	 "test array should be {:amount => “1234567”, :nai =>  “@@000000021”, :precision =>  3}")
   end

   def test_new_04
      _test = Steem::Type::Amount.new({:amount => 1000, :precision => 3, :nai => "@@000000021"}, :hive)

      assert_equal(1.0, _test.to_f, "float value  should be 1.0")
      assert_equal("1.000", _test.amount, "test amount  should be “1.000”")
      assert_equal(3, _test.precision, "test precision should be 3'")
      assert_equal("HIVE", _test.asset, "test asset should be  “HIVE”")
      assert_equal("@@000000021", _test.nai, "test nai should be “@@000000021”")
      assert_equal(:hive, _test.chain, "test chain should be :hive")
      assert_equal("1.000 HIVE", _test.to_s, "string value should be “1.0 HIVE”")
      assert_equal(["1000", 3, "@@000000021"], _test.to_a, "test array should be [“1000”, 3, “@@000000021”]")
      assert_equal(
	 {:amount => "1000", :nai => "@@000000021", :precision => 3},
	 _test.to_h,
	 "test hash should be {:amount=>“1000”, :nai=>“@@000000021”, :precision=>3}]")
   end

   def test_new_05
      _test = Steem::Type::Amount.new(["1234", 3, "@@000000021"], :hive)

      assert_equal(1.234, _test.to_f, "float value  should be 1.234")
      assert_equal("1.234", _test.amount, "test amount  should be “1.234”")
      assert_equal(3, _test.precision, "test precision should be 3'")
      assert_equal("HIVE", _test.asset, "test asset should be  “HIVE”")
      assert_equal("@@000000021", _test.nai, "test nai should be “@@000000021”")
      assert_equal(:hive, _test.chain, "test chain should be :hive")
      assert_equal("1.234 HIVE", _test.to_s, "string value should be “1.234 HIVE”")
      assert_equal(["1234", 3, "@@000000021"], _test.to_a, "test array should be [“1234”, 3, “@@000000021”]")
      assert_equal(
	 {:amount => "1234", :nai => "@@000000021", :precision => 3},
	 _test.to_h,
	 "test array should be {:amount => “1234”, :nai =>  “@@000000021”, :precision =>  3}")
   end

   def test_new_06
      _test = Steem::Type::Amount.new("1234.567 HIVE", :hive)

      assert_equal(1234.567, _test.to_f, "float value  should be 1.234456")
      assert_equal("1234.567", _test.amount, "test amount  should be “1234.567”")
      assert_equal(3, _test.precision, "test precision should be 3'")
      assert_equal("HIVE", _test.asset, "test asset should be  “HIVE”")
      assert_equal("@@000000021", _test.nai, "test nai should be “@@000000021”")
      assert_equal(:hive, _test.chain, "test chain should be :hive")
      assert_equal("1234.567 HIVE", _test.to_s, "string value should be “1234.567 HIVE”")
      assert_equal(["1234567", 3, "@@000000021"], _test.to_a, "test array should be [“1234567”, 3, “@@000000021”]")
      assert_equal(
	 {:amount => "1234567", :nai => "@@000000021", :precision => 3},
	 _test.to_h,
	 "test array should be {:amount => “1234567”, :nai =>  “@@000000021”, :precision =>  3}")
   end

   def test_new_07
      _source = Steem::Type::Amount.new("1234.567 HIVE", :hive)
      _test   = Steem::Type::Amount.new(_source)

      assert_equal(1234.567, _test.to_f, "float value  should be 1.234456")
      assert_equal("1234.567", _test.amount, "test amount  should be “1234.567”")
      assert_equal(3, _test.precision, "test precision should be 3'")
      assert_equal("HIVE", _test.asset, "test asset should be  “HIVE”")
      assert_equal("@@000000021", _test.nai, "test nai should be “@@000000021”")
      assert_equal(:hive, _test.chain, "test chain should be :hive")
      assert_equal("1234.567 HIVE", _test.to_s, "string value should be “1234.567 HIVE”")
      assert_equal(["1234567", 3, "@@000000021"], _test.to_a, "test array should be [“1234567”, 3, “@@000000021”]")
      assert_equal(
	 {:amount => "1234567", :nai => "@@000000021", :precision => 3},
	 _test.to_h,
	 "test array should be {:amount => “1234567”, :nai =>  “@@000000021”, :precision =>  3}")
   end

   def test_new_10
      _test = Steem::Type::Amount.new({:amount => 1000, :precision => 3, :nai => "@@000000013"})

      assert_equal(1.0, _test.to_f, "float value  should be 1.0")
      assert_equal("1.000", _test.amount, "test amount  should be “1.000”")
      assert_equal(3, _test.precision, "test precision should be 3'")
      assert_equal("SBD", _test.asset, "test asset should be  “SBD”")
      assert_equal("@@000000013", _test.nai, "test nai should be “@@000000013”")
      assert_equal(:steem, _test.chain, "test chain should be :steem")
      assert_equal("1.000 SBD", _test.to_s, "string value should be “1.0 SBD”")
      assert_equal(["1000", 3, "@@000000013"], _test.to_a, "test array should be [“1000”, 3, “@@000000013”]")
      assert_equal(
	 {:amount => "1000", :nai => "@@000000013", :precision => 3},
	 _test.to_h,
	 "test array should be {:amount => “1000”, :nai =>  “@@000000013”, :precision =>  3}")
   end

   def test_new_11
      _test = Steem::Type::Amount.new([1234, 3, "@@000000013"])

      assert_equal(1.234, _test.to_f, "float value  should be 1.234")
      assert_equal("1.234", _test.amount, "test amount  should be “1.234”")
      assert_equal(3, _test.precision, "test precision should be 3'")
      assert_equal("SBD", _test.asset, "test asset should be  “SBD”")
      assert_equal("@@000000013", _test.nai, "test nai should be “@@000000013”")
      assert_equal(:steem, _test.chain, "test chain should be :steem")
      assert_equal("1.234 SBD", _test.to_s, "string value should be “1.234 SBD”")
      assert_equal(["1234", 3, "@@000000013"], _test.to_a, "test array should be [“1234”, 3, “@@000000013”]")
      assert_equal(
	 {:amount => "1234", :nai => "@@000000013", :precision => 3},
	 _test.to_h,
	 "test array should be {:amount => “1234”, :nai =>  “@@000000013”, :precision =>  3}")
   end

   def test_new_12
      _test = Steem::Type::Amount.new("1234.567 SBD")

      assert_equal(1234.567, _test.to_f, "float value  should be 1.234456")
      assert_equal("1234.567", _test.amount, "test amount  should be “1234.567”")
      assert_equal(3, _test.precision, "test precision should be 3'")
      assert_equal("SBD", _test.asset, "test asset should be  “SBD”")
      assert_equal("@@000000013", _test.nai, "test nai should be “@@000000013”")
      assert_equal(:steem, _test.chain, "test chain should be :steem")
      assert_equal("1234.567 SBD", _test.to_s, "string value should be “1234.567 SBD”")
      assert_equal(["1234567", 3, "@@000000013"], _test.to_a, "test array should be [“1234567”, 3, “@@000000013”]")
      assert_equal(
	 {:amount => "1234567", :nai => "@@000000013", :precision => 3},
	 _test.to_h,
	 "test array should be {:amount => “1234567”, :nai =>  “@@000000013”, :precision =>  3}")
   end

   def test_new_13
      _source = Steem::Type::Amount.new("1234.567 SBD")
      _test   = Steem::Type::Amount.new(_source)

      assert_equal(1234.567, _test.to_f, "float value  should be 1.234456")
      assert_equal("1234.567", _test.amount, "test amount  should be “1234.567”")
      assert_equal(3, _test.precision, "test precision should be 3'")
      assert_equal("SBD", _test.asset, "test asset should be  “SBD”")
      assert_equal("@@000000013", _test.nai, "test nai should be “@@000000013”")
      assert_equal(:steem, _test.chain, "test chain should be :steem")
      assert_equal("1234.567 SBD", _test.to_s, "string value should be “1234.567 SBD”")
      assert_equal(["1234567", 3, "@@000000013"], _test.to_a, "test array should be [“1234567”, 3, “@@000000013”]")
      assert_equal(
	 {:amount => "1234567", :nai => "@@000000013", :precision => 3},
	 _test.to_h,
	 "test array should be {:amount => “1234567”, :nai =>  “@@000000013”, :precision =>  3}")
   end

   def test_new_14
      _test = Steem::Type::Amount.new({:amount => 1000, :precision => 3, :nai => "@@000000013"}, :hive)

      assert_equal(1.0, _test.to_f, "float value  should be 1.0")
      assert_equal("1.000", _test.amount, "test amount  should be “1.000”")
      assert_equal(3, _test.precision, "test precision should be 3'")
      assert_equal("HBD", _test.asset, "test asset should be  “HBD”")
      assert_equal("@@000000013", _test.nai, "test nai should be “@@000000013”")
      assert_equal(:hive, _test.chain, "test chain should be :hive")
      assert_equal("1.000 HBD", _test.to_s, "string value should be “1.0 HBD”")
      assert_equal(["1000", 3, "@@000000013"], _test.to_a, "test array should be [“1000”, 3, “@@000000013”]")
      assert_equal(
	 {:amount => "1000", :nai => "@@000000013", :precision => 3},
	 _test.to_h,
	 "test array should be {:amount => “1000”, :nai =>  “@@000000013”, :precision =>  3}")
   end

   def test_new_15
      _test = Steem::Type::Amount.new([1234, 3, "@@000000013"], :hive)

      assert_equal(1.234, _test.to_f, "float value  should be 1.234")
      assert_equal("1.234", _test.amount, "test amount  should be “1.234”")
      assert_equal(3, _test.precision, "test precision should be 3'")
      assert_equal("HBD", _test.asset, "test asset should be  “HBD”")
      assert_equal("@@000000013", _test.nai, "test nai should be “@@000000013”")
      assert_equal(:hive, _test.chain, "test chain should be :hive")
      assert_equal("1.234 HBD", _test.to_s, "string value should be “1.234 HBD”")
      assert_equal(["1234", 3, "@@000000013"], _test.to_a, "test array should be [“1234”, 3, “@@000000013”]")
      assert_equal(
	 {:amount => "1234", :nai => "@@000000013", :precision => 3},
	 _test.to_h,
	 "test array should be {:amount => “1234”, :nai =>  “@@000000013”, :precision =>  3}")
   end

   def test_new_16
      _test = Steem::Type::Amount.new("1234.567 HBD", :hive)

      assert_equal(1234.567, _test.to_f, "float value  should be 1.234456")
      assert_equal("1234.567", _test.amount, "test amount  should be “1234.567”")
      assert_equal(3, _test.precision, "test precision should be 3'")
      assert_equal("HBD", _test.asset, "test asset should be  “HBD”")
      assert_equal("@@000000013", _test.nai, "test nai should be “@@000000013”")
      assert_equal(:hive, _test.chain, "test chain should be :hive")
      assert_equal("1234.567 HBD", _test.to_s, "string value should be “1234.567 HBD”")
      assert_equal(["1234567", 3, "@@000000013"], _test.to_a, "test array should be [“1234567”, 3, “@@000000013”]")
      assert_equal(
	 {:amount => "1234567", :nai => "@@000000013", :precision => 3},
	 _test.to_h,
	 "test array should be {:amount => “1234567”, :nai =>  “@@000000013”, :precision =>  3}")
   end

   def test_new_17
      _source = Steem::Type::Amount.new("1234.567 HBD", :hive)
      _test   = Steem::Type::Amount.new(_source)

      assert_equal(1234.567, _test.to_f, "float value  should be 1.234456")
      assert_equal("1234.567", _test.amount, "test amount  should be “1234.567”")
      assert_equal(3, _test.precision, "test precision should be 3'")
      assert_equal("HBD", _test.asset, "test asset should be  “HBD”")
      assert_equal("@@000000013", _test.nai, "test nai should be “@@000000013”")
      assert_equal(:hive, _test.chain, "test chain should be :hive")
      assert_equal("1234.567 HBD", _test.to_s, "string value should be “1234.567 HBD”")
      assert_equal(["1234567", 3, "@@000000013"], _test.to_a, "test array should be [“1234567”, 3, “@@000000013”]")
      assert_equal(
	 {:amount => "1234567", :nai => "@@000000013", :precision => 3},
	 _test.to_h,
	 "test array should be {:amount => “1234567”, :nai =>  “@@000000013”, :precision =>  3}")
   end

   def test_new_20
      _test = Steem::Type::Amount.new({:amount => 1000000, :precision => 6, :nai => "@@000000037"})

      assert_equal(1.0, _test.to_f, "float value  should be 1.0")
      assert_equal("1.000000", _test.amount, "test amount  should be “1.000000”")
      assert_equal(6, _test.precision, "test precision should be 3'")
      assert_equal("VESTS", _test.asset, "test asset should be  “VESTS”")
      assert_equal("@@000000037", _test.nai, "test nai should be “@@000000037”")
      assert_equal(:steem, _test.chain, "test chain should be :steem")
      assert_equal("1.000000 VESTS", _test.to_s, "string value should be “1.0 VESTS”")
      assert_equal(["1000000", 6, "@@000000037"], _test.to_a, "test array should be [“1000000”, 6, “@@000000037”]")
      assert_equal(
	 {:amount => "1000000", :nai => "@@000000037", :precision => 6},
	 _test.to_h,
	 "test array should be {:amount => “1000000”, :nai =>  “@@000000037”, :precision =>  6}")
   end

   def test_new_21
      _test = Steem::Type::Amount.new([1234000, 6, "@@000000037"])

      assert_equal(1.234, _test.to_f, "float value  should be 1.234")
      assert_equal("1.234000", _test.amount, "test amount  should be “1.234000”")
      assert_equal(6, _test.precision, "test precision should be 6'")
      assert_equal("VESTS", _test.asset, "test asset should be  “VESTS”")
      assert_equal("@@000000037", _test.nai, "test nai should be “@@000000037”")
      assert_equal(:steem, _test.chain, "test chain should be :steem")
      assert_equal("1.234000 VESTS", _test.to_s, "string value should be “1.234000 VESTS”")
      assert_equal(["1234000", 6, "@@000000037"], _test.to_a, "test array should be [“1234000”, 6, “@@000000037”]")
      assert_equal(
	 {:amount => "1234000", :nai => "@@000000037", :precision => 6},
	 _test.to_h,
	 "test array should be {:amount => “1234000”, :nai =>  “@@000000037”, :precision =>  6}")
   end

   def test_new_22
      _test = Steem::Type::Amount.new("1.234567 VESTS")

      assert_equal(1.234567, _test.to_f, "float value  should be 1.234456")
      assert_equal("1.234567", _test.amount, "test amount  should be “1.234567”")
      assert_equal(6, _test.precision, "test precision should be 6'")
      assert_equal("VESTS", _test.asset, "test asset should be  “VESTS”")
      assert_equal("@@000000037", _test.nai, "test nai should be “@@000000037”")
      assert_equal(:steem, _test.chain, "test chain should be :steem")
      assert_equal("1.234567 VESTS", _test.to_s, "string value should be “1.234567 VESTS”")
      assert_equal(["1234567", 6, "@@000000037"], _test.to_a, "test array should be [“1234567”, 6, “@@000000037”]")
      assert_equal(
	 {:amount => "1234567", :nai => "@@000000037", :precision => 6},
	 _test.to_h,
	 "test array should be {:amount => “1234567”, :nai =>  “@@000000037”, :precision =>  6}")
   end

   def test_new_23
      _source = Steem::Type::Amount.new("123.4567 VESTS")
      _test   = Steem::Type::Amount.new(_source)

      assert_equal(123.4567, _test.to_f, "float value  should be 123.4456")
      assert_equal("123.4567", _test.amount, "test amount  should be “123.4567”")
      assert_equal(6, _test.precision, "test precision should be 6'")
      assert_equal("VESTS", _test.asset, "test asset should be  “VESTS”")
      assert_equal("@@000000037", _test.nai, "test nai should be “@@000000037”")
      assert_equal(:steem, _test.chain, "test chain should be :steem")
      assert_equal("123.4567 VESTS", _test.to_s, "string value should be “123.4567 VESTS”")
      assert_equal(["123456700", 6, "@@000000037"], _test.to_a, "test array should be [“123456700”, 6, “@@000000037”]")
      assert_equal(
	 {:amount => "123456700", :nai => "@@000000037", :precision => 6},
	 _test.to_h,
	 "test array should be {:amount => “123456700”, :nai =>  “@@000000037”, :precision =>  6}")
   end

   def test_new_24
      _test = Steem::Type::Amount.new({:amount => 1000000, :precision => 6, :nai => "@@000000037"}, :hive)

      assert_equal(1.0, _test.to_f, "float value  should be 1.0")
      assert_equal("1.000000", _test.amount, "test amount  should be “1.000000”")
      assert_equal(6, _test.precision, "test precision should be 3'")
      assert_equal("VESTS", _test.asset, "test asset should be  “VESTS”")
      assert_equal("@@000000037", _test.nai, "test nai should be “@@000000037”")
      assert_equal(:hive, _test.chain, "test chain should be :hive")
      assert_equal("1.000000 VESTS", _test.to_s, "string value should be “1.0 VESTS”")
      assert_equal(["1000000", 6, "@@000000037"], _test.to_a, "test array should be [“1000000”, 6, “@@000000037”]")
      assert_equal(
	 {:amount => "1000000", :nai => "@@000000037", :precision => 6},
	 _test.to_h,
	 "test array should be {:amount => “1000000”, :nai =>  “@@000000037”, :precision =>  6}")
   end

   def test_new_25
      _test = Steem::Type::Amount.new([1234000, 6, "@@000000037"], :hive)

      assert_equal(1.234, _test.to_f, "float value  should be 1.234")
      assert_equal("1.234000", _test.amount, "test amount  should be “1.234000”")
      assert_equal(6, _test.precision, "test precision should be 6'")
      assert_equal("VESTS", _test.asset, "test asset should be  “VESTS”")
      assert_equal("@@000000037", _test.nai, "test nai should be “@@000000037”")
      assert_equal(:hive, _test.chain, "test chain should be :hive")
      assert_equal("1.234000 VESTS", _test.to_s, "string value should be “1.234000 VESTS”")
      assert_equal(["1234000", 6, "@@000000037"], _test.to_a, "test array should be [“1234000”, 6, “@@000000037”]")
      assert_equal(
	 {:amount => "1234000", :nai => "@@000000037", :precision => 6},
	 _test.to_h,
	 "test array should be {:amount => “1234000”, :nai =>  “@@000000037”, :precision =>  6}")
   end

   def test_new_26
      _test = Steem::Type::Amount.new("1.234567 VESTS", :hive)

      assert_equal(1.234567, _test.to_f, "float value  should be 1.234456")
      assert_equal("1.234567", _test.amount, "test amount  should be “1.234567”")
      assert_equal(6, _test.precision, "test precision should be 6'")
      assert_equal("VESTS", _test.asset, "test asset should be  “VESTS”")
      assert_equal("@@000000037", _test.nai, "test nai should be “@@000000037”")
      assert_equal(:hive, _test.chain, "test chain should be :hive")
      assert_equal("1.234567 VESTS", _test.to_s, "string value should be “1.234567 VESTS”")
      assert_equal(["1234567", 6, "@@000000037"], _test.to_a, "test array should be [“1234567”, 6, “@@000000037”]")
      assert_equal(
	 {:amount => "1234567", :nai => "@@000000037", :precision => 6},
	 _test.to_h,
	 "test array should be {:amount => “1234567”, :nai =>  “@@000000037”, :precision =>  6}")
   end

   def test_new_27
      _source = Steem::Type::Amount.new("123.4567 VESTS", :hive)
      _test   = Steem::Type::Amount.new(_source)

      assert_equal(123.4567, _test.to_f, "float value  should be 123.4456")
      assert_equal("123.4567", _test.amount, "test amount  should be “123.4567”")
      assert_equal(6, _test.precision, "test precision should be 6'")
      assert_equal("VESTS", _test.asset, "test asset should be  “VESTS”")
      assert_equal("@@000000037", _test.nai, "test nai should be “@@000000037”")
      assert_equal(:hive, _test.chain, "test chain should be :hive")
      assert_equal("123.4567 VESTS", _test.to_s, "string value should be “123.4567 VESTS”")
      assert_equal(["123456700", 6, "@@000000037"], _test.to_a, "test array should be [“123456700”, 6, “@@000000037”]")
      assert_equal(
	 {:amount => "123456700", :nai => "@@000000037", :precision => 6},
	 _test.to_h,
	 "test array should be {:amount => “123456700”, :nai =>  “@@000000037”, :precision =>  6}")
   end

   def test_to_amount_01
      _test = Steem::Type::Amount.to_amount(1.0, Steem::Type::Amount::STEEM, :steem)

      assert_not_nil(_test, "An amount should be created")
      assert_instance_of(Steem::Type::Amount, _test, "The amount should be of type «Steem::Type::Amount»")
      assert_equal(Steem::Type::Amount::STEEM, _test.asset, "The amount is if a «STEEEM» asset")
   end

   def test_to_steem_01
      _test = Steem::Type::Amount.to_amount(1.0, Steem::Type::Amount::STEEM, :steem)

      assert_not_nil(_test, "An amount should be created")
      assert_instance_of(Steem::Type::Amount, _test, "The amount should be of type «Steem::Type::Amount»")
      assert_equal(Steem::Type::Amount::STEEM, _test.asset, "The amount is if a «STEEEM» asset")

      _steem = _test.to_steem

      assert_not_nil(_steem, "A vests amount should be created")
      assert_instance_of(Steem::Type::Amount, _steem, "The amount should be of type «Rator::Type::Amount»")
      assert_equal(Steem::Type::Amount::STEEM, _steem.asset, "The amount is if a «STEEM» asset")
   end

   def test_to_steem_02
      _test = Steem::Type::Amount.to_amount(1.0, Steem::Type::Amount::SBD, :steem)

      assert_not_nil(_test, "An amount should be created")
      assert_instance_of(Steem::Type::Amount, _test, "The amount should be of type «Steem::Type::Amount»")
      assert_equal(Steem::Type::Amount::SBD, _test.asset, "The amount is if a «SBD» asset")

      _steem = _test.to_steem

      assert_not_nil(_steem, "A vests amount should be created")
      assert_instance_of(Steem::Type::Amount, _steem, "The amount should be of type «Rator::Type::Amount»")
      assert_equal(Steem::Type::Amount::STEEM, _steem.asset, "The amount is if a «STEEM» asset")
   end

   def test_to_steem_03
      _test = Steem::Type::Amount.to_amount(1.0, Steem::Type::Amount::VESTS, :steem)

      assert_not_nil(_test, "An amount should be created")
      assert_instance_of(Steem::Type::Amount, _test, "The amount should be of type «Steem::Type::Amount»")
      assert_equal(Steem::Type::Amount::VESTS, _test.asset, "The amount is if a «VESTS» asset")

      _steem = _test.to_steem

      assert_not_nil(_steem, "A vests amount should be created")
      assert_instance_of(Steem::Type::Amount, _steem, "The amount should be of type «Rator::Type::Amount»")
      assert_equal(Steem::Type::Amount::STEEM, _steem.asset, "The amount is if a «STEEM» asset")
   end

   def test_to_sbd_01
      _test = Steem::Type::Amount.to_amount(1.0, Steem::Type::Amount::STEEM, :steem)

      assert_not_nil(_test, "An amount should be created")
      assert_instance_of(Steem::Type::Amount, _test, "The amount should be of type «Steem::Type::Amount»")
      assert_equal(Steem::Type::Amount::STEEM, _test.asset, "The amount is if a «STEEM» asset")

      _sbd = _test.to_sbd

      assert_not_nil(_sbd, "A sbd amount should be created")
      assert_instance_of(Steem::Type::Amount, _sbd, "The amount should be of type «Steem::Type::Amount»")
      assert_equal(Steem::Type::Amount::SBD, _sbd.asset, "The amount is if a «SBD» asset")
   end

   def test_to_sbd_02
      _test = Steem::Type::Amount.to_amount(1.0, Steem::Type::Amount::SBD, :steem)

      assert_not_nil(_test, "An amount should be created")
      assert_instance_of(Steem::Type::Amount, _test, "The amount should be of type «Steem::Type::Amount»")
      assert_equal(Steem::Type::Amount::SBD, _test.asset, "The amount is if a «SBD» asset")

      _sbd = _test.to_sbd

      assert_not_nil(_sbd, "A sbd amount should be created")
      assert_instance_of(Steem::Type::Amount, _sbd, "The amount should be of type «Steem::Type::Amount»")
      assert_equal(Steem::Type::Amount::SBD, _sbd.asset, "The amount is if a «SBD» asset")
   end

   def test_to_sbd_03
      _test = Steem::Type::Amount.to_amount(1.0, Steem::Type::Amount::VESTS, :steem)

      assert_not_nil(_test, "An amount should be created")
      assert_instance_of(Steem::Type::Amount, _test, "The amount should be of type «Steem::Type::Amount»")
      assert_equal(Steem::Type::Amount::VESTS, _test.asset, "The amount is if a «VESTS» asset")

      _sbd = _test.to_sbd

      assert_not_nil(_sbd, "A sbd amount should be created")
      assert_instance_of(Steem::Type::Amount, _sbd, "The amount should be of type «Steem::Type::Amount»")
      assert_equal(Steem::Type::Amount::SBD, _sbd.asset, "The amount is if a «SBD» asset")
   end

   def test_to_vests_01
      _test = Steem::Type::Amount.to_amount(1.0, Steem::Type::Amount::STEEM, :steem)

      assert_not_nil(_test, "An amount should be created")
      assert_instance_of(Steem::Type::Amount, _test, "The amount should be of type «Steem::Type::Amount»")
      assert_equal(Steem::Type::Amount::STEEM, _test.asset, "The amount is if a «STEEEM» asset")

      _vests = _test.to_vests

      assert_not_nil(_vests, "A vests amount should be created")
      assert_instance_of(Steem::Type::Amount, _vests, "The amount should be of type «Rator::Type::Amount»")
      assert_equal(Steem::Type::Amount::VESTS, _vests.asset, "The amount is if a «VESTS» asset")
   end

   def test_to_vests_02
      _test = Steem::Type::Amount.to_amount(1.0, Steem::Type::Amount::SBD, :steem)

      assert_not_nil(_test, "An amount should be created")
      assert_instance_of(Steem::Type::Amount, _test, "The amount should be of type «Steem::Type::Amount»")
      assert_equal(Steem::Type::Amount::SBD, _test.asset, "The amount is if a «SBD» asset")

      _vests = _test.to_vests

      assert_not_nil(_vests, "A vests amount should be created")
      assert_instance_of(Steem::Type::Amount, _vests, "The amount should be of type «Rator::Type::Amount»")
      assert_equal(Steem::Type::Amount::VESTS, _vests.asset, "The amount is if a «VESTS» asset")
   end

   def test_to_vests_03
      _test = Steem::Type::Amount.to_amount(1.0, Steem::Type::Amount::VESTS, :steem)

      assert_not_nil(_test, "An amount should be created")
      assert_instance_of(Steem::Type::Amount, _test, "The amount should be of type «Steem::Type::Amount»")
      assert_equal(Steem::Type::Amount::VESTS, _test.asset, "The amount is if a «VESTS» asset")

      _vests = _test.to_vests

      assert_not_nil(_vests, "A vests amount should be created")
      assert_instance_of(Steem::Type::Amount, _vests, "The amount should be of type «Rator::Type::Amount»")
      assert_equal(Steem::Type::Amount::VESTS, _vests.asset, "The amount is if a «VESTS» asset")
   end # test_to_vests_03
end # Radiator_Amount_Test

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
