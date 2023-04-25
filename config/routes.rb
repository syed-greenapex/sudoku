Rails.application.routes.draw do
  namespace :api do
    post "sudoku", to: "sudoku_puzzle#create"
  end
end
