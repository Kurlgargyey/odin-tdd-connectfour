class Game

  def initialize(cols = 7, rows = 6)
    valid_cols = cols.to_i > 0 ? cols.to_i : 7
    valid_rows = rows.to_i > 0 ? rows.to_i : 6
    @board = Array.new(valid_cols) { Array.new(valid_rows) }
    @scores = Hash.new(0)
    @active_player = 1
  end

  def run_game

  end

  def game_over?

  end
end