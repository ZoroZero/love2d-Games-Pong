push = require "push"

WINDOW_WIDTH = 1280;
WINDOW_HEIGHT = 720;

VIRTUAL_WIDTH = 432;
VIRTUAL_HEIGH = 243;

PADDLE_SPEED = 300;

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

    player1_Y = 30;
    player2_Y = VIRTUAL_HEIGH-50;

    ball_X = VIRTUAL_WIDTH/2-2;
    ball_Y = VIRTUAL_HEIGH/2 -2;

    ball_DX = math.random(2) == 1 and 100 or -100;
    ball_DY = math.random(-50, 50)* 1.5;
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

            ball_X = VIRTUAL_WIDTH/2 -2;
            ball_Y = VIRTUAL_HEIGH/2 -2;
        
            ball_DX = math.random(2) == 1 and 100 or -100;
            ball_DY = math.random(-50, 50)* 1.5;
        
        end
    end
end

function love.update(dt)
    if game_state == 'play' then
        if love.keyboard.isDown('w') then
            player1_Y = math.max(0, player1_Y - PADDLE_SPEED*dt);
        elseif love.keyboard.isDown('s') then
            player1_Y = math.min(VIRTUAL_HEIGH - 20, player1_Y + PADDLE_SPEED*dt);
        end

        if love.keyboard.isDown('up') then
            player2_Y = math.max(0, player2_Y - PADDLE_SPEED*dt);
        elseif love.keyboard.isDown('down') then
            player2_Y = math.min(VIRTUAL_HEIGH - 20, player2_Y + PADDLE_SPEED*dt);
        end

        ball_X = ball_X + ball_DX*dt;
        ball_Y = ball_Y + ball_DY*dt;
    end
end

function love.draw()
    push:apply('start')

    -- love.graphics.clear(40, 45, 52, 255)
    love.graphics.setFont(smallFont)
    love.graphics.printf("Hello Pong", 0, 20, VIRTUAL_WIDTH, 'center');

    love.graphics.setFont(largeFont)
    love.graphics.print(tostring(player1_score), VIRTUAL_WIDTH/2 - 50, VIRTUAL_HEIGH/3)
    love.graphics.print(tostring(player2_score), VIRTUAL_WIDTH/2 + 30, VIRTUAL_HEIGH/3)


    love.graphics.rectangle('fill', 10, player1_Y, 5, 20)

    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 30, player2_Y, 5, 20)
    
    love.graphics.rectangle('fill', ball_X , ball_Y , 4, 4)

    push:apply('end')
end