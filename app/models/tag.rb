class Tag < ApplicationRecord
  belongs_to :tenant

  has_many :service_inventory_tags
  has_many :service_inventories, :through => :service_inventory_tags

  has_many :service_offering_tags
  has_many :service_offerings, :through => :service_offering_tags

  acts_as_tenant(:tenant)

  def to_tag_string
    "/#{namespace}/#{name}".tap { |string| string << "=#{value}" if value.present? }
  end

  def self.create!(attributes)
    attributes = attributes.with_indifferent_access

    super(attributes.except(:tag).merge(parse(attributes[:tag])))
  end

  def self.parse(tag_string)
    return {} if tag_string.blank?

    raise ArgumentError, "must start with /" unless tag_string.start_with?("/")

    {}.tap do |tag_values|
      keyspace, tag_values[:value]       = tag_string.split("=")
      _nil, namespace, tag_values[:name] = keyspace.split("/", 3)
      tag_values[:namespace]             = namespace.presence
    end
  end
end
