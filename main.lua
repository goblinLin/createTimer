-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- 本範例用來解說如何使用Timer
-- Author: Zack Lin
-- Time: 2015/3/13

_SCREEN = {
	WIDTH = display.viewableContentWidth,
	HEIGHT = display.viewableContentHeight
}

----UI設置區塊
--顯示碼表數字
local output = display.newText( "10.0", 0, 0, native.systemFont, 64 )
output:setTextColor( 255, 255, 255 )
output.x = _SCREEN.WIDTH * 0.5
output.y = _SCREEN.HEIGHT * 0.5

--顯示狀態文字
local stateText = display.newText( "Paused", 0 , 0 ,  native.systemFont , 24 )
stateText:setTextColor( 255 , 255 , 255 )
stateText.x = _SCREEN.WIDTH * 0.5
stateText.y = _SCREEN.HEIGHT - 20

local tmr
local sec = 10.0

--偵聽performWithDelay的function，取用e.count可以得知被呼叫的次數
function listener (e)

	--[[ 此為數字增加的版本
	output.text = e.count
	if(e.count == 20) then
		timer.cancel( tmr )
		tmr = nil;
		stateText.text = "Timer Finished"
	end
	]]
	
	if sec >= 0.1 then
		print( "sec:" .. sec )
		sec = sec - 0.1
		--將浮點數格式化為指定格式，下例為保持小數點後一位
		output.text = string.format( "%.1f",sec )
	else 
		output.text = "0.0"
		timer.cancel( tmr )
		tmr = nil;
		stateText.text = "Timer Finished"

	end
end

--timer可用來監視時間，performWithDelay用於當過一指定期間便會通知偵聽器，第一個參數為期間，第二個參數為偵聽器，第三為呼叫幾次後結束，如為無限可設為-1
tmr = timer.performWithDelay( 100, listener, -1)

--暫停指定的timer
timer.pause( tmr )
local pause = true


local function touchHandler(e)
	if(tmr) then
		if(e.phase == "ended" or e.phase == "canceled") then
			if(pause == false) then
				timer.pause( tmr )
				stateText.text = "Paused"
				pause = true
			elseif(pause == true) then
				--重新啟動Timer
				timer.resume( tmr )
				stateText.text = "Running"
				pause = false
			end
		end
	end

end

--追蹤螢幕上所有的Touch事件
Runtime:addEventListener( "touch", touchHandler )
