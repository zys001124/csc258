#####################################################################
#
# CSC258 Summer 2021 Assembly Final Project
# University of Toronto
#
# Student: Yaosheng Zhang, Student Number: 1005062487, UTorID: zhan6444
#
# Bitmap Display Configuration:
# -Unit width in pixels: 4
# -Unit height in pixels: 4
# -Display width in pixels: 512
# -Display height in pixels: 256
# -Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# -Milestone 3
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features)
# 1. A scoring system, which would add one point each time the monster eats a planet(green obstacle).
# 2. An increasing difficulty where the damaging obstacles(missiles and asteroids) would move faster when the score reach certain points.
# 3. A damaging obstacle(missiles) that move in unnatural way.
#
# Link to video demonstration for final submission:
# https://play.library.utoronto.ca/watch/85fc8a3277462f5836ea3a366361f501
#
# Are you OK with us sharing the video with people outside course staff?
# -yes
#
# Any additional information that the TA needs to know:
# /
#
#####################################################################


.eqv BASE_ADDRESS 0x10008000 # 268468224

.eqv red 0xff0000
.eqv green 0x00ff00
.eqv blue 0x8fd3fe
.eqv white -1
.eqv grey 0x415570
.eqv BLACK 0

.eqv healthOne 268469320 # 0x10008000 + (3 *128 + 3) * 4  
.eqv healthTwo 268469364
.eqv healthThree 268469408
.eqv healthFour 268469452
.eqv healthFive 268469496
.eqv healthSix 268469540
.eqv HpWord 268469252

# Score first number location :(50,35) 
.eqv S1X 50
.eqv SY 35
# Score second number location :(58,35)
.eqv S2X 58

# Planet data
.eqv planetVX -1

# first score number location (107,1) 
# second score number location (115,1)
.eqv SP1X 107
.eqv SP2X 115
.eqv SPY 1

.data 
frameBuffer: 	.space 	0x80000		#512 wide x 256 high pixels
MONSTERX: .word 4 # the most upper and left point of the monster (4,31) hex: 268483604
MONSTERY: .word 31
MXV: .word 0 # monster's x velocity
MYV: .word 0 # monster's y velocity
health: .word 6 # monster's hp
score: .word 0 # the player's score
counter1: .word 0 # one counter
counter2: .word 0 # ten counter

### Constant dificulty, so constant number of obstacles
### Obstacles data (location)

## First planet
# All set to 0 for later replacement with random value
P1Y: .word 0 # the highest pixel location (x,y)
P1X: .word 65 

P2Y: .word 0
P2X: .word 100


## First missile
# All set to 0 for later replacement with random value
M1Y: .word 0 # left most pixel
M1X: .word 120 
missile1VY: .word 0 # set to 0 initially

M2X: .word 75
M2Y: .word 0
missile2VY: .word 0

# Missile data
missileVX: .word -4

## First asteroid s
# All set to 0 for later replacement with random value
A1Y: .word 0 ## (x,y) at is the highest pixel at the most left column
A1X: .word 115 

A2X: .word 80
A2Y: .word 0

A3X: .word 90
A3Y: .word 0

# asteroid data
asteroidVX: .word -2

.text

main:

### BACKGROUND OF THE GAME WILL BE BLACK WHICH WOULD NOT NEED AND FURTHER ALTERCATION

### DRAW THE SCORE AND HP SECTION OF THE GAME
### BOTTOM OF THE SCREEN, 512 LENGTH AND  WIDTH
### each row has 512/4 * 4 = 512 bytes
### each column has 256/4 * 4 = 256 bytes 

	li	$t0, BASE_ADDRESS	# load address of top left corner.
	addi	$t1, $zero, 1152	# t1 = 128 * 9 row
	li 	$t2, 0x415570		# load color grey
drawTopSection:
	sw	$t2, 0($t0)		# color Pixel gery
	addi	$t0, $t0, 4		# go to next pixel
	addi	$t1, $t1, -1		# decrease pixel count
	bnez	$t1, drawTopSection	# repeat unitl pixel count == 0
	
### HP display
### TOTAL OF SIX HP BAR
### EACH WOULD HAVE ITS TOP-LEFT CORNER ADDRESS STORED IN DATA
### HEALTH BAR: 5 x 8, 2 FOR GAP BETWEEN EACH BAR, TOP LEAVE OUT 3 AND BOTTOM LEAVE OUT 2, Left leave out 3

# Health bar one
	li $t0, healthOne
	addi $t1, $zero, 40 		# 40 pixels in total, total pixel counter $t1
	li $t2, 8			# width counter $t2
	li $t3, green			# load color green as initial health bar color in $t3
	jal drawHealthBarX
	
# Health bar two
	li $t0, healthTwo
	addi $t1, $zero, 40 		
	li $t2, 8			
	jal drawHealthBarX


# Health bar three
	
	li $t0, healthThree
	addi $t1, $zero, 40 		
	li $t2, 8
	jal drawHealthBarX

# Health bar four
	
	li $t0, healthFour
	addi $t1, $zero, 40 		
	li $t2, 8
	jal drawHealthBarX

# Health bar five
	
	li $t0, healthFive
	addi $t1, $zero, 40 		
	li $t2, 8
	jal drawHealthBarX
	
# Health bar six
	
	li $t0, healthSix
	addi $t1, $zero, 40 		
	li $t2, 8
	jal drawHealthBarX

### WORD HP
# H
	li $t0, red ## color red
	li $a0, 3
	li $a1, 1
	li $a2, 2
	li $a3, 5
	jal rectangle

	li $a0, 6
	li $a1, 1
	li $a2, 2
	li $a3, 5
	jal rectangle
	
	li $a0, 3
	li $a1, 3
	li $a2, 4
	li $a3, 1
	jal rectangle

# P
	li $a0, 9
	li $a1, 1
	li $a2, 2
	li $a3, 5
	jal rectangle
	
	li $a0, 9
	li $a1, 3
	li $a2, 2
	li $a3, 1
	jal rectangle
	
	li $a0, 9
	li $a1, 3
	li $a2, 4
	li $a3, 1
	jal rectangle
	
	li $a0, 12
	li $a1, 1
	li $a2, 2
	li $a3, 3
	jal rectangle


### Nicer top part (more color?)
	
	li $s2, 9
	li $s1, 0
	
slide:
	li $t0, -1 
	li $a0, 100
	mul $s3, $s1, 1
	sub $a0, $a0, $s3
	li $a1, 2
	li $a2, 0
	add $a2, $a2, $s1
	li $a3, 1
	jal rectangle
	addi $s2, $s2, -1
	addi $s1, $s1, 1
	bnez $s2, slide
	

### Initialize Score display
### AT THE START OF THE GAME, THE SCORE IS FIRST SET TO ZERO AT THE SECOND NUMBER LOCATION
	
	li $s0, SP2X # second score number location (115,1)
	li $s1, SPY
	jal drawZero
	
	li $s0, SP1X # second score number location (107,1)
	li $s1, SPY
	jal drawZero
	
	## generate random number for A1Y
	li $a1, 37 # set upper bound
	jal generateRandom
	add $t1, $a0, $zero # t0 = y position of the obstacle
	addi $t1, $t1, 13
	sw $t1, A1Y # save the random Y value to memory 
	
	## generate random number for A2Y
	li $a1, 37 # set upper bound
	jal generateRandom
	add $t1, $a0, $zero # t0 = y position of the obstacle
	addi $t1, $t1, 13
	sw $t1, A2Y # save the random Y value to memory 
	
	## generate random number for A3Y
	li $a1, 37 # set upper bound
	jal generateRandom
	add $t1, $a0, $zero # t0 = y position of the obstacle
	addi $t1, $t1, 13
	sw $t1, A3Y # save the random Y value to memory 
	
	li $t0, white # load color white
	jal drawA
	
	## generate random number for P1Y
	li $a1, 38 # set upper bound
	jal generateRandom
	add $t1, $a0, $zero # t0 = y position of the obstacle
	addi $t1, $t1, 10
	sw $t1, P1Y # save the random Y value to memory 
	
	## generate random number for P2Y
	li $a1, 38 # set upper bound
	jal generateRandom
	add $t1, $a0, $zero # t0 = y position of the obstacle
	addi $t1, $t1, 10
	sw $t1, P2Y # save the random Y value to memory 
	
	li $t0, green # load color green
	jal drawP
	
	## generate random number for M1Y
	li $a1, 30 # set upper bound
	jal generateRandom
	add $t1, $a0, $zero # t0 = y position of the obstacle
	addi $t1, $t1, 21
	sw $t1, M1Y # save the random Y value to memory 
	
	## generate random number for M2Y
	li $a1, 30 # set upper bound
	jal generateRandom
	add $t1, $a0, $zero # t0 = y position of the obstacle
	addi $t1, $t1, 21
	sw $t1, M2Y # save the random Y value to memory 
	
	li $t0, blue # load color blue
	jal drawM
	
	li $t0, red # load color red for drawing the monster
	jal drawMonster
	
	### Sleep for 66 ms so frame rate is about 15
	addi	$v0, $zero, 32	# syscall sleep
	addi	$a0, $zero, 66	# 66 ms
	syscall
	
gameUpdateLoop:
	li $t0, grey
	li $a0, 107
	li $a1,	5
	li $a2, 1
	li $a3, 7
	jal rectangle
	li $a0, 115
	li $a1,	5
	li $a2, 1
	li $a3, 7
	jal rectangle
	
	li $t0, white
	jal updateScoreO # update score 
	jal updateScoreT
	
	lw	$t3, 0xffff0004		# get keypress from keyboard input
	beq	$t3, 100, moveRight	# if key press = 'd' branch to moveright
	beq	$t3, 97,  moveLeft	# else if key press = 'a' branch to moveLeft
	beq	$t3, 119, moveUp	# if key press = 'w' branch to moveUp
	beq	$t3, 115, moveDown	# else if key press = 's' branch to moveDown
	beq 	$t3, 112, restart	# restart the game 'p'
	
	jal updateA # update asteroids
	jal updateP # update planets
	jal updateM # update missiles
	
	### Sleep for 66 ms so frame rate is about 15
	addi	$v0, $zero, 32	# syscall sleep
	addi	$a0, $zero, 45	# 45 ms
	syscall
	
	j gameUpdateLoop

moveLeft:
addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
sw 	$fp, 0($sp)	# store caller's frame pointer
sw 	$ra, 4($sp)	# store caller's return address
addiu 	$fp, $sp, 20	# setup frame pointer

li $t0, BLACK # load color black for erasing the old monster
jal drawMonster
li $t1, -5 # new velocity x 
sw $t1, MXV # save new x velocity in the memory

lw $t2, MONSTERX
add $t2, $t2, $t1
bltz $t2, moveLeftEdge

li $t0, red # load color red for updated monster
jal drawMonster


li $t1, -5
lw $t2, MONSTERX
add $t1, $t1, $t2
sw $t1, MONSTERX

sw $zero, MXV # save new x velocity in the memory
sw $zero, 0xffff0004 # reset keyboard value

lw 	$ra, 4($sp)	# load caller's return address
lw 	$fp, 0($sp)	# restores caller's frame pointer
addiu 	$sp, $sp, 24	# restores caller's stack pointer
jr 	$ra		# return to caller's code

moveLeftEdge:
sw $zero, MXV # save new x velocity in the memory

li $t1, 3
sw $t1, MONSTERX

li $t0, red # load color red for updated monster
jal drawMonster

sw $zero, 0xffff0004 # reset keyboard value

lw 	$ra, 4($sp)	# load caller's return address
lw 	$fp, 0($sp)	# restores caller's frame pointer
addiu 	$sp, $sp, 24	# restores caller's stack pointer
jr 	$ra		# return to caller's code


moveRight:
addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
sw 	$fp, 0($sp)	# store caller's frame pointer
sw 	$ra, 4($sp)	# store caller's return address
addiu 	$fp, $sp, 20	# setup frame pointer

li $t0, BLACK # load color black for erasing the old monster
jal drawMonster
li $t1, 5 # new velocity x 
sw $t1, MXV # save new x velocity in the memory

lw $t2, MONSTERX
add $t2, $t2, $t1
li $t5, 121
bgt $t2, $t5, moveRightEdge

li $t0, red # load color white for updated monster
jal drawMonster


li $t1, 5
lw $t2, MONSTERX
add $t1, $t1, $t2
sw $t1, MONSTERX

sw $zero, MXV # save new x velocity in the memory
sw $zero, 0xffff0004 # reset keyboard value

lw 	$ra, 4($sp)	# load caller's return address
lw 	$fp, 0($sp)	# restores caller's frame pointer
addiu 	$sp, $sp, 24	# restores caller's stack pointer
jr 	$ra		# return to caller's code

moveRightEdge:
sw $zero, MXV # save new x velocity in the memory

li $t1, 121
sw $t1, MONSTERX

li $t0, red # load color red for updated monster
jal drawMonster

sw $zero, 0xffff0004 # reset keyboard value

lw 	$ra, 4($sp)	# load caller's return address
lw 	$fp, 0($sp)	# restores caller's frame pointer
addiu 	$sp, $sp, 24	# restores caller's stack pointer
jr 	$ra		# return to caller's code


moveUp:
addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
sw 	$fp, 0($sp)	# store caller's frame pointer
sw 	$ra, 4($sp)	# store caller's return address
addiu 	$fp, $sp, 20	# setup frame pointer

li $t0, BLACK # load color black for erasing the old monster
jal drawMonster
li $t1, -5 # new velocity Y 
sw $t1, MYV # save new Y velocity in the memory

lw $t2, MONSTERY
add $t2, $t2, $t1
li $t5, 9
blt $t2, $t5, moveUpEdge

li $t0, red # load color white for updated monster
jal drawMonster


li $t1, -5
lw $t2, MONSTERY
add $t1, $t1, $t2
sw $t1, MONSTERY

sw $zero, MYV # save new Y velocity in the memory
sw $zero, 0xffff0004 # reset keyboard value

lw 	$ra, 4($sp)	# load caller's return address
lw 	$fp, 0($sp)	# restores caller's frame pointer
addiu 	$sp, $sp, 24	# restores caller's stack pointer
jr 	$ra		# return to caller's code

moveUpEdge:
sw $zero, MYV # save new x velocity in the memory

li $t1, 9
sw $t1, MONSTERY

li $t0, red # load color red for updated monster
jal drawMonster

sw $zero, 0xffff0004 # reset keyboard value

lw 	$ra, 4($sp)	# load caller's return address
lw 	$fp, 0($sp)	# restores caller's frame pointer
addiu 	$sp, $sp, 24	# restores caller's stack pointer
jr 	$ra		# return to caller's code

moveDown:
addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
sw 	$fp, 0($sp)	# store caller's frame pointer
sw 	$ra, 4($sp)	# store caller's return address
addiu 	$fp, $sp, 20	# setup frame pointer

li $t0, BLACK # load color black for erasing the old monster
jal drawMonster
li $t1, 5 # new velocity Y 
sw $t1, MYV # save new Y velocity in the memory

lw $t2, MONSTERY
add $t2, $t2, $t1
li $t5, 57
bgt $t2, $t5, moveDownEdge

li $t0, red # load color white for updated monster
jal drawMonster


li $t1, 5
lw $t2, MONSTERY
add $t1, $t1, $t2
sw $t1, MONSTERY

sw $zero, MYV # save new Y velocity in the memory
sw $zero, 0xffff0004 # reset keyboard value

lw 	$ra, 4($sp)	# load caller's return address
lw 	$fp, 0($sp)	# restores caller's frame pointer
addiu 	$sp, $sp, 24	# restores caller's stack pointer
jr 	$ra		# return to caller's code

moveDownEdge:
sw $zero, MYV # save new x velocity in the memory

li $t1, 57
sw $t1, MONSTERY

li $t0, red # load color red for updated monster
jal drawMonster

sw $zero, 0xffff0004 # reset keyboard value

lw 	$ra, 4($sp)	# load caller's return address
lw 	$fp, 0($sp)	# restores caller's frame pointer
addiu 	$sp, $sp, 24	# restores caller's stack pointer
jr 	$ra		# return to caller's code

restart:
	li $t5, 6
	sw $t5, health
	sw $zero, score 	
	sw $zero, counter1
	sw $zero, counter2
	li 	$t0, BASE_ADDRESS	# load base address
	li 	$t1, 8192		# save 512*256 pixels
	li 	$t2, 0			# load black color
bLAck:
	sw   	$t2, 0($t0)
	addi 	$t0, $t0, 4 	# advance to next pixel position in display
	addi 	$t1, $t1, -1	# decrement number of pixels
	bnez 	$t1, bLAck	# repeat while number of pixels is not zero
sw $0, 0xffff0004
j main

drawMonster:
addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
sw 	$fp, 0($sp)	# store caller's frame pointer
sw 	$ra, 4($sp)	# store caller's return address
addiu 	$fp, $sp, 20	# setup frame pointer

## velocity added
lw $s1, MXV
lw $s2, MYV

lw $a0, MONSTERX
add $a0, $a0, $s1
li $a1, 4
lw $a2, MONSTERY
add $a2, $a2, $s2
li $a3, 2
jal rectangle 

lw $a0, MONSTERX
addi $a0, $a0, 1
add $a0, $a0, $s1
li $a1, 2
lw $a2, MONSTERY
addi $a2, $a2, 2
add $a2, $a2, $s2
li $a3, 2
jal rectangle 

lw $a0, MONSTERX
add $a0, $a0, $s1
li $a1, 1
lw $a2, MONSTERY
addi $a2, $a2, 3
add $a2, $a2, $s2
li $a3, 2
jal rectangle 

lw $a0, MONSTERX
addi $a0, $a0, 3
add $a0, $a0, $s1
li $a1, 1
lw $a2, MONSTERY
addi $a2, $a2, 3
add $a2, $a2, $s2
li $a3, 2
jal rectangle 

lw $a0, MONSTERX
addi $a0, $a0, -1
add $a0, $a0, $s1
li $a1, 1
lw $a2, MONSTERY
addi $a2, $a2, 1
add $a2, $a2, $s2
li $a3, 5
jal rectangle 

lw $a0, MONSTERX
addi $a0, $a0, 4
add $a0, $a0, $s1
li $a1, 1
lw $a2, MONSTERY
addi $a2, $a2, 1
add $a2, $a2, $s2
li $a3, 5
jal rectangle 

lw $a0, MONSTERX
add $a0, $a0, $s1
li $a1, 4
lw $a2, MONSTERY
addi $a2, $a2, 5
add $a2, $a2, $s2
li $a3, 1
jal rectangle 

lw $a0, MONSTERX
addi $a0, $a0, -2
add $a0, $a0, $s1
li $a1, 1
lw $a2, MONSTERY
addi $a2, $a2, 2
add $a2, $a2, $s2
li $a3, 2
jal rectangle 

lw $a0, MONSTERX
addi $a0, $a0, 5
add $a0, $a0, $s1
li $a1, 1
lw $a2, MONSTERY
addi $a2, $a2, 2
add $a2, $a2, $s2
li $a3, 2
jal rectangle 

lw $a0, MONSTERX
addi $a0, $a0, 6
add $a0, $a0, $s1
li $a1, 1
lw $a2, MONSTERY
addi $a2, $a2, 3
add $a2, $a2, $s2
li $a3, 4
jal rectangle 

lw $a0, MONSTERX
addi $a0, $a0, -3
add $a0, $a0, $s1
li $a1, 1
lw $a2, MONSTERY
addi $a2, $a2, 3
add $a2, $a2, $s2
li $a3, 4
jal rectangle 

lw $a0, MONSTERX
add $a0, $a0, $s1
li $a1, 1
lw $a2, MONSTERY
addi $a2, $a2, 6
add $a2, $a2, $s2
li $a3, 1
jal rectangle 

lw $a0, MONSTERX
addi $a0, $a0, 3
add $a0, $a0, $s1
li $a1, 1
lw $a2, MONSTERY
addi $a2, $a2, 6
add $a2, $a2, $s2
li $a3, 1
jal rectangle 

### Sleep for 66 ms so frame rate is about 15
	addi	$v0, $zero, 32	# syscall sleep
	addi	$a0, $zero, 30	# 30 ms
	syscall

lw 	$ra, 4($sp)	# load caller's return address
lw 	$fp, 0($sp)	# restores caller's frame pointer
addiu 	$sp, $sp, 24	# restores caller's stack pointer
jr 	$ra		# return to caller's code


drawM: # Missiles
	# height: 3
	# length: 5

	addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
	sw 	$fp, 0($sp)	# store caller's frame pointer
	sw 	$ra, 4($sp)	# store caller's return address
	addiu 	$fp, $sp, 20	# setup frame pointer

### M1:
	lw $a0, M1X
	li $a1, 1
	lw $a2, M1Y
	li $a3, 1
	jal rectangle 
	
	lw $a0, M1X
	addi $a0, $a0, 1
	li $a1, 1
	lw $a2, M1Y
	addi $a2, $a2, -1
	li $a3, 3
	jal rectangle
	
	lw $a0, M1X
	addi $a0, $a0, 2
	li $a1, 4
	lw $a2, M1Y
	li $a3, 1
	jal rectangle  
	
### M2: 
	lw $a0, M2X
	li $a1, 1
	lw $a2, M2Y
	li $a3, 1
	jal rectangle 
	
	lw $a0, M2X
	addi $a0, $a0, 1
	li $a1, 1
	lw $a2, M2Y
	addi $a2, $a2, -1
	li $a3, 3
	jal rectangle
	
	lw $a0, M2X
	addi $a0, $a0, 2
	li $a1, 4
	lw $a2, M2Y
	li $a3, 1
	jal rectangle  
	
	lw 	$ra, 4($sp)	# load caller's return address
	lw 	$fp, 0($sp)	# restores caller's frame pointer
	addiu 	$sp, $sp, 24	# restores caller's stack pointer
	jr 	$ra		# return to caller's code

updateM: # update the missiles movement

	addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
	sw 	$fp, 0($sp)	# store caller's frame pointer
	sw 	$ra, 4($sp)	# store caller's return address
	addiu 	$fp, $sp, 20	# setup frame pointer
	
	## velocity added
	lw $t1, score
	li $t2, 10
	bge $t1, $t2, doubleMVX
rtM:
	
	lw $s0, missileVX

	li $t0, BLACK
	jal drawM
	
	lw $s1, M1X
	add $s1, $s1, $s0
	ble $s1, $zero, resetM1XY
	sw $s1, M1X
	
	lw $s1, M2X
	add $s1, $s1, $s0
	ble $s1, $zero, resetM2XY
	sw $s1, M2X
	
	### generate a random number to determine whether the missile would go up or down
	li $a1, 2 # set upper bound
	li $v0, 42
	li $a0, 0
	syscall
	add $t9, $a0, $zero # t0 = y position of the obstacle
	beq $t9, $zero, updateMup # up for missile one and down for missile two
	bne $t9, $zero, updateMdown # down for missile two and up for missile one
	
updateMup:
	li $t7, -3
	sw $t7, missile1VY
	lw $t1, score
	li $t2, 10
	bge $t1, $t2, doubleMVYup1
rtupMY1:
	
	li $t7, 3
	sw $t7, missile2VY
	lw $t1, score
	li $t2, 10
	bge $t1, $t2, doubleMVYup2
rtupMY2:
	
	lw $s2, missile1VY
	lw $t8, M1Y
	add $t8, $t8, $s2
	li $t6, 12
	ble $t8, $t6, resetM1XY
	li $t6, 63
	bge $t8, $t6, resetM1XY
	sw $t8, M1Y
	
	lw $s2, missile2VY
	lw $t8, M2Y
	add $t8, $t8, $s2
	li $t6, 12
	ble $t8, $t6, resetM2XY
	li $t6, 63
	bge $t8, $t6, resetM2XY
	sw $t8, M2Y
	
	jal checkMC
	
	li $t0, blue
	jal drawM
	
	j gameUpdateLoop

updateMdown:
	li $t7, 3
	sw $t7, missile1VY
	lw $t1, score
	li $t2, 10
	bge $t1, $t2, doubleMVYdown1
rtdownMY1:
	
	li $t7, -3
	sw $t7, missile2VY
	lw $t1, score
	li $t2, 10
	bge $t1, $t2, doubleMVYdown2

rtdownMY2:
		
	lw $s2, missile1VY
	lw $t8, M1Y
	add $t8, $t8, $s2
	li $t6, 12
	ble $t8, $t6, resetM1XY
	li $t6, 63
	bge $t8, $t6, resetM1XY
	lw $s2, missile2VY
	lw $t8, M2Y
	add $t8, $t8, $s2
	li $t6, 12
	ble $t8, $t6, resetM2XY
	li $t6, 63
	bge $t8, $t6, resetM2XY
	
	jal checkMC
	
	li $t0, blue
	jal drawM
	
	j gameUpdateLoop

	
			
resetM1XY:
	addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
	sw 	$fp, 0($sp)	# store caller's frame pointer
	sw 	$ra, 4($sp)	# store caller's return address
	addiu 	$fp, $sp, 20	# setup frame pointer

	li $s3, 129
	sw $s3, M1X
	## generate random number for M1Y
	li $a1, 30 # set upper bound
	jal generateRandom
	add $t1, $a0, $zero # t0 = y position of the obstacle
	addi $t1, $t1, 21
	sw $t1, M1Y # save the random Y value to memory 
	
	lw 	$ra, 4($sp)	# load caller's return address
	lw 	$fp, 0($sp)	# restores caller's frame pointer
	addiu 	$sp, $sp, 24	# restores caller's stack pointer
	jr $ra

resetM2XY:
	addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
	sw 	$fp, 0($sp)	# store caller's frame pointer
	sw 	$ra, 4($sp)	# store caller's return address
	addiu 	$fp, $sp, 20	# setup frame pointer

	li $s3, 129
	sw $s3, M2X
	## generate random number for M1Y
	li $a1, 30 # set upper bound
	jal generateRandom
	add $t1, $a0, $zero # t0 = y position of the obstacle
	addi $t1, $t1, 21
	sw $t1, M2Y # save the random Y value to memory 
	
	lw 	$ra, 4($sp)	# load caller's return address
	lw 	$fp, 0($sp)	# restores caller's frame pointer
	addiu 	$sp, $sp, 24	# restores caller's stack pointer
	jr $ra
	
checkMC:
	addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
	sw 	$fp, 0($sp)	# store caller's frame pointer
	sw 	$ra, 4($sp)	# store caller's return address
	addiu 	$fp, $sp, 20	# setup frame pointer
	
	lw $a0, M1X
	li $a1, 1
	lw $a2, M1Y
	li $a3, 1
	jal checkM1Collision 
	
	lw $a0, M1X
	addi $a0, $a0, 1
	li $a1, 1
	lw $a2, M1Y
	addi $a2, $a2, -1
	li $a3, 3
	jal checkM1Collision
	
	lw $a0, M1X
	addi $a0, $a0, 2
	li $a1, 4
	lw $a2, M1Y
	li $a3, 1
	jal checkM1Collision  
	
### M2: 
	lw $a0, M2X
	li $a1, 1
	lw $a2, M2Y
	li $a3, 1
	jal checkM2Collision 
	
	lw $a0, M2X
	addi $a0, $a0, 1
	li $a1, 1
	lw $a2, M2Y
	addi $a2, $a2, -1
	li $a3, 3
	jal checkM2Collision
	
	lw $a0, M2X
	addi $a0, $a0, 2
	li $a1, 4
	lw $a2, M2Y
	li $a3, 1
	jal checkM2Collision  
	
	lw 	$ra, 4($sp)	# load caller's return address
	lw 	$fp, 0($sp)	# restores caller's frame pointer
	addiu 	$sp, $sp, 24	# restores caller's stack pointer
	jr 	$ra		# return to caller's code
	
drawA: # Asteroid
	# height: 5
	# length: 6

	addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
	sw 	$fp, 0($sp)	# store caller's frame pointer
	sw 	$ra, 4($sp)	# store caller's return address
	addiu 	$fp, $sp, 20	# setup frame pointer
	 
### A1
	lw $a0, A1X
	li $a1, 1
	lw $a2, A1Y
	li $a3, 2
	jal rectangle 
	
	lw $a0, A1X
	addi $a0, $a0, 1
	li $a1, 2
	lw $a2, A1Y
	addi $a2, $a2, 2
	li $a3, 1
	jal rectangle 
	
	lw $a0, A1X
	addi $a0, $a0, 3
	li $a1, 1
	lw $a2, A1Y
	addi $a2, $a2, 1
	li $a3, 1
	jal rectangle 
	
	lw $a0, A1X
	addi $a0, $a0, 4
	li $a1, 1
	lw $a2, A1Y
	addi $a2, $a2, -3
	li $a3, 4
	jal rectangle 
	
	lw $a0, A1X
	addi $a0, $a0, 3
	li $a1, 1
	lw $a2, A1Y
	addi $a2, $a2, -3
	li $a3, 1
	jal rectangle 
	
	lw $a0, A1X
	addi $a0, $a0, 2
	li $a1, 1
	lw $a2, A1Y
	addi $a2, $a2, -2
	li $a3, 1
	jal rectangle
	
	lw $a0, A1X
	addi $a0, $a0, 1
	li $a1, 1
	lw $a2, A1Y
	addi $a2, $a2, -1
	li $a3, 1
	jal rectangle 
	
### A2:
	lw $a0, A2X
	li $a1, 1
	lw $a2, A2Y
	li $a3, 2
	jal rectangle 
	
	lw $a0, A2X
	addi $a0, $a0, 1
	li $a1, 2
	lw $a2, A2Y
	addi $a2, $a2, 2
	li $a3, 1
	jal rectangle 
	
	lw $a0, A2X
	addi $a0, $a0, 3
	li $a1, 1
	lw $a2, A2Y
	addi $a2, $a2, 1
	li $a3, 1
	jal rectangle 
	
	lw $a0, A2X
	addi $a0, $a0, 4
	li $a1, 1
	lw $a2, A2Y
	addi $a2, $a2, -3
	li $a3, 4
	jal rectangle 
	
	lw $a0, A2X
	addi $a0, $a0, 3
	li $a1, 1
	lw $a2, A2Y
	addi $a2, $a2, -3
	li $a3, 1
	jal rectangle 
	
	lw $a0, A2X
	addi $a0, $a0, 2
	li $a1, 1
	lw $a2, A2Y
	addi $a2, $a2, -2
	li $a3, 1
	jal rectangle
	
	lw $a0, A2X
	addi $a0, $a0, 1
	li $a1, 1
	lw $a2, A2Y
	addi $a2, $a2, -1
	li $a3, 1
	jal rectangle

### A3:
	lw $a0, A3X
	li $a1, 1
	lw $a2, A3Y
	li $a3, 2
	jal rectangle 
	
	lw $a0, A3X
	addi $a0, $a0, 1
	li $a1, 2
	lw $a2, A3Y
	addi $a2, $a2, 2
	li $a3, 1
	jal rectangle 
	
	lw $a0, A3X
	addi $a0, $a0, 3
	li $a1, 1
	lw $a2, A3Y
	addi $a2, $a2, 1
	li $a3, 1
	jal rectangle 
	
	lw $a0, A3X
	addi $a0, $a0, 4
	li $a1, 1
	lw $a2, A3Y
	addi $a2, $a2, -3
	li $a3, 4
	jal rectangle 
	
	lw $a0, A3X
	addi $a0, $a0, 3
	li $a1, 1
	lw $a2, A3Y
	addi $a2, $a2, -3
	li $a3, 1
	jal rectangle 
	
	lw $a0, A3X
	addi $a0, $a0, 2
	li $a1, 1
	lw $a2, A3Y
	addi $a2, $a2, -2
	li $a3, 1
	jal rectangle
	
	lw $a0, A3X
	addi $a0, $a0, 1
	li $a1, 1
	lw $a2, A3Y
	addi $a2, $a2, -1
	li $a3, 1
	jal rectangle
	
	lw 	$ra, 4($sp)	# load caller's return address
	lw 	$fp, 0($sp)	# restores caller's frame pointer
	addiu 	$sp, $sp, 24	# restores caller's stack pointer
	jr 	$ra		# return to caller's code	

updateA: # update the asteroids movement

	addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
	sw 	$fp, 0($sp)	# store caller's frame pointer
	sw 	$ra, 4($sp)	# store caller's return address
	addiu 	$fp, $sp, 20	# setup frame pointer
	
	## velocity added
	lw $t1, score
	li $t2, 10
	bge $t1, $t2, doubleAVX
rtA:
	lw $s0, asteroidVX
	
	# earse old asteroids
	li $t0, BLACK
	jal drawA
	
	## update new location
	lw $s1, A1X
	add $s1, $s1, $s0
	ble $s1, $zero, resetA1XY
	sw $s1, A1X
	
	lw $s1, A2X
	add $s1, $s1, $s0
	ble $s1, $zero, resetA2XY
	sw $s1, A2X
	
	lw $s1, A3X
	add $s1, $s1, $s0
	ble $s1, $zero, resetA3XY
	sw $s1, A3X
	
	### check if any one of the three asteroids made contact with the monster
	jal checkAC
	
	# draw new asteroids
	li $t0, white
	jal drawA
	
	### Sleep for 66 ms so frame rate is about 15
	addi	$v0, $zero, 32	# syscall sleep
	addi	$a0, $zero, 30	# 30 ms
	syscall
	
	lw 	$ra, 4($sp)	# load caller's return address
	lw 	$fp, 0($sp)	# restores caller's frame pointer
	addiu 	$sp, $sp, 24	# restores caller's stack pointer
	jr $ra
	
resetA1XY:
	addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
	sw 	$fp, 0($sp)	# store caller's frame pointer
	sw 	$ra, 4($sp)	# store caller's return address
	addiu 	$fp, $sp, 20	# setup frame pointer

	li $s3, 128
	sw $s3, A1X
	## generate random number for A1Y
	li $a1, 37 # set upper bound
	jal generateRandom
	add $t1, $a0, $zero # t0 = y position of the obstacle
	addi $t1, $t1, 13
	sw $t1, A1Y # save the random Y value to memory 
	
	lw 	$ra, 4($sp)	# load caller's return address
	lw 	$fp, 0($sp)	# restores caller's frame pointer
	addiu 	$sp, $sp, 24	# restores caller's stack pointer
	jr $ra
	
resetA2XY:
	addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
	sw 	$fp, 0($sp)	# store caller's frame pointer
	sw 	$ra, 4($sp)	# store caller's return address
	addiu 	$fp, $sp, 20	# setup frame pointer

	li $s3, 128
	sw $s3, A2X
	## generate random number for A1Y
	li $a1, 37 # set upper bound
	jal generateRandom
	add $t1, $a0, $zero # t0 = y position of the obstacle
	addi $t1, $t1, 13
	sw $t1, A2Y # save the random Y value to memory 
	
	lw 	$ra, 4($sp)	# load caller's return address
	lw 	$fp, 0($sp)	# restores caller's frame pointer
	addiu 	$sp, $sp, 24	# restores caller's stack pointer
	jr $ra
	
resetA3XY:
	addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
	sw 	$fp, 0($sp)	# store caller's frame pointer
	sw 	$ra, 4($sp)	# store caller's return address
	addiu 	$fp, $sp, 20	# setup frame pointer

	li $s3, 128
	sw $s3, A3X
	## generate random number for A1Y
	li $a1, 37 # set upper bound
	jal generateRandom
	add $t1, $a0, $zero # t0 = y position of the obstacle
	addi $t1, $t1, 13
	sw $t1, A3Y # save the random Y value to memory 
	
	lw 	$ra, 4($sp)	# load caller's return address
	lw 	$fp, 0($sp)	# restores caller's frame pointer
	addiu 	$sp, $sp, 24	# restores caller's stack pointer
	jr $ra
	
checkAC:
	addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
	sw 	$fp, 0($sp)	# store caller's frame pointer
	sw 	$ra, 4($sp)	# store caller's return address
	addiu 	$fp, $sp, 20	# setup frame pointer
	
	lw $a0, A1X
	li $a1, 5
	lw $a2, A1Y
	li $a3, 1
	jal checkA1Collision 
	
	lw $a0, A1X
	li $a1, 4
	lw $a2, A1Y
	addi $a2, $a2, 1
	li $a3, 1
	jal checkA1Collision 
	
	lw $a0, A1X
	addi $a0, $a0, 1
	li $a1, 2
	lw $a2, A1Y
	addi $a2, $a2, 2
	li $a3, 1
	jal checkA1Collision 
	
	lw $a0, A1X
	addi $a0, $a0, 1
	li $a1, 4
	lw $a2, A1Y
	addi $a2, $a2, -1
	li $a3, 1
	jal checkA1Collision 
	
	lw $a0, A1X
	addi $a0, $a0, 2
	li $a1, 3
	lw $a2, A1Y
	addi $a2, $a2, -2
	li $a3, 1
	jal checkA1Collision 
	
	lw $a0, A1X
	addi $a0, $a0, 3
	li $a1, 2
	lw $a2, A1Y
	addi $a2, $a2, -3
	li $a3, 1
	jal checkA1Collision

	lw $a0, A2X
	li $a1, 5
	lw $a2, A2Y
	li $a3, 1
	jal checkA2Collision 
	
	lw $a0, A2X
	li $a1, 4
	lw $a2, A2Y
	addi $a2, $a2, 1
	li $a3, 1
	jal checkA2Collision 
	
	lw $a0, A2X
	addi $a0, $a0, 1
	li $a1, 2
	lw $a2, A2Y
	addi $a2, $a2, 2
	li $a3, 1
	jal checkA2Collision 
	
	lw $a0, A2X
	addi $a0, $a0, 1
	li $a1, 4
	lw $a2, A2Y
	addi $a2, $a2, -1
	li $a3, 1
	jal checkA2Collision 
	
	lw $a0, A2X
	addi $a0, $a0, 2
	li $a1, 3
	lw $a2, A2Y
	addi $a2, $a2, -2
	li $a3, 1
	jal checkA2Collision 
	
	lw $a0, A2X
	addi $a0, $a0, 3
	li $a1, 2
	lw $a2, A2Y
	addi $a2, $a2, -3
	li $a3, 1
	jal checkA2Collision

	lw $a0, A3X
	li $a1, 5
	lw $a2, A3Y
	li $a3, 1
	jal checkA3Collision 
	
	lw $a0, A3X
	li $a1, 4
	lw $a2, A3Y
	addi $a2, $a2, 1
	li $a3, 1
	jal checkA3Collision 
	
	lw $a0, A3X
	addi $a0, $a0, 1
	li $a1, 2
	lw $a2, A3Y
	addi $a2, $a2, 2
	li $a3, 1
	jal checkA3Collision 
	
	lw $a0, A3X
	addi $a0, $a0, 1
	li $a1, 4
	lw $a2, A3Y
	addi $a2, $a2, -1
	li $a3, 1
	jal checkA3Collision 
	
	lw $a0, A3X
	addi $a0, $a0, 2
	li $a1, 3
	lw $a2, A3Y
	addi $a2, $a2, -2
	li $a3, 1
	jal checkA3Collision 
	
	lw $a0, A3X
	addi $a0, $a0, 3
	li $a1, 2
	lw $a2, A3Y
	addi $a2, $a2, -3
	li $a3, 1
	jal checkA3Collision
	
	lw 	$ra, 4($sp)	# load caller's return address
	lw 	$fp, 0($sp)	# restores caller's frame pointer
	addiu 	$sp, $sp, 24	# restores caller's stack pointer
	jr 	$ra		# return to caller's code

drawP: # Planets
	# height: 5
	# length: 5

	addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
	sw 	$fp, 0($sp)	# store caller's frame pointer
	sw 	$ra, 4($sp)	# store caller's return address
	addiu 	$fp, $sp, 20	# setup frame pointer

### P1:
	lw $a0, P1X
	li $a1, 1
	lw $a2, P1Y
	li $a3, 1
	jal rectangle 
	
	lw $a0, P1X
	addi $a0, $a0, -1
	li $a1, 3
	lw $a2, P1Y
	addi $a2, $a2, 1
	li $a3, 1
	jal rectangle 
	
	lw $a0, P1X
	addi $a0, $a0, -2
	li $a1, 2
	lw $a2, P1Y
	addi $a2, $a2, 2
	li $a3, 1
	jal rectangle 
	
	lw $a0, P1X
	addi $a0, $a0, 1
	li $a1, 2
	lw $a2, P1Y
	addi $a2, $a2, 2
	li $a3, 1
	jal rectangle 
	
	lw $a0, P1X
	addi $a0, $a0, -1
	li $a1, 3
	lw $a2, P1Y
	addi $a2, $a2, 3
	li $a3, 1
	jal rectangle 
	
	lw $a0, P1X
	li $a1, 1
	lw $a2, P1Y
	addi $a2, $a2, 4
	li $a3, 1
	jal rectangle 
	
### P2:
	lw $a0, P2X
	li $a1, 1
	lw $a2, P2Y
	li $a3, 1
	jal rectangle 
	
	lw $a0, P2X
	addi $a0, $a0, -1
	li $a1, 3
	lw $a2, P2Y
	addi $a2, $a2, 1
	li $a3, 1
	jal rectangle 
	
	lw $a0, P2X
	addi $a0, $a0, -2
	li $a1, 2
	lw $a2, P2Y
	addi $a2, $a2, 2
	li $a3, 1
	jal rectangle 
	
	lw $a0, P2X
	addi $a0, $a0, 1
	li $a1, 2
	lw $a2, P2Y
	addi $a2, $a2, 2
	li $a3, 1
	jal rectangle 
	
	lw $a0, P2X
	addi $a0, $a0, -1
	li $a1, 3
	lw $a2, P2Y
	addi $a2, $a2, 3
	li $a3, 1
	jal rectangle 
	
	lw $a0, P2X
	li $a1, 1
	lw $a2, P2Y
	addi $a2, $a2, 4
	li $a3, 1
	jal rectangle 

	lw 	$ra, 4($sp)	# load caller's return address
	lw 	$fp, 0($sp)	# restores caller's frame pointer
	addiu 	$sp, $sp, 24	# restores caller's stack pointer
	jr 	$ra		# return to caller's code
	
updateP: # update the asteroids movement

	addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
	sw 	$fp, 0($sp)	# store caller's frame pointer
	sw 	$ra, 4($sp)	# store caller's return address
	addiu 	$fp, $sp, 20	# setup frame pointer
	
	## velocity added
	li $s0, planetVX
	
	li $t0, BLACK
	jal drawP
	
	lw $s1, P1X
	add $s1, $s1, $s0
	addi $s4, $s1, -2
	ble $s4, $zero, resetP1XY
	sw $s1, P1X
	
	lw $s1, P2X
	add $s1, $s1, $s0
	addi $s4, $s1, -2
	ble $s4, $zero, resetP2XY
	sw $s1, P2X
	
	jal checkPC
		
	li $t0, green
	jal drawP
	
	### Sleep for 66 ms so frame rate is about 15
	addi	$v0, $zero, 32	# syscall sleep
	addi	$a0, $zero, 30	# 30 ms
	syscall
	
	lw 	$ra, 4($sp)	# load caller's return address
	lw 	$fp, 0($sp)	# restores caller's frame pointer
	addiu 	$sp, $sp, 24	# restores caller's stack pointer
	jr $ra

	
resetP1XY:
	addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
	sw 	$fp, 0($sp)	# store caller's frame pointer
	sw 	$ra, 4($sp)	# store caller's return address
	addiu 	$fp, $sp, 20	# setup frame pointer

	li $s3, 126
	sw $s3, P1X
	## generate random number for A1Y
	li $a1, 38 # set upper bound
	jal generateRandom
	add $t1, $a0, $zero # t0 = y position of the obstacle
	addi $t1, $t1, 10
	sw $t1, P1Y # save the random Y value to memory 
	
	lw 	$ra, 4($sp)	# load caller's return address
	lw 	$fp, 0($sp)	# restores caller's frame pointer
	addiu 	$sp, $sp, 24	# restores caller's stack pointer
	jr $ra
	
resetP2XY:
	addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
	sw 	$fp, 0($sp)	# store caller's frame pointer
	sw 	$ra, 4($sp)	# store caller's return address
	addiu 	$fp, $sp, 20	# setup frame pointer

	li $s3, 126
	sw $s3, P2X
	## generate random number for A1Y
	li $a1, 38 # set upper bound
	jal generateRandom
	add $t1, $a0, $zero # t0 = y position of the obstacle
	addi $t1, $t1, 10
	sw $t1, P2Y # save the random Y value to memory 
	
	lw 	$ra, 4($sp)	# load caller's return address
	lw 	$fp, 0($sp)	# restores caller's frame pointer
	addiu 	$sp, $sp, 24	# restores caller's stack pointer
	jr $ra
	
checkPC:
	addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
	sw 	$fp, 0($sp)	# store caller's frame pointer
	sw 	$ra, 4($sp)	# store caller's return address
	addiu 	$fp, $sp, 20	# setup frame pointer
	
	lw $a0, P1X
	li $a1, 1
	lw $a2, P1Y
	li $a3, 1
	jal checkP1Collision 
	
	lw $a0, P1X
	addi $a0, $a0, -1
	li $a1, 2
	lw $a2, P1Y
	addi $a2, $a2, 1
	li $a3, 1
	jal checkP1Collision 
	
	lw $a0, P1X
	addi $a0, $a0, -2
	li $a1, 5
	lw $a2, P1Y
	addi $a2, $a2, 2
	li $a3, 1
	jal checkP1Collision 
	
	lw $a0, P1X
	addi $a0, $a0, -1
	li $a1, 3
	lw $a2, P1Y
	addi $a2, $a2, 3
	li $a3, 1
	jal checkP1Collision 
	
	lw $a0, P1X
	li $a1, 1
	lw $a2, P1Y
	addi $a2, $a2, 4
	li $a3, 1
	jal checkP1Collision 
	
### P2:
	lw $a0, P2X
	li $a1, 1
	lw $a2, P2Y
	li $a3, 1
	jal checkP2Collision 
	
	lw $a0, P2X
	addi $a0, $a0, -1
	li $a1, 2
	lw $a2, P2Y
	addi $a2, $a2, 1
	li $a3, 1
	jal checkP2Collision 
	
	lw $a0, P2X
	addi $a0, $a0, -2
	li $a1, 5
	lw $a2, P2Y
	addi $a2, $a2, 2
	li $a3, 1
	jal checkP2Collision 
	
	lw $a0, P2X
	addi $a0, $a0, -1
	li $a1, 3
	lw $a2, P2Y
	addi $a2, $a2, 3
	li $a3, 1
	jal checkP2Collision 
	
	lw $a0, P2X
	li $a1, 1
	lw $a2, P2Y
	addi $a2, $a2, 4
	li $a3, 1
	jal checkP2Collision 
	
	lw 	$ra, 4($sp)	# load caller's return address
	lw 	$fp, 0($sp)	# restores caller's frame pointer
	addiu 	$sp, $sp, 24	# restores caller's stack pointer
	jr $ra
	
rectangle:
# $a0 is xmin (i.e., left edge; must be within the display)
# $a1 is width (must be nonnegative and within the display)
# $a2 is ymin  (i.e., top edge, increasing down; must be within the display)
# $a3 is height (must be nonnegative and within the display)

li $t1, BASE_ADDRESS
add $a1,$a1,$a0 # simplify loop tests by switching to first too-far value
add $a3,$a3,$a2
sll $a0,$a0,2 # scale x values to bytes (4 bytes per pixel)
sll $a1,$a1,2
sll $a2,$a2,9 # scale y values to bytes (512*4 bytes per display row)
sll $a3,$a3,9
addu $t2,$a2,$t1 # translate y values to display row starting addresses
addu $a3,$a3,$t1
addu $a2,$t2,$a0 # translate y values to rectangle row starting addresses
addu $a3,$a3,$a0
addu $t2,$t2,$a1 # and compute the ending address for first rectangle row
li $t4,0x200  # bytes per display row

rectangleYloop:
move $t3,$a2 # pointer to current pixel for X loop; start at left edge

rectangleXloop:
sw $t0,($t3)
addiu $t3,$t3,4
bne $t3,$t2,rectangleXloop # keep going if not past the right edge of the rectangle

addu $a2,$a2,$t4 # advace one row worth for the left edge
addu $t2,$t2,$t4 # and right edge pointers
bne $a2,$a3,rectangleYloop # keep going if not off the bottom of the rectangle
jr $ra

checkM1Collision:
	li $t1, BASE_ADDRESS
	li $t0, red
	add $a1,$a1,$a0 # simplify loop tests by switching to first too-far value
	add $a3,$a3,$a2
	sll $a0,$a0,2 # scale x values to bytes (4 bytes per pixel)
	sll $a1,$a1,2
	sll $a2,$a2,9 # scale y values to bytes (512*4 bytes per display row)
	sll $a3,$a3,9
	addu $t2,$a2,$t1 # translate y values to display row starting addresses
	addu $a3,$a3,$t1
	addu $a2,$t2,$a0 # translate y values to rectangle row starting addresses
	addu $a3,$a3,$a0
	addu $t2,$t2,$a1 # and compute the ending address for first rectangle row
	li $t4,0x200  # bytes per display row

M1CollisionYloop:
	move $t3,$a2 # pointer to current pixel for X loop; start at left edge

M1CollisionXloop:
	lw $t5, ($t3)
	beq $t0, $t5, collisionW1M
	addiu $t3,$t3,4
	bne $t3,$t2,M1CollisionXloop # keep going if not past the right edge of the rectangle

	addu $a2,$a2,$t4 # advace one row worth for the left edge
	addu $t2,$t2,$t4 # and right edge pointers
	bne $a2,$a3,M1CollisionYloop # keep going if not off the bottom of the rectangle
	
	jr $ra

collisionW1M:
	jal resetM1XY
	lw $t5, health
	addi $t5, $t5, -2
	sw $t5, health
	ble $t5, $zero, Gameover
	li $t8, 1
	beq $t5, $t8, oneHP
	li $t8, 2
	beq $t5, $t8, twoHP
	li $t8, 3
	beq $t5, $t8, threeHP
	li $t8, 4
	beq $t5,$t8, fourHP
	li $t8, 5
	beq $t5, $t8, fiveHP
	
checkM2Collision:
	li $t1, BASE_ADDRESS
	li $t0, red
	add $a1,$a1,$a0 # simplify loop tests by switching to first too-far value
	add $a3,$a3,$a2
	sll $a0,$a0,2 # scale x values to bytes (4 bytes per pixel)
	sll $a1,$a1,2
	sll $a2,$a2,9 # scale y values to bytes (512*4 bytes per display row)
	sll $a3,$a3,9
	addu $t2,$a2,$t1 # translate y values to display row starting addresses
	addu $a3,$a3,$t1
	addu $a2,$t2,$a0 # translate y values to rectangle row starting addresses
	addu $a3,$a3,$a0
	addu $t2,$t2,$a1 # and compute the ending address for first rectangle row
	li $t4,0x200  # bytes per display row

M2CollisionYloop:
	move $t3,$a2 # pointer to current pixel for X loop; start at left edge

M2CollisionXloop:
	lw $t5, ($t3)
	beq $t0, $t5, collisionW2M
	addiu $t3,$t3,4
	bne $t3,$t2,M2CollisionXloop # keep going if not past the right edge of the rectangle

	addu $a2,$a2,$t4 # advace one row worth for the left edge
	addu $t2,$t2,$t4 # and right edge pointers
	bne $a2,$a3,M2CollisionYloop # keep going if not off the bottom of the rectangle
	
	jr $ra

collisionW2M:
	jal resetM2XY
	lw $t5, health
	addi $t5, $t5, -2
	sw $t5, health
	ble $t5, $zero, Gameover
	li $t8, 1
	beq $t5, $t8, oneHP
	li $t8, 2
	beq $t5, $t8, twoHP
	li $t8, 3
	beq $t5, $t8, threeHP
	li $t8, 4
	beq $t5,$t8, fourHP
	li $t8, 5
	beq $t5, $t8, fiveHP

checkP1Collision:
	li $t1, BASE_ADDRESS
	li $t0, red
	add $a1,$a1,$a0 # simplify loop tests by switching to first too-far value
	add $a3,$a3,$a2
	sll $a0,$a0,2 # scale x values to bytes (4 bytes per pixel)
	sll $a1,$a1,2
	sll $a2,$a2,9 # scale y values to bytes (512*4 bytes per display row)
	sll $a3,$a3,9
	addu $t2,$a2,$t1 # translate y values to display row starting addresses
	addu $a3,$a3,$t1
	addu $a2,$t2,$a0 # translate y values to rectangle row starting addresses
	addu $a3,$a3,$a0
	addu $t2,$t2,$a1 # and compute the ending address for first rectangle row
	li $t4,0x200  # bytes per display row

P1CollisionYloop:
	move $t3,$a2 # pointer to current pixel for X loop; start at left edge

P1CollisionXloop:
	lw $t5, ($t3)
	beq $t0, $t5, collisionW1P
	addiu $t3,$t3,4
	bne $t3,$t2,P1CollisionXloop # keep going if not past the right edge of the rectangle

	addu $a2,$a2,$t4 # advace one row worth for the left edge
	addu $t2,$t2,$t4 # and right edge pointers
	bne $a2,$a3,P1CollisionYloop # keep going if not off the bottom of the rectangle
	
	jr $ra

collisionW1P:
	jal resetP1XY
	lw $t5, score
	addi $t5, $t5, 1
	sw $t5, score
	
	### update counters
	lw $t5, counter1  ## counter1 is the one counter and counter2 is the ten counter
	addi $t5, $t5, 1
	sw $t5, counter1
	
	j gameUpdateLoop
	
checkP2Collision:
	li $t1, BASE_ADDRESS
	li $t0, red
	add $a1,$a1,$a0 # simplify loop tests by switching to first too-far value
	add $a3,$a3,$a2
	sll $a0,$a0,2 # scale x values to bytes (4 bytes per pixel)
	sll $a1,$a1,2
	sll $a2,$a2,9 # scale y values to bytes (512*4 bytes per display row)
	sll $a3,$a3,9
	addu $t2,$a2,$t1 # translate y values to display row starting addresses
	addu $a3,$a3,$t1
	addu $a2,$t2,$a0 # translate y values to rectangle row starting addresses
	addu $a3,$a3,$a0
	addu $t2,$t2,$a1 # and compute the ending address for first rectangle row
	li $t4,0x200  # bytes per display row

P2CollisionYloop:
	move $t3,$a2 # pointer to current pixel for X loop; start at left edge

P2CollisionXloop:
	lw $t5, ($t3)
	beq $t0, $t5, collisionW2P
	addiu $t3,$t3,4
	bne $t3,$t2,P2CollisionXloop # keep going if not past the right edge of the rectangle

	addu $a2,$a2,$t4 # advace one row worth for the left edge
	addu $t2,$t2,$t4 # and right edge pointers
	bne $a2,$a3,P2CollisionYloop # keep going if not off the bottom of the rectangle
	
	jr $ra

collisionW2P:
	jal resetP2XY
	### update score in memory
	lw $t5, score
	addi $t5, $t5, 1
	sw $t5, score
	### update counters
	lw $t5, counter1  ## counter1 is the one counter and counter2 is the ten counter
	addi $t5, $t5, 1
	sw $t5, counter1

	j gameUpdateLoop
	
oneToten:
	sw $zero, counter1
	lw $t6, counter2
	addi $t6, $t6, 1
	sw $t6, counter2
	li $s0, SP2X # second score number location (107,1)
	li $s1, SPY
	jal drawZero
	
	j gameUpdateLoop

upLimit: 
	li $t5, 9
	sw $t5, counter1
	sw $t5, counter2

	j gameUpdateLoop
	
checkA1Collision:
	li $t1, BASE_ADDRESS
	li $t0, red
	add $a1,$a1,$a0 # simplify loop tests by switching to first too-far value
	add $a3,$a3,$a2
	sll $a0,$a0,2 # scale x values to bytes (4 bytes per pixel)
	sll $a1,$a1,2
	sll $a2,$a2,9 # scale y values to bytes (512*4 bytes per display row)
	sll $a3,$a3,9
	addu $t2,$a2,$t1 # translate y values to display row starting addresses
	addu $a3,$a3,$t1
	addu $a2,$t2,$a0 # translate y values to rectangle row starting addresses
	addu $a3,$a3,$a0
	addu $t2,$t2,$a1 # and compute the ending address for first rectangle row
	li $t4,0x200  # bytes per display row

A1CollisionYloop:
	move $t3,$a2 # pointer to current pixel for X loop; start at left edge

A1CollisionXloop:
	lw $t5, ($t3)
	beq $t0, $t5, collisionW1A
	addiu $t3,$t3,4
	bne $t3,$t2,A1CollisionXloop # keep going if not past the right edge of the rectangle

	addu $a2,$a2,$t4 # advace one row worth for the left edge
	addu $t2,$t2,$t4 # and right edge pointers
	bne $a2,$a3,A1CollisionYloop # keep going if not off the bottom of the rectangle
	
	jr $ra
	
collisionW1A:
	jal resetA1XY
	lw $t5, health
	addi $t5, $t5, -1
	sw $t5, health
	ble $t5, $zero, Gameover
	li $t8, 1
	beq $t5, $t8, oneHP
	li $t8, 2
	beq $t5, $t8, twoHP
	li $t8, 3
	beq $t5, $t8, threeHP
	li $t8, 4
	beq $t5,$t8, fourHP
	li $t8, 5
	beq $t5, $t8, fiveHP
	
checkA2Collision:
	li $t1, BASE_ADDRESS
	li $t0, red
	add $a1,$a1,$a0 # simplify loop tests by switching to first too-far value
	add $a3,$a3,$a2
	sll $a0,$a0,2 # scale x values to bytes (4 bytes per pixel)
	sll $a1,$a1,2
	sll $a2,$a2,9 # scale y values to bytes (512*4 bytes per display row)
	sll $a3,$a3,9
	addu $t2,$a2,$t1 # translate y values to display row starting addresses
	addu $a3,$a3,$t1
	addu $a2,$t2,$a0 # translate y values to rectangle row starting addresses
	addu $a3,$a3,$a0
	addu $t2,$t2,$a1 # and compute the ending address for first rectangle row
	li $t4,0x200  # bytes per display row

A2CollisionYloop:
	move $t3,$a2 # pointer to current pixel for X loop; start at left edge

A2CollisionXloop:
	lw $t5, ($t3)
	beq $t0, $t5, collisionW2A
	addiu $t3,$t3,4
	bne $t3,$t2,A2CollisionXloop # keep going if not past the right edge of the rectangle

	addu $a2,$a2,$t4 # advace one row worth for the left edge
	addu $t2,$t2,$t4 # and right edge pointers
	bne $a2,$a3,A2CollisionYloop # keep going if not off the bottom of the rectangle
	
	jr $ra
	
collisionW2A:
	jal resetA2XY
	lw $t5, health
	addi $t5, $t5, -1
	sw $t5, health
	ble $t5, $zero, Gameover
	li $t8, 1
	beq $t5, $t8, oneHP
	li $t8, 2
	beq $t5, $t8, twoHP
	li $t8, 3
	beq $t5, $t8, threeHP
	li $t8, 4
	beq $t5,$t8, fourHP
	li $t8, 5
	beq $t5, $t8, fiveHP
	
checkA3Collision:
	li $t1, BASE_ADDRESS
	li $t0, red
	add $a1,$a1,$a0 # simplify loop tests by switching to first too-far value
	add $a3,$a3,$a2
	sll $a0,$a0,2 # scale x values to bytes (4 bytes per pixel)
	sll $a1,$a1,2
	sll $a2,$a2,9 # scale y values to bytes (512*4 bytes per display row)
	sll $a3,$a3,9
	addu $t2,$a2,$t1 # translate y values to display row starting addresses
	addu $a3,$a3,$t1
	addu $a2,$t2,$a0 # translate y values to rectangle row starting addresses
	addu $a3,$a3,$a0
	addu $t2,$t2,$a1 # and compute the ending address for first rectangle row
	li $t4,0x200  # bytes per display row

A3CollisionYloop:
	move $t3,$a2 # pointer to current pixel for X loop; start at left edge

A3CollisionXloop:
	lw $t5, ($t3)
	beq $t0, $t5, collisionW3A
	addiu $t3,$t3,4
	bne $t3,$t2,A3CollisionXloop # keep going if not past the right edge of the rectangle

	addu $a2,$a2,$t4 # advace one row worth for the left edge
	addu $t2,$t2,$t4 # and right edge pointers
	bne $a2,$a3,A3CollisionYloop # keep going if not off the bottom of the rectangle
	
	jr $ra
	
collisionW3A:
	jal resetA3XY
	lw $t5, health
	addi $t5, $t5, -1
	sw $t5, health
	ble $t5, $zero, Gameover
	li $t8, 1
	beq $t5, $t8, oneHP
	li $t8, 2
	beq $t5, $t8, twoHP
	li $t8, 3
	beq $t5, $t8, threeHP
	li $t8, 4
	beq $t5,$t8, fourHP
	li $t8, 5
	beq $t5, $t8, fiveHP
	
generateRandom: # the generated random number will be stored in $a0
	addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
	sw 	$fp, 0($sp)	# store caller's frame pointer
	sw 	$ra, 4($sp)	# store caller's return address
	addiu 	$fp, $sp, 20	# setup frame pointer

	li $v0, 42
	li $a0, 0
	syscall

	lw 	$ra, 4($sp)	# load caller's return address
	lw 	$fp, 0($sp)	# restores caller's frame pointer
	addiu 	$sp, $sp, 24	# restores caller's stack pointer
	jr $ra

doubleMVX:
	li $s0, -4
	addi $s0, $s0, -2
	sw $s1, missileVX

	j rtM 
	
doubleMVYup1:

	li $s0, -3
	addi $s1, $s0, -1
	sw $s1, missile1VY
	
	j rtupMY1

doubleMVYup2:
	li $s0, 3
	addi $s1, $s0, 1
	sw $s1, missile2VY

	j rtupMY2
	
doubleMVYdown1:
	li $s0, 3
	addi $s1, $s0, 1
	sw $s1, missile1VY
	
	j rtdownMY1

doubleMVYdown2:
	li $s0, -3
	addi $s1, $s0, -1
	sw $s1, missile2VY

	j rtdownMY2
		
doubleAVX:
	li $t8, -2
	addi $t8, $t8, -2
	sw $t8, asteroidVX

	j rtA

drawHealthBarX:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	addi $t1, $t1, -1
	addi $t2, $t2, -1
	beqz $t2, drawHealthBarY
	j drawHealthBarX

drawHealthBarY:
	addi $t0, $t0, 480
	addi $t2, $t2, 8
	bnez $t1, drawHealthBarX
	jr $ra

fiveHP: 
	li $t3, grey
	li $t0, healthSix
	addi $t1, $zero, 40 		
	li $t2, 8
	jal drawHealthBarX
	
	j gameUpdateLoop

fourHP: 
	li $t3, grey
	li $t0, healthSix
	addi $t1, $zero, 40 		
	li $t2, 8
	jal drawHealthBarX
	
	li $t0, healthFive
	addi $t1, $zero, 40 		
	li $t2, 8
	jal drawHealthBarX
	
	j gameUpdateLoop
	
threeHP: 
	li $t3, grey
	li $t0, healthFive
	addi $t1, $zero, 40 		
	li $t2, 8
	jal drawHealthBarX
	
	li $t0, healthFour
	addi $t1, $zero, 40 		
	li $t2, 8
	jal drawHealthBarX
	
	j gameUpdateLoop
	
twoHP: 
	li $t3, grey
	li $t0, healthFour
	addi $t1, $zero, 40 		
	li $t2, 8
	jal drawHealthBarX
	
	li $t0, healthThree
	addi $t1, $zero, 40 		
	li $t2, 8
	jal drawHealthBarX
	
	j gameUpdateLoop

oneHP: 
	li $t3, grey
	li $t0, healthThree
	addi $t1, $zero, 40 		
	li $t2, 8
	jal drawHealthBarX
	
	li $t0, healthTwo
	addi $t1, $zero, 40 		
	li $t2, 8
	jal drawHealthBarX
	
	j gameUpdateLoop
	
updateScoreT:
	addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
	sw 	$fp, 0($sp)	# store caller's frame pointer
	sw 	$ra, 4($sp)	# store caller's return address
	addiu 	$fp, $sp, 20	# setup frame pointer

	#### the score at the first score number location (107,1) i.e. the ten  SP1X=107
	li $s0, SP1X # second score number location (107,1)
	li $s1, SPY
	lw $t1, counter2
	li $t2, 0
	beq $t1, $t2, drawZero
	li $t2, 1
	beq $t1, $t2, drawOne
	li $t2, 2
	beq $t1, $t2, drawTwo
	li $t2, 3
	beq $t1, $t2, drawThree
	li $t2, 4
	beq $t1, $t2, drawFour
	li $t2, 5
	beq $t1, $t2, drawFive
	li $t2, 6
	beq $t1, $t2, drawSix
	li $t2, 7
	beq $t1, $t2, drawSeven
	li $t2, 8
	beq $t1, $t2, drawEight
	li $t2, 9
	beq $t1, $t2, drawNine
	
	lw 	$ra, 4($sp)	# load caller's return address
	lw 	$fp, 0($sp)	# restores caller's frame pointer
	addiu 	$sp, $sp, 24	# restores caller's stack pointer
	jr $ra

updateScoreO:
	addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
	sw 	$fp, 0($sp)	# store caller's frame pointer
	sw 	$ra, 4($sp)	# store caller's return address
	addiu 	$fp, $sp, 20	# setup frame pointer
	
	#### the score at the second score number location (115, 1) i.e. the one SP2X=115 SPY=1
	li $s0, SP2X # second score number location (107,1)
	li $s1, SPY
	lw $t1, counter1
	li $t2, 0
	beq $t1, $t2, drawZero
	li $t2, 1
	beq $t1, $t2, drawOne
	li $t2, 2
	beq $t1, $t2, drawTwo
	li $t2, 3
	beq $t1, $t2, drawThree
	li $t2, 4
	beq $t1, $t2, drawFour
	li $t2, 5
	beq $t1, $t2, drawFive
	li $t2, 6
	beq $t1, $t2, drawSix
	li $t2, 7
	beq $t1, $t2, drawSeven
	li $t2, 8
	beq $t1, $t2, drawEight
	li $t2, 9
	beq $t1, $t2, drawNine
	li $t2, 10
	beq $t1, $t2, oneToten
	
	lw 	$ra, 4($sp)	# load caller's return address
	lw 	$fp, 0($sp)	# restores caller's frame pointer
	addiu 	$sp, $sp, 24	# restores caller's stack pointer
	jr $ra
	
updateFinalO: 
	addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
	sw 	$fp, 0($sp)	# store caller's frame pointer
	sw 	$ra, 4($sp)	# store caller's return address
	addiu 	$fp, $sp, 20	# setup frame pointer
	
	li $s0, S2X  # Score second number location :(58,35)
	li $s1, SY
	lw $t1, counter1
	li $t2, 0
	beq $t1, $t2, drawZero
	li $t2, 1
	beq $t1, $t2, drawOne
	li $t2, 2
	beq $t1, $t2, drawTwo
	li $t2, 3
	beq $t1, $t2, drawThree
	li $t2, 4
	beq $t1, $t2, drawFour
	li $t2, 5
	beq $t1, $t2, drawFive
	li $t2, 6
	beq $t1, $t2, drawSix
	li $t2, 7
	beq $t1, $t2, drawSeven
	li $t2, 8
	beq $t1, $t2, drawEight
	li $t2, 9
	beq $t1, $t2, drawNine
	li $t2, 10
	beq $t1, $t2, oneToten
	
	lw 	$ra, 4($sp)	# load caller's return address
	lw 	$fp, 0($sp)	# restores caller's frame pointer
	addiu 	$sp, $sp, 24	# restores caller's stack pointer
	jr $ra
	
updateFinalT:
	addiu 	$sp, $sp, -24	# allocate 24 bytes for stack
	sw 	$fp, 0($sp)	# store caller's frame pointer
	sw 	$ra, 4($sp)	# store caller's return address
	addiu 	$fp, $sp, 20	# setup frame pointer
	
	#### 
	li $s0, S1X  # Score second number location :(50,35)
	li $s1, SY
	lw $t1, counter2
	li $t2, 0
	beq $t1, $t2, drawZero
	li $t2, 1
	beq $t1, $t2, drawOne
	li $t2, 2
	beq $t1, $t2, drawTwo
	li $t2, 3
	beq $t1, $t2, drawThree
	li $t2, 4
	beq $t1, $t2, drawFour
	li $t2, 5
	beq $t1, $t2, drawFive
	li $t2, 6
	beq $t1, $t2, drawSix
	li $t2, 7
	beq $t1, $t2, drawSeven
	li $t2, 8
	beq $t1, $t2, drawEight
	li $t2, 9
	beq $t1, $t2, drawNine
	li $t2, 10
	beq $t1, $t2, oneToten
	
	lw 	$ra, 4($sp)	# load caller's return address
	lw 	$fp, 0($sp)	# restores caller's frame pointer
	addiu 	$sp, $sp, 24	# restores caller's stack pointer
	jr $ra


drawZero:
	move $v1, $ra
	# $s0 is xmin (i.e., left edge; must be within the display)
	# $s1 is ymin (i.e., top edge, increasing down; must be within the display)
	addi $a2, $s1, 0
	addi $a0, $s0, 0
	li $a1, 1
	li $a3, 6
	jal rectangle
	
	addi $a2, $s1, 0
	addi $a0, $s0, 0
	li $a3, 1
	li $a1, 4
	jal rectangle
	
	addi $a2, $s1, 6
	addi $a0, $s0, 0
	li $a3, 1
	li $a1, 4
	jal rectangle
	
	addi $a2, $s1, 0
	addi $a0, $s0, 4
	li $a1, 1
	li $a3, 7
	jal rectangle
	
	jr $v1

drawOne:
	move $v1, $ra
	addi $a2, $s1, 0
	addi $a0, $s0, 0
	li $a1, 1
	li $a3, 7
	jal rectangle
	
	jr $v1

drawTwo:
	move $v1, $ra
	addi $a2, $s1, 0
	addi $a0, $s0, 0
	li $a1, 4
	li $a3, 1
	jal rectangle
	
	addi $a2, $s1, 3
	addi $a0, $s0, 0
	li $a1, 4
	li $a3, 1
	jal rectangle
	
	addi $a2, $s1, 6
	addi $a0, $s0, 0
	li $a3, 1
	li $a1, 4
	jal rectangle
	
	addi $a2, $s1, 0
	addi $a0, $s0, 3
	li $a3, 3
	li $a1, 1
	jal rectangle
	
	addi $a2, $s1, 3
	addi $a0, $s0, 0
	li $a3, 3
	li $a1, 1
	jal rectangle
	
	jr $v1

drawThree:
	move $v1, $ra
	addi $a2, $s1, 0
	addi $a0, $s0, 0
	li $a3, 1
	li $a1, 4
	jal rectangle
	
	addi $a2, $s1, 6
	addi $a0, $s0, 0
	li $a3, 1
	li $a1, 4
	jal rectangle
	
	addi $a2, $s1, 3
	addi $a0, $s0, 0
	li $a3, 1
	li $a1, 4
	jal rectangle
	
	addi $a2, $s1, 0
	addi $a0, $s0, 3
	li $a3, 6
	li $a1, 1
	jal rectangle
	
	jr $v1

drawFour:
	move $v1, $ra
	addi $a2, $s1, 0
	addi $a0, $s0, 3
	li $a3, 7
	li $a1, 1
	jal rectangle
	
	addi $a2, $s1, 3
	addi $a0, $s0, 0
	li $a3, 1
	li $a1, 4
	jal rectangle
	
	addi $a2, $s1, 0
	addi $a0, $s0, 0
	li $a3, 3
	li $a1, 1
	jal rectangle
	
	jr $v1

drawFive:
	move $v1, $ra
	addi $a2, $s1, 0
	addi $a0, $s0, 0
	li $a3, 3
	li $a1, 1
	jal rectangle
	
	addi $a2, $s1, 0
	addi $a0, $s0, 0
	li $a3, 1
	li $a1, 4
	jal rectangle
	
	addi $a2, $s1, 6
	addi $a0, $s0, 0
	li $a3, 1
	li $a1, 4
	jal rectangle
	
	addi $a2, $s1, 3
	addi $a0, $s0, 0
	li $a3, 1
	li $a1, 4
	jal rectangle
	
	addi $a2, $s1, 3
	addi $a0, $s0, 3
	li $a3, 3
	li $a1, 1
	jal rectangle
	
	jr $v1
	
drawSix:
	move $v1, $ra
	addi $a2, $s1, 0
	addi $a0, $s0, 0
	li $a3, 1
	li $a1, 4
	jal rectangle
	
	addi $a2, $s1, 6
	addi $a0, $s0, 0
	li $a3, 1
	li $a1, 4
	jal rectangle
	
	addi $a2, $s1, 3
	addi $a0, $s0, 0
	li $a3, 1
	li $a1, 4
	jal rectangle
	
	addi $a2, $s1, 3
	addi $a0, $s0, 3
	li $a3, 3
	li $a1, 1
	jal rectangle
	
	addi $a2, $s1, 0
	addi $a0, $s0, 0
	li $a3, 6
	li $a1, 1
	jal rectangle
	
	jr $v1

drawSeven:
	move $v1, $ra
	addi $a2, $s1, 0
	addi $a0, $s0, 3
	li $a3, 6
	li $a1, 1
	jal rectangle
	
	addi $a2, $s1, 0
	addi $a0, $s0, 0
	li $a3, 1
	li $a1, 3
	jal rectangle
	
	jr $v1

drawEight:
	move $v1, $ra
	addi $a2, $s1, 0
	addi $a0, $s0, 3
	li $a3, 6
	li $a1, 1
	jal rectangle
	
	addi $a2, $s1, 0
	addi $a0, $s0, 0
	li $a3, 6
	li $a1, 1
	jal rectangle
	
	addi $a2, $s1, 0
	addi $a0, $s0, 0
	li $a3, 1
	li $a1, 4
	jal rectangle
	
	addi $a2, $s1, 6
	addi $a0, $s0, 0
	li $a3, 1
	li $a1, 4
	jal rectangle
	
	addi $a2, $s1, 3
	addi $a0, $s0, 0
	li $a3, 1
	li $a1, 4
	jal rectangle
	
	jr $v1

drawNine:
	move $v1, $ra
	addi $a2, $s1, 0
	addi $a0, $s0, 3
	li $a3, 6
	li $a1, 1
	jal rectangle
	
	addi $a2, $s1, 0
	addi $a0, $s0, 0
	li $a3, 3
	li $a1, 1
	jal rectangle
	
	addi $a2, $s1, 0
	addi $a0, $s0, 0
	li $a3, 1
	li $a1, 4
	jal rectangle
	
	addi $a2, $s1, 6
	addi $a0, $s0, 0
	li $a3, 1
	li $a1, 4
	jal rectangle
	
	addi $a2, $s1, 3
	addi $a0, $s0, 0
	li $a3, 1
	li $a1, 4
	jal rectangle
	
	jr $v1

Gameover:
### Graphics for the gameover scene

	li 	$t0, BASE_ADDRESS	# load base address
	li 	$t1, 8192		# save 512*256 pixels
	li 	$t2, 0			# load black color
black:
	sw   	$t2, 0($t0)
	addi 	$t0, $t0, 4 	# advance to next pixel position in display
	addi 	$t1, $t1, -1	# decrement number of pixels
	bnez 	$t1, black	# repeat while number of pixels is not zero

### The word of  "GAME OVER" 
li $t0, red # color red
##G

li $a0, 30
li $a1, 5
li $a2, 9
li $a3, 1
jal rectangle

li $a0, 28
li $a1, 2
li $a2, 10
li $a3, 5
jal rectangle

li $a0, 29
li $a1, 5
li $a2, 15
li $a3, 1
jal rectangle

li $a0, 34
li $a1, 2
li $a2, 12
li $a3, 3
jal rectangle

li $a0, 33
li $a1, 1
li $a2, 12
li $a3, 1
jal rectangle

## A

li $a0, 40
li $a1, 5
li $a2, 9
li $a3, 1
jal rectangle

li $a0, 39
li $a1, 7
li $a2, 10
li $a3, 1
jal rectangle

li $a0, 39
li $a1, 1
li $a2, 11
li $a3, 5
jal rectangle

li $a0, 45
li $a1, 1
li $a2, 11
li $a3, 5
jal rectangle

li $a0, 39
li $a1, 7
li $a2, 13
li $a3, 1
jal rectangle

## M 
li $a0, 49
li $a1, 2
li $a2, 9
li $a3, 7
jal rectangle

li $a0, 51
li $a1, 1
li $a2, 9
li $a3, 3
jal rectangle

li $a0, 52
li $a1, 2
li $a2, 11
li $a3, 2
jal rectangle

li $a0, 54
li $a1, 1
li $a2, 9
li $a3, 3
jal rectangle

li $a0, 55
li $a1, 2
li $a2, 9
li $a3, 7
jal rectangle


## E
li $a0, 60
li $a1, 2
li $a2, 10
li $a3, 5
jal rectangle

li $a0, 62
li $a1, 5
li $a2, 9
li $a3, 1
jal rectangle

li $a0, 62
li $a1, 5
li $a2, 15
li $a3, 1
jal rectangle

li $a0, 62
li $a1, 5
li $a2, 12
li $a3, 1
jal rectangle

## O
li $a0, 38
li $a1, 5
li $a2, 19
li $a3, 1
jal rectangle

li $a0, 38
li $a1, 5
li $a2, 25
li $a3, 1
jal rectangle

li $a0, 37
li $a1, 1
li $a2, 20
li $a3, 5
jal rectangle

li $a0, 43
li $a1, 1
li $a2, 20
li $a3, 5
jal rectangle

## V

li $a0, 47
li $a1, 2
li $a2, 19
li $a3, 5
jal rectangle

li $a0, 53
li $a1, 2
li $a2, 19
li $a3, 5
jal rectangle

li $a0, 48
li $a1, 6
li $a2, 24
li $a3, 1
jal rectangle

li $a0, 49
li $a1, 4
li $a2, 25
li $a3, 1
jal rectangle

## E again
li $a0, 58
li $a1, 2
li $a2, 20
li $a3, 5
jal rectangle

li $a0, 60
li $a1, 5
li $a2, 19
li $a3, 1
jal rectangle

li $a0, 60
li $a1, 5
li $a2, 25
li $a3, 1
jal rectangle

li $a0, 60
li $a1, 5
li $a2, 22
li $a3, 1
jal rectangle

## R
li $a0, 68
li $a1, 2
li $a2, 19
li $a3, 7
jal rectangle

li $a0, 70
li $a1, 4
li $a2, 19
li $a3, 1
jal rectangle

li $a0, 73
li $a1, 2
li $a2, 20
li $a3, 2
jal rectangle

li $a0, 70
li $a1, 4
li $a2, 22
li $a3, 1
jal rectangle

li $a0, 70
li $a1, 5
li $a2, 23
li $a3, 1
jal rectangle

li $a0, 73
li $a1, 2
li $a2, 24
li $a3, 2
jal rectangle

### THE WORD OF "FINAL SCORE : "
### S
li $a0, 10
li $a1, 1
li $a2, 35
li $a3, 3
jal rectangle

li $a0, 10
li $a1, 4
li $a2, 35
li $a3, 1
jal rectangle

li $a0, 10
li $a1, 3
li $a2, 38
li $a3, 1
jal rectangle

li $a0, 13
li $a1, 1
li $a2, 38
li $a3, 4
jal rectangle

li $a0, 10
li $a1, 3
li $a2, 41
li $a3, 1
jal rectangle

### C
li $a0, 17
li $a1, 4
li $a2, 35
li $a3, 1
jal rectangle

li $a0, 17
li $a1, 4
li $a2, 41
li $a3, 1
jal rectangle

li $a0, 16
li $a1, 1
li $a2, 36
li $a3, 5
jal rectangle

### O
li $a0, 24
li $a1, 4
li $a2, 35
li $a3, 1
jal rectangle

li $a0, 24
li $a1, 4
li $a2, 41
li $a3, 1
jal rectangle

li $a0, 23
li $a1, 1
li $a2, 36
li $a3, 5
jal rectangle

li $a0, 28
li $a1, 1
li $a2, 36
li $a3, 5
jal rectangle

### R
li $a0, 31
li $a1, 1
li $a2, 35
li $a3, 7
jal rectangle

li $a0, 32
li $a1, 3
li $a2, 35
li $a3, 1
jal rectangle

li $a0, 35
li $a1, 1
li $a2, 36
li $a3, 2
jal rectangle

li $a0, 32
li $a1, 3
li $a2, 38
li $a3, 1
jal rectangle

li $a0, 35
li $a1, 1
li $a2, 39
li $a3, 3
jal rectangle

### E
li $a0, 39
li $a1, 4
li $a2, 35
li $a3, 1
jal rectangle

li $a0, 39
li $a1, 4
li $a2, 41
li $a3, 1
jal rectangle

li $a0, 38
li $a1, 1
li $a2, 36
li $a3, 5
jal rectangle

li $a0, 39
li $a1, 3
li $a2, 38
li $a3, 1
jal rectangle

### :
li $a0, 45
li $a1, 1
li $a2, 37
li $a3, 1
jal rectangle

li $a0, 45
li $a1, 1
li $a2, 39
li $a3, 1
jal rectangle

### THE SCORE ITSELF
jal updateFinalO
jal updateFinalT


li $v0, 10  # terminate the program gracefully
syscall


