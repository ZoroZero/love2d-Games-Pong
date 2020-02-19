push = require "push"

Class = require 'class'

-- our Paddle class, which stores position and dimensions for each Paddle
-- and the logic for rendering them
require 'Paddle'
-- our Ball class, which isn't much different than a Paddle structure-wise
-- but which will mechanically function very differently
require 'Ball'


WINDOW_WIDTH = 1280;
WINDOW_HEIGHT = 720;

VIRTUAL_WIDTH = 432;
VIRTUAL_HEIGH = 243;

PADDLE_SPEED = 200;

function love.load()
    -- love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    --     fullscreen = false;
    --     resizable = false;
    --     vsync = true;
    -- });

    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 32)

    
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGH, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false;
        resizable = false;
        vsync = true;
    });

    player1_score = 0;
    player2_score = 0;

    -- player1_Y = 30;
    -- player2_Y = VIRTUAL_HEIGH-50;
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 30, VIRTUAL_HEIGH-50, 5, 20)
    -- ball_X = VIRTUAL_WIDTH/2 -2;
    -- ball_Y = VIRTUAL_HEIGH/2 -2;

    -- ball_DX = math.random(2) == 1 and 100 or -100;
    -- ball_DY = math.random(-50, 50)* 1.5;
    ball = Ball(VIRTUAL_WIDTH/2 -2, VIRTUAL_HEIGH/2 -2, 4, 4)
    game_state = 'start';
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit();
    end

    if key == 'enter' or key == 'return' then
        if game_state == 'start' then
            game_state = 'play';
        else
            game_state = 'start';
            ball:reset();
        
        end
    end
end

function love.update(dt)
    if game_state == 'play' then
        if love.keyboard.isDown('w') then
            player1.speed = -PADDLE_SPEED
        elseif love.keyboard.isDown('s') then
            player1.speed = PADDLE_SPEED
        else 
            player1.speed = 0
        end

        if love.keyboard.isDown('up') then
            player2.speed = -PADDLE_SPEED
        elseif love.keyboard.isDown('down') then
            player2.speed = PADDLE_SPEED
        else
            player2.speed = 0
        end
        ball:update(dt);
    end

    player1:update(dt);
    player2:update(dt);
end

function love.draw()
    push:apply('start')

    -- love.graphics.clear(40, 45, 52, 255)
    love.graphics.setFont(smallFont)
    love.graphics.printf("Hello Pong", 0, 20, VIRTUAL_WIDTH, 'center');

    love.graphics.setFont(largeFont)
    love.graphics.print(tostring(player1_score), VIRTUAL_WIDTH/2 - 50, VIRTUAL_HEIGH/3)
    love.graphics.print(tostring(player2_score), VIRTUAL_WIDTH/2 + 30, VIRTUAL_HEIGH/3)


    -- love.graphics.rectangle('fill', 10, player1_Y, 5, 20)

    -- love.graphics.rectangle('fill', VIRTUAL_WIDTH - 30, player2_Y, 5, 20)
    player1:render()

    player2:render()

    ball:render();

    push:apply('end')
end