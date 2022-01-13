pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
--hppe adventure
--by twigwallder v0.1.0

function _init()
	create_player()
	init_msg()
	init_camera()
end

function _update()
 if not messages[1] then
	player_movement()
	end
	update_camera()
	update_msg()
end

function _draw()
	cls()
	draw_map()
	draw_player()
	draw_ui()
	draw_msg()
end


-->8
--map

function draw_map()
	map(0,0,0,0,128,64)
end

function check_flag(flag,x,y)
 local sprite=mget(x,y)
 return fget(sprite,flag)
end

function init_camera()
	camx,camy=0,0
end

function update_camera()
	sectionx=flr(p.x/16)*16
	sectiony=flr(p.y/16)*16
	
	destx=sectionx*8
	desty=sectiony*8
	
	diffx=destx-camx
	diffy=desty-camy
	
	diffx/=4
	diffy/=4
	
	camx+=diffx
	camy+=diffy
	
	camera(camx,camy)
end

--i made this for learning
function other_camera()
 camx=mid(0,(p.x-7.5)*8+p.ox,
 (31-15)*8)
 camy=mid(0,(p.y-7.5)*8+p.oy,
 (31-15)*8)
	camera(camx,camy)
end

function next_tile(x,y)
	sprite=mget(x,y)
	mset(x,y,sprite+1)
end

function pick_up_key(x,y)
	next_tile(x,y)
	p.keys+=1
	sfx(0)
end

function open_door(x,y)
	next_tile(x,y)
	p.keys-=1
	sfx(1)
end
-->8
--player

function create_player()
p={
	x=6,y=4,
	ox=0,oy=0,
	start_ox=0,start_oy=0,
	anim_t=0,
	sprite=16,
	keys=0}
end

function player_movement()
	newx=p.x
	newy=p.y
	if p.anim_t==0 then
		newox=0
		newoy=0
		if btn(➡️) then 
		newx+=1
		newox=-8
		p.flip=false
		end
		if btn(⬅️) then 
		newx-=1
		newox=8
		p.flip=true
		end
		if btn(⬇️) then
		newy+=1
		newoy=-8
		end
		if btn(⬆️) then
		newy-=1
		newoy=8
	end
end
	
	interact(newx,newy)
	
	if not check_flag(0,newx,newy)
	and (p.x!=newx or p.y!=newy) then
		p.x=mid(0,newx,127)
		p.y=mid(0,newy,63)
		p.start_ox=newox
		p.start_oy=newoy
		p.anim_t=1
	end
	
	--animation
	p.anim_t=max(p.anim_t-0.125,0)
	p.ox=p.start_ox*p.anim_t
	p.oy=p.start_oy*p.anim_t
	
	if p.anim_t>0.5 then
		p.sprite=17
	else
		p.sprite=16
	end
end

function interact(x,y)
	if check_flag(1,x,y) then
		pick_up_key(x,y)
		elseif check_flag(2,x,y)
	 and p.keys>0 then
			open_door(x,y)
	end --text of all
	if x==7 and y==3 then
		create_msg("pancarte",
		"press ❎ to continue")
	end
	if x==6 and y==13 then
		create_msg("pancarte","hi")
	end
	if y==25 and x>1 and x<=5 
	and not test_msg then
	create_msg("test","2036")
	test_msg=true
	end
end

function draw_player()
	spr(p.sprite,p.x*8+p.ox,
	p.y*8+p.oy,1,1,p.flip)
end
-->8
--ui

function draw_ui()
	camera()
	palt(0,false)
	palt(12,true)
	spr(32,2,2)
	palt()
	print_outline("X"..p.keys,3,12)
end

function print_outline(text,y,x)
	print(text,x-1,y,0)
	print(text,x+1,y,0)
	print(text,x,y-1,0)
	print(text,x,y+1,0)
	print(text,x,y,7)
end
-->8
--messages

function init_msg()
	messages={}
end


function create_msg(name,...)
	msg_title=name
	messages={...}
end

function update_msg()
	if (btnp(❎)) then
	 deli(messages,1)
	end
end

function draw_msg()
	if messages[1] then
	local y=100
	if p.y%16>9 then
	 y=10
	end
	--titre
	rectfill(7,y,
	11+#msg_title*4,y+7,2)
	print(msg_title,10,y+2,9)
	--message
	rectfill(3,y+8,124,y+24,4)
	rect(3,y+8,124,y+24,2)
	print(messages[1],6,y+11,15)
	end
end
__gfx__
000000003333333333333333333333333333333333bbbb3311111111444444444444444466666666666666660000000000000000000000000000000000000000
000000003333333333a333333333333333333b333bbaabb311111111444444444ffffff466666666565555650000000000000000000000000000000000000000
00700700333333333a9a3333333333333bb33b333bbbab1311111111cccccccc4444444466666666565555650000000000000000000000000000000000000000
000770003333333333a333333333733333bb33333bbbb31311111111111111114f444f4466666666666666660000000000000000000000000000000000000000
00077000333333333333a33333379733333b3333313b331311111111111111114ffffff466666666555655550000000000000000000000000000000000000000
0070070033333333333a9a3337337333333333333311113311111111111111114444f44466666666555655550000000000000000000000000000000000000000
00000000333333333333a33379733333333333333332233311111111111111114ffffff466666666666666660000000000000000000000000000000000000000
00000000333333333333333337333333333333333314423311111111111111114444444466666666655556550000000000000000000000000000000000000000
01111800011118006666666666666666333333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8811f8808811f88066666aa666666666399999930000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1fbffa101fbffa106666a11a66666666344444430000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
81ffff1081ffff10aaaaa66a66666666342242430000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8122221081222210a1a11aa166666666344444430000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02888800028888001616611666666666332332330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02dddd0020dddd006666666666666666334334330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02100100200110006666666666666666333333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccc000000003333333333333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
caaccccc0000000033333aa333333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a00acccc000000003333a11a33333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
accaaaaa00000000aaaaa33a33333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0aa00a0a00000000a1a11aa133333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c00cc0c0000000001313311333333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccc000000003333333333333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccc000000003333333333333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000001444444114420001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000004405050444520000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000009405050495520000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000009444444495420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000004444441444420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000009444446494420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000009424444494200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000004224242442000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000010101000001000000000000000200010000000000000000000000000002000000000000000000000000000000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0505050505010505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505010101010105050505050505010105050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010101010101010101010105050505050501010a010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505010104010114030101010505050501010102010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0501010101010103010101010122050501010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0501010101010101010201010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050101010102020101010101040101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050101010101010101010101010101010107070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0507070707070707070707080707070707070706060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0706060606060606060606080606060606060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060606060606060606080606060606060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060606060606060606080606060606010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
050101010101140101010a0a0a0a010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
050101010101010101013209120a010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
050501010101040101010a0a0a0a010101010101010101010101050505050501010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050101010101010101010101010101010101010101010505050505050505050100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050501010101010101010101010101010101010101050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050501010101010101010101010101010101010101050505050505050505050505000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050501010104010101010101010101010101010101050505050505050505050505000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0501010101010101010101010101010101010101010101010505050505050505050505000005050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0501010101010101010101010101010101010101010101010101050505050505050505000000050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101050505050505000000000505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000010101010101010101010101010101050505000000000005050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0009090909090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000500000f55012550155500000000000255502555025550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000d000000000126201c6201e60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
