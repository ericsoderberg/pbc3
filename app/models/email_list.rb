require 'active_model'

class EmailList
  include ActiveModel::Validations
  attr_accessor :name, :new_record
  @@domain = nil
  @@owner = nil
  
  validates :name, :format => /\A[^@\s]+\Z/
  
  def self.set_domain(domain, owner)
    @@domain = domain
    @@owner = owner
  end
  
  def initialize(attributes = nil)
    @new_record = true
    if attributes
      @name = attributes[:name]
    end
  end
  
  # ActiveRecord API
  
  def to_model
    self
  end
  
  def persisted?
    true
  end
  
  def to_key
    if persisted?
      @name
    end
  end
  
  def to_partial_path
    'email_lists/email_list'
  end
  
  def to_param
    if persisted?
      @name
    end
  end
  
  def addresses
    if Configuration.mailman
      %x(#{Configuration.mailman} members #{@name}#{@@domain}).split.sort
    elsif Configuration.mailman_dir
      %x(#{Configuration.mailman_dir}/list_members #{@name}).split.sort
    else
      Mailman.members @name
    end
  end
  
  def pending
    if Configuration.mailman
      []
    elsif Configuration.mailman_dir
      %x(#{Configuration.mailman_dir}/withlist -q -l -r dump_pending #{@name}).
        split("\n").sort.map do |l|
          p l
          a = l.strip.split(',', 2)
          { address: a[0], expires: Time.parse(a[1]) }
        end
    else
      Mailman.pending @name
    end
  end
  
  def self.all
    if Configuration.mailman
      self.run("#{Configuration.mailman} lists")
    elsif Configuration.mailman_dir
      self.run("#{Configuration.mailman_dir}/list_lists -b")
    else
      self.load(Mailman.lists)
    end
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
    if Configuration.mailman
      raise 'TBD'
    elsif Configuration.mailman_dir
      self.run("#{Configuration.mailman_dir}/find_member #{address}")
    else
      self.load(Mailman.lists_containing(address))
    end
  end
  
  def self.replace_address(old_address, new_address)
    system("#{Configuration.mailman_dir}/clone_member -a -r #{old_address} #{new_address}")
  end
  
  def add_addresses(new_addresses, invite)
    if new_addresses.empty?
      true
    else
      if Configuration.mailman
        IO.popen("#{Configuration.mailman} members --add - #{@name}#{@@domain}", 'w') do |io|
          io.write(new_addresses.join("\n"))
        end
        0 == $?
      elsif Configuration.mailman_dir
        cmd = invite ? 'invite_members' : 'add_members'
        IO.popen("#{Configuration.mailman_dir}/#{cmd} -a n -r - #{@name}", 'w') do |io|
          io.write(new_addresses.join("\n"))
        end
        0 == $?
      end
    end
  end
  
  def remove_addresses(old_addresses)
    if old_addresses.empty?
      true
    else
      IO.popen("#{Configuration.mailman_dir}/remove_members -n -N -f - #{@name}", 'w') do |io|
        io.write(old_addresses.join("\n"))
      end
      0 == $?
    end
  end
  
  def save
    if valid? and @new_record
      if Configuration.mailman
        if system("#{Configuration.mailman} create #{@name}#{@@domain} --domain --owner #{@@owner}")
          @new_record = false
          true
        end
      elsif Configuration.mailman_dir
        if system("#{Configuration.mailman_dir}/newlist -q #{@name} #{@@owner} #{UUIDTools::UUID.random_create.to_s}")
          @new_record = false
          true
        end
      end
    end
  end
  
  def destroy
    if Configuration.mailman
      system("#{Configuration.mailman} remove #{@name}#{@@domain}")
    elsif Configuration.mailman_dir
      system("#{Configuration.mailman_dir}/rmlist -a #{@name}")
    end
  end
  
  private
  
  def self.run(cmd)
    data = %x(#{cmd}).split("\n")
    self.load(data)
  end
  
  def self.load(data)
    result = []
    data.map do |name|
      next if name =~ /:$/ or 'mailman' == name.strip
      list = EmailList.new(:name => name.strip.split('@').first)
      list.new_record = false
      result << list
    end
    result.sort{|l1, l2| l1.name <=> l2.name}
  end
  
end
