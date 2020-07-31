class LinkedList
  def initialize
    @list = []
  end

  def append(value)
    new_node = Node.new(value)
    if @list
      @list[-1].next = new_node
      @list = @list << new_node
    else
      @list = new_node
    end
  end

  def prepend(value)
    new_node = Node.new(value)
    if @list
      new_node.next = list[0]
      @list = @list.unshift(new_node)
    end
  end

  def size
    @list.length
  end

  def head
    @list[0]
  end

  def tail
    @list[-1]
  end

  def at(index)
    @list[index]
  end

  def pop
    @list = @list.pop
    @list[-1].next = nil
  end

  def contains?(num)
    @list.any? {|node| node.value == num}
  end

  def find(num)
    @list.each_with_index do |node, index|
      return index if node.value == num
    end
  end
end

class Node
  def initialize(val=nil)
    @val = val
    @next = nil
  end

  def value
    @val
  end

  def next_node
    return @next
  end
end