class Api::SudokuPuzzleController < ApplicationController
    before_action :check_params, only: [:create]

    # POST /api/sudoku
    def create
        response_dict = { "solution": solution }.to_json
        render json: response_dict, status: :ok
    end

    private

    def check_params
        @grid = params[:data]
        if @grid.empty?
            render json: { errors: @grid.full_message.errors}, status: :unprocessable_entity
        end
    end

    def solution
        solve_cell(0, 0)
        @grid
    end

    def solve_cell(row, col)
        return true if row == 9
    
        next_row, next_col = next_cell(row, col)
    
        if @grid[row][col].nil?
          (1..9).each do |num|
            if valid_move?(row, col, num)
              @grid[row][col] = num
              return true if solve_cell(next_row, next_col)
            end
          end
    
          # Backtrack
          @grid[row][col] = nil
          return false
        else
          return solve_cell(next_row, next_col)
        end
    end

    def valid_move?(row, col, num)
        (0..8).none? { |i| @grid[row][i] == num } &&
          (0..8).none? { |i| @grid[i][col] == num } &&
          valid_box?(row, col, num)
    end
    
    def valid_box?(row, col, num)
        row_start = (row / 3) * 3
        col_start = (col / 3) * 3

        (row_start...row_start + 3).each do |r|
            (col_start...col_start + 3).each do |c|
            return false if @grid[r][c] == num
            end
        end

        true
    end

    def next_cell(row, col)
        if col == 8
            [row + 1, 0]
        else
            [row, col + 1]
        end
    end
end
