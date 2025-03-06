require_relative 'Node.rb'

# Driver script
random_array = Array.new(15) { rand(1..100) }
tree = Tree.new(random_array)

tree.pretty_print
puts "Balanced?: #{tree.balanced?}"

puts "Level-order: #{tree.level_order}"
puts "Preorder: #{tree.preorder}"
puts "Postorder: #{tree.postorder}"
puts "Inorder: #{tree.inorder}"

# Unbalancing the tree
tree.insert(150)
tree.insert(200)
tree.insert(250)

tree.pretty_print
puts "Balanced after adding large values?: #{tree.balanced?}"

# Rebalancing the tree
tree.rebalance

tree.pretty_print
puts "Balanced after rebalancing?: #{tree.balanced?}"

puts "Level-order: #{tree.level_order}"
puts "Preorder: #{tree.preorder}"
puts "Postorder: #{tree.postorder}"
puts "Inorder: #{tree.inorder}"
