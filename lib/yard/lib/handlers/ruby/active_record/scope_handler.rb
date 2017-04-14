# frozen_string_literal: true

module YARD

  module Handlers

    module Ruby

      # Handlers for methods defined with ActiveRecord DSL
      module ActiveRecord

        # @see `YARD::Handlers::Ruby::DSLHandler`
        # @see file:spec/lib/yard/handlers/ruby/active_record/scope_handler_spec.rb rspec spec/lib/yard/handlers/ruby/active_record/scope_handler_spec.rb
        class ScopeHandler < Handlers::Ruby::Base

          handles method_call(:scope)
          namespace_only

          process do
            method_name = statement.parameters.first.jump(:tstring_content, :ident).source

            object = MethodObject.new(namespace, method_name, :class)
            register(object)

            push_state scope: :class, owner: object do
              inner_node = statement.parameters.jump(:block_var)
              # inner_node.jump(:params).unnamed_required_params.each do |param|
              #   owner.parameters << YARD::Tags::Tag.new(:param, '', Object, param.source)
              # end
              parser.process(inner_node.children)
            end

            object.dynamic = true # is it conditionally defined at runtime?
            object.group   = 'Scopes'

            object.add_tag YARD::Tags::Tag.new(:return, '', class_name)

            object.add_tag get_tag(:see, 'ActiveRecord::Scoping', nil,
              'http://api.rubyonrails.org/classes/ActiveRecord/Scoping/Named/ClassMethods.html')
          end

          private

            # @return [String]
            def class_name
              'ActiveRecord::Relation'
            end

            # @param [Symbol] tag
            # @param [String] text
            # @param [Array] return_classes
            # @param [String] name
            # @return [YARD::Tags::Tag]
            def get_tag(tag, text, return_classes = [], name = nil)
              YARD::Tags::Tag.new(tag, text, [return_classes].flatten, name)
            end

        end

      end

    end

  end

end
