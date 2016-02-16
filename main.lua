-----------------------------------------------------------------------------------------
-- 本範例用來解說如何使用Timer來搭配performWithDelay，如需更多資料請參考下列網址
-- https://docs.coronalabs.com/api/library/timer/performWithDelay.html
-- Author: Zack Lin
-- Time: 2015/8/17
-----------------------------------------------------------------------------------------
_SCREEN = {
	WIDTH = display.viewableContentWidth,
	HEIGHT = display.viewableContentHeight
}
_SCREEN.CENTER = {
	X = display.contentCenterX,
	Y = display.contentCenterY
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

--指向Timer的變數，用以控制Timer
local tmr
local sec = 10.0

--偵聽performWithDelay的function，取用e.count可以得知被呼叫的次數
function listener (e)

	--[[此為數字增加的版本
	output.text = e.count
	if(e.count == 40) then
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
		-- 取用timer裡的params
		local params = e.source.params
		print('Name:' .. params.name)
		print('Version:' .. params.version)

		output.text = "0.0"
		-- 將timer取消
		timer.cancel( tmr )
		tmr = nil;
		stateText.text = "Timer Finished"

	end
end

--  timer可用來監視時間，performWithDelay用於當過一指定期間便會通知偵聽器
--  第一個參數為期間，單位為微秒
--  第二個參數為偵聽器
--  第三為呼叫幾次後結束，如為無限可設為-1 or 0，預設為1
tmr = timer.performWithDelay( 100, listener, -1)
--可設定改timer使用的參數
tmr.params = {name='zack' , version='1.0'}

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
	--print('touchHandler')
end

--當該timer已經用不到，可以將該timer給cancel掉
--timer.cancel( tmr )

--追蹤螢幕上所有的Touch事件
Runtime:addEventListener( "touch", touchHandler )
