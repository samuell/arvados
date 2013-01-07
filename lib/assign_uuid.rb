module AssignUuid

  def self.included(base)
    base.extend(ClassMethods)
    base.validates_presence_of :uuid, :if => :respond_to_uuid?
    base.validates_uniqueness_of :uuid, :if => :respond_to_uuid?
    base.before_validation :assign_uuid
  end

  module ClassMethods
    def uuid_prefix
      Digest::MD5.hexdigest(self.to_s).to_i(16).to_s(36)[0..4]
    end
  end

  protected

  def respond_to_uuid?
    self.respond_to? :uuid
  end

  def assign_uuid
    return true if !self.respond_to_uuid?
    self.uuid ||= [Server::Application.config.uuid_prefix,
                   self.class.uuid_prefix,
                   rand(2**256).to_s(36)[0..14]].
      join '-'
  end
end