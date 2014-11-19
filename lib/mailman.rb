# stub out mailman behavior for development on systems without it, like OSX Yosemite
class Mailman
  
  def self.lists
    return []
  end
  
  def self.members(list)
    return []
  end
  
  def self.pending(list)
    return []
  end
  
  def self.lists_containing(address)
    return []
  end
  
end
