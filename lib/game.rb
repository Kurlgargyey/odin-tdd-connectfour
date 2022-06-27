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
    if board_full?
      puts "The game ended in Turn #{turn}! Nobody won."
    else
      puts "The game ended in Turn #{turn}! The #{@active_player}s won."
    end
  end

  def process_turn
    print_board
    puts "It's #{@active_player}'s turn."
    game_over?(make_move(input_col))
  end

  def input_col
    col = -1
    puts 'Which column would you like to drop your marker into?'
    col = gets.chomp.to_i until col_valid?(col)
    col
  end

  def make_move(col)
    unless col_full?(col)
      add_marker(col)
      return move_coords(col)
    end

    puts 'That column is already full. Pick a different one!'
    new_col = input_col
    make_move(new_col)
  end

  def game_over?(last_move)
    return true if board_full?
    return true if connect_four?(last_move)

    swap_players
    false
  end

  def swap_players
    @active_player = @players.rotate![0]
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
    hits += scan(move, 0, 1)
    hits += scan(move, 0, -1)
    return true if hits >= 4

    false
  end

  def horizontal_hit?(move)
    hits = 1
    hits += scan(move, 1, 0)
    hits += scan(move, -1, 0)
    return true if hits >= 4

    false
  end

  def diagonal_hit?(move)
    hits = 1
    hits += scan(move, -1, 1)
    hits += scan(move, 1, -1)
    return true if hits >= 4

    hits = 1
    hits += scan(move, 1, 1)
    hits += scan(move, -1, -1)
    return true if hits >= 4

    false
  end

  def scan(move, direction_col, direction_row)
    hits = 0
    marker = board[move[0]][move[1]]
    col_idx = move[0] + direction_col
    row_idx = move[1] + direction_row
    while scan_valid?(col_idx, row_idx) &&
          board[col_idx][row_idx] == marker
      hits += 1
      col_idx += direction_col
      row_idx += direction_row
    end
    hits
  end

  def col_full?(col)
    board[col - 1].length == @rows
  end

  def add_marker(col)
    board[col - 1].push(@active_player)
  end

  def col_valid?(col)
    col.between?(1, @cols)
  end

  def scan_valid?(col_idx, row_idx)
    col_idx.between?(0, @cols - 1) && row_idx.between?(0, board[col_idx].length)
  end

  def move_coords(col)
    [col - 1, board[col - 1].length - 1]
  end

  def print_board
    @rows.times do |row_idx|
      puts "+---" * @cols + '+'
      @cols.times do |col_idx|
        marker = board.dig(col_idx, @rows - row_idx - 1)
        print "| #{marker || ' '} "
      end
      print "|\n"
    end
    @cols.times { |i| print "+-#{i + 1}-" }
    print "+\n"
  end
end
