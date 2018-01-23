io.stdout:setvbuf('no')

love.graphics.setDefaultFilter("nearest")


function love.load()

	largeur = love.graphics.getWidth()
	hauteur = love.graphics.getHeight()

	img = initImage()

	-- pour avoir 32px
	scaleImg = 0.5
	tileWidth = img[14]:getWidth()/2



	currentLevel = loadLevel(10)

	


end

function love.update(dt)



end

function love.draw()

-- afficher un font pour le style (sans importance)
drawBack()
drawBackLevel(currentLevel)
drawLevel(currentLevel)

end

function love.keypressed(key)

	-- print(key)

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