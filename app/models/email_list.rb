require 'active_model'

class EmailList
  include ActiveModel::Validations
  attr_accessor :name, :addresses
  cattr_accessor :lists
  @@lists = []
  
  validates :name, :format => /^[^@\s]+$/
  
  def initialize(attributes = nil)
    @new_record = true
    if attributes
      p attributes
      @name = attributes[:name]
      @addresses = attributes[:addresses] || []
    end
  end
  
  def to_param
    @name
  end
  
  def self.all
    self.load
    @@lists
  end
  
  def self.find(name)
    all.each{|list| return list if name == list.name}
    nil
  end
  
  def self.find_by_address(address)
    result = []
    all.each do |list|
      result << list if list.addresses.include?(address)
    end
    result
  end
  
  def update_attributes(attributes)
    if attributes.has_key?(:name)
      @old_name = @name
      @name = attributes[:name]
    end
    @addresses = attributes[:addresses] if attributes.has_key?(:addresses)
    save
  end
  
  def self.replace_address(old_address, new_address)
    all.each do |list|
      if list.addresses.include?(old_address)
        list.addresses = list.addresses.delete_if{|a| a == old_address}
      end
      if not list.addresses.include?(new_address)
        list.addresses << new_address
      end
      list.save
    end
  end
  
  def add_addresses(new_addresses)
    new_addresses.each do |address|
      next if address.empty?
      next if @addresses.include?(address)
      @addresses << address
    end
    save
  end
  
  def remove_addresses(old_addresses)
    @addresses = @addresses.delete_if do |address|
      old_addresses.include?(address)
    end
    save
  end
  
  def save
    if valid?
      File.unlink(EmailList.data_file(@old_name)) if @old_name
      EmailList.setup
      File.open(EmailList.data_file(@name), 'w'){|f| f.write(self.to_json)}
    end
  end
  
  def destroy
    File.unlink(EmailList.data_file(@name))
  end
  
  private
  
  TMP_DIR_PATH = '/tmp/email_lists'
  
  def self.data_file(name)
    File.join(TMP_DIR_PATH, "#{name}.json")
  end
  
  def self.setup
    Dir.mkdir(TMP_DIR_PATH) unless Dir.exists?(TMP_DIR_PATH)
  end
  
  def self.load
    @@lists = []
    Dir.glob(File.join(TMP_DIR_PATH, '*')).each do |path|
      File.open(path, 'r') do |file|
        data = ActiveSupport::JSON.decode(file.read)
        list = EmailList.new(:name => data['name'])
        list.addresses = data['addresses']
        @@lists << list
      end
    end
    @@lists
  end
  
end
