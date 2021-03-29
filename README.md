<h1 align="center">Battleship</h1>
<h4 align="center">Implementation of the infamous game Battleship or Sea Battle using the logic programming language Prolog</h4>

<p align="center">
  <img alt="ULL" src="https://img.shields.io/badge/University-La%20Laguna-%2354048c?style=flat-square" />  
  <img alt="License" src="https://img.shields.io/github/license/angeligareta/battleship?style=flat-square" />
  <img alt="GitHub contributors" src="https://img.shields.io/github/contributors/angeligareta/battleship?style=flat-square" />
</p>

## About
The aim of the game is to guess were the boat of the opponent is. 
We only implemented 1 boat that can have 1, 2 or 3 blocks of width, depending on the difficulty we choose.

### Features
* The board is square.
* You can choose a size for the board. Maximum 9 columns. 
* You can choose a difficulty before starting the game.
* Depending on the difficulty there will be more or less attempts and the size of the boat will vary.
* In each round you can put an x/y position.
* If the attempts finish and you haven't sunk the boat you loose.
* To exit the game you can put 0 in a position.

## Usage
To play the program it's necessary to have Prolog installed. After that we can execute the program following the syntax:
```
prolog src/sink_the_float.pl
```
After that we can start the game writing:
```
play.
```
First of all we have to choose the size of the board, followed by the desired difficulty. Finally it will show the number of rounds left to guess the opponent boat.

## Screenshots
*Starting the Game*

<div style="display: flex; align-items: center; justify-content: center;">
  <img src="docs/screenshot-1.png" alt="Starting the Game" style="width: 40%;"/>
</div>

*Game Finished - Win*

<div style="display: flex; align-items: center; justify-content: center;">
<img src="docs/screenshot-2.png" alt="Game Finished - Win" style="width: 40%;"/>
</div>

*Game Finished - Loose*

<div style="display: flex; align-items: center; justify-content: center;">
<img src="docs/screenshot-3.png" alt="Game Finished - Loose" style="width: 40%;"/>
</div>

## Authors
- [Ángel Igareta](https://github.com/AngelIgareta)
- [Cristian Abrante Dorta](https://github.com/CristianAbrante)
