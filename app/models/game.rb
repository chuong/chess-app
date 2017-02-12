class Game < ActiveRecord::Base
  has_many :moves
  has_many :pieces
  belongs_to :white_player, class_name: 'Player'
  belongs_to :black_player, class_name: 'Player'
  belongs_to :active_player, class_name: 'Player'

  def populate_game!
    8.times do |n|
      self.pieces.create(type: 'Pawn', row: 2, is_black: false, captured: false, column: n + 1)
      self.pieces.create(type: 'Pawn', row: 7, is_black: true, captured: false, column: n + 1)
    end

    [1,8].each do |n|
      self.pieces.create(type: 'Rook', row: 1, is_black: false, captured: false, column: n)
      self.pieces.create(type: 'Rook', row: 8, is_black: true, captured: false, column: n)
    end

    [2,7].each do |n|
      self.pieces.create(type: 'Knight', row: 1, is_black: false, captured: false, column: n)
      self.pieces.create(type: 'Knight', row: 8, is_black: true, captured: false, column: n)
    end

    [3,6].each do |n|
      self.pieces.create(type: 'Bishop', row: 1, is_black: false, captured: false, column: n)
      self.pieces.create(type: 'Bishop', row: 8, is_black: true, captured: false, column: n)
    end

    self.pieces.create(type: 'Queen', row: 1, is_black: false, captured: false, column: 4)
    self.pieces.create(type: 'Queen', row: 8, is_black: true, captured: false, column: 4)
    self.pieces.create(type: 'King', row: 1, is_black: false, captured: false, column: 5)
    self.pieces.create(type: 'King', row: 8, is_black: true, captured: false, column: 5)
  end

  # reset game to the initial positions and state
  def reset_game!
    white_pawns = self.pieces.where(type: 'Pawn', is_black: false)
    black_pawns = self.pieces.where(type: 'Pawn', is_black: true)
    white_rooks = self.pieces.where(type: 'Rook', is_black: false)
    black_rooks = self.pieces.where(type: 'Rook', is_black: true)
    white_knights = self.pieces.where(type: 'Knight', is_black: false)
    black_knights = self.pieces.where(type: 'Knight', is_black: true)
    white_bishops = self.pieces.where(type: 'Bishop', is_black: false)
    black_bishops = self.pieces.where(type: 'Bishop', is_black: true)
    white_queen = self.pieces.where(type: 'Queen', is_black: false).first
    black_queen = self.pieces.where(type: 'Queen', is_black: true).first
    white_king = self.pieces.where(type: 'King', is_black: false).first
    black_king = self.pieces.where(type: 'King', is_black: true).first

    8.times do |i|
      white_pawns[i].update_attributes(row: 2, column: i+1, captured: false)
      black_pawns[i].update_attributes(row: 7, column: i+1, captured: false)
    end
    [1,8].each.with_index do |n, i|
      white_rooks[i].update_attributes(row: 1, column: n,captured: false)
      black_rooks[i].update_attributes(row: 8, column: n, captured: false)
    end
    [2,7].each.with_index do |n, i|
      white_knights[i].update_attributes(row: 1, column: n,captured: false)
      black_knights[i].update_attributes(row: 8, column: n, captured: false)
    end
    [3,6].each.with_index do |n, i|
      white_bishops[i].update_attributes(row: 1, column: n,captured: false)
      black_bishops[i].update_attributes(row: 8, column: n, captured: false)
    end
    white_queen.update_attributes(row: 1, column: 4, captured: false)
    black_queen.update_attributes(row: 8, column: 4, captured: false)
    white_king.update_attributes(row: 1, column: 5, captured: false)
    black_king.update_attributes(row: 8, column: 5, captured: false)

    # clear all previous moves
    self.moves.delete_all
  end

  def undo_last_move!
    last_move = self.moves.last
    piece = Piece.find(last_move.piece_id)
    piece.update_attributes(column: last_move.start_column, row: last_move.start_row)
    # TODO: check if captured a piece needs to be reinstated
    if last_move.captured_piece_id.nil?
      move = {:type => 'normal',
              :piece => {:id => piece.id, :end_row => last_move.start_row, :end_column => last_move.start_column}}
    else
      captured_piece = Piece.find_by_id(last_move.captured_piece_id)
      captured_piece.update_attributes(captured: false)
      move = {:type => 'refresh'}
    end

    last_move.destroy
    return move
  end

  # Determine if a player is currently in check.
  # Expects a boolean value to represent whos turn it currently is
  # true = black, white = false
  def player_in_check?(is_black)
    # Grabs active players king
    king = self.pieces.find_by(type: 'King', is_black: is_black)

    # Grab all opponent pieces
    opponent_pieces = self.pieces.active.where(is_black: !is_black)

    # Loop through each piece and check to see if they can make a
    # valid move to the active players king (aka check)
    opponent_pieces.each do |piece|
      if piece.valid_move?(king.row, king.column)
        return true
      end
    end

    # Return false if no opponent piece can move to active players
    # king
    return false
  end
end
