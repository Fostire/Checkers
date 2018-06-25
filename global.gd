extends Node

#Rules

#Starting position
#Each player starts with 12 men on the dark squares of the three rows closest to that player's side (see diagram). The row closest to each player is called the kings row or crownhead. The player with the darker-coloured pieces moves first.

#Move rules
#There are two different ways to move in English draughts:
#
#Simple move: A simple move consists of moving a piece one square diagonally to an adjacent unoccupied dark square. Uncrowned pieces can move diagonally forward only; kings can move in any diagonal direction.
#Jump: A jump consists of moving a piece that is diagonally adjacent an opponent's piece, to an empty square immediately beyond it in the same direction. (Thus "jumping over" the opponent's piece.) Men can jump diagonally forward only; kings can jump in any diagonal direction. A jumped piece is considered "captured" and removed from the game. Any piece, king or man, can jump a king.
#Multiple jumps are possible, if after one jump, another piece is immediately eligible to be jumped—even if that jump is in a different diagonal direction. If more than one multi-jump is available, the player can choose which piece to jump with, and which sequence of jumps to make. The sequence chosen is not required to be the one that maximizes the number of jumps in the turn; however, a player must make all available jumps in the sequence chosen.
#
#Jumping is always mandatory: if a player has the option to jump, he must take it, even if doing so results in disadvantage for the jumping player. For example, a mandated single jump might set up the player such that the opponent has a multi-jump in reply.
#Kings
#If a man moves into the kings row on the opponent's side of the board, it is crowned as a king and gains the ability to move both forward and backward. If a man jumps into the kings row, the current move terminates; the piece is crowned as a king but cannot jump back out as in a multi-jump, until another move.

#End of game
#A player wins by capturing all of the opponent's pieces or by leaving the opponent with no legal move. The game ends in a draw if neither side can force a win, or by agreement (one side offering a draw, the other accepting).


#variant rules
var starting_side = "black"
var captureBackwards = false
var flyingKings = false