class Game
  attr_accessor :board

  def initialize(cols = 7, rows = 6)
    @cols = cols.to_i > 0 ? cols.to_i : 7
    @rows = rows.to_i > 0 ? rows.to_i : 6
    @board = Array.new(@cols) { Array.new() }
    @scores = Hash.new(0)
    @players = ['X', 'O']
    @active_player = @players[0]
  end

  def run_game

  end

  def game_over?

  end

  def process_turn
    move = get_move
    make_move(move)
    @active_player = @players.rotate![0]
  end

  def get_move
    move = -1
    until move.between?(1, @cols)
      move = gets.chomp.to_i
    end
    move
  end

  def make_move(col)
    return board[col-1].push(@active_player) unless board[col-1].length == @rows
    new_move = get_move
    make_move(new_move)
  end
end