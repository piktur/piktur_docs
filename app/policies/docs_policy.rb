# frozen_string_literal: true

# Polices access to Sidekiq::Web framework
# @example
#   entity = Admin.new
#   Pundit.authorize(entity, :docs, :authorized?)
#
class DocsPolicy < Piktur::Security::BasePolicy

  # @return [Boolean]
  def authorized?
    admin?
  end

end
