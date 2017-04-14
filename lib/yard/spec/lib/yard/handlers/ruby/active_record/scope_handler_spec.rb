require 'rails_helper'
require 'yard/ext'

RSpec.describe YARD::Handlers::Ruby::ActiveRecord::ScopeHandler do
  let(:source) { <<-RUBY }
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
      scope :scope2, -> (a, b) { 1 }

      # Test 3
      # @param [String] a
      # @param [String] b
      scope :scope3, -> (a, b) { 1 }

    end
  RUBY

  let(:file) { Piktur::Engine.root.join('spec/fixtures/docs.rb').to_s }

  describe do
    pending

    it do
      YARD::Parser::SourceParser.parse(file, [], log.level)
    end
  end
end


<<-EOS
  file = Piktur::Engine.root.join('app/models/concerns/associations/ownable.rb').to_s
  file = Piktur::Engine.root.join('app/models/catalogue/attribution.rb').to_s
  YARD::Parser::SourceParser.parse(file, [], log.level)

  statement = Ripper.sexp(File.read(file))

  parser = YARD::Parser::SourceParser.parse(file, [], log.level)
  YARD::Handlers::Ruby::Concerns::ExtendedHandler.new(), File.read(file)).process
EOS
