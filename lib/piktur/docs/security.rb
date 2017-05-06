# frozen_string_literal: true

require_relative '../../../app/policies/docs_policy'

# Setup `UseProxy` for permitted entities. The proxy object supports authentication without a
# database connection.
#
# To **authenticate** include **JSON Web Token (JWT)** via
# - url    `?token=<token>`
# - header `Authorization: Bearer <token>`
[:Admin].each { |const| ::Piktur::UserProxy.call(const) }
