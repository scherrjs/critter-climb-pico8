pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--j scherrer
--ims 213 honors project
--scherrjs@miamioh.edu

function _init()
 cls(1)
--set initial values for screens
--difficulty, score, and music
 score=0
 gamestate=0
 diffmod=256
 applespeed=1
 birdspeed=1
 difficulty=1
 counter=0
 highscore=0
 music_on=false
--initialize the bird arrays
--for x,y,flip, and exist
--only 8 birds possible on
--screen at once
 bird_x={-8,-8,-8,-8,-8,-8,-8,-8}
 bird_y={-8,-8,-8,-8,-8,-8,-8,-8}
 bird_e={false,false,false,false,false,false,false,false}
 bird_flip={false,false,false,false,false,false,false,false}
--initialize same values for
--apples, only 16 on screen at
--once
 apple_x={-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8}
 apple_y={-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8}
 apple_e={false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false}
--place the branches used to
--make it look like moving up
 branch1=-32
 branch2=16
 branch3=64
 branch4=112
--initialize acorn values, only
--one on screen at a time
 acorn_x=-8
 acorn_y=-8
 acorn_e=false
--initialize squirrel values
 squirrel_x=64
 squirrel_y=64
 squirrel_flip=-1
--play menu chime
 sfx(4)
end
-->8
function _update()
--menu, start game
 if gamestate==0 then
  if btnp(5) then
   gamestate=1
   sfx(-1)
  end
--main game, start counter to
--space out birds, start music
 elseif gamestate==1 then
  counter+=1
  if music_on==false then
   music(0)
   music_on=true
  end
--handles movement based on
--direction
  if btnp(0) then
   smove(0)
  elseif btnp(1) then
   smove(1)
  elseif btnp(2) then
   smove(2)
--doesn't allow negative score
  elseif btnp(3) and score!=0 then
   smove(3)
  end
--checks for collisions with
--apples
  for i=1,16 do
   if apple_e[i] then
    if collide(squirrel_x,
    squirrel_y,8,16,apple_x[i],
    apple_y[i],8,8) then
     gamestate=2
     music(-1)
     sfx(8)
     sfx(7)
    end
   end
  end
--checks for collisions with
--birds
  for i=1,8 do
   if bird_e[i] then
    if collide(squirrel_x,
    squirrel_y,8,16,bird_x[i],
    bird_y[i],14,8) then
     gamestate=2
     music(-1)
     sfx(8)
     sfx(7)
    end
   end
  end
--checks for collisions with
--acorns=bonus points
  if acorn_e then
   if collide(squirrel_x,
   squirrel_y,8,16,acorn_x,
   acorn_y,8,8) then
    score+=50
    acorn_y=129
    sfx(3)
   end
  end
--loops branches
  branchflip()
--handles creation and movement
--of apples
  applecreate()
  applemove()
  applereset()
--handles creation and movement
--of birds
  birdcreate()
  birdmove()
  birdreset()
--handles creation and movement
--of birds
  acorncreate()
  acornmove()
  acornreset()
--checks for and changes
--difficulty
  diffcheck()
  diffupdate()
--resets values when game
--is restarted after losing
 else
  if btnp(5) then
   score=0
   gamestate=1
   diffmod=256
   applespeed=1
   birdspeed=1
   difficulty=1
   counter=0
   music_on=false
 
   bird_x={-8,-8,-8,-8,-8,-8,-8,-8}
   bird_y={-8,-8,-8,-8,-8,-8,-8,-8}
   bird_e={false,false,false,false,false,false,false,false}
   bird_flip={false,false,false,false,false,false,false,false}
 
   apple_x={-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8}
   apple_y={-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8}
   apple_e={false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false}
 
   branch1=-32
   branch2=16
   branch3=64
   branch4=112
 
   acorn_x=-8
   acorn_y=-8
   acorn_e=false
 
   squirrel_x=64
   squirrel_y=64
   squirrel_flip=-1
   
   sfx(-1)
  end
 end
end
-->8
function _draw()
--draws title
 if gamestate==0 then
  cls(4)
  print("critter climb",38,40,6)
  print("press ??? to start",30,70,6)
--draws main game, tree first
 elseif gamestate==1 then 
  cls(1)
  for row=0,15 do
   for col=4,11 do
    spr(7,col*8,row*8)
   end
  end
--draws squirrel, flipped or not
  if squirrel_flip==1 then
   spr(2,squirrel_x,squirrel_y,1,2)
  else
   spr(1,squirrel_x,squirrel_y,1,2)
  end
--draws branches
  spr(8,0,branch1,4,2,true)
  spr(8,96,branch2,4,2)
  spr(8,0,branch3,4,2,true)
  spr(8,96,branch4,4,2)
--draw apples, birds, and acorns
  appledraw()
  birddraw()
  acorndraw()
--draw score
  print("score: "..score,44,120,0)
--draw game over screen
 else
  cls(1)
  print("game over",46,40,9)
  if score>highscore then
   highscore=score
  end
  print("score: "..score,44,48,9)
  print("highscore: "..highscore,36,56,7)
  print("press ??? to play again",20,70,9)
 end
end
-->8
function smove(direct)
--handles squirrel movement
--based on direction
--left and right:
 if direct==0 then
  if squirrel_x!=32 then
   squirrel_x-=8
  end
 elseif direct==1 then
  if squirrel_x!=88 then
   squirrel_x+=8
  end
--up and down: moves everything
--except squirrel
 elseif direct==2 then
  score+=1
  branch1+=8
  branch2+=8
  branch3+=8
  branch4+=8
  appledown()
  acorndown()
  birddown()
  squirrel_flip=squirrel_flip*-1
 elseif direct==3 then
  score-=1
  branch1-=8
  branch2-=8
  branch3-=8
  branch4-=8
  appleup()
  acornup()
  birdup()
  squirrel_flip=squirrel_flip*-1
 end
 sfx(2)
end
--loops branches
function branchflip()
 if branch1==-72 then
  branch1=120
 elseif branch1==184 then
  branch1=-8
 end
 if branch2==-72 then
  branch2=120
 elseif branch2==184 then
  branch2=-8
 end
 if branch3==-72 then
  branch3=120
 elseif branch3==184 then
  branch3=-8
 end
 if branch4==-72 then
  branch4=120
 elseif branch4==184 then
  branch4=-8
 end
end
-->8
function applecreate()
--creates new falling apples
 local createcheck=false
--checks with all 16
 for i=1,16 do
--apple hasn't been created
--already
  if apple_e[i]==false and createcheck==false then
   local check = flr(rnd(256))+1
--higher difficulty=more apples
   if check%diffmod==0 then
--random position
    apple_x[i]=(flr(rnd(8))+4)*8
    apple_e[i]=true
--no more apples this frame
    createcheck=true
    sfx(0)
   end
  end
 end
end
--apples fall based on
--difficulty speed
function applemove()
 for i=1,16 do
  if apple_e[i] then
   apple_y[i]+=applespeed
  end
 end
end
--draws apples
function appledraw()
 for i=1,16 do
  if apple_e[i] then
   spr(3,apple_x[i],apple_y[i])
  end
 end
end
--resets apples off the screen
function applereset()
 for i=1,16 do
  if apple_e[i] then
   if apple_y[i]>=128 then
    apple_e[i]=false
    apple_y[i]=-8
   end
  end
 end
end
--moves apple with input
function appleup()
 for i=1,16 do
  if apple_e[i] then
   apple_y[i]-=8
  end
 end
end
--moves apple with input
function appledown()
 for i=1,16 do
  if apple_e[i] then
   apple_y[i]+=8
  end
 end
end
-->8
function diffcheck()
--checks if score has been
--reached to change difficulty
 if score<50 then
  difficulty=1
 elseif score<100 then
  difficulty=2
 elseif score<150 then
  difficulty=3
 elseif score<200 then
  difficulty=4
 elseif score<250 then
  difficulty=5
 elseif score<300 then
  difficulty=6
 else
  difficulty=7
 end
end

function diffupdate()
--changes associated check
--values to make enemies more
--common and faster at higher
--difficulties
 if difficulty==1 then
  diffmod=256
 elseif difficulty==2 then
  diffmod=128
  applespeed=2
 elseif difficulty==3 then
  diffmod=64
  birdspeed=2
 elseif difficulty==4 then
  diffmod=32
 elseif difficulty==5 then
  diffmod=16
  applespeed=3
  birdspeed=3
 elseif difficulty==6 then
  diffmod=8
 else
  diffmod=4
  applespeed=4
  birdspeed=4
 end
end
-->8
function birdcreate()
 local createcheck=false
 for i=1,8 do
--time between bird creation
  if bird_e[i]==false and createcheck==false and counter%15==0 then
   local check = flr(rnd(128))+1
--odds of bird based on
--difficulty
   if check%diffmod==0 then
--random y position
    bird_y[i]=(flr(rnd(16)))*8
--randomly coming from left 
--or right
    local bflip = flr(rnd(2))
    if bflip==1 then
     bird_flip[i]=true
     bird_x[i]=-16
    else
     bird_flip[i]=false
     bird_x[i]=128
    end
    bird_e[i]=true
    createcheck=true
    sfx(1)
   end
  end
 end
end
--moves bird based on difficulty
--speed
function birdmove()
 for i=1,8 do
  if bird_e[i] then
   if bird_flip[i] then
    bird_x[i]+=birdspeed
   else
    bird_x[i]-=birdspeed
   end
  end
 end
end
--draws bird
function birddraw()
 for i=1,8 do
  if bird_e[i] then
   spr(5,bird_x[i],bird_y[i],2,1,bird_flip[i])
  end
 end
end
--resets bird off the screen
function birdreset()
 for i=1,8 do
  if bird_e[i] then
   if bird_x[i]>=128 or bird_x[i]<=-16 then
    bird_e[i]=false
   end
  end
 end
end
--moves bird with input
function birdup()
 for i=1,8 do
  if bird_e[i] then
   bird_y[i]-=8
  end
 end
end
--moves bird with input
function birddown()
 for i=1,16 do
  if bird_e[i] then
   bird_y[i]+=8
  end
 end
end
-->8
function acorncreate()
 if acorn_e==false then
--randomly creates acorn:
--fairly uncommon
  local check = flr(rnd(1024))+1
  if check==1023 then
--random falling position
   acorn_x=(flr(rnd(8))+4)*8
   acorn_e=true
   sfx(0)
  end
 end
end
--acorn always falls at same
--speed
function acornmove()
 if acorn_e then
  acorn_y+=1
 end
end
--draw acorn
function acorndraw()
 if acorn_e then
  spr(4,acorn_x,acorn_y)
 end
end
--resets acorn off screen
function acornreset()
 if acorn_e then
  if acorn_y>=128 then
   acorn_e=false
   acorn_y=-8
  end
 end
end
--moves acorn with input
function acornup()
 if acorn_e then
  acorn_y-=8
 end
end
--moves acorn with input
function acorndown()
 if acorn_e then
  acorn_y+=8
 end
end
-->8
function collide(
 x1,y1,
 w1,h1,
 x2,y2,
 w2,h2)
 
--collision function - checks
--if the distance between
--center of object bounding
--boxes is less than their
--half-widths and half-heights
--combined
 local xd=abs((x1+(w1/2))-(x2+(w2/2)))
 local xs=w1*0.5+w2*0.5
 local yd=abs((y1+(h1/2))-(y2+(h2/2)))
 local ys=h1/2+h2/2
--if the objects collide,
--return true
 if xd<xs and yd<ys then 
  return true 
 else
  return false
 end
end
__gfx__
0000000000011000000110000000300000009000000000000ccc00004f444f440000000000000000000000000000000000000000000000000000000000000000
0000000000722700007227000004000005555550000cc000ccc00a004f444f444444000000044440000000000000000000000000000000000000000000000000
007007000222222002222220008488005555555500c77c0ccccaa00044f444f44444444444444444000000000000000000000000000000000000000000000000
000770000021120000211200088878800999999000cd7cccccc00a0044f44f444444444444444444444000000000000000000000000000000000000000000000
0007700000211201102112000888878009999990099cccccccc00a0044f44f444444444444444444444444400000000000000000000000000000000000000000
00700700102112200221120108888880099999900000000ccccaa00044f444f44444444444444444444444444400044000000000000000000000000000000000
000000000221120000211220088888800099990000000000ccc00a004f444f444444444444444444444444444444444400000000000000000000000000000000
0000000000211200002112000088880000099000000000000ccc00004f4444f44444444444444444444444444444444400000000000000000000000000000000
00000000002112200221120000000000000000000000000000000000000000004444444444444444444444444444444400000000000000000000000000000000
00000000022112022021122000000000000000000000000000000000000000004444444444444444444444444444444400000000000000000000000000000000
00000000202112011021120200000000000000000000000000000000000000004444444444444444444444444444440000000000000000000000000000000000
00000000100220000002200100000000000000000000000000000000000000004444444444444444444444444444000000000000000000000000000000000000
00000000000220000002200000000000000000000000000000000000000000004444444444440000004444440000000000000000000000000000000000000000
00000000000110000001100000000000000000000000000000000000000000004444444444400000000000000000000000000000000000000000000000000000
00000000001110000001110000000000000000000000000000000000000000004444400000000000000000000000000000000000000000000000000000000000
00000000001100000000110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010800003701435011340113201100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010b00001f5241e5211d5211c5211b5211a52119521195211a5211b5211c5211d5210000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010200000273500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01100000240262602628026290262b025000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000002402025020000000000021020200201f02000000180201a0201c0201d0201d0201d020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000071500000016130000000715000000161300000007150000001613000000071500000016130161300715000000161300000007150000001613016030071500000016130000000715000000161301613
01100000240102601027010280100000027010260100000026010270102801029010000002801027010000002b01006000290100000028010272002601000000240102601028010290102b010290102801026010
0114000011542105420f5420e5420d5420d5420d5420d5420d5420d5420d542000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010500000477103771027710277200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
03 05064344

