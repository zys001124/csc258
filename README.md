# csc258
Space monster game
# Bitmap Display Configuration:
# -Unit width in pixels: 4
# -Unit height in pixels: 4
# -Display width in pixels: 512
# -Display height in pixels: 256
# -Base Address for Display: 0x10008000 ($gp)

Use the keyboard and display MMIO simulator to control the monster
w - up
s - down
a - left
d - right
p - restart the game when it is still running 

different results when colliding with different obstacles:
green obstacle is planet, monster devours it and add 1 points
white obstacle is asteroid, colliding with monster deducts 1 hp
blue obstacle is missile, colliding with monster deducts 2 hp

6 hp at the start of the game.
after scoring 10 points, enter second phase with increased difficulty
