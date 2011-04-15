require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  
  test "normal create" do
    note = Note.new(:text => 'hi')
    note.page = pages(:public)
    assert note.save
  end
  
  test "no page or text" do
    note = Note.new
    assert !note.save
  end
  
end
