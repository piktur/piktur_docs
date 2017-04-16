class Docs < ActiveRecord::Base

  self.table_name = 'catalogues'

  # @!method scope1(a, b)
  #   @!scope class
  #   Test
  #   @param [String] a
  #   @param [String] b
  scope :scope1, lambda { |a, b| 1 }

  # @!method scope2(a, b)
  #   @!scope class
  #   Test 2
  #   @param [String] a
  #   @param [String] b
  scope :scope2, ->(a, b) { 1 }

  # Test 3
  # @param [String] a
  # @param [String] b
  scope :scope3, ->(a, b) { 1 }

end
