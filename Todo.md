Client and Server should hold a copy of tictactoe playing table

Client needs to show Table Values -> Löve
Add Clickable Buttons to Löve
Generate 3x3 Grid and keep data

Client checks if move is valid or not -> handle wrong moves clientside
Client(s) can send move to Server
Server validates Move
  - already X or O?
  - X's / O's turn?
  - game over?
  - other player still connected?
Broadcast move to Clients if valid
Refuse move and let Client do another if move was invalid
