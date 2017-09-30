/*Daedalus Library for Jass*/
globals
	hashtable HT = InitHashtable()
	unit array HERO
    unit array SHOP
    unit array TARGET
	real Map_Max_X = 0
	real Map_Max_Y = 0
	real Map_Min_X = 0
	real Map_Min_Y = 0
    leaderboard array LB
endglobals

//========================================================
// 常用函数库
// 
library Common

    function DistanceU2U takes unit u, unit target returns real
        local real xx = GetUnitX(u) - GetUnitX(target)
        local real yy = GetUnitY(u) - GetUnitY(target)
        return SquareRoot(xx*xx+yy*yy)
    endfunction

	//检测是否出边界
	function IsOutside takes real x, real y returns boolean
		local boolean b=false
		if(x>Map_Max_X)or(x<Map_Min_X)or(y>Map_Max_Y)or(y<Map_Min_Y)then
			set b=true
		endif
		return b
	endfunction

	//马甲施法
	function MjSpell takes player pl,integer id,integer skill,integer lv,unit target,string order returns nothing
		local unit u=CreateUnit(pl, id, GetUnitX(target), GetUnitY(target), 0)
		call UnitAddAbility(u, skill)
		call SetUnitAbilityLevel(u, skill, lv)
		call UnitApplyTimedLife(u, 'BHwe', 2)
		call IssueTargetOrder(u, order, target)
	endfunction
	
	// 检查玩家是否正在游戏
	function CheckPlayerPlaying takes player pl returns boolean
		local boolean b=false
		if (( GetPlayerSlotState(pl) == PLAYER_SLOT_STATE_PLAYING ) and ( GetPlayerController(pl) == MAP_CONTROL_USER ) ) then
			set b=true
		endif
		return b
	endfunction

	// 随机获取一个拥有英雄且在线的玩家
	function RandomUsefulPlayer takes nothing returns player
		local integer lop1=0
		local integer ran=0
		local player pl = null
		loop
			set ran=GetRandomInt(0,11)
			if ( CheckPlayerPlaying(Player(ran)) and (HERO[ran] != null)) then
				set pl = Player(ran)
			endif
			set lop1=lop1+1
		exitwhen ((lop1>999)or(pl!=null))
		endloop
		return pl
	endfunction