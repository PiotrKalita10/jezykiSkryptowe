require 'ruby2d'

set title: "Mario Game", width: 1040, height: 480

Image.new(
  'map.png',
  x: 0,
  width: Window.width,
  height: Window.height
)


start_x = 50
start_y = 380
mario = Image.new(
  'mario.png',
  x: start_x,
  y: start_y,
  width: 30,
  height: 30
)

gravity = 0.5
jump_power = 10
mario_speed = 5
is_jumping = false
jump_velocity = 0
is_falling = false
fall_speed = 0
lives = 3
points = 0
game_over = false
enemy_direction = 1
enemy_speed = 1

obstacles = [
  Rectangle.new(x: 426, y: 327, width: 50, height: 80, color: [1, 0, 0, 0]),
  Rectangle.new(x: 651, y: 327, width: 50, height: 80, color: [1, 0, 0, 0]),
  Rectangle.new(x: 961, y: 327, width: 50, height: 80, color: [1, 0, 0, 0]),
  Rectangle.new(x: 222, y: 290, width: 83, height: 37, color: [1, 0, 0, 0]),
  Rectangle.new(x: 158, y: 325, width: 28, height: 37, color: [1, 0, 0, 0]),
  Rectangle.new(x: 735, y: 290, width: 83, height: 37, color: [1, 0, 0, 0]),
  Rectangle.new(x: 874, y: 290, width: 28, height: 37, color: [1, 0, 0, 0]),
]

holes = [
  Rectangle.new(x: 205, y: 408, width: 37, height: 80, color: [1, 0, 0, 0]),
  Rectangle.new(x: 490, y: 408, width: 37, height: 80, color: [1, 0, 0, 0]),
]

coins = [
  Square.new(x: 220, y: 267, size: 15, color: 'yellow'),
  Square.new(x: 250, y: 267, size: 15, color: 'yellow'),
  Square.new(x: 280, y: 267, size: 15, color: 'yellow')
]

enemies = [
  Image.new(
    'enemy.png',
    x: 300,
    y: 380,
    width: 30,
    height: 30
  ),
  Image.new(
    'enemy.png',
    x: 700,
    y: 380,
    width: 30,
    height: 30
  )]

def on_top_of?(mario, obstacle)
  mario.x < obstacle.x + obstacle.width &&
    mario.x + mario.width > obstacle.x &&
    mario.y + mario.height <= obstacle.y + 5 &&
    mario.y + mario.height >= obstacle.y
end

def in_hole?(mario, hole)
  mario.x < hole.x + hole.width &&
    mario.x + mario.width > hole.x &&
    mario.y + mario.height > hole.y
end

def collides_with_obstacle?(x, y, size, obstacle)
  x < obstacle.x + obstacle.width &&
    x + size > obstacle.x &&
    y < obstacle.y + obstacle.height &&
    y + size > obstacle.y
end

def hits_bottom_of_obstacle?(mario, obstacle)
  mario.x < obstacle.x + obstacle.width &&
    mario.x + mario.width > obstacle.x &&
    mario.y >= obstacle.y + obstacle.height - 2 &&
    mario.y <= obstacle.y + obstacle.height
end

def ground_obstacle?(obstacle)
  obstacle.y + obstacle.height >= 380
end

Rectangle.new(x: 0, y: 0, width: 100, height: 70, color: 'black')
lives_text = Text.new("Lives: #{lives}", x: 10, y: 10, size: 20, color: 'red')
points_text = Text.new("Points: #{points}", x: 10, y: 30, size: 20, color: 'red')

update do
  unless game_over
    unless is_falling
      mario.y += gravity unless mario.y >= 380

      if is_jumping
        mario.y -= jump_velocity
        jump_velocity -= gravity
        if mario.y >= 380
          mario.y = 380
          is_jumping = false
          jump_velocity = 0
        end
      end

      on_obstacle = false
      obstacles.each do |obstacle|
        if on_top_of?(mario, obstacle)
          mario.y = obstacle.y - mario.height
          is_jumping = false
          jump_velocity = 0
          on_obstacle = true
        end
      end

      if !on_obstacle && mario.y < 380
        is_jumping = true
      end

      obstacles.each do |obstacle|
        if hits_bottom_of_obstacle?(mario, obstacle)
          mario.y = obstacle.y + obstacle.height
          is_jumping = false
          jump_velocity = 0
        end
      end

      holes.each do |hole|
        if in_hole?(mario, hole)
          is_falling = true
          fall_speed = 5
        end
      end

      coins.each do |coin|
        if mario.contains?(coin.x, coin.y)
          coins.delete(coin)
          coin.remove
          points += 10
          points_text.text = "Points: #{points}"
        end
      end

      enemies.each do |enemy|
        enemy.x += enemy_speed * enemy_direction
        ground_obstacles = obstacles.select { |obstacle| ground_obstacle?(obstacle) }
        ground_obstacles.each do |obstacle|
          if collides_with_obstacle?(enemy.x, enemy.y, enemy.width, obstacle)
            enemy_direction *= -1

            break
          end
        end
        holes.each do |hole|
          if collides_with_obstacle?(enemy.x, enemy.y, enemy.width, hole)
            enemy_direction *= -1
            break
          end
        end

        if enemy.x <= 0 || enemy.x + enemy.width >= Window.width
          enemy_direction *= -1
        end
      end

      enemies.each do |enemy|
        if mario.contains?(enemy.x, enemy.y) || mario.contains?(enemy.x + enemy.width, enemy.y)
          if is_jumping
            enemies.delete(enemy)
            enemy.remove
          else
            lives -= 1
            lives_text.text = "Lives: #{lives}"
            mario.x = start_x
            mario.y = start_y
            if lives == 0
              Text.new("GAME OVER", x: 130, y: 130, size: 120, color: 'red')
              game_over = true
            end
          end
        end
      end
    else
      mario.y += fall_speed
      fall_speed += gravity

      if mario.y > Window.height
        lives -= 1
        lives_text.text = "Lives: #{lives}"
        mario.x = start_x
        mario.y = start_y
        is_falling = false
        fall_speed = 0
        if lives == 0
          Text.new("GAME OVER", x: 130, y: 130, size: 120, color: 'red')
          game_over = true
        end
      end
    end
  end
end

on :key_held do |event|
  unless game_over
    case event.key
    when 'left'
      new_x = mario.x - mario_speed
      unless new_x <= 0 || obstacles.any? { |obstacle| collides_with_obstacle?(new_x, mario.y, mario.width, obstacle) }
        mario.x = new_x
      end
    when 'right'
      new_x = mario.x + mario_speed
      unless new_x >= Window.width - mario.width || obstacles.any? { |obstacle| collides_with_obstacle?(new_x, mario.y, mario.width, obstacle) }
        mario.x = new_x
      end
    end
  end
end

on :key_down do |event|
  unless game_over
    if event.key == 'space' && (!is_jumping || obstacles.any? { |obstacle| on_top_of?(mario, obstacle) } || mario.y >= 380)
      is_jumping = true
      jump_velocity = jump_power
    end
  end
end

show
