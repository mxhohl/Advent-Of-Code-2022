
enum Move : UInt32
  Rock = 1
  Paper = 2
  Scissors = 3
end

enum Result
  Lose = 0
  Draw = 3
  Win = 6
end

def letter_to_move(letter : String) : Move
  case letter
  when "A"
    Move::Rock
  when "B"
    Move::Paper
  when "C"
    Move::Scissors
  when "X"
    Move::Rock
  when "Y"
    Move::Paper
  when "Z"
    Move::Scissors
  else
    raise "Unknown move: '#{letter}'."
  end
end

def letter_to_result(letter : String) : Result
  case letter
  when "X"
    Result::Lose
  when "Y"
    Result::Draw
  when "Z"
    Result::Win
  else
    raise "Unknown result: '#{letter}'."
  end
end

def get_wining_move_against(move : Move) Move
  case move
  when Move::Rock
    Move::Paper
  when Move::Paper
    Move::Scissors
  when Move::Scissors
    Move::Rock
  else
    raise "Unknown move: #{move}"
  end
end

def get_losing_move_against(move : Move) Move
  case move
  when Move::Rock
    Move::Scissors
  when Move::Paper
    Move::Rock
  when Move::Scissors
    Move::Paper
  else
    raise "Unknown move: #{move}"
  end
end

def get_first_score_for_game(game : Tuple(Move, Move, Result)) UInt32
  score = game[1].value
  if game[0] == Move::Rock && game[1] == Move::Scissors
  elsif (game[0] == Move::Scissors && game[1] == Move::Rock) || game[0] < game[1]
    score += 6
  elsif game[0] == game[1]
    score += 3
  end
  score
end

def get_second_score_for_game(game : Tuple(Move, Move, Result)) UInt32
  case game[2]
  when Result::Lose
    game[2].value + get_losing_move_against(game[0]).value
  when Result::Draw
    game[2].value + game[0].value
  when Result::Win
    game[2].value + get_wining_move_against(game[0]).value
  else
    raise "Unknown result: #{game[2]}"
  end
end

def read_values(sub_path : String) Array(Tuple(Move, Move, Result))
  values = [] of Tuple(Move, Move, Result)
  File.each_line(sub_path) do |line|
    elems = line.split(' ')
    values << {letter_to_move(elems[0]), letter_to_move(elems[1]), letter_to_result(elems[1])}
  end
  values
end

values = read_values "input.txt"

first_scores = values.map { |game| get_first_score_for_game(game) }
first_total_score = first_scores.reduce { |acc, score| acc + score }
puts "Total score (1st): #{first_total_score}"

second_scores = values.map { |game| get_second_score_for_game(game) }
second_total_scores = second_scores.reduce { |acc, score| acc + score }
puts "Total score (2nd): #{second_total_scores}"
