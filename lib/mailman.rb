# stub out mailman behavior for development on systems without it, like OSX
class Mailman
  @@lists = {
    'list1' => ['me@my.com', 'you@your.com', 'him@his.com', 'her@her.com'],
    'list2' => ['me@my.com', 'you@your.com', 'him@his.com', 'her@her.com'],
    'list3' => ['me@my.com', 'you@your.com', 'him@his.com', 'her@her.com']
  }

  def self.lists
    return @@lists.keys
  end

  def self.members(list)
    return @@lists[list]
  end

  def self.add(list, email_addresses)
    @@lists[list] += email_addresses
  end

  def self.remove(list, email_addresses)
    @@lists[list] -= email_addresses
  end

  # def self.pending(list)
  #   return [{address: 'who@who.com', expires: Time.now}]
  # end
  #
  # def self.lists_containing(address)
  #   return ['list1', 'list2']
  # end

end
