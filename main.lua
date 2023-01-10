function newObject(imageName, imageX, imageY, imagexScale, imageyScale)
    object = {}
    object.image = love.graphics.newImage(imageName)
    object.x = imageX
    object.y = imageY
    object.rotation = 0
    object.xScale = imagexScale
    object.yScale = imageyScale
    object.width = object.image:getWidth()
    object.height = object.image:getHeight()
    object.xOrigin = object.width / 2
    object.yOrigin = object.height / 2
    object.red = 1
    object.green = 1
    object.blue = 1
    object.alpha = 1

    return object
end

function addLog(newText)
    textList[#textList+1] = newText

    if #textList > 20 then
        table.remove(textList, 1)
    end
end



function drawObject(object)
    love.graphics.setColor(object.red, object.green, object.blue, object.alpha)
    love.graphics.draw(object.image, object.x, object.y, object.rotation, object.xScale, object.yScale, object.xOrigin, object.yOrigin)
end

function love.load()
    textList = {}
    snowList = {}
    warpList = {}
    trailList = {}
    fireworkList = {}

    local img = newObject('fireworkParticle.png')

	psystem = love.graphics.newParticleSystem(img.image, 1000)
	psystem:setParticleLifetime(5) -- Particles live at most 5s.
    psystem:setSizes(4,1)
	psystem:setSizeVariation(1)
	psystem:setLinearAcceleration(-200, -200, 200, 200) -- Random movement in all directions.
	psystem:setColors(1, 1, 1, 1, 1, math.random(0,1), math.random(0,1), 0) -- Fade to transparency.

    spacePhase0 = newObject("spacePhase0.png", 500, 550, 1, 1)
    spacePhase1 = newObject("spacePhase1.png", 500, 550, 1, 1)
    spacePhase2 = newObject("spacePhase2.png", 500, 550, 1, 1)
    spacePhase3 = newObject("spacePhase3.png", 500, 550, 1, 1)
    spacePhase4 = newObject("spacePhase4.png", 500, 550, 1, 1)
    spacePhase5 = newObject("spacePhase5.png", 500, 550, 1, 1)
    spacePhase6 = newObject("spacePhase6.png", 500, 550, 1, 1)
    spacePhase7 = newObject("spacePhase7.png", 500, 550, 1, 1)
    spacePhase8 = newObject("spacePhase8.png", 500, 550, 1, 1)

    spacebarAnimation = 0
    firework = newObject("firework.png", 400, 300, 1, 1)
    holdSpace = newObject("holdSpace.png", 370, 550, 1, 1)
    background = newObject("background.png", 400, 300, 1, 1)
    background2 = newObject("background2.png", 400, 300, 1, 1)
    fadeBlack = newObject("fadeBlack.png", 400, 300, 1, 1)
    countdownAnimation = 300
    countdownSpacebar = 400
    spacebarHit = "false"
    animatePhase = 0
    firework.alpha = 0
    x = 0
end

function love.update(dt)
    --addLog(x)

    if animatePhase == 7 then
        psystem:setColors(1, 1, 1, 1, 1, math.random(0,1), math.random(0,1), 0) -- Fade to transparency.
	    psystem:update(dt)
    end

    -- 1/5 chance of creating snow objects
    if math.random(1, 5) == 1 then
        newSnow = {}
        snowList[#snowList+1] = newObject("snowParticle.png", math.random(0, 800), -100, 0.7, 0.7)
    end

    --Snow settings
    for index = #snowList, 1 ,-1 do
        snow = snowList[index]
        snow.alpha = snow.alpha - 0.0015
        snow.rotation = snow.rotation + 0.01
        snow.y = snow.y + 1

        if snow.alpha <= 0 then
            table.remove(snowList, index)
        end
    end

    -- Creating warp effect
    if animatePhase >= 5 then
        if math.random(1, 3) == 1 then
            newWarp = {}
            warpList[#warpList+1] = newObject("warpParticle.png", math.random(0, 800), -100, math.random(1, 2), imagexScale)
        end
    end

    --Warp settings
    if animatePhase >= 5 then
        for index = #warpList, 1 ,-1 do
            warp = warpList[index]
            warp.alpha = warp.alpha - 0.0007
            x = x + 0.008
            warp.y = warp.y + x
            --[[if warp.y >= 100 and warp.y < 200 then
                warp.y = warp.y + 5
            elseif warp.y >= 200 and warp.y < 300 then
                warp.y = warp.y + 7
            elseif warp.y >= 300 and warp.y < 400 then
                warp.y = warp.y + 9
            elseif warp.y >= 400 and warp.y < 500 then
                warp.y = warp.y + 12
            elseif warp.y >= 500 and warp.y < 700 then
                warp.y = warp.y + 16
            else
                warp.y = warp.y + 3
            end]]--
            
    
            if warp.y >= 700 or warp.alpha <= 0 or animatePhase >= 7 then
                table.remove(warpList, index)
            end
        end
    
    end
    
    -- Creating Firework trail
    if animatePhase >= 5 then
        newTrail = {}
        trailList[#trailList+1] = newObject("firework.png", firework.x, firework.y, firework.xScale, firework.yScale)
    end

    --Trail settings
    for index = #trailList, 1, -1 do
        trail = trailList[index]
        trail.alpha = trail.alpha - 0.1
        trail.y = trail.y + 3
        if trail.alpha <= 0 then
            table.remove(trailList, index)
        end
    end

    -- Firework settings
    if animatePhase >= 5 then
        if firework.x <= 380 then
            firework.x = 380
        elseif firework.y > 420 then
            firework.y = 420
        end
        firework.x = firework.x + math.random(-1,1)
        if animatePhase >= 5 and animatePhase <= 6 then
            firework.xScale = firework.xScale + 0.001
            firework.yScale = firework.yScale + 0.001
        end
    end

    --Animation statement
    if animatePhase == 0 then
        fadeBlack.alpha = fadeBlack.alpha - 0.01
    elseif animatePhase == 1 then
        fadeBlack.alpha = fadeBlack.alpha + 0.01
    elseif animatePhase == 2 then
        fadeBlack.alpha = fadeBlack.alpha - 0.002
    elseif animatePhase == 3 then
        fadeBlack.alpha = fadeBlack.alpha + 0.01
    elseif animatePhase == 4 then
        fadeBlack.alpha = fadeBlack.alpha - 0.01
        firework.alpha = firework.alpha + 0.005
        table.remove(snowList, #snowList)
    elseif animatePhase == 5 then
        firework.y = firework.y - 1
    elseif animatePhase == 6 then
        fadeBlack.alpha = 0
    elseif animatePhase == 7 then
        fadeBlack.alpha = 1
    elseif animatePhase == 8 then
        fadeBlack.alpha = fadeBlack.alpha - 0.01
    end

    --Constantly set fadeBlack.alpha = 0/1 so it does not go beyond 0/1
    if fadeBlack.alpha < 0 then
        fadeBlack.alpha = 0
    end

    if fadeBlack.alpha > 1 then
        fadeBlack.alpha = 1
    end

    --Constantly set firework.alpha = 0/1 so it does not go beyond 0/1
    if firework.alpha < 0 then
        firework.alpha = 0
    end

    if firework.alpha > 1 then
        firework.alpha = 1
    end

    

    --Holding "d" key will delete snow objects (prevent lag for testing)
    if love.keyboard.isDown("d") then
        table.remove(snowList, 1)
    end

    --Holding "space" key will start countdownSpacebar.
    if love.keyboard.isDown("space") and countdownSpacebar <= 400 and countdownSpacebar >= 0 then
        countdownSpacebar = countdownSpacebar - 1
    elseif animatePhase == 0 then
        countdownSpacebar = countdownSpacebar + 1
    end

    if countdownSpacebar > 400 then
        countdownSpacebar = 400
    end

    if countdownSpacebar > 300 and countdownSpacebar <= 350 then
        spacebarAnimation = 1
    elseif countdownSpacebar > 250 and countdownSpacebar <= 300 then
        spacebarAnimation = 2
    elseif countdownSpacebar > 200 and countdownSpacebar <= 250 then
        spacebarAnimation = 3
    elseif countdownSpacebar > 150 and countdownSpacebar <= 200 then
        spacebarAnimation = 4
    elseif countdownSpacebar > 100 and countdownSpacebar <= 150 then
        spacebarAnimation = 5
    elseif countdownSpacebar > 50 and countdownSpacebar <= 100 then
        spacebarAnimation = 6
    elseif countdownSpacebar > 0 and countdownSpacebar <= 50 then
        spacebarAnimation = 7
    elseif countdownSpacebar <= 0 and animatePhase == 0 then
        spacebarAnimation = 8
        animatePhase = 1
    else
        spacebarAnimation = 0
    end

    if animatePhase == 1 then
        spacebarAnimation = 8
    end
    
    --Check animatePhase
    if animatePhase == 1 then
        countdownAnimation = countdownAnimation - 1
        if countdownAnimation <= 0 then
            countdownAnimation = 600
            animatePhase = 2
        end
    elseif animatePhase == 2 then
        countdownAnimation = countdownAnimation - 1
        if countdownAnimation <= 0 then
            countdownAnimation = 300
            animatePhase = 3
        end
    elseif animatePhase == 3 then
        countdownAnimation = countdownAnimation - 1
        if countdownAnimation <= 0 then
            countdownAnimation = 300
            animatePhase = 4
        end
    elseif animatePhase == 4 then
        countdownAnimation = countdownAnimation - 1
        if countdownAnimation <= 0 then
            countdownAnimation = 180
            animatePhase = 5
        end
    elseif animatePhase == 5 then
        countdownAnimation = countdownAnimation - 1
        if countdownAnimation <= 0 then
            countdownAnimation = 300
            animatePhase = 6
        end
    elseif animatePhase == 6 then
        countdownAnimation = countdownAnimation - 1
        if countdownAnimation <= 0 then
            countdownAnimation = 300
            animatePhase = 7
        end
    elseif animatePhase == 7 then
        countdownAnimation = countdownAnimation - 1
        if countdownAnimation <= 0 then
            countdownAnimation = 300
            animatePhase = 8
        end
    elseif animatePhase == 8 then
        countdownAnimation = countdownAnimation - 1
        if countdownAnimation <= 0 then
            countdownAnimation = 300
            animatePhase = 9
        end


    end

    
    
end

function love.draw()
    --Background
    if animatePhase >= 0 and animatePhase <= 1 then
        drawObject(background)
    elseif animatePhase >= 2 and animatePhase < 4 then
        drawObject(background2)
    end

    --Snow particles
    if animatePhase <= 3 then
        for index = 1, #snowList do
            snow = snowList[index]
            drawObject(snow)
        end
    end
    

    --addLog
    for index = 1, #textList, 1 do
        oldText = textList[index]
        love.graphics.print(oldText, 0, 20*(index-1))
    end

    --Holding spacebar animation.
    if animatePhase <= 1 then
        drawObject(holdSpace)
    end


    if spacebarAnimation == 0 and animatePhase <= 1 then
        drawObject(spacePhase0)
    elseif spacebarAnimation == 1 and animatePhase <= 1 then
        drawObject(spacePhase1)
    elseif spacebarAnimation == 2 and animatePhase <= 1 then
        drawObject(spacePhase2)
    elseif spacebarAnimation == 3 and animatePhase <= 1 then
        drawObject(spacePhase3)
    elseif spacebarAnimation == 4 and animatePhase <= 1 then
        drawObject(spacePhase4)
    elseif spacebarAnimation == 5 and animatePhase <= 1 then
        drawObject(spacePhase5)
    elseif spacebarAnimation == 6 and animatePhase <= 1 then
        drawObject(spacePhase6)
    elseif spacebarAnimation == 7 and animatePhase <= 1 then
        drawObject(spacePhase7)
    elseif spacebarAnimation == 8 and animatePhase <= 1 then
        drawObject(spacePhase8)
    end
    
    
    --Firework trail
    if animatePhase >= 5 and animatePhase < 7 then
        for index = 1, #trailList do
            trail = trailList[index]
            drawObject(trail)
        end
    end

    --Firework
    if animatePhase >= 2 and animatePhase < 7 then
        drawObject(firework)
    end

    --Warp particles
    if animatePhase >= 5 and animatePhase < 7 then
        for index = 1, #warpList do
            warp = warpList[index]
            drawObject(warp)
        end
    end


    drawObject(fadeBlack)
    -- Draw the firework particle system at the center of the game window.
    if animatePhase == 8 then
        psystem:setEmissionRate(0)
    else
        psystem:setEmissionRate(1000)
    end
	love.graphics.draw(psystem, love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5)

    if animatePhase == 9 then
        love.graphics.print("yes, it ends", 400, 300)
    end
    --[[love.graphics.print(countdownSpacebar, 200, 280)
    love.graphics.print(countdownAnimation, 200, 300)
    love.graphics.print(spacebarHit, 240, 300)
    love.graphics.print(animatePhase, 280, 300)]]--
end
