# Dungeon game

## Table of Contents
1. [Project State](#project-state)
2. [How to Run](#how-to-run)
3. [Overview](#overview)
4. [Game States](#game-states)
5. [Data Structure](#data-structure)
6. [Dungeon Representation and States](#dungeon-representation-and-states)
    * [Representation](#representation)
    * [Dungeon States](#states)
7. [Room Representation](#room-representation)
8. [Game AI](#game-ai)
9. [Collision Detection](#collision-detection)
10. [Game Control](#game-control)

## Project State
The game mechanics are not fully implemented yet, developement have stopped. <br/>
What have been done so far, rooms have been connected together, collision detection have been implemented, other game characters move and follow the main player wihtout damaging him.

## How to Run
In order to run the game you need to download the game framework love2d from the website love2d.org .
Downloading the file dungeon.love is the only one necessary which contains the code source compressed, the other files contains the code source for reviewing purpose, starting with main.lua . 
Run the downloaded file using the game framework previously downloaded.

## Overview
Here is a quick overview of what have been done : 
* The data structure corresponding to rooms and dungeons have been implemented, as well as the level generation algorithm. 
* Game objects as well as entities can exist in room at any place and can collide with each other and with the main character. 
* Entites have a follow state where they surf in the room, intelligently finding the shortest path to the main character all while avoiding the collision with game objects.
* Game's goal have not been implemented yet.

## Game States
The game is run by different states handled using a state machine. All states are initialised in the main file and they correspond to the start and play states. <br/>
Each state is represented by its own class where its own logic, animation and interactions with the user are defined. <br/>
The state machine is another class whose objective is to coordinate between all the different states by switching between them whenever it receives a signal event to do so. <br/>

The main character and entities have their own states, and state machines :
* Each character state define a way that he is interaction with the game (being idle, walking, attacking, defending, etc...) as well as entities states (attacking, following the character, etc...)
* Each character or entity possess its own player state which is the class that will handle the coordination between all the different states, in a way that the character can be in one state at a given time, and handles the shift between states through a signal event that it may receive.

## Data Structure
The use of data structure in the implementaiton of all the different mechanics present in this game played a huge role to achieve the desired behaviour efficiently. <br/>
Here is a list of all the implemented data structure as well as their use cases :
1. **Quad Tree** : Collision detection algorithm has been built using a quad tree structure to efficiently patition bidimentional space (in this case each room) in order to locate the objects and entities that are near the main character.
2. **Visibility Graph** : AI Entities who follows the main character use the visibility graph generated for each room in order to guide them surf through game objects. With the help of visibility graph, entities can navigate through as many objects in the room and avoid colliding with them in order to follow and reach the player using a search algorithm described below.
3. **A\* Search Algorithm** : Entities can find the shortest existing path in the visibility graph using the help of A* search algorithm to follow and reach the player. Using a heuristic function that gives the cartesian distance between route's start and end coordinates.
4. **Min Binary Heap** : A* search algorithm described above make use of a binary heap tree in order to efficiently select a route from the available ones according to the minimum expected arrival distance.

## Dungeon Representation and States

### Representation
The dungeons are essentially the list of rooms that make it up, as well as all the entities and objects inside of them. <br/>
We can imagine a dungeon being a floor of a building that we are looking at from above. Since rooms are connected together spacially, its easier to represent the dungeon as two dimentional array of rooms. <br/>
Rooms and their corresponding objects and entities are not instanciated during the dungeon generation to preserve memory efficiency, instead their data are compressed in an array that can be decompressed and built when a certain room is needed (when a player reachs that room). <br/>

### States
We distinguish two different dungeon states :
1. Dungeon Play State : 
    * This state of the dungeon describes the normal flow where the game will display the images and animation of the current room that the player is inside. 
    * Game interaction flows normally (player movement, entities, attacks, collision).
2. Dungeon Shift State : 
    * This state describes and handle the situation when the player is shifting between rooms.
    * It is launched whenever the player collides with a door with his direction being the inside of that door.
    * Game interaction is limited during the transition, keyboard inputs are ignored, entities freeze and the next room's generation and displaying starts.

The transition between dungeon states are handled using a state machine class in the play state.

## Room Representation
Rooms are encoded inside of array, and not instanciated during the dungeon generation to preserve memory efficiency. Each rooms can be represented by its corners, by connecting its corners together using walls, setting the doors and filling the inside with ground image we can effectively generate that room. <br/>
Each room instance and the objects/entities instances inside of it are instanciated when the main character reachs that room. Whenever the character leave a certain room all references to the room's instance as well as objects/entities instances are eliminated, and all there is left is for the garabage collector to erase it from the memory. <br/>

## Game AI
Entites possess a state where they follow the main character intelligently using a visibility graph. <br/>
The visibility graph offers a way to model the entire room as a graph instance. The construction of the graph is as follows : 
* Assigning a node to all object's corners inside of that room, while the edges represent a possible path between nodes that are unblocked by other objects. 
* The generation of such graph is based on an algorithm that will connect every node with every other node if the the geographic space between them is empty. 
* At the end the nodes representing the entities and main character's location are added.

We have obtained a graph where we have entities connected with all the object's corners which are directly accessible through a strait line which guarantees finding the shortest path between them and the main character.

The seach of the shortest path in this graph is left to the A* Search algorithm where each node is discovered and being assigned a value corresponding to the cartesian distance from the entitie's location to that node, after the discovery of the shortest path, the path is given to the entity in order to follow it. 

Since the main character could be idle as well as constantly moving, a shortest path calculated once, is only valid for that particular location. We need to find the shortest path at every frame update in order to take into account the change in the main character's location due to his movement.

The visibility graph is generated once whenever the room is generated (entered), and then it is destroyed whenever the main character leaves that room.

## Collision Detection
Collision detection is handled by using the quad tree to divide the spatial regions of the room whenever there is a concentration of objects. <br/>
Whenever the game is going to test the collision of the main character with the objects, it will query the quad tree to give all the objects that correspond to the spacial region that the player is inside. The spacial region is a small region containing near by objects.

Advantage : instead of testing the collision with every other game object, the quad tree will determine which spacial region the player is inside and then after determining the nearby objects, the collision detection algorithm (Axis-aligned-bouding-box) will be run between the player's location and the object's location. thus only testing the collision with a subset of room's objects.

Entities can't be integrated in the collision because of their nature since they can move and are not spacially fixed. Testing the collision with entities is simply running the algorithm on all the entities that are in that room.

## Game Control
Game control have not been implemented yet. There is no goal defined, the player can not win the game, neither can he die or lose.
