class DirectedGraph
  
  def initialize
    @vertices = {}
  end
  
  def vertices
    @vertices
  end
  
  def self.add(vertices, from, to)
    vertices[from] ||= Set.new
    if to
      vertices[to] ||= Set.new
      vertices[from].add(to)
    end
  end
  
  def add(from, to = nil)
    DirectedGraph.add(@vertices, from, to)
    self
  end
  
  def cyclic?(from, to)
    vertices = {}
    @vertices.each{|node, set| vertices[node] = set.clone}
    DirectedGraph.add(vertices, from, to)
    DirectedGraph.cycles(vertices, from)
  end
  
  def self.cycles(vertices, start, node = start, reachable = Set.new)
    adjacent = vertices[node]
    return true if reachable.include?(start)
    reachable.merge(adjacent)
    return adjacent.any? {|node| cycles(vertices, start, node, reachable)}
  end
  
  def cycles?(start)
    DirectedGraph.cycles(@vertices, start)
  end
  
end