# frozen_string_literal: true

module TicTacToe
  class Board
    attr_reader :cells

    def initialize
      @cells = [
        %w[_ _ _],
        %w[_ _ _],
        %w[_ _ _]
      ]
    end

    def display
      cells.each do |row|
        puts row.join(' | ')
        puts '--+--+--'
      end
    end

    def update_board(pos:, value:)
      row = (pos - 1) / 3
      col = (pos - 1) % 3
      cells[row][col] = value
    end
  end

  class Player
    attr_reader :name, :symbol

    def initialize(name:, symbol:)
      @name = name
      @symbol = symbol
    end
  end

  class Game
    def game_loop
      @player_one = get_player_info(player_number: 1)
      @player_two = get_player_info(player_number: 2)
    end

    def get_player_info(player_number:)
      puts "Enter Player #{player_number} name:"
      player_name = $stdin.gets.chomp
      puts "Enter Player #{player_number} symbol:"
      player_symbol = $stdin.gets.chomp
      Player(player_name: player_name, player_symbol: player_symbol)
    end
  end
end

# X | O | X
# --+---+--
# O | X | X
# --+---+--
# O | X | O

# 1 2 3
# 4 5 6
# 7 8 9

# [0][0] [0][1] [0][2]
# [1][0] [1][1] [1][2]
# [2][0] [2][1] [2][2]

# 3 -> row = floor(3/3)-1 = 0, col = 3%3 = 0
# 6 -> row = floor(6/3) = 2, col = 6%3 = 0
# 5 -> row = floor(5/3) = 1, col = 5%3 = 2
