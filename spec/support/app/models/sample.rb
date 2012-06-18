class Sample
  # This is a stub model for testing.

  cattr_accessor :objects
  self.objects = {}

  def self.create(params={})
    obj = Sample.new
    obj.save
    obj
  end

  def save()
    @pid ||= "sample:#{(rand * 1000).to_i}"
    self.class.objects[@pid] = self
  end

  def update_attributes(attributes)
    metaclass = class << self; self; end
    attributes.each do |k, v|
      metaclass.send(:define_method, k) do
        v
      end
    end
  end

  def self.find(pid)
    objects[pid]
  end

  def pid
    @pid
  end
end
