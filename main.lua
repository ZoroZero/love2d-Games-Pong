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

PADDLE_SPEED = 150;

function love.load()
    -- love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    --     fullscreen = false;
    --     resizable = false;
    --     vsync = true;
    -- });

    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle("Pong")

    math.randomseed(os.time())

    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 32)

    sounds = {
        ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static')
    }
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGH, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false;
        resizable = true;
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
    ball = Ball(VIRTUAL_WIDTH/2, VIRTUAL_HEIGH/2, 2)
    game_state = 'start';
    serve_player = math.random(2);
    winning_player = 0;
end

function love.resize(w, h)
    push:resize(w,h);
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit();
    end

    if key == 'enter' or key == 'return' then
        if game_state == 'start' then
            game_state = 'serving';
        elseif game_state == 'serving' then
            game_state = 'play';
        elseif game_state == 'game_over' then
            player1_score = 0;
            player2_score = 0;
            serve_player = math.random(2);
            game_state = 'serving'
        else
            game_state = 'start';
            ball:reset(); 
        end
    end
end

function love.update(dt)
    if game_state == 'serving' then 
        ball.dy = math.random(-50,50)
        if serve_player == 1 then
            ball.dx = math.random(50,150)
        else 
            ball.dx = -math.random(50,150)
        end
    end

    if game_state == 'play' then

        if ball:collides(player1) then
            ball.dx = -ball.dx*1.03
            ball.x = player1.x + 7

            if ball.dy < 0 then 
                ball.dy = - math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
            sounds['paddle-hit']:play();
        end
        
        if ball:collides(player2) then
            ball.dx = -ball.dx*1.03
            ball.x = player2.x - 3

            if ball.dy < 0 then 
                ball.dy = - math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
            sounds['paddle-hit']:play();
        end

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
        if ball.y + ball.dy*dt  <= ball.radius or ball.y + ball.dy*dt >= VIRTUAL_HEIGH - ball.radius then
            ball.dy = -ball.dy
            sounds['wall-hit']:play();
        end

        if ball.x < ball.radius then 
            player2_score = player2_score + 1
            if player2_score == 10 then
                game_state = 'game_over'
                winning_player = 2
            else
                game_state = 'serving'
                serve_player = 1
            end
            ball:reset()
            sounds['score']:play()
        elseif ball.x > VIRTUAL_WIDTH - ball.radius then
            player1_score = player1_score + 1
            if player1_score == 10 then
                game_state = 'game_over'
                winning_player = 1
            else
                game_state = 'serving'
                serve_player = 2
            end
            ball:reset()
            sounds['score']:play()
        end
    end

    player1:update(dt);
    player2:update(dt);
end

function love.draw()
    push:apply('start')

    -- love.graphics.clear(40, 45, 52, 255)
    if game_state == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf("Hello Pong", 0, 20, VIRTUAL_WIDTH, 'center');
    elseif game_state == 'serving' then
        love.graphics.printf("Player " .. tostring(serve_player) .. "'s serve!" , 0, 20, VIRTUAL_WIDTH, 'center');
        love.graphics.printf("Press Enter to serve", 0, 40, VIRTUAL_WIDTH, 'center');
    elseif game_state == 'game_over' then 
        love.graphics.printf("Player " .. tostring(winning_player) .. "' win!" , 0, 20, VIRTUAL_WIDTH, 'center');
        love.graphics.printf("Press Enter to start", 0, 40, VIRTUAL_WIDTH, 'center');
    end

    love.graphics.setFont(largeFont)
    love.graphics.print(tostring(player1_score), VIRTUAL_WIDTH/2 - 50, VIRTUAL_HEIGH/3);
    love.graphics.print(tostring(player2_score), VIRTUAL_WIDTH/2 + 30, VIRTUAL_HEIGH/3);


    -- love.graphics.rectangle('fill', 10, player1_Y, 5, 20)

    -- love.graphics.rectangle('fill', VIRTUAL_WIDTH - 30, player2_Y, 5, 20)
    player1:render();

    player2:render();

    ball:render();

    displayFPS();

    push:apply('end')
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0 , 255, 0, 255)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end