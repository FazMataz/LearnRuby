class Node
  attr_accessor :data
  attr_accessor :left
  attr_accessor :right
  def initialize(d)
    @data = d
    @left = nil
    @right = nil
    p "Initialised a node with value #{@data}"
  end

  def isleaf?
    if @left == nil && @right == nil
      true
    else
      false
    end
  end

  def singlechild?
    if @left && !@right
      return @left
    elsif @right && !@left
      return @right
    end
    return false
  end
end

class Tree
  attr_accessor :root
  def initialize(arr)
    @root = build_tree(arr)
    p "Built a tree with #{@root}"
  end
  
  def find(root, key)
    if key == root.data
      return root
    elsif key < root.data
      find(root.left, key)
    elsif key > root.data
      find(root.right, key)
    end
  end

  def insert(root, key)
    if key < root.data && root.left == nil
      root.left = Node.new(key)
    elsif key > root.data && root.right == nil
      root.right = Node.new(key)
    elsif key < root.data 
      insert(root.left, key)
    elsif key > root.data
      insert(root.right, key)
    end
  end

  def delete(value, node = @root)
    return nil if node.nil?

    if value < node.data
      node.left = delete(value, node.left)
    #  return node
    elsif value > node.data
      node.right = delete(value, node.right)
    #  return node
    elsif node.left.nil? && node.right.nil? # CASE 1: No children
      node = nil
    elsif node.left.nil? # CASE 2: One child
      node = node.right
    elsif node.right.nil?
      node = node.left
    else # CASE 3: Two children
      delete_two_children_node(node)
    end
    node
  end

  def delete_two_children_node(node)
    successor = node.right
    if successor.left.nil? # edge case check
      node.data = successor.data
      node.right = successor.right
    end
    until successor.left.nil?
      successor_parent = successor
      successor = successor.left
      node.data = successor.data
      successor_parent.left = successor.right
    end
  end
end

def build_tree(arr)

  working_array = arr.sort.uniq
  midpoint = working_array.length/2

  p "Building a tree with #{working_array}, midpoint: #{midpoint}"
  
  root = Node.new(working_array[midpoint])
  unless working_array.length <= 1
    root.left = build_tree(working_array[0..midpoint - 1])
    root.right = build_tree(working_array[midpoint + 1..])
    p "#{root.left} L : R #{root.right}"
  end
  return root
end

def min(root)
  if root.left == nil
    return root
  else min(root.left)
  end
end

def pretty_print(node = root, prefix="", is_left = true)
  pretty_print(node.right, "#{prefix}#{is_left ? "│ " : " "}", false) if node.right
  puts "#{prefix}#{is_left ? "└── " : "┌── "}#{node.data.to_s}"
  pretty_print(node.left, "#{prefix}#{is_left ? " " : "│ "}", true) if node.left
end

tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])

p "Hi"