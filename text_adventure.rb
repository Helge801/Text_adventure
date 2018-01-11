require 'colorize'


# 0 = wall
# 1 = space
# 2 = armor
# 3 = weapon
# 4 = player
# 5 = beast
# 6 = super_weapon
# 7 = trap
row_1 = [0,0,0,0,0,0,0,0,0,0,0,0]
row_2 = [0,6,1,1,1,0,1,1,1,1,5,0]
row_3 = [0,1,1,1,1,0,1,1,1,1,1,0]
row_4 = [0,1,1,1,1,0,1,1,1,1,1,0]
row_5 = [0,1,1,1,1,1,1,1,0,1,1,0]
row_6 = [0,0,0,1,1,1,1,1,1,1,1,0]
row_7 = [0,0,0,1,1,1,1,1,1,1,1,0]
row_8 = [0,1,1,1,7,7,7,1,1,1,1,0]
row_9 = [0,1,1,1,1,2,1,1,1,1,1,0]
row_10 = [0,1,1,1,2,1,1,1,1,1,1,0]
row_11 = [0,1,1,1,1,1,1,0,0,0,0,0]
row_13 = [0,1,1,1,1,1,1,1,1,1,1,0]
row_14 = [0,1,3,1,1,1,1,1,1,3,1,0]
row_15 = [0,1,1,1,1,4,1,1,1,1,1,0]
row_12 = [0,0,0,0,0,0,0,0,0,0,0,0]

$board = [
row_1,
row_2,
row_3, 
row_4, 
row_5, 
row_6, 
row_7, 
row_8, 
row_9, 
row_10,
row_11,
row_13,
row_14,
row_15,
row_12
]

# map = {}
# [*1..1].each do |l|
#   [*1..15].each do |i|

#   end
# end
# ==================== Methods ==================== #

def get_position entity
  thing = case entity
  when :player then 4
  when :beast then 5
  else
    return "not a valid entity!"
  end
  row = 0
  colum = 0
  $board.count.times do |i|
    row = i if $board[i].include? thing
  end
  colum = $board[row].index thing
  [row, colum]
end

def get_moves_away entity1, entity2
  get_rows_away(entity1, entity2) + get_cols_away(entity1, entity2)
end

def get_rows_away entity1, entity2
  rows = [entity1.position[0], entity2.position[0]].sort
  rows[1] - rows[0]
end

def get_cols_away entity1, entity2
  cols = [entity1.position[1], entity2.position[1]].sort
  cols[1] - cols[0]
end

def can_see entity
  items = []
  $board.count.times do |r|
    $board[r].count.times do |c|
      if ($board[r][c] != 1) && ($board[r][c] != 0) && ($board[r][c] != 4)
        if (d = distance_to([r,c], entity)) < 5
          items.push({row: r,column: c, object: $board[r][c], distance: d, direction: direction_to([r,c],entity)})
        end
      end
    end
  end
  items
end

def direction_to position, entity
  e_position = entity.position
  south = [position[0] - e_position[0], 0].max
  north = [e_position[0] - position[0], 0].max
  west = [e_position[1] - position[1], 0].max
  east = [position[1] - e_position[1], 0].max
  direction_arr = [{"north" => north},{"south" => south},{"east" => east},{"west" => west}].sort_by {|a| a.values[0]}
    if (direction_arr[3].values[0] - direction_arr[2].values[0]) < 2
      "#{direction_arr[3].keys[0]}-#{direction_arr[2].keys[0]}"
    else
      direction_arr[3].keys[0]
    end
end

def distance_to position, entity
  e_position = entity.position
  rows = [position[0], e_position[0]].sort
  cols = [position[1], e_position[1]].sort
  (rows[1] - rows[0]) + (cols[1] - cols[0])
end

def narative string
  string.colorize(:blue)
end

def object string
  string.colorize(:yellow)
end

def danger string
  string.colorize(:red)
end

def direction string
  string.colorize(:white)
end

def what_is_it item
  case item
  when 0 then "wall"
  when 1 then "open space"
  when 2 then "armor"
  when 3 then "weapon"
  when 4 then "player"
  when 5 then "beast"
  when 6 then "super_weapon"
  when 7 then "trap"
  end
end



def explain_what_i_see entity
  can_see(entity).each do |item|
    case item[:distance]
    when 4
      puts narative("you can barely makeout ") + object("something ") + narative("off to the ") + direction(item[:direction]) + narative(" but you can't tell what it is.")
    when 3
       puts narative("You can just make out the object to the ") + direction(item[:direction]) + narative(" It appears to be") + object(what_is_it(item[:object]))
    when 2
      puts "your close to something"
    when 1
      puts "it's right next to you"
    else
      puts "You can just make out the object to the #{object[:direction]}. It appears to be a "
    end
  end
end

def what_can_i_do entity

end

def change_board position, item
  $board[position[0]][position[1]] = item
end

def print_board
  $board.each do |r|
    row_string = ""
    r.each do |s|
      case s
      when 0 then row_string += " #{s} ".colorize(:color => :black, :background => :black)
      when 1 then row_string += "   "
      when 2 then row_string += " #{s} ".colorize(:color => :yellow, :background => :yellow)
      when 3 then row_string += " #{s} ".colorize(:color => :blue, :background => :blue)
      when 4 then row_string += " #{s} ".colorize(:color => :red, :background => :red)
      when 5 then row_string += " #{s} ".colorize(:color => :light_blue, :background => :light_blue)
      when 6 then row_string += " #{s} ".colorize(:color => :green, :background => :green)
      else
        row_string += " #{s} ".colorize(:color => :white, :background => :white)
      end
    end
  puts row_string
  end
end

# 0 = wall
# 1 = space
# 2 = armor
# 3 = weapon
# 4 = player
# 5 = beast
# 6 = super_weapon
# 7 = trap

# ==================== Methods ==================== #

# ==================== Classes ==================== #

class Player
  attr_accessor :position
  attr_accessor :armor
  attr_accessor :weapons
  attr_accessor :super_weapon
  attr_accessor :direction

  def initialize
    @position = get_position(:player)
    @armor = 0
    @weapons = 0
    @super_weapon = 0
    @direction = "north"
  end

  def move
    case gets.chomp.downcase
    when "w", "up", "north", "go up", "go north", "move up", "move north" then move_north
    end
  end

  private

  def move_north
    handle_item $board[(self.position[0] - 1)][self.position[1]]
    change_board self.position, 1
    change_board [(self.position[0] - 1),self.position[1]], 4
    @position = [(self.position[0] - 1),self.position[1]]
  end

  def move_south

  end

  def move_west

  end

  def move_east

  end

  def handle_item item
    p "item is #{item}"
  end
end

class Beast
  attr_accessor :position

  def initialize
    @position = get_position(:beast)
  end

  def move_towards_player

  end
end

# ==================== Classes ==================== #

# ==================== initialize ==================== #

$player = Player.new
$beast = Beast.new

# ==================== initialize ==================== #

# ==================== Tests ==================== #

$player = Player.new
$beast = Beast.new
puts "player is on row #{$player.position[0]} and column #{$player.position[1]}".colorize(:blue)
puts "beast is on row #{$beast.position[0]} and column #{$beast.position[1]}".colorize(:red)
puts "beast is #{get_moves_away($player, $beast)} moves away from player".colorize(:green)

# ==================== Tests ==================== #

# ==================== Intro ==================== #

puts narative("You wake to find yourself in complete darknes. The smell of stagnent water and dirt fills the air. \n After a moment your eyes adjust and you realize you can see, but only a few feet. \n Suddenly you hear a ") + danger("snarl") + narative(" in the not so far distance...\n You are not alone!")

# ==================== Intro ==================== #

# ==================== game ==================== #
# print_board
# p $player.position
# what_can_i_do $player
# explain_what_i_see $player
# $player.move_north
# p $player.position
# print_board
# p $board
# what_can_i_do $player

loop do
  print_board
  explain_what_i_see $player
  what_can_i_do $player
  $player.move
end

# ==================== game ==================== #




























