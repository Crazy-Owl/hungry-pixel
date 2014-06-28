-- useful constants

windowHeight = 900
windowWidth = 1200

leftKey = "left"
rightKey = "right"
upKey = "up"
downKey = "down"
pauseKey = "escape"
newGameKey = "n"

easyDifficulty = {
    -- Hero section
    startingHeroWidth = 1,
    startingHeroHeight = 1,
    startingHeroSpeed = {0, 0},
    startingHeroSize = 4,
    heroVelocity = 250,
    heroSlowing = 0.4,
    heroTimeToShrink = 10,
    growRate = 2,
    shrinkRate = 4,
    minimumWidth = 2,
    minimumHeight = 2,
    maxSize = 400,
    -- gameplay section
    objectAppearRange = {3, 7},
    obstacleAppearRange = {15, 30},
    obstacleBaseTime = 10,
    objectLifespan = {6, 15},
    objectWidth = 10,
    objectHeight = 10,
    obstacleMinSize = 20,
    obstacleMaxSize = 35,
    displayRuler = true
}
