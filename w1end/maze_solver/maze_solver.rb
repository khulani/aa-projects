class MazeSolver
  attr_reader :maze, :start, :finish

  def initialize filename
    @maze = File.readlines(filename).map { |el| el.chomp.split('') }
    @start, @finish = maze_info
  end

  def maze_info
    start = nil
    finish = nil

    (0...maze.size).each do |row|
      (0...maze[row].size).each do |col|
        if maze[row][col] == 'S'
          start = [row, col]
        elsif maze[row][col] == 'E'
          finish = [row, col]
        end
        return [start, finish] unless start.nil? || finish.nil?
      end
    end
    raise 'Bad map file'
  end

  def solve_maze
    path = find_path
    'No path found' if path.empty?
    path.each do |pos|
      next if pos == start || pos == finish
      maze[pos[0]][pos[1]] = 'X'
    end
    maze.each { |row| p row.join(' ') }
  end

  def find_path
    root = MazeTreeNode.new start
    valid = [' ', 'E']
    moves_seen = [start]
    valid_moves = [root]
    until valid_moves.empty?
      here = valid_moves.shift
      # print here.value , ':'
      [-1, 0, 1].repeated_permutation(2).to_a.each do |direction|
        next if direction == [0, 0]
        go = [here.value[0] + direction[0], here.value[1] + direction[1]]
        # print go
        if valid.include?(maze[go[0]][go[1]]) && !moves_seen.include?(go)

          moves_seen << go
          new_node = MazeTreeNode.new(go)
          new_node.set_parent here
          valid_moves << new_node
          if go == finish
            # p 'finish'
            return new_node.path
          end
        end
      end
      # puts
    end
    []
  end
end

class MazeTreeNode
  attr_accessor :value, :length, :children, :parent

  def initialize value
    @value = value
    @children = []
    @parent = nil
  end

  def set_parent node
    self.parent = node
    node.children << self
  end

  def path
    if parent.nil?
      [value]
    else
      parent.path + [value]
    end
  end
end


MazeSolver.new('maze1.txt').solve_maze
