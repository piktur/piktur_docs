# frozen_string_literal: true

require_relative '../../../app/policies/docs_policy'

# Define `UseProxy` for each `User` subclass.
# The proxy object supports authentication without a database connection.
#
# To **authenticate** include **JSON Web Token (JWT)** via
# - url    `?token=<token>`
# - header `Authorization: Bearer <token>`
#
[:Admin].each do |klass|
  klass = Object.const_set(klass, Class.new)
  klass.extend ::Piktur::Security::Authentication::UserProxy
end
