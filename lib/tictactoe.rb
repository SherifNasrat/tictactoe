# frozen_string_literal: true

require_relative 'custom_exceptions'

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
      cells.each_with_index do |row, index|
        puts row.join(' | ')
        puts '--+--+--' unless index == 2
      end
    end

    def update_board(pos:, value:)
      raise InputError.new('Invalid input, position must be an integer between 1 and 9.') unless pos >= 1 && pos <= 9

      row = (pos - 1) / 3
      col = (pos - 1) % 3
      unless cells[row][col] == '_'
        raise InvalidPosition.new('Invalid cell position, please enter a valid cell position!')
      end

      cells[row][col] = value
    end

    def get_cell(pos)
      row = (pos - 1) / 3
      col = (pos - 1) % 3
      cells[row][col]
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
    attr_accessor :winner, :game_state

    def initialize
      @winner = nil
      @game_state = 0 # 0 = Not started, 1 = a player won, 2 = tie
    end

    def run!
      @player_one = get_player_info('1')
      @player_two = get_player_info('2')
      @board = Board.new
      game_loop
    end

    def game_loop
      loop do
        players.each do |player|
          @board.display
          get_player_input(player)
          if game_over?
            display_result
            return
          end
        end
      end
    end

    def get_player_info(player_number)
      name = get_player_name(player_number)
      symbol = get_player_symbol(player_number)
      Player.new(name: name, symbol: symbol)
    end

    def get_player_name(player_number)
      player_name = ''
      loop do
        print "Enter Player #{player_number} name: "
        player_name = gets.chomp
        valid_name = !player_name.empty? && player_name.split.length == 1
        break if valid_name

        puts 'Invalid player name, player name must be 1 word and not empty.'
      end
      player_name
    end

    def get_player_symbol(player_number)
      player_symbol = ''
      loop do
        print "Enter Player #{player_number} symbol (X/O): "
        player_symbol = gets.chomp
        valid_symbol = %w[X O].include?(player_symbol)
        break if valid_symbol

        puts "Invalid player symbol, player symbol must be either 'X' or 'O'!"
      end
      player_symbol
    end

    def get_player_input(player)
      loop do
        print "It's #{player.name}'s turn! Enter position (1..9): "
        input = gets.to_i
        begin
          @board.update_board(pos: input, value: player.symbol)
          break
        rescue StandardError => e
          puts e.message
        end
      end
    end

    def game_over?
      players.each do |player|
        next unless player_won?(player.symbol)

        @winner = player
        @game_state = 1
        return true
      end
      if board_filled?
        @game_state = 2
        return true
      end
      false
    end

    def winner_found?
      players.any? { |player| player_won?(player.symbol) }
    end

    def player_won?(symbol)
      winning_idxs.any? do |row|
        row.all? { |pos| @board.get_cell(pos) == symbol }
      end
    end

    def board_filled?
      @board.cells.flatten.none? { |cell| cell == '_' }
    end

    def display_result
      @board.display
      if @game_state == 1
        puts "The winner is #{@winner.name}!"
      else
        puts "It's a tie!"
      end
    end

    def winning_idxs
      [
        [1, 2, 3], [4, 5, 6], [7, 8, 9], # Rows
        [1, 4, 7], [2, 5, 8], [3, 6, 9], # Columns
        [1, 5, 9], [3, 5, 7] # Diagonals
      ]
    end

    def players
      [@player_one, @player_two]
    end
  end
end

TicTacToe::Game.new.run!
