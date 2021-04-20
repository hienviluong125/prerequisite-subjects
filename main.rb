# idea: We just describe this problem as a directed graph
#
# - Case that will be FALSE if graph contain a CYCLE ( some nodes can go back to itself through other nodes )
# - Other cases will be TRUE
#
# example with prerequisites: [[1,0], [0, 3], [4, 3], [5, 4], [3, 5]]
# we will have graph below:
# 1 -> 0
# 0 -> 3
# 3 -> 4
# 4 -> 5
# 5 -> 3
#
# there is a cycle 3 -> 4 -> 5 -> 4
# => we cannot finish course with this prerequisites
#
#             3 <------
#           / \      /
#         0    4   /
#       /      \ /
#      1        5
#
# Time complexity: O(n + m), n: total courses, m: total course that link to n(i) course
# Space complexity: O(n^2): adjacency matrix to store status ( link or not link ) of each node to other nodes

require 'set'

class Set
  def pop
    temp = self.to_a.first
    self.delete(temp)
    temp
  end
end

def can_not_take_all_courses?(numCourses, prerequisites)
  all_nodes = prerequisites.flatten.uniq
  adj_matrix = Array.new(all_nodes.max+1) { Array.new(all_nodes.max+1) { false } }

  prerequisites.each do |pair|
    adj_matrix[pair[1]][pair[0]] = true
  end

  waiting = Set.new(all_nodes)
  visiting = Set.new
  visited = Set.new

  until waiting.empty?
    current_node = waiting.pop
    return true if traverse(current_node, waiting, visiting, visited, adj_matrix)
  end

  false
end

def traverse(node, waiting, visiting, visited, adj_matrix)
  move_node(node, waiting, visiting)
  adj_matrix.each_with_index do |_, z|
    next unless adj_matrix[node][z]

    # if this node be pointed from current node
    next if visited.include?(z)

    return true if visiting.include?(z)

    return true if traverse(z, waiting, visiting, visited, adj_matrix)
  end

  move_node(node, visiting, visited)
  false
end

def move_node(node, from_set, to_set)
  from_set.delete(node)
  to_set.add(node)
end

numCourses = 2, prerequisites = [[1,0], [0, 3], [4, 3], [5, 4], [3, 5]]
result = can_not_take_all_courses?(numCourses, prerequisites)

puts "Prerequisites: #{prerequisites}"
puts "Can take all courses? #{!result ? 'Yes' : 'No'}"
