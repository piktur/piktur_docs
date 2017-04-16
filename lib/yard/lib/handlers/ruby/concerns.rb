# frozen_string_literal: true

module YARD

  module Handlers

    module Ruby

      # @see https://github.com/digitalcuisine/yard-activesupport-concern/blob/master/lib/yard-activesupport-concern.rb
      module Concerns

        class IncludedHandler < YARD::Handlers::Ruby::MethodHandler

          handles method_call(:included)
          namespace_only

          # Process any found `included` block within a "namespace" scope (class
          # or module).
          process do
            # `statement.last.last` refers to the statements within the block
            # given to `included`. YARD will parse those and attach any generated
            # documentation to the current namespace at the instance level (unless
            # overridden with a @!scope directive)
            parse_block(statement.last.last, scope: :instance)
          end

        end

        class ExtendedHandler < YARD::Handlers::Ruby::ModuleHandler

          # handles :module, /(def self.extended\(base\))/
          handles method_call(:class_methods)
          namespace_only

          process do
            # `statement.last.last` refers to the statements within the block
            # given to `class_methods`. YARD will parse those and attach any
            # generated documentation to the current namespace at the class
            # level (unless overridden with a @!scope directive)
            parse_block(statement.last.last, scope: :class)
          end

        end

      end

    end

  end

end
