class PiecesController < ApplicationController
  before_action :current_piece, only: [:show, :update]

  def show
    # if no piece is selected before, update current piece's is_selected
    # else if the same piece has been selected before, deselect it

    pieces_selected = Piece.where(is_selected: true, game_id: params[:game_id])
    if pieces_selected.empty?
      current_piece.update_attributes(is_selected: true)
    elsif pieces_selected[0].id == piece.id
      current_piece.update_attributes(is_selected: false)
    end
    redirect_to game_path(current_piece.game)
  end

  def update
    if is_actual_move?(params[:row], params[:column])
      current_piece.move_to(params[:row], params[:column])
      redirect_to game_path(current_piece.game)
    else
      # This will need additional game logic to not switch turns if not a real move.
      redirect_to game_path(current_piece.game)
    end
  end

  private

    def current_piece
      @piece ||= Piece.find(params[:id])
    end

    def is_actual_move?(row_destination, col_destination)
      current_piece.row != row_destination || current_piece.column != col_destination
    end
end