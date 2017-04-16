require 'spec_helper'
require_relative '../../../../../../lib/yard/lib/ext'

RSpec.describe YARD::Handlers::Ruby::ActiveRecord::ScopeHandler do
  before(:all) do
    @source = <<-RUBY
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
    RUBY

    @file = File.join(root, 'spec/fixtures/models/docs.rb')
  end

  describe do
    it do
      # parser  = YARD::Parser::SourceParser.parse([@file], [], log.level)
      parser = YARD::Parser::Ruby::RubyParser.new(File.read(@file), nil)
      ast    = parser.parse.ast
      YARD::Handlers::Ruby::Concerns::ExtendedHandler.new(parser, ast).process
    end
  end
end

<<-EOS
  file = Piktur::Engine.root.join('app/models/concerns/associations/ownable.rb').to_s
  file = Piktur::Engine.root.join('app/models/catalogue/attribution.rb').to_s
  YARD::Parser::SourceParser.parse(@file, [], log.level)

  statement = Ripper.sexp(File.read(@file))

  parser = YARD::Parser::SourceParser.parse([@file], [], log.level)
  YARD::Handlers::Ruby::Concerns::ExtendedHandler.new(parser, statement).process
EOS
