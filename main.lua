io.stdout:setvbuf('no')
if arg[#arg] == "-debug" then require("mobdebug").start() end

love.graphics.setDefaultFilter("nearest")


function love.load()

	largeur = love.graphics.getWidth()
	hauteur = love.graphics.getHeight()

	img = initImage()

	-- pour avoir 32px
	scaleImg = 0.5
	tileWidth = img[14]:getWidth()/2
	local leveltmp = initLevel(1)
	initPlayer(leveltmp)
	pressOnce = false


end

function love.update(dt)
	
	local currentCoord = getCoord(currentLevel,player.x,player.y)
	local transCoord

	if love.keyboard.isDown("up","right","down","left") then


		if pressOnce == false then


			if love.keyboard.isDown("up") then

				transCoord = transformCoord(currentLevel,currentCoord.col,currentCoord.lig - 1)
				player.y = transCoord.centerY

			end

			if love.keyboard.isDown("right") then

				transCoord = transformCoord(currentLevel,currentCoord.col + 1,currentCoord.lig)
				player.x = transCoord.centerX

			end

			if love.keyboard.isDown("down") then

				transCoord = transformCoord(currentLevel,currentCoord.col,currentCoord.lig + 1)
				player.y = transCoord.centerY

			end

			if love.keyboard.isDown("left") then

				transCoord = transformCoord(currentLevel,currentCoord.col - 1,currentCoord.lig)
				player.x = transCoord.centerX


			end

			pressOnce = true



		end

		else
			pressOnce = false
	end


end

function love.draw()

-- afficher un font pour le style (sans importance)
drawBack()
drawBackLevel(currentLevel)
drawLevel(currentLevel)
drawPlayer(currentLevel)


end

function love.keypressed(key)

	-- print(key)

end





function collidePlayer()

	local oldPlayerX = player.x
	local oldPlayerY = player.y
	
	local typeTile = getTypeTile(currentLevel,player.x,player.y)
	
	if typeTile == "mur" then

		player.x = oldPlayerX
		player.y = oldPlayerY

	end


end


function transformCoord(level,col,lig)
--donne coord en fonction de la ligne et la colonne
local coord = {}

coord.centerX = col * tileWidth + tileWidth /2
coord.centerY = lig * tileWidth + tileWidth / 2

return coord

end


function getCoord(level,x,y)

	local coord = {}
	coord.lig = math.abs(math.floor(y/tileWidth))
	coord.col = math.abs(math.floor(x/tileWidth))
	
	coord.centerX = coord.col * tileWidth
	coord.centerY = coord.lig * tileWidth


	return coord

end


function getTypeTile(level,x,y)


	local lig = math.abs(math.floor(y/tileWidth))
	local col = math.abs(math.floor(x/tileWidth))
	local typeTile = ""

	currentChar = string.char(string.byte(level[lig],col))

	if currentChar == "#" then
		typeTile = "mur"

		elseif currentChar == "$" then
			typeTile = "caisse"

			elseif currentChar == "." then
				typeTile = "cible"

			end

			return typeTile
		end



		function drawPlayer(level)

			for ligne=1,#level do
				for colonne=1,#level[ligne] do


					love.graphics.draw( player.img, player.x, player.y, 0, player.sx, player.sy, player.ox, player.oy)



				end

			end


		end


		function isInLevel(level, caseX,caseY)
	-- avoir un mur en haut et en bas
	local currentCase = string.char(string.byte(level[caseY],caseX))
	local boolTop = false
	local boolBottom = false

	if currentCase ~= "#" then
	    -- voir si y a un mur en bas de la case
	    for i=caseY,#level do
	    	if string.char(string.byte(level[i],caseX)) == "#" then
	    		boolBottom = true
	    	end
	    end
	    -- voir si y a un mur en haut de la case (où cas où le niveau ne commencerait pas à la ligne 1)
	    for i=caseY, #level-#level+1, -1 do
	    	if string.char(string.byte(level[i],caseX)) == "#" then
	    		boolTop = true
	    	end
	    end

	end


	return (boolTop == true and boolBottom == true) and true or false

end

function drawLevel(level)

-- string byte pour prendre le code ASCII et ensuite string.char pour convertir celui-ci en charactère
local currentChar

for ligne=1,#level do
	for colonne=1,#level[ligne] do

		currentChar = string.char(string.byte(level[ligne],colonne))

		if currentChar == "#" then
			love.graphics.draw( img[16], colonne*tileWidth, ligne*tileWidth, 0, scaleImg, scaleImg, 0, 0)

			elseif currentChar == "$" then
				love.graphics.draw( img[11], colonne*tileWidth, ligne*tileWidth, 0, scaleImg, scaleImg, 0, 0)

				elseif currentChar == "." then
					love.graphics.draw( img[15], colonne*tileWidth, ligne*tileWidth, 0, 1, 1, 0, 0)


				end


			end
		end

	end

	function drawBackLevel(level)

-- string byte pour prendre le code ASCII et ensuite string.char pour convertir celui-ci en charactère
local currentChar

for ligne=1,#level do
	for colonne=1,#level[ligne] do
		
		
		currentChar = string.char(string.byte(level[ligne],colonne))

		if currentChar ~= "#" or currentChar ~= "$" then
			if isInLevel(level, colonne, ligne) == true then

				love.graphics.draw( img[13], colonne*tileWidth, ligne*tileWidth, 0, scaleImg, scaleImg, 0, 0)
			end

		end


	end
end

end




function loadLevel(level)

	local currentLevel = {}


	for line in love.filesystem.lines("levels/level"..level..".txt") do
		table.insert(currentLevel, line)
	end

	return currentLevel

end



function drawBack()

-- afficher un font pour le style (sans importance)
for y=0,hauteur/tileWidth do
	for x=0,largeur/tileWidth do
		love.graphics.draw( img[14], x*tileWidth, y*tileWidth, 0, scaleImg, scaleImg, 0, 0)
	end
end

end

function initImage()

	local img = {}

	for i=#img+1,10 do
		table.insert(img,love.graphics.newImage("assets/Character"..i..".png"))
	end

	for i=1,2 do
		table.insert(img,love.graphics.newImage("assets/case"..i..".png"))
	end
	
	for i=1,2 do
		table.insert(img,love.graphics.newImage("assets/ground"..i..".png"))
	end

	table.insert(img,love.graphics.newImage("assets/target.png"))
	table.insert(img,love.graphics.newImage("assets/wall.png"))

	return img
end

function initLevel(n)

	currentLevel = loadLevel(n)
	return currentLevel
end

function initPlayer(level)
	player = {}
	player.img = img[4]
	player.x = 0 
	player.y = 0
	player.sx = 0.5 
	player.sy = 0.5 
	player.width = player.img:getWidth() * player.sx
	player.height = player.img:getHeight() * player.sy
	player.ox = player.width
	player.oy = player.height
	player.speed = 0.5 

	for ligne=1,#level do
		for colonne=1,#level[ligne] do

			local currentChar = string.char(string.byte(level[ligne],colonne))

			if currentChar == "@" then

				player.x = colonne*tileWidth + tileWidth / 2
				player.y = ligne*tileWidth + tileWidth / 2

			end


		end
	end

end
