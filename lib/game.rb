class Game
  attr_accessor :board

  def initialize(cols = 7, rows = 6)
    @cols = cols.to_i.positive? ? cols.to_i : 7
    @rows = rows.to_i.positive? ? rows.to_i : 6
    @board = Array.new(@cols) { [] }
    @scores = Hash.new(0)
    @players = %w[X O]
    @active_player = @players[0]
  end

  def run_game
    turn = 0
    turn += 1 until process_turn
    print_board
    puts "The game ended in Turn #{turn}! #{@active_player} won."
  end

  def process_turn
    print_board
    puts "It's #{@active_player}'s turn."
    move = input_move
    last_move = make_move(move)
    return true if game_over?(last_move)

    @active_player = @players.rotate![0]
    false
  end

  def input_move
    move = -1
    puts 'Which column would you like to drop your marker into?'
    move = gets.chomp.to_i until move_valid?(move)
    move
  end

  def make_move(col)
    unless col_full?(col)
      add_marker(col)
      return move_coords(col)
    end

    new_move = input_move
    make_move(new_move)
  end

  def game_over?(last_move)
    return true if board_full?
    return true if connect_four?(last_move)

    false
  end

  def board_full?
    board.all? { |col| col.length == @rows }
  end

  def connect_four?(move)
    return true if vertical_hit?(move)
    return true if horizontal_hit?(move)
    return true if diagonal_hit?(move)

    false
  end

  def vertical_hit?(move)
    hits = 1
    hits += scan_up(move)
    hits += scan_down(move)
    return true if hits >= 4

    false
  end

  def horizontal_hit?(move)
    hits = 1
    hits += scan_left(move)
    hits += scan_right(move)
    return true if hits >= 4

    false
  end

  def diagonal_hit?(move)
    hits = 1
    hits += scan_left_up(move)
    hits += scan_right_down(move)
    return true if hits >= 4

    hits = 1
    hits += scan_right_up(move)
    hits += scan_left_down(move)
    return true if hits >= 4

    false
  end

  def scan_up(move)
    hits = 0
    marker = board[move[0]][move[1]]
    col = move[0]
    row = move[1] + 1
    until row >= board[col].length || board[col][row] != marker
      hits += 1
      row += 1
    end
    hits
  end

  def scan_down(move)
    hits = 0
    marker = board[move[0]][move[1]]
    col = move[0]
    row = move[1] - 1
    until row.negative? || board[col][row] != marker
      hits += 1
      row -= 1
    end
    hits
  end

  def scan_left(move)
    hits = 0
    marker = board[move[0]][move[1]]
    col = move[0] - 1
    row = move[1]
    until col.negative? || board[col][row] != marker
      hits += 1
      col -= 1
    end
    hits
  end

  def scan_right(move)
    hits = 0
    marker = board[move[0]][move[1]]
    col = move[0] + 1
    row = move[1]
    until col >= @cols || board[col][row] != marker
      hits += 1
      col += 1
    end
    hits
  end

  def scan_left_up(move)
    hits = 0
    marker = board[move[0]][move[1]]
    col = move[0] - 1
    row = move[1] + 1
    until col.negative? ||
          row >= board[col].length ||
          board[col][row] != marker
      hits += 1
      col -= 1
      row += 1
    end
    hits
  end

  def scan_right_down(move)
    hits = 0
    marker = board[move[0]][move[1]]
    col = move[0] + 1
    row = move[1] - 1
    until col >= @cols ||
          row.negative? ||
          board[col][row] != marker
      hits += 1
      col += 1
      row -= 1
    end
    hits
  end

  def scan_right_up(move)
    hits = 0
    marker = board[move[0]][move[1]]
    col = move[0] + 1
    row = move[1] + 1
    until col >= @cols ||
          row >= board[col].length ||
          board[col][row] != marker
      hits += 1
      col += 1
      row += 1
    end
    hits
  end

  def scan_left_down(move)
    hits = 0
    marker = board[move[0]][move[1]]
    col = move[0] - 1
    row = move[1] - 1
    until col.negative? ||
          row.negative? ||
          board[col][row] != marker
      hits += 1
      col -= 1
      row -= 1
    end
    hits
  end

  def col_full?(col)
    board[col - 1].length == @rows
  end

  def add_marker(col)
    board[col - 1].push(@active_player)
  end

  def move_valid?(move)
    move.between?(1, @cols)
  end

  def move_coords(col)
    [col - 1, board[col - 1].length - 1]
  end

  def print_board
    @rows.times do |row_idx|
      @cols.times { print '+---' }
      print "+\n"
      @cols.times do |col_idx|
        marker = board.dig(col_idx, @rows - row_idx - 1)
        print "| #{marker ? marker : ' '} "
      end
      print "|\n"
    end
    @cols.times { |i| print "+-#{i + 1}-" }
    print "+\n"
  end
end
