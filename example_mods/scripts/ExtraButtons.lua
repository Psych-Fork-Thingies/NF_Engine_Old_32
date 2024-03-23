local toolsList = {'Move Camera', 'Move Object', 'Flip', 'Scroll Speed', 'Object Camera', 'Alpha', 'Front', 'Antialiasing', 'Scale', 'Remove Sprite'}
local toolsListJson = {'DAD Position', 'GF Position', 'BF Position', 'Default Camera Zoom', 'Hide Girlfriend', 'Move Camera'}
local toolChoose = 1
local toolChooseJson = 1

-- Style
local style = 'new'
local type = 'exit'
--Styles new or old
--Tyoes exit , new , old

local gameCam = {'camGame', 'camHUD', 'camOther'}

local addSpriteStep = {'Animated?', 'Name the tag', 'Path to image', 'animName', 'Name in xml file'}
local addSpriteStepNum = 1

local layerList = {
	tag = {},
	imagePath = {},
	position = {},
	alpha = {},
	antialiasing = {},
	scale = {},
	scrollSpeed = {},
	flip = {},
	order = {},
	camera = {},
	isAnimated = {},
	anim = {}
}
local layerChoose = 1
local filePath = 'origjdjdjal'

local typingTXT = ''
local capitalTyping = 'false'
local canTyping = false

local pageESMenu = 1

local moveSpeed = 10

local text = 1

function onCreate()
addVirtualPad('NULL', 'V_E_F_G_S_X')
--addVirtualPad('ALEFT_DRIGHT', 'NULL')
--addVirtualPad('FULL', 'A_B_C_X_Y_Z')
end

function onUpdate()
if androidPadJustPress('V') then
    endSong();
    end
    if androidPadJustPress('E') then
    restartSong(true)
    end    
    if not getProperty('cpuControlled') and androidPadJustPress('X') then
    setProperty('cpuControlled', true)
    elseif androidPadJustPress('X') then
    setProperty('cpuControlled', false)
    end
    if androidPadJustPress('G') then
        runHaxeCode('PlayState.instance.openPauseMenu();')
    end
    if androidPadJustPress('F') then
        runHaxeCode('PlayState.instance.openChartEditor();')
    end
    if androidPadJustPress('S') then
        runHaxeCode([[
    import options.OptionsState;
    import backend.MusicBeatState;
    game.paused = true; // For lua
    game.vocals.volume = 0;
    MusicBeatState.switchState(new OptionsState());
    if (ClientPrefs.data.pauseMusic != 'None') {
        FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)), game.modchartSounds('pauseMusic').volume);
        FlxTween.tween(FlxG.sound.music, {volume: 1}, 0.8);
        FlxG.sound.music.time = game.modchartSounds('pauseMusic').time;
    }
    OptionsState.onPlayState = true;
]])
    debugPrint('Not Working Huh...        Try using Psych 0.7+ Or NF 0.7.3')
    end
    if androidPadJustPress('Z') then
        playSound('yeah')
        characterPlayAnim("boyfriend", "hey", true);
        characterPlayAnim("girlfriend", "hey", true);
    end
    if androidPadJustPress('up') then
    playSound('yeah')
    characterPlayAnim("boyfriend", "singUP", true);
    end
    if androidPadJustPress('down') then
    playSound('bf-ah')
    characterPlayAnim("boyfriend", "singDOWN", true);
    end
    if androidPadJustPress('left') then
    playSound('bf-twist')
    characterPlayAnim("boyfriend", "singLEFT", true);
    end
    if androidPadJustPress('right') then
    playSound('bf-yeah')
    characterPlayAnim("boyfriend", "singRIGHT", true);
    end
end

function onUpdatePost()
	--debugPrint(returnVariable(layerList['tag'][1]))
	AndroidPadUpdate()
	--Android
	
	for i = 1, #normalKeys[1] do
		if ((getMouseY('camHUD') > getProperty('mobileKey'..normalKeys[1][i]..'.y') and getMouseY('camHUD') < getProperty('mobileKey'..normalKeys[1][i]..'.y')+100) and (getMouseX('camHUD') > getProperty('mobileKey'..normalKeys[1][i]..'.x') and getMouseX('camHUD') < getProperty('mobileKey'..normalKeys[1][i]..'.x')+100) and mouseClicked('left')) then
			entreTypingTXT(returnKeys[1][i], typingTXT)
		end
	end
	
	for i = 1, #normalKeys[2] do
		if ((getMouseY('camHUD') > getProperty('mobileKey'..normalKeys[2][i]..'.y') and getMouseY('camHUD') < getProperty('mobileKey'..normalKeys[2][i]..'.y')+100) and (getMouseX('camHUD') > getProperty('mobileKey'..normalKeys[2][i]..'.x') and getMouseX('camHUD') < getProperty('mobileKey'..normalKeys[2][i]..'.x')+100) and mouseClicked('left')) then
			entreTypingTXT(returnKeys[2][i], typingTXT)
		end
	end
	
	for i = 1, #normalKeys[3] do
		if ((getMouseY('camHUD') > getProperty('mobileKey'..normalKeys[3][i]..'.y') and getMouseY('camHUD') < getProperty('mobileKey'..normalKeys[3][i]..'.y')+100) and (getMouseX('camHUD') > getProperty('mobileKey'..normalKeys[3][i]..'.x') and getMouseX('camHUD') < getProperty('mobileKey'..normalKeys[3][i]..'.x')+100) and mouseClicked('left')) then
			entreTypingTXT(returnKeys[3][i], typingTXT)
		end
	end
	
	for i = 1, #normalKeys[4] do
		if ((getMouseY('camHUD') > getProperty('mobileKey'..normalKeys[4][i]..'.y') and getMouseY('camHUD') < getProperty('mobileKey'..normalKeys[4][i]..'.y')+100) and (getMouseX('camHUD') > getProperty('mobileKey'..normalKeys[4][i]..'.x') and getMouseX('camHUD') < getProperty('mobileKey'..normalKeys[4][i]..'.x')+100) and mouseClicked('left')) then
			entreTypingTXT(returnKeys[4][i], typingTXT)
		end
	end
end

function addVirtualPad(left, right)
	if buildTarget == 'android' then
		androidPad = {}
		if left == 'UP_DOWN' then
			addAndroidPad('up', 0, 471, '00FF00')
			addAndroidPad('down', 0, 593, '00FFFF')
		elseif left == 'ALEFT_DRIGHT' then
			addAndroidPad('left', 0, 593, 'FF00FF')
			addAndroidPad('right', 1148, 593, 'FF0000')
		elseif left == 'LEFT_RIGHT' then
			addAndroidPad('left', 0, 593, 'FF00FF')
			addAndroidPad('right', 132, 593, 'FF0000')
		elseif left == 'FULL' then
			addAndroidPad('up', 112, 359, '00FF00')
			addAndroidPad('down', 112, 573, '00FFFF')
			addAndroidPad('left', 0, 461, 'FF00FF')
			addAndroidPad('right', 223, 461, 'FF0000')
		end
		
		if right == 'A' then
			addAndroidPad('a', 1148, 593, 'FF0000')
		elseif right == 'B' then
			addAndroidPad('b', 1148, 593, 'FFCB00')
		elseif right == 'A_B' then
			addAndroidPad('a', 1148, 593, 'FF0000')
			addAndroidPad('b', 1024, 593, 'FFCB00')
		elseif right == 'A_B_C' then
		    addAndroidPad('a', 1148, 593, 'FF0000')
			addAndroidPad('b', 1024, 593, 'FFCB00')
			addAndroidPad('c', 900, 593, '00FFFF')
		elseif style == 'new' and right == 'E_F_G_S_X' then
		addAndroidPad('x', 134, 124, 'NULL')
		addAndroidPad('s', 0, 124, 'NULL')
		addAndroidPad('g', 1124, 0, 'NULL')
		addAndroidPad('f', 0, 0, 'NULL')
		addAndroidPad('e', 134, 0, 'NULL')
		elseif style == 'old' and right == 'E_F_G_S_X' then
		addAndroidPad('x', 134, 124, 'NULL')
		addAndroidPad('s', 0, 124, 'NULL')
		addAndroidPad('g', 0, 0, 'NULL')
		addAndroidPad('f', 134, 0, 'NULL')
		addAndroidPad('e', 268, 0, 'NULL')
		--Exit Button
		elseif style == 'new' and right == 'V_E_F_G_S_X' then
		addAndroidPad('x', 134, 124, 'NULL')
		addAndroidPad('s', 0, 124, 'NULL')
		addAndroidPad('g', 1124, 0, 'NULL')
		addAndroidPad('f', 0, 0, 'NULL')
		addAndroidPad('e', 134, 0, 'NULL')
		addAndroidPad('v', 268, 0, 'NULL')
		elseif right == 'FULL' then
			addAndroidPad('a', 1148, 593, 'FF0000')
			addAndroidPad('b', 1024, 593, 'FFCB00')
			addAndroidPad('c', 900, 593, '00FFFF')
			addAndroidPad('d', 776, 593, 'FF00FF')
			addAndroidPad('e', 1148, 477, '556611')
			addAndroidPad('f', 1024, 477, '4678SS')
			addAndroidPad('g', 900, 477, 'FF8866')
			addAndroidPad('s', 776, 477, '114514')
			addAndroidPad('v', 1148, 355, '49A9B2')
			addAndroidPad('x', 1024, 355, '99062D')
			addAndroidPad('y', 900, 355, '4A35B9')
			addAndroidPad('z', 776, 355, 'CCB98E')
		elseif right == 'A_B_C' then
			addAndroidPad('a', 1148, 593, 'FF0000')
			addAndroidPad('b', 1024, 593, 'FFCB00')
			addAndroidPad('c', 900, 593, '00FFFF')
		elseif right == 'A_B_C_D' then
			addAndroidPad('a', 1148, 593, 'FF0000')
			addAndroidPad('b', 1024, 593, 'FFCB00')
			addAndroidPad('c', 900, 593, '00FFFF')
			addAndroidPad('d', 776, 593, 'FF00FF')
		elseif right == 'A_B_C_X_Y_Z' then
			addAndroidPad('a', 1148, 593, 'FF0000')
			addAndroidPad('b', 1024, 593, 'FFCB00')
			addAndroidPad('c', 900, 593, '00FFFF')
			addAndroidPad('x', 1148, 477, '99062D')
			addAndroidPad('y', 1024, 477, '4A35B9')
			addAndroidPad('z', 900, 477, 'CCB98E')
		end
	end
end

function addAndroidPad(name, x, y)
	makeAnimatedLuaSprite(name:lower()..'_AndroidPad', 'androidPadNew', x, y)
	setObjectCamera(name:lower()..'_AndroidPad', 'other')
	addLuaSprite(name:lower()..'_AndroidPad', true)
	addAnimationByPrefix(name:lower()..'_AndroidPad', 'normal', name:lower()..'1', 24, false)
	addAnimationByPrefix(name:lower()..'_AndroidPad', 'pressed', name:lower()..'2', 24, false)
	setProperty(name:lower()..'_AndroidPad.alpha', 0.7)
	table.insert(androidPad, name:lower())
end

function AndroidPadUpdate()
	for i = 1, #androidPad do
		if ((getMouseY('camHUD') > getProperty(androidPad[i]..'_AndroidPad.y') and getMouseY('camHUD') < getProperty(androidPad[i]..'_AndroidPad.y')+132) and (getMouseX('camHUD') > getProperty(androidPad[i]..'_AndroidPad.x') and getMouseX('camHUD') < getProperty(androidPad[i]..'_AndroidPad.x')+132) and mousePressed('left')) then
			objectPlayAnimation(androidPad[i]..'_AndroidPad', 'pressed', true)
		else
			objectPlayAnimation(androidPad[i]..'_AndroidPad', 'normal', true)
		end
	end
end

function androidPadJustPress(name)
	return ((getMouseY('camHUD') > getProperty(name:lower()..'_AndroidPad.y') and getMouseY('camHUD') < getProperty(name:lower()..'_AndroidPad.y')+132) and (getMouseX('camHUD') > getProperty(name:lower()..'_AndroidPad.x') and getMouseX('camHUD') < getProperty(name:lower()..'_AndroidPad.x')+132) and mouseClicked('left'))
end

function androidPadPress(name)
	return ((getMouseY('camHUD') > getProperty(name:lower()..'_AndroidPad.y') and getMouseY('camHUD') < getProperty(name:lower()..'_AndroidPad.y')+132) and (getMouseX('camHUD') > getProperty(name:lower()..'_AndroidPad.x') and getMouseX('camHUD') < getProperty(name:lower()..'_AndroidPad.x')+132) and mousePressed('left'))
end

function removeAndroidPad()
	for i = 1, #androidPad do
		removeLuaSprite(androidPad[i]..'_AndroidPad', false)
	end
end