require_relative './gamepiece'
require_relative './board'

class Pawn < GamePiece
  attr_accessor :t_e_p

  def initialize(pos = nil, color = nil)
    super(pos, color)
    @t_e_p = false # can pawn take en passant?
  end

  def valid_move?(new_pos, board)
    x1 = @pos[0]
    y1 = @pos[1]
    x2 = new_pos[0]
    y2 = new_pos[1]

    return false if board.off_board?(new_pos)
    return false if friendly_piece?(new_pos, board)
    #backward moves
    return false if y2 < y1 && @color == 'white' 
    return false if y2 > y1 && @color == 'black'
    # y2 can not change by more than 2
    return false if (y2 - y1).abs() > 2 
    # x2 can not change by more than 2
    return false if (x2 - x1).abs() > 1

    # can not move 2 if pawn has moved already
    # can not move 2 if piece is the way 
    if(y2 - y1).abs() == 2
      return false if !on_start_pos? || piece_in_path?(@pos, new_pos, board)
    end
    
    #can not move horizontally if not diagonal
    #can not move diagonally by one if there is no enemy piece and can not take en passant
    if (x2 - x1).abs() == 1
      return false if !board.is_diagonal?(@pos, new_pos)
      return false if !enemy_piece?(new_pos, board) && !@t_e_p
    end

    true
  end

  def on_start_pos?
    return false if @color == 'white' && @pos[1] != 1
    return false if @color == 'black' && @pos[1] != 6
    true
  end
end
# think i can with abs of 1 bc i already checked for backwards?

b = Board.new
bp = Pawn.new([3,5],'black')
print bp.valid_move?([3,3], b)