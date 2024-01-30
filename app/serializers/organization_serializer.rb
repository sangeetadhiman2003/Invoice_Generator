class OrganizationSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name
end
