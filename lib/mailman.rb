# stub out mailman behavior for development on systems without it, like OSX Yosemite
class Mailman
  
  def self.lists
    return ['list1', 'list2', 'list3']
  end
  
  def self.members(list)
    return ['me@my.com', 'you@your.com', 'him@his.com', 'her@her.com']
  end
  
  def self.pending(list)
    return [{address: 'who@who.com', expires: Time.now}]
  end
  
  def self.lists_containing(address)
    return ['list1', 'list2']
  end
  
end
