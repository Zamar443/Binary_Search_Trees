class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end

  def <=>(other)
    data <=> other.data
  end
end

class Tree
  attr_accessor :root

  def initialize(array)
    sorted_array = array.uniq.sort
    @root = build_tree(sorted_array)
  end

  def build_tree(array)
    return nil if array.empty?

    mid = array.length / 2
    root = Node.new(array[mid])

    root.left = build_tree(array[0...mid])
    root.right = build_tree(array[mid + 1..-1])

    root
  end

  def insert(value, node = @root)
    return Node.new(value) if node.nil?

    if value < node.data
      node.left = insert(value, node.left)
    elsif value > node.data
      node.right = insert(value, node.right)
    end

    node
  end

  def delete(value, node = @root)
    return node if node.nil?

    if value < node.data
      node.left = delete(value, node.left)
    elsif value > node.data
      node.right = delete(value, node.right)
    else
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      min_larger_node = find_min(node.right)
      node.data = min_larger_node.data
      node.right = delete(min_larger_node.data, node.right)
    end

    node
  end

  def find(value, node = @root)
    return nil if node.nil?
    return node if node.data == value

    value < node.data ? find(value, node.left) : find(value, node.right)
  end

  def level_order
    return [] if @root.nil?
    queue = [@root]
    result = []
    until queue.empty?
      node = queue.shift
      block_given? ? yield(node) : result << node.data
      queue << node.left if node.left
      queue << node.right if node.right
    end
    result unless block_given?
  end

  def inorder(node = @root, result = [], &block)
    return result if node.nil?
    inorder(node.left, result, &block)
    block_given? ? yield(node) : result << node.data
    inorder(node.right, result, &block)
    result unless block_given?
  end

  def preorder(node = @root, result = [], &block)
    return result if node.nil?
    block_given? ? yield(node) : result << node.data
    preorder(node.left, result, &block)
    preorder(node.right, result, &block)
    result unless block_given?
  end

  def postorder(node = @root, result = [], &block)
    return result if node.nil?
    postorder(node.left, result, &block)
    postorder(node.right, result, &block)
    block_given? ? yield(node) : result << node.data
    result unless block_given?
  end

  def height(node)
    return -1 if node.nil?
    1 + [height(node.left), height(node.right)].max
  end

  def depth(node, current_node = @root, depth = 0)
    return nil if current_node.nil?
    return depth if current_node == node

    left = depth(node, current_node.left, depth + 1)
    right = depth(node, current_node.right, depth + 1)
    left || right
  end

  def balanced?(node = @root)
    return true if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)
    (left_height - right_height).abs <= 1 && balanced?(node.left) && balanced?(node.right)
  end

  def rebalance
    values = inorder
    @root = build_tree(values)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    return unless node

    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false)
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true)
  end
end

# Example usage
tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
tree.pretty_print
tree.insert(10)
tree.pretty_print
tree.delete(7)
tree.pretty_print
tree.level_order { |node| print "#{node.data} " }
puts "\nTree balanced? #{tree.balanced?}"
tree.rebalance
tree.pretty_print
