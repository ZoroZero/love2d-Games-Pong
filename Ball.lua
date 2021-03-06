Ball = Class{}

function Ball:init(x, y, radius)
    self.x = x;
    self.y = y;
    -- self.width = width;
    -- self.height = height;
    self.radius = radius
    self.dx = math.random(2) == 1 and 100 or -100;
    self.dy = math.random(-50, 50)* 1.5;

end

function Ball:update(dt) 
   
    self.x = self.x + self.dx*dt
    self.y = self.y + self.dy*dt 
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH/2;
    self.y = VIRTUAL_HEIGH/2;

    self.dx = math.random(2) == 1 and 100 or -100;
    self.dy = math.random(-50, 50) * 1.5;
end

function Ball:collides(paddle)
    return (self.x - self.radius <= paddle.x + paddle.width) and (self.x + self.radius >= paddle.x) 
            and (self.y - self.radius <= paddle.y + paddle.height) and (self.y + self.radius >= paddle.y)
end

function Ball:render()
    -- love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.circle('fill', self.x , self.y, self.radius)
end

