require 'active_model'

class EmailList
  include ActiveModel::Validations
  attr_accessor :name, :new_record
  
  validates :name, :format => /^[^@\s]+$/
  
  def initialize(attributes = nil)
    @new_record = true
    if attributes
      @name = attributes[:name]
    end
  end
  
  def to_param
    @name
  end
  
  def addresses
    %x(list_members #{@name}).split
  end
  
  def self.all
    self.load("list_lists -b")
  end
  
  def self.find(name)
    if name and not name.empty?
      all.each{|list| return list if name == list.name}
    end
    nil
  end
  
  def self.find_by_search(search_text)
    result = []
    all.each do |list|
      result << list if search_text.empty? or list.name =~ /#{search_text}/
    end
    result.sort{|l1, l2| l1.name <=> l2.name}
  end
  
  def self.find_by_address(address)
    self.load("find_member #{address}")
  end
  
  def self.replace_address(old_address, new_address)
    system("clone_member -a -r #{old_address} #{new_address}")
  end
  
  def add_addresses(new_addresses)
    if new_addresses.empty?
      true
    else
      IO.popen("add_members -w n -a n -r - #{@name}", 'w') do |io|
        io.write(new_addresses.join("\n"))
      end
      0 == $?
    end
  end
  
  def remove_addresses(old_addresses)
    if old_addresses.empty?
      true
    else
      IO.popen("remove_members -n -N -f - #{@name}", 'w') do |io|
        io.write(old_addresses.join("\n"))
      end
      0 == $?
    end
  end
  
  def save(user)
    if valid? and @new_record
      if system("newlist -q #{@name} #{user.email} #{user.name}")
        @new_record = false
        true
      end
    end
  end
  
  def destroy
    system("rmlist -a #{@name}")
  end
  
  private
  
  def self.load(cmd)
    result = []
    %x(#{cmd}).split("\n").map do |name|
      next if name =~ /:$/ or 'mailman' == name.strip
      list = EmailList.new(:name => name.strip)
      list.new_record = false
      result << list
    end
    result.sort{|l1, l2| l1.name <=> l2.name}
  end
  
end
