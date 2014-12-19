def eight_queens(n=8, board = Array.new(8) { Array.new(8) })
  if n == 0
    return board
  else
    (0..7).each do |col|
      found = check_before n, col, board
      if found
        board[n-1][col] = true
        solution = eight_queens(n-1, board)
        return solution if solution
        board[n-1][col] = nil
      end
    end
    nil
  end
end

def check_before n, col, board
  found = true
  i = 1
  (n..7).each do |row|
    check = board[row][col]
    check ||= board[row][col - i] if col - i >= 0
    check ||= board[row][col + i] if col + i <= 7
    i += 1
    if check
      found = false
      break
    end
  end

  found
end

eight_queens.each { |row| p row.map { |i| i == true ? ' Q ' : ' . '}.join }
