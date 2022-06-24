class Game
  attr_accessor :board

  def initialize(cols = 7, rows = 6)
    @cols = cols.to_i.positive? ? cols.to_i : 7
    @rows = rows.to_i.positive? ? rows.to_i : 6
    @board = Array.new(@cols) { Array.new() }
    @scores = Hash.new(0)
    @players = %w[X O]
    @active_player = @players[0]
  end

  def run_game

  end

  def process_turn
    move = input_move
    last_move = make_move(move)
    return if game_over?(move)

    @active_player = @players.rotate![0]
  end

  def input_move
    move = -1
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
    return if board[move[0]].nil?
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

  end

  def scan_up(move)
    hits = 0
    marker = board[move[0]][move[1]]
    col = move[0]
    idx = move[1] + 1
    until idx >= board[col].length || board[col][idx] != marker
      hits += 1
      idx += 1
    end
    hits
  end

  def scan_down(move)
    hits = 0
    marker = board[move[0]][move[1]]
    col = move[0]
    idx = move[1] - 1
    until idx.negative? || board[col][idx] != marker
      hits += 1
      idx -= 1
    end
    hits
  end

  def scan_left(move)
    hits = 0
    marker = board[move[0]][move[1]]
    row = move[1]
    idx = move[0] - 1
    until idx.negative? || board[idx][row] != marker
      hits += 1
      idx -= 1
    end
    hits
  end

  def scan_right(move)
    hits = 0
    marker = board[move[0]][move[1]]
    row = move[1]
    idx = move[0] + 1
    until idx >= @cols || board[idx][row] != marker
      hits += 1
      idx += 1
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
end
