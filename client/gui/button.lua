local Button = {}
Button.__index = Button

function Button:Create()
    local self = setmetatable({}, Button)

    -- Default-Werte
    self.x = 0
    self.y = 0
    self.w = 100
    self.h = 40
    self.color = {
        r = 1,
        g = 1,
        b = 1
    }

    self.text = "Button"
    self.hovered = false
    self.onClick = nil
    self.enabled = true

    return self
end

function Button:SetPos(x, y)
    self.x = x
    self.y = y
end

function Button:SetSize(w, h)
    self.w = w
    self.h = h
end

function Button:SetIndex(index)
    self.index = index
end

function Button:GetIndex()
    return self.index
end

function Button:SetText(text)
    self.text = text
end

function Button:SetOnClick(fn)
    self.onClick = fn
end

function Button:SetEnabled(b)
    self.enabled = b
end

function Button:SetColor(r, g ,b)
    self.color.r = r
    self.color.g = g
    self.color.b = b
end

function Button:GetColor()
    return self.color.r, self.color.g, self.color.b
end

function Button:Update(dt)
    local mx, my = love.mouse.getPosition()
    self.hovered =
        mx >= self.x and mx <= self.x + self.w and
        my >= self.y and my <= self.y + self.h

    local padding = 25
    local window_width, window_height = love.window.getMode()
    self.w = (window_width - 4 * padding) / 3
    self.h = (window_height - 4 * padding) / 3 - 50 -- for the text
    local xpos = self:GetIndex() % 3 ~= 0 and self:GetIndex() % 3 or 3
    self.x = padding * xpos + self.w * (xpos - 1)
    self.y = padding * math.ceil(self:GetIndex() / 3) + self.h * (math.ceil(self:GetIndex() / 3) - 1)
end

function Button:MousePressed(x, y, button)
    if not self.enabled then return false end
    if button == 1 and self.hovered then
        if self.onClick then
            self.onClick()
        end
        return true
    end
    return false
end


function Button:Draw()
    local r, g, b = self:GetColor()
    if self.hovered then
        love.graphics.setColor(r, g, b)
    else
        love.graphics.setColor(r * 0.8, g * 0.8, b * 0.8)
    end

    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

    -- Text zentrieren
    love.graphics.setNewFont("resource/fonts/BBHBogle-Regular.ttf", 24)
    local font = love.graphics.getFont()
    local textW = font:getWidth(self.text)
    local textH = font:getHeight()

    love.graphics.print(
        self.text,
        self.x + (self.w - textW) / 2,
        self.y + (self.h - textH) / 2
    )

    love.graphics.setColor(1, 1, 1)
end

return Button
