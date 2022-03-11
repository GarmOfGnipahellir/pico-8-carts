pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
--main

plr={
	mp={},
	mb=0,
	hovered=0,
}

units={}

function _init()
	plr.mp=vec:new()

	add(units,unit:new({
		pos=vec:new(32, 32),
		sprite=3,
		hp=75
	}))
end

function _update()
	poke(0x5f2d,1)
	plr.mp.x=stat(32)
	plr.mp.y=stat(33)
	if stat(34)>0 then
		plr.mb=1
	else
		plr.mb=0
	end
	
	--check hover
	plr.hovered=0
	for i,u in pairs(units) do
		local b = aabb:new(
			u.pos, u.size)
		if b:contains(plr.mp) then
			plr.hovered=i
		end
	end
end

function _draw()
	cls(1)
	
	--draw hover gizmo
	if plr.hovered > 0 then
		local u=units[plr.hovered]
		rect(
			u.pos.x-1,
			u.pos.y-1,
			u.pos.x+u.size.x,
			u.pos.y+u.size.y,
			3)
	end
	
	--draw units
	for u in all(units) do
		u:draw()
	end
	
	--draw hp bars
	for u in all(units) do
		local w=u.size.x+1
		local h=2
		local x=u.pos.x-1
		local y=u.pos.y-h-2
		rectfill(x,y,x+w,y+h,0)
		local f=(w-1)*(u.hp/u.hpm)
		line(x+1,y+1,x+f,y+1,3)
	end
	
	--draw cursor
	spr(
		plr.mb+1,
		plr.mp.x-1,
		plr.mp.y-1)
end
-->8
--utils

vec={
	x=0,
	y=0,
}
vec.__index=vec

function vec:new(x,y)
	return setmetatable({
			x=x or 0, 
			y=y or 0,
		}, 
		self)
end

aabb={
	pos=vec:new(),
	size=vec:new(),
}
aabb.__index=aabb

function aabb:new(pos,size)
	return setmetatable({
			pos=pos or vec:new(),
			size=size or vec:new(),
		},
		self)
end

function aabb:contains(pos)
	return (
		pos.x>=self.pos.x and
		pos.x<=self.pos.x+self.size.x and
		pos.y>=self.pos.y and
		pos.y<=self.pos.y+self.size.y)
end
-->8
--unit

unit={
	pos=vec:new(),
	size=vec:new(8,8),
	sprite=0,
	hp=100,
	hpm=100,
}
unit.__index=unit

function unit:new(o)
	return setmetatable(
		o or {},
		self)
end

function unit:draw()
	spr(
		self.sprite,
		self.pos.x,
		self.pos.y)
end
__gfx__
000000000b0000000300000000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b3b000003b30000008888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700b33b00003bb3000088888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000b333b0003bbb300089888898000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000b3333b003bbbb30089988998000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700b3333b003bbbb30088888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b33bb0003bb3300008800880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000bb000000330000000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
