"DUNGEON for
			    DEADLINE
	 Copyright 1982 Infocom, Inc.  All rights reserved.
"

"Directions"

<DIRECTIONS NORTH SOUTH EAST WEST NE NW SE SW UP DOWN IN OUT>

"The usual globals"

<OBJECT GLOBAL-OBJECTS
	(FLAGS INVISIBLE TOUCHBIT SURFACEBIT OPENBIT TRANSBIT
	       SEARCHBIT)>

<OBJECT LOCAL-GLOBALS
	(IN GLOBAL-OBJECTS)
	(SYNONYM ZZKJLK ;"This synonym is necessary - God knows")>

<OBJECT ROOMS>

<OBJECT PSEUDO-OBJECT
	(IN LOCAL-GLOBALS)
	(DESC "FROBNO" ;"Place holder (MUST BE 6 CHARACTERS!!!!!)")
	(ACTION LIBRARY-F ;"Place holder")>

<OBJECT IT
	(IN GLOBAL-OBJECTS)
	(SYNONYM IT THEM)
	(DESC "X")
	(FLAGS NDESCBIT)>

<OBJECT HIM-HER
	(IN GLOBAL-OBJECTS)
	(SYNONYM HE SHE HIM HER)
	(DESC "X")
	(FLAGS NDESCBIT)>

"Necessary Flags"

<GLOBAL LOAD-MAX 100>
<GLOBAL LOAD-ALLOWED 100>

"Grounds of Robner Estate"

<ROOM SOUTH-LAWN
      (IN ROOMS)
      (LDESC
"You are on a wide lawn just north of the entrance to the Robner estate.
Directly north at the end of a pebbled path is the Robner house, flanked
to the northeast and northwest by a vast expanse of well-kept lawn.
Beyond the house can be seen the lakefront.")
      (DESC "South Lawn")
      (SYNONYM LAWN)
      (ADJECTIVE SOUTH)
      (FLAGS RLANDBIT ONBIT)
      (NORTH TO FRONT-PATH)
      (SOUTH "Leaving the estate would mean quitting the case and, most
probably, your job.")
      (NW TO WEST-LAWN)
      (NE TO EAST-LAWN)
      (GLOBAL LAWN HOUSE)
      (LINE 2)
      (STATION FRONT-PATH)
      (CORRIDOR 64)>

<ROOM FRONT-PATH
      (IN ROOMS)
      (DESC "Front Path")
      (SYNONYM PATH)
      (ADJECTIVE FRONT)
      (FLAGS RLANDBIT ONBIT)
      (ACTION FRONT-PATH-F)
      (IN TO FOYER IF FRONT-DOOR IS OPEN)
      (NORTH TO FOYER IF FRONT-DOOR IS OPEN)
      (SOUTH TO SOUTH-LAWN)
      (SE TO SOUTH-LAWN)
      (SW TO SOUTH-LAWN)
      (WEST TO WEST-OF-DOOR)
      (EAST TO EAST-OF-DOOR)
      (GLOBAL HOUSE FRONT-DOOR)
      (LINE 2)
      (STATION FRONT-PATH)
      (CORRIDOR 32)>

<ROOM WEST-OF-DOOR
      (IN ROOMS)
      (LDESC
"You are in front of the Robner house just west of the front door.  To the
north is a large bay window through which can be seen part of the living
room.  To the northwest is the west side of the house.")
      (DESC "West of Front Door")
      (FLAGS RLANDBIT ONBIT)
      (NORTH TO LIVING-ROOM IF BAY-WINDOW IS OPEN)
      (NE TO LIVING-ROOM IF BAY-WINDOW IS OPEN)
      (EAST TO FRONT-PATH)
      (WEST TO WEST-LAWN)
      (SOUTH TO SOUTH-LAWN)
      (SE TO SOUTH-LAWN)
      (SW TO SOUTH-LAWN)
      (NW TO WEST-SIDE)
      (GLOBAL BAY-WINDOW HOUSE)
      (ACTION WEST-DOOR-F)
      (LINE 2)
      (STATION WEST-OF-DOOR)
      (CORRIDOR 32)>

<ROOM EAST-OF-DOOR
      (IN ROOMS)
      (LDESC
"You are in front of the Robner house just east of the front door.  A small
window, closed and securely locked, is the only thing of note here. To the
northeast is the east side of the house.")
      (DESC "East of Front Door")
      (FLAGS RLANDBIT ONBIT)
      (NORTH "The window is closed and locked.")
      (WEST TO FRONT-PATH)
      (EAST TO EAST-LAWN)
      (SOUTH TO SOUTH-LAWN)
      (SE TO SOUTH-LAWN)
      (SW TO SOUTH-LAWN)
      (NE TO EAST-SIDE)
      (GLOBAL WINDOW HOUSE)
      (LINE 2)
      (STATION EAST-OF-DOOR)
      (CORRIDOR 96)>

 <ROOM WEST-LAWN
       (IN ROOMS)
       (LDESC
"This is a sprawling lawn west of the Robner house. To the west and north is
the lake shore.  To the northeast is a rose garden, and to the south another
wide lawn.")
       (DESC "West Lawn")
       (SYNONYM LAWN)
       (ADJECTIVE WEST)
       (FLAGS RLANDBIT ONBIT)
       (NORTH "You can't go into the lake.")
       (NW "You can't go into the lake.")
       (WEST "You can't go into the lake.")
       (NE TO ROSE-GARDEN)
       (EAST TO WEST-SIDE)
       (SE TO WEST-OF-DOOR)
       (SOUTH TO SOUTH-LAWN)
       (GLOBAL LAWN HOUSE LAKE)
       (LINE 2)
       (STATION WEST-LAWN)
       (CORRIDOR 32)> 
       
<ROOM EAST-LAWN
       (IN ROOMS)
       (LDESC
"You are on a neatly manicured lawn, east of the house, which extends north
and east to the shore of a lake. To the northwest is a peaceful orchard, and
toward the south another wide lawn. Southeast, beside the lake, is a small
shed with a solitary dirty window.")
       (DESC "East Lawn")
       (SYNONYM LAWN)
       (ADJECTIVE EAST)
       (FLAGS RLANDBIT ONBIT)
       (NORTH "You can't go into the lake.")
       (NE "You can't go into the lake.")
       (EAST "You can't go into the lake.")
       (NW TO ORCHARD)
       (WEST TO EAST-SIDE)
       (SW TO EAST-OF-DOOR)
       (SOUTH TO SOUTH-LAWN)
       (SE TO SHED-ROOM)
       (IN TO SHED-ROOM)
       (GLOBAL HOUSE LAWN SHED LAKE SHED-WINDOW)
       (LINE 2)
       (STATION EAST-LAWN)
       (CORRIDOR 672)>

<ROOM EAST-SIDE
      (IN ROOMS)
      (LDESC
"There are no windows or entries of any kind here at the east side of the
house. To the north is the orchard, and the front lawn lies to the south.
A lawn also slopes down toward the shore of a lake to the east.")
      (DESC "East Side of House")
      (FLAGS RLANDBIT ONBIT)
      (NORTH TO ORCHARD)
      (NE TO EAST-LAWN)
      (SOUTH TO EAST-OF-DOOR)
      (SE TO EAST-LAWN)
      (EAST TO EAST-LAWN)
      (WEST "You can't enter the house here.")
      (GLOBAL HOUSE)
      (LINE 2)
      (STATION EAST-SIDE)
      (CORRIDOR 64)>

<ROOM WEST-SIDE
      (IN ROOMS)
      (LDESC
"There are no doors or windows at ground level here on the west side of the
house. A beautiful rose garden, separated by a tall fence, lies to the north,
and the front of the house is to your south. A large lawn bordering the lake
lies to the west.")
      (DESC "West Side of House")
      (FLAGS RLANDBIT ONBIT)
      (SW TO WEST-LAWN)
      (WEST TO WEST-LAWN)
      (NW TO WEST-LAWN)
      (NORTH "A fence prevents your mucking up the rose garden.")
      (SE TO WEST-OF-DOOR)
      (SOUTH TO WEST-OF-DOOR)
      (EAST "You can't enter the house here.")
      (GLOBAL HOUSE)
      (PSEUDO "FENCE" RANDOM-PSEUDO)
      (LINE 2)
      (STATION WEST-SIDE)>

<ROOM SHED-ROOM
      (IN ROOMS)
      (LDESC
"This small garden shed is filled with implements of gardening and lawn care.
Shelves filled with various tools line the walls and a filthy window looks out
on the lawn.")    
      (DESC "Shed")
      (SYNONYM SHED CABIN)
      (ADJECTIVE TOOL GARDEN WOODEN)
      (FLAGS RLANDBIT ONBIT)
      (OUT TO EAST-LAWN)
      (NORTH TO EAST-LAWN)
      (NW TO EAST-LAWN)
      (GLOBAL SHED SHED-WINDOW)
      (LINE 2)
      (STATION EAST-LAWN)>

<ROOM BEHIND-SHED
      (IN ROOMS)
      (LDESC
"You are now between the shed and the lake, a position invisible from the
house or the adjacent lawns. There are no windows here, but you can easily
enter the shed via the door around the corner.")
      (DESC "Behind the Shed")
      (OUT TO EAST-LAWN)
      (IN TO SHED-ROOM)
      (EAST "You can't go into the lake.")
      (WEST TO EAST-LAWN)
      (NORTH TO EAST-LAWN)
      (SOUTH TO SOUTH-LAWN)
      (FLAGS RLANDBIT ONBIT)
      (GLOBAL SHED)
      (LINE 2)
      (STATION EAST-LAWN)>      

<ROOM ROSE-GARDEN 
      (IN ROOMS)
      (DESC "Garden Path")
      (SYNONYM PATH)
      (ADJECTIVE GARDEN ROSE FLOWER)
      (FLAGS RLANDBIT ONBIT)
      (ACTION ROSE-GARDEN-F)
      (NORTH TO NORTH-LAWN)
      (NE TO NORTH-LAWN)
      (NW TO NORTH-LAWN)
      (SW TO WEST-LAWN)
      (WEST TO WEST-LAWN)
      (EAST TO ORCHARD)
      (SOUTH TO IN-ROSES)
      (SE TO IN-ROSES)
      (GLOBAL ROSE HOUSE DINING-ROOM-WINDOW)
      (LINE 2)
      (STATION ROSE-GARDEN)
      (CORRIDOR 2048)>

<ROOM IN-ROSES
      (IN ROOMS)
      (DESC "Among the Roses")
      (FLAGS RLANDBIT ONBIT)
      (ACTION IN-ROSES-F)
      (UP TO LIBRARY-BALCONY IF LADDER-FLAG)
      (NORTH TO ROSE-GARDEN)
      (NE TO ROSE-GARDEN)
      (NW TO ROSE-GARDEN)
      (WEST TO WEST-LAWN)
      (EAST TO IN-ORCHARD)
      (SOUTH "You can't enter the house here.")
      (GLOBAL DINING-ROOM-WINDOW HOUSE ROSE BALCONY)
      (LINE 2)
      (STATION ROSE-GARDEN)>

<ROOM ORCHARD
      (IN ROOMS)
      (LDESC
"You are on a path at the edge of a small orchard of fruit trees which abuts
the eastern side of the back of the house. The orchard is obviously intended
more to display the beauty of the blossoms in spring than to produce
significant amounts of fruit. The windows of the kitchen look out onto the
orchard, although your view of them is blocked by the trees and a small grape
arbor.  To the west is a path along a rose garden, and lawns sweep out to the
north and east.")
      (DESC "Orchard Path")
      (SYNONYM PATH)
      (ADJECTIVE ORCHARD)
      (FLAGS RLANDBIT ONBIT)
      (EAST TO EAST-LAWN)
      (SE TO EAST-LAWN)
      (NORTH TO NORTH-LAWN)
      (NW TO NORTH-LAWN)
      (NE TO NORTH-LAWN)
      (WEST TO ROSE-GARDEN)
      (SOUTH TO IN-ORCHARD)
      (SW TO IN-ORCHARD)
      (GLOBAL KITCHEN-WINDOW HOUSE FRUIT-TREES)
      (LINE 2)
      (STATION ORCHARD)
      (CORRIDOR 2176)>

<ROOM IN-ORCHARD
      (IN ROOMS)
      (DESC "In the Orchard")
      (FLAGS RLANDBIT ONBIT)
      (NORTH TO ORCHARD)
      (WEST TO IN-ROSES)
      (NW TO ORCHARD)
      (NE TO ORCHARD)
      (UP TO BEDROOM-BALCONY IF LADDER-FLAG-2)
      (SOUTH TO EAST-SIDE)
      (ACTION IN-ORCHARD-F)
      (GLOBAL KITCHEN-WINDOW HOUSE FRUIT-TREES BALCONY)
      (LINE 2)
      (STATION ORCHARD)>

<ROOM NORTH-LAWN
      (IN ROOMS)
      (LDESC
"This idyllic spot lies on a jut of land well north of the house and is
surrounded on three sides by lake shore.  Its charm includes the sweet smell
of roses blown on a southwest breeze from the rose garden and by the sound
of the leaves rustling in the orchard to the southeast.")
      (DESC "North Lawn")
      (SYNONYM LAWN)
      (ADJECTIVE NORTH)
      (FLAGS RLANDBIT ONBIT)
      (NE "You can't go into the lake.")
      (NW "You can't go into the lake.")
      (NORTH "You can't go into the lake.")
      (EAST "You can't go into the lake.")
      (WEST "You can't go into the lake.")
      (SW TO ROSE-GARDEN)
      (SE TO ORCHARD)
      (SOUTH TO ROSE-GARDEN)
      (GLOBAL LAWN HOUSE LAKE)
      (LINE 2)
      (STATION NORTH-LAWN)
      (CORRIDOR 128)>

"The First Floor"

<ROOM FOYER
      (IN ROOMS)
      (DESC "Foyer")
      (SYNONYM FOYER)
      (FLAGS RLANDBIT ONBIT)
      (ACTION FOYER-F)
      (SOUTH TO FRONT-PATH IF FRONT-DOOR IS OPEN)
      (NORTH TO NFOYER)
      (OUT TO FRONT-PATH IF FRONT-DOOR IS OPEN)
      (GLOBAL FRONT-DOOR)
      (LINE 1)
      (STATION FOYER)
      (CORRIDOR 8)>

<ROOM NFOYER
      (IN ROOMS)
      (LDESC 
"This is a hallway north of the foyer. To the west is an open doorway, and to
the east is the foot of a staircase. The hall continues north.")
      (DESC "North of Foyer")
      (FLAGS RLANDBIT ONBIT)
      (SOUTH TO FOYER)
      (WEST TO LIVING-ROOM)
      (EAST TO STAIR-BOTTOM)
      (NORTH TO CORNER)
      (LINE 1)
      (STATION NFOYER)
      (CORRIDOR 264)>

<ROOM SHALL-1
      (IN ROOMS)
      (DESC "South Hallway")
      (FLAGS RLANDBIT ONBIT)
      (ACTION SHALL-1-F)
      (EAST TO SHALL-2)
      (NORTH TO STAIR-BOTTOM)
      (SOUTH TO ROURKE-ROOM IF ROURKE-DOOR IS OPEN)
      (GLOBAL ROURKE-DOOR)
      (LINE 1)
      (STATION SHALL-1)
      (CORRIDOR 16)>
      
<ROOM SHALL-2
      (IN ROOMS)
      (DESC "South Hallway")
      (FLAGS RLANDBIT ONBIT)
      (ACTION SHALL-2-F)
      (EAST TO ROURKE-BATH IF ROURKE-BATH-DOOR IS OPEN)
      (WEST TO SHALL-1)
      (SOUTH TO SOUTH-CLOSET IF SOUTH-CLOSET-DOOR IS OPEN)
      (GLOBAL ROURKE-BATH-DOOR SOUTH-CLOSET-DOOR)
      (LINE 1)
      (STATION SHALL-2)>      

<ROOM ROURKE-ROOM
      (IN ROOMS)
      (DESC "Mrs. Rourke's Room")
      (SYNONYM BEDROOM ROOM)
      (ADJECTIVE ROURKE)
      (ACTION ROURKE-ROOM-F)
      (FLAGS RLANDBIT ONBIT)
      (NORTH TO SHALL-1 IF ROURKE-DOOR IS OPEN)
      (OUT TO SHALL-1 IF ROURKE-DOOR IS OPEN)
      (GLOBAL ROURKE-DOOR END-TABLE CHAIR BED WINDOW)
      (LINE 1)
      (STATION SHALL-1)>

<ROOM ROURKE-BATH
      (IN ROOMS)
      (DESC "Mrs. Rourke's Bathroom")
      (FLAGS RLANDBIT ONBIT)
      (ACTION ROURKE-BATH-F)
      (WEST TO SHALL-2 IF ROURKE-BATH-DOOR IS OPEN)
      (GLOBAL ROURKE-BATH-DOOR TOILET SHOWER SINK)
      (LINE 1)
      (STATION SHALL-2)>

<ROOM SOUTH-CLOSET
      (IN ROOMS)
      (LDESC
"This is a little-used storage closet containing odds and ends of no interest
whatsoever. The exit is to the north.")
      (DESC "South Closet")
      (SYNONYM CLOSET)
      (ADJECTIVE SOUTH)
      (FLAGS RLANDBIT ONBIT)
      (NORTH TO SHALL-2 IF SOUTH-CLOSET-DOOR IS OPEN)
      (OUT TO SHALL-2 IF SOUTH-CLOSET-DOOR IS OPEN)
      (GLOBAL SOUTH-CLOSET-DOOR CLOSET)
      (LINE 1)
      (STATION SHALL-2)
      (SIZE 1)>
      	    
<ROOM STAIR-BOTTOM
      (IN ROOMS)
      (LDESC
"You are at the foot of the stairs to the second floor. Open archways lead
west and south.")
      (DESC "Bottom of Stairs")
      (FLAGS RLANDBIT ONBIT)
      (UP TO STAIRS)
      (SOUTH TO SHALL-1)
      (WEST TO NFOYER)
      (GLOBAL STAIRS)
      (LINE 1)
      (STATION STAIR-BOTTOM)
      (CORRIDOR 272)>

<ROOM LIVING-ROOM
      (IN ROOMS)
      (DESC "Living Room")
      (SYNONYM ROOM)
      (ADJECTIVE LIVING)
      (FLAGS RLANDBIT ONBIT)
      (ACTION LIVING-ROOM-F)
      (EAST TO NFOYER)
      (OUT TO NFOYER)
      (SOUTH TO WEST-OF-DOOR IF BAY-WINDOW IS OPEN)
      (GLOBAL BAY-WINDOW TELEPHONE SOFA CHAIR LGTABLE)
      (LINE 1)
      (STATION NFOYER)>

<ROOM CORNER
      (IN ROOMS)
      (DESC "Corner")
      (LDESC
"You are at the corner of two halls, one a short hallway to the west ending
with a set of doors, and the other a long hall leading south toward the front
door. To the north are swinging double doors leading into the kitchen.")
      (FLAGS RLANDBIT ONBIT)
      (SOUTH TO NFOYER)
      (WEST TO DINING-ROOM)
      (NORTH TO KITCHEN)
      (LINE 3)
      (STATION CORNER)
      (CORRIDOR 8)>

<ROOM DINING-ROOM
      (IN ROOMS)
      (LDESC
"You have entered the dining room. A long table seating twelve is in the
center of the room and a large trestle table is against the south wall. A
large picture window to the north allows a view of the rose garden. Hanging
on the wall are several cheerful paintings, including one by Seurat which
appears to be an original.")
      (DESC "Dining Room")
      (SYNONYM ROOM)
      (ADJECTIVE DINING)
      (FLAGS RLANDBIT ONBIT)
      (EAST TO CORNER)
      (OUT TO CORNER)
      (GLOBAL DINING-ROOM-WINDOW)
      (LINE 3)
      (STATION DINING-ROOM)>

<ROOM KITCHEN
      (IN ROOMS)
      (LDESC
"This is the Robner kitchen, quite large and with a full complement of
appliances and labor-saving devices. On one wall, a beautifully-crafted
shelf unit contains rare china, a unique hand-painted family heirloom
depicting scenes from Greek mythology. The china consists of many place
settings of plates, teacups, and saucers. There are several cabinets which
likely contain silverware, glasses, and the like. To the east is a pantry.")
      (DESC "Kitchen")
      (SYNONYM KITCHEN)
      (FLAGS RLANDBIT ONBIT)
      (SOUTH TO CORNER)
      (EAST TO PANTRY)
      (GLOBAL KITCHEN-WINDOW SINK)
      (LINE 3)
      (STATION KITCHEN)>

<ROOM PANTRY
      (IN ROOMS)
      (LDESC
"This is the pantry with shelves containing a large selection of canned and
packaged foods, such as fruits, vegetables, and dry goods.")
      (DESC "Pantry")
      (SYNONYM PANTRY)
      (FLAGS RLANDBIT ONBIT)
      (WEST TO KITCHEN)
      (LINE 3)
      (STATION PANTRY)>

"Staircase"

<ROOM STAIRS
      (IN ROOMS)
      (LDESC
"You are on a landing halfway up the flight of stairs. You notice that the
stairs do indeed make quite a noise when stepped upon.")
      (DESC "Stairs")
      (SYNONYM STAIRS)
      (FLAGS RLANDBIT ONBIT)
      (UP TO STAIR-TOP)
      (DOWN TO STAIR-BOTTOM)
      (GLOBAL STAIRS)
      (LINE 1)
      (STATION STAIRS)
      (CORRIDOR 256)>

"Second Floor of Robner House"

<ROOM STAIR-TOP
      (IN ROOMS)
      (LDESC
"You are at the top of the staircase where short hallways run north and south
and a corridor the length of the house heads west.")
      (DESC "Top of Stairs")
      (FLAGS RLANDBIT ONBIT)
      (DOWN TO STAIRS)
      (NORTH TO NORTH-HALL)
      (SOUTH TO SHALL-11)
      (WEST TO CORRIDOR-1)
      (GLOBAL STAIRS)
      (LINE 0)
      (STATION STAIR-TOP)
      (CORRIDOR 3)>

<ROOM CORRIDOR-1
      (IN ROOMS)
      (DESC "Hallway")
      (FLAGS RLANDBIT ONBIT)
      (ACTION CORRIDOR-1-F)
      (EAST TO STAIR-TOP)
      (WEST TO CORRIDOR-2)
      (SOUTH TO DUNBAR-ROOM IF DUNBAR-DOOR IS OPEN)
      (NORTH TO MASTER-BEDROOM IF MASTER-BEDROOM-DOOR IS OPEN)
      (GLOBAL DUNBAR-DOOR MASTER-BEDROOM-DOOR)
      (LINE 0)
      (STATION CORRIDOR-1)
      (CORRIDOR 1)>

<ROOM CORRIDOR-2
      (IN ROOMS)
      (LDESC
"This is approximately the middle of the corridor, a convenient place for a
closet full of linens. Stairs to the east and a window to the west are about
equidistant. The closet, to the north, is open and rather shallow.")
      (DESC "Hallway")
      (FLAGS RLANDBIT ONBIT)
      (NORTH TO UPSTAIRS-CLOSET)
      (EAST TO CORRIDOR-1)
      (WEST TO CORRIDOR-3)
      (GLOBAL CLOSET)
      (LINE 0)
      (STATION CORRIDOR-2)
      (CORRIDOR 1025)>
 
<ROOM CORRIDOR-3
      (IN ROOMS)
      (DESC "Hallway")
      (FLAGS RLANDBIT ONBIT)
      (ACTION CORRIDOR-3-F)
      (EAST TO CORRIDOR-2)
      (WEST TO CORRIDOR-4)
      (SOUTH TO GEORGE-ROOM IF GEORGE-DOOR IS OPEN)
      (GLOBAL GEORGE-DOOR)
      (LINE 0)
      (STATION CORRIDOR-3)
      (CORRIDOR 1)>

<ROOM CORRIDOR-4
      (IN ROOMS)
      (DESC "End of Hallway")
      (FLAGS RLANDBIT ONBIT)
      (ACTION CORRIDOR-4-F)
      (EAST TO CORRIDOR-3)
      (WEST "The hall ends here.")
      (NORTH TO LIBRARY)
      (GLOBAL LIBRARY-DOOR)
      (LINE 0)
      (STATION CORRIDOR-4)
      (CORRIDOR 1)>

<ROOM LIBRARY
      (IN ROOMS)
      (DESC "Library")
      (SYNONYM LIBRARY)
      (FLAGS RLANDBIT ONBIT)
      (ACTION LIBRARY-F)
      (EAST TO HIDDEN-CLOSET IF HIDDEN-DOOR-L IS OPEN)
      (SOUTH TO CORRIDOR-4)
      (NORTH TO LIBRARY-BALCONY IF LIBRARY-BALCONY-DOOR IS OPEN)
      (GLOBAL HIDDEN-DOOR-L LIBRARY-BALCONY-DOOR TELEPHONE LIBRARY-DOOR)
      (LINE 0)
      (STATION LIBRARY)>

<ROOM LIBRARY-BALCONY
      (IN ROOMS)
      (DESC "Library Balcony")
      (SYNONYM BALCONY)
      (ADJECTIVE LIBRARY)
      (FLAGS RLANDBIT ONBIT)
      (ACTION LIBRARY-BALCONY-F)
      (SOUTH TO LIBRARY IF LIBRARY-BALCONY-DOOR IS OPEN)
      (DOWN TO IN-ROSES IF LADDER-FLAG
        ELSE "The fall would probably kill you.")
      (GLOBAL LIBRARY-BALCONY-DOOR)
      (LINE 0)
      (STATION LIBRARY-BALCONY)>

<ROOM UPSTAIRS-CLOSET
      (IN ROOMS)
      (LDESC
"The closet is rather shallow and has some shelves full of assorted linens,
towels, and uninteresting toilet articles.")
      (DESC "Upstairs Closet")
      (SYNONYM CLOSET)
      (ADJECTIVE UPSTAIRS)
      (FLAGS RLANDBIT ONBIT)
      (OUT TO CORRIDOR-2)
      (SOUTH TO CORRIDOR-2)
      (GLOBAL CLOSET)
      (LINE 0)
      (STATION CORRIDOR-2)
      (CORRIDOR 1024)>

<ROOM HIDDEN-CLOSET
      (IN ROOMS)
      (DESC "Hidden Closet")
      (SYNONYM CLOSET)
      (ADJECTIVE HIDDEN)
      (FLAGS RLANDBIT ONBIT)
      (ACTION HIDDEN-CLOSET-F)
      (EAST TO MASTER-BEDROOM IF HIDDEN-DOOR-B IS OPEN)
      (WEST TO LIBRARY IF HIDDEN-DOOR-L IS OPEN)
      (GLOBAL HIDDEN-DOOR-B HIDDEN-DOOR-L CLOSET)
      (LINE 0)
      (STATION LIBRARY)>

<ROOM MASTER-BEDROOM
      (IN ROOMS)
      (DESC "Master Bedroom")
      (SYNONYM BEDROOM ROOM)
      (ADJECTIVE MASTER ROBNER)
      (FLAGS RLANDBIT ONBIT)
      (ACTION MASTER-BEDROOM-F)
      (WEST TO HIDDEN-CLOSET IF HIDDEN-DOOR-B IS OPEN)
      (NORTH TO BEDROOM-BALCONY IF BEDROOM-BALCONY-DOOR IS OPEN)
      (SOUTH TO CORRIDOR-1 IF MASTER-BEDROOM-DOOR IS OPEN)
      (EAST TO MASTER-BATH)
      (GLOBAL HIDDEN-DOOR-B BEDROOM-BALCONY-DOOR MASTER-BEDROOM-DOOR
              END-TABLE CHAIR TELEPHONE)
      (LINE 0)
      (STATION CORRIDOR-1)>

<ROOM MASTER-BATH
      (IN ROOMS)
      (LDESC
"This is Mr. and Mrs. Robner's private bathroom, accessible only from
the bedroom through a door to the west. On one wall is a mirror over a long
counter containing two sinks, and in addition to the usual bathroom fixtures
is a jacuzzi. Hanging plants give the room an almost tropical atmosphere.")
      (DESC "Master Bathroom")
      (SYNONYM BATH BATHROOM)
      (ADJECTIVE MASTER)
      (FLAGS RLANDBIT ONBIT)
      (WEST TO MASTER-BEDROOM)
      (OUT TO MASTER-BEDROOM)
      (GLOBAL SHOWER TOILET SINK)
      (PSEUDO "TOOTHPASTE" RANDOM-PSEUDO)>

<ROOM BEDROOM-BALCONY
      (IN ROOMS)
      (DESC "Bedroom Balcony")
      (SYNONYM BALCONY)
      (ADJECTIVE BEDROOM)
      (FLAGS RLANDBIT ONBIT)
      (ACTION BEDROOM-BALCONY-F)
      (SOUTH TO MASTER-BEDROOM IF BEDROOM-BALCONY-DOOR IS OPEN)
      (DOWN TO IN-ORCHARD IF LADDER-FLAG-2 ELSE "The jump is inadvisable.")
      (GLOBAL BEDROOM-BALCONY-DOOR)>

<ROOM NORTH-HALL
      (IN ROOMS)
      (LDESC
"This is the end of a short north-south hallway. To the east is a small room.")
      (DESC "North Upstairs Hall")
      (FLAGS RLANDBIT ONBIT)
      (EAST TO GUEST-ROOM)
      (SOUTH TO STAIR-TOP)
      (LINE 0)
      (STATION STAIR-TOP)>

<ROOM GUEST-ROOM
      (IN ROOMS)
      (DESC "Guest Room")
      (LDESC
"This room contains the bare essentials for a guest room: bed, tables, and a
chair. A window looks out toward the east.")
      (FLAGS RLANDBIT ONBIT)
      (WEST TO NORTH-HALL)
      (GLOBAL END-TABLE CHAIR BED)
      (LINE 0)
      (CORRIDOR 0)
      (STATION STAIR-TOP)>

<ROOM SHALL-11
      (IN ROOMS)
      (DESC "South Upstairs Hall")
      (FLAGS RLANDBIT ONBIT)
      (ACTION SHALL-11-F)
      (NORTH TO STAIR-TOP)
      (EAST TO SHALL-12)
      (SOUTH TO DUNBAR-BATH IF DUNBAR-BATH-DOOR IS OPEN)
      (GLOBAL DUNBAR-BATH-DOOR)
      (LINE 0)
      (STATION SHALL-11)
      (CORRIDOR 6)>

<ROOM SHALL-12
      (IN ROOMS)
      (LDESC
"The hall ends here. To the south is a walk-in closet.")
      (DESC "End of South Hall")
      (FLAGS RLANDBIT ONBIT)
      (WEST TO SHALL-11)
      (SOUTH TO CLOSET-11)
      (IN TO CLOSET-11)
      (LINE 0)
      (STATION SHALL-12)
      (CORRIDOR 4)>

<ROOM CLOSET-11
      (IN ROOMS)
      (LDESC
"This large closet has many shelves containing various cleaning equipment
and supplies.")
      (DESC "Closet")
      (FLAGS RLANDBIT ONBIT)
      (OUT TO SHALL-12)
      (NORTH TO SHALL-12)
      (GLOBAL CLOSET)>
      
<ROOM DUNBAR-BATH
      (IN ROOMS)
      (DESC "Dunbar's Bathroom")
      (SYNONYM BATHROOM BATH)
      (ADJECTIVE DUNBAR)
      (FLAGS RLANDBIT ONBIT)
      (ACTION DUNBAR-BATH-F)
      (NORTH TO SHALL-11 IF DUNBAR-BATH-DOOR IS OPEN)
      (GLOBAL DUNBAR-BATH-DOOR SHOWER TOILET SINK)
      (PSEUDO "POLISH" RANDOM-PSEUDO "NAILPOLISH" RANDOM-PSEUDO)
      (LINE 0)
      (STATION SHALL-11)>

<ROOM DUNBAR-ROOM
      (IN ROOMS)
      (DESC "Dunbar's Bedroom")
      (SYNONYM BEDROOM ROOM)
      (ADJECTIVE DUNBAR)
      (FLAGS RLANDBIT ONBIT)
      (ACTION DUNBAR-ROOM-F)
      (NORTH TO CORRIDOR-1 IF DUNBAR-DOOR IS OPEN)
      (GLOBAL DUNBAR-DOOR END-TABLE CHAIR BED)
      (LINE 0)
      (STATION CORRIDOR-1)>

<ROOM GEORGE-BATH
      (IN ROOMS)
      (DESC "George's Bathroom")
      (SYNONYM BATHROOM ROOM)
      (ADJECTIVE GEORGE)
      (FLAGS RLANDBIT ONBIT)
      (ACTION GEORGE-BATH-F)
      (WEST TO GEORGE-ROOM IF GEORGE-BATH-DOOR IS OPEN)
      (GLOBAL GEORGE-BATH-DOOR TOILET SHOWER SINK)
      (LINE 0)
      (STATION CORRIDOR-3)>

<ROOM GEORGE-ROOM
      (IN ROOMS)
      (DESC "George's Bedroom")
      (SYNONYM BEDROOM ROOM)
      (ADJECTIVE GEORGE)
      (FLAGS RLANDBIT ONBIT)
      (ACTION GEORGE-ROOM-F)
      (NORTH TO CORRIDOR-3 IF GEORGE-DOOR IS OPEN)
      (EAST TO GEORGE-BATH IF GEORGE-BATH-DOOR IS OPEN)
      (GLOBAL GEORGE-DOOR GEORGE-BATH-DOOR END-TABLE CHAIR BED)
      (LINE 0)
      (STATION CORRIDOR-3)>

"Doors"

<OBJECT SOUTH-CLOSET-DOOR 
	(IN LOCAL-GLOBALS)
	(ADJECTIVE CLOSET)
	(SYNONYM DOOR)
	(DESC "south closet door")
	(FLAGS DOORBIT CONTBIT OPENBIT)
	(ACTION DOOR-F)>

<OBJECT FRONT-DOOR 
	(IN LOCAL-GLOBALS)
	(SYNONYM DOOR)
	(ADJECTIVE FRONT)
	(DESC "front door")
	(FLAGS DOORBIT CONTBIT)
	(ACTION DOOR-F)>

<OBJECT ROURKE-DOOR 
	(IN LOCAL-GLOBALS)
	(SYNONYM DOOR)
	(DESC "door")
	(FLAGS DOORBIT CONTBIT)
	(ACTION DOOR-F)>

<OBJECT DUNBAR-DOOR 
	(IN LOCAL-GLOBALS)
	(SYNONYM DOOR)
	(ADJECTIVE DUNBAR SOUTH SOUTHE)
	(DESC "south door")
	(FLAGS DOORBIT CONTBIT)
	(ACTION DOOR-F)>

<OBJECT DUNBAR-BATH-DOOR 
	(IN LOCAL-GLOBALS)
	(SYNONYM DOOR)
	(DESC "door")
	(FLAGS DOORBIT CONTBIT OPENBIT)>

<OBJECT ROURKE-BATH-DOOR 
	(IN LOCAL-GLOBALS)
	(SYNONYM DOOR)
	(ADJECTIVE BATHROOM)
	(DESC "bathroom door")
	(FLAGS DOORBIT CONTBIT)>

<OBJECT MASTER-BEDROOM-DOOR 
	(IN LOCAL-GLOBALS)
	(SYNONYM DOOR)
	(ADJECTIVE BEDROOM MASTER NORTH)
	(DESC "bedroom door")
	(FLAGS DOORBIT CONTBIT)
	(ACTION MASTER-BEDROOM-DOOR-F)>

<OBJECT GEORGE-DOOR
	(IN LOCAL-GLOBALS)
	(SYNONYM DOOR)
	(ADJECTIVE BEDROOM SOUTH SOUTHE)
	(DESC "bedroom door")
	(FLAGS DOORBIT CONTBIT)
	(ACTION DOOR-F)>

<OBJECT GEORGE-BATH-DOOR 
	(IN LOCAL-GLOBALS)
	(SYNONYM DOOR)
	(ADJECTIVE BATHROOM EAST)
	(DESC "bathroom door")
	(FLAGS DOORBIT CONTBIT OPENBIT)>

<OBJECT HIDDEN-DOOR-L
	(IN LOCAL-GLOBALS)
	(SYNONYM DOOR)
	(ADJECTIVE HIDDEN)
	(DESC "hidden door")
	(FLAGS DOORBIT CONTBIT INVISIBLE)>

<OBJECT HIDDEN-DOOR-B
	(IN LOCAL-GLOBALS)
	(SYNONYM DOOR)
	(ADJECTIVE HIDDEN)
	(DESC "hidden door")
	(FLAGS DOORBIT CONTBIT INVISIBLE)>

<OBJECT LIBRARY-BALCONY-DOOR 
	(IN LOCAL-GLOBALS)
	(SYNONYM DOOR DOORS WINDOW)
	(ADJECTIVE BALCONY)
	(DESC "balcony door")
	(FLAGS DOORBIT CONTBIT)
	(ACTION BALCONY-DOOR-F)>

<OBJECT BEDROOM-BALCONY-DOOR 
	(IN LOCAL-GLOBALS)
	(SYNONYM DOOR DOORS WINDOW)
	(ADJECTIVE GLASS BALCONY)
	(DESC "balcony door")
	(FLAGS DOORBIT CONTBIT)
	(ACTION BALCONY-DOOR-F)>

"Objects start here...."

<OBJECT ROSE
	(IN LOCAL-GLOBALS)
	(DESC "roses")
	(SYNONYM BED ROSE ROSES)
	(ADJECTIVE RED WHITE PINK YELLOW)
	(ACTION ROSE-F)>

<OBJECT HOUSE
	(IN LOCAL-GLOBALS)
	(DESC "house")
	(SYNONYM HOUSE WALL)
	(ADJECTIVE ROBNER)
	(ACTION HOUSE-F)>

<OBJECT LAWN
	(IN LOCAL-GLOBALS)
	(DESC "lawn")
	(SYNONYM LAWN GRASS)
	(ADJECTIVE GREEN)
	(ACTION LAWN-F)>

<OBJECT GROUND
	(IN GLOBAL-OBJECTS)
	(DESC "ground")
	(SYNONYM GROUND DIRT MUD SOIL ;AREA)
	(ADJECTIVE HARD)
	(ACTION GROUND-F)>

<OBJECT AIR
	(IN GLOBAL-OBJECTS)
	(DESC "air")
	(SYNONYM AIR WIND BREEZE)
	(ACTION AIR-F)>

<OBJECT SHED
	(IN LOCAL-GLOBALS)
	(DESC "shed")
	(SYNONYM SHED CABIN)
	(ADJECTIVE LOG WOODEN WOOD)
	(ACTION SHED-F)>

<OBJECT LAKE
	(IN LOCAL-GLOBALS)
	(DESC "lake")
	(SYNONYM LAKE WATER)
	(ACTION LAKE-F)>

<OBJECT BALCONY
	(IN LOCAL-GLOBALS)
	(DESC "balcony")
	(SYNONYM BALCONY)>	

<OBJECT BAY-WINDOW
	(IN LOCAL-GLOBALS)
	(DESC "bay window")
	(SYNONYM WINDOW)
	(ADJECTIVE BAY)
	(FLAGS DOORBIT CONTBIT)
	(ACTION BAY-WINDOW-F)>
	
"Kludge"

<ROOM XXX
      (IN ROOMS)
      (DESC "X")
      (FDESC "FROB")
      (SIZE 10)
      (CAPACITY 10)>

"People"

<OBJECT PLAYER
	(IN SOUTH-LAWN)
	(DESC "player")
	(SYNONYM ME PLAYER INSPECTOR)
	(ACTION PLAYER-F)
	(FLAGS NDESCBIT)
	(CHARACTER 0)>

<OBJECT GARDENER
	(IN NORTH-LAWN)
	(DESC "Mr. McNabb")
	(SYNONYM MCNABB)
	(ADJECTIVE MR MISTER ANGUS)
	(ACTION GARDENER-F)
	(DESCFCN GARDENER-F)
	(FLAGS PERSON OPENBIT)
	(CAPACITY 40)
	(CHARACTER 1)
	(STATE 0)>

<OBJECT GLOBAL-GARDENER
	(DESC "Mr. McNabb")
	(IN GLOBAL-OBJECTS)
	(SYNONYM MCNABB)
	(ADJECTIVE MR MISTER ANGUS)
	(FLAGS PERSON)
	(ACTION GLOBAL-PERSON)
	(CHARACTER 1)>

<OBJECT BAXTER
	(DESC "Mr. Baxter")
	(SYNONYM BAXTER)
	(ADJECTIVE MISTER MR)
	(FLAGS PERSON OPENBIT)
	(CAPACITY 40)
	(ACTION BAXTER-F)
	(DESCFCN BAXTER-F)
	(STATE 0)
	(CHARACTER 2)>

<OBJECT GLOBAL-BAXTER
	(IN GLOBAL-OBJECTS)
	(DESC "Mr. Baxter")
	(SYNONYM BAXTER)
	(ADJECTIVE MISTER MR)
	(FLAGS PERSON)
	(ACTION GLOBAL-PERSON)
	(CHARACTER 2)>

<OBJECT DUNBAR
	(IN LIVING-ROOM)
        (DESC "Ms. Dunbar")
	(SYNONYM DUNBAR)
	(ADJECTIVE MS MRS)
	(FLAGS PERSON OPENBIT)
	(CAPACITY 40)
	(ACTION DUNBAR-F)
	(DESCFCN DUNBAR-F)
	(STATE 0)
	(CHARACTER 3)>

<OBJECT GLOBAL-DUNBAR
	(IN GLOBAL-OBJECTS)
	(DESC "Ms. Dunbar")
	(SYNONYM DUNBAR)
	(ADJECTIVE MS MRS)
	(FLAGS PERSON)
	(ACTION GLOBAL-PERSON)
	(CHARACTER 3)>

<OBJECT GEORGE
	(IN GEORGE-ROOM)
	(DESC "George")
	(ADJECTIVE GEORGE)
	(SYNONYM GEORGE ROBNER)
	(FLAGS PERSON OPENBIT)
	(CAPACITY 40)
	(ACTION GEORGE-F)
	(DESCFCN GEORGE-F)
	(STATE 0)
	(CHARACTER 4)>

<OBJECT GLOBAL-GEORGE
	(IN GLOBAL-OBJECTS)
	(DESC "George")
	(ADJECTIVE GEORGE)
	(SYNONYM GEORGE ROBNER)
	(FLAGS PERSON)
	(ACTION GLOBAL-PERSON)
	(CHARACTER 4)>

<OBJECT MRS-ROBNER
	(IN LIVING-ROOM)
	(DESC "Mrs. Robner")
	(SYNONYM ROBNER MOTHER LESLIE)
	(ADJECTIVE MRS MS LESLIE)
	(FLAGS PERSON OPENBIT)
	(CAPACITY 40)
	(ACTION MRS-ROBNER-F)
	(DESCFCN MRS-ROBNER-F)
	(STATE 0)
	(CHARACTER 5)>

<OBJECT GLOBAL-MRS-ROBNER
	(IN GLOBAL-OBJECTS)
	(DESC "Mrs. Robner")
	(SYNONYM ROBNER MOTHER LESLIE)
	(ADJECTIVE MRS MS LESLIE)
	(FLAGS PERSON)
	(ACTION GLOBAL-PERSON)
	(CHARACTER 5)>

<OBJECT ROURKE
	(IN KITCHEN)
	(DESC "Mrs. Rourke")
	(SYNONYM ROURKE)
	(ADJECTIVE MS MRS)
	(FLAGS PERSON OPENBIT)
	(CAPACITY 40)
	(ACTION ROURKE-F)
	(DESCFCN ROURKE-F)
	(STATE 0)
	(CHARACTER 6)>

<OBJECT GLOBAL-ROURKE
	(IN GLOBAL-OBJECTS)
	(DESC "Mrs. Rourke")
	(SYNONYM ROURKE)
	(ADJECTIVE MS MRS)
	(FLAGS PERSON)
	(ACTION GLOBAL-PERSON)
	(CHARACTER 6)>

"Evidence"

<OBJECT LIBRARY-DESK
	(IN LIBRARY)
	(SYNONYM DESK)
	(ADJECTIVE LARGE EXECUTIVE)
	(DESC "desk")
	(FLAGS NDESCBIT SURFACEBIT CONTBIT OPENBIT)
	(ACTION LIBRARY-DESK-F)
	(CAPACITY 25)>

<OBJECT NOTE-PAPER
	(IN LIBRARY-DESK)
	(SYNONYM PAD PAPER NOTEPAD)
	(ADJECTIVE NOTE WHITE)
	(FDESC "Lying atop the desk is a pad of white note paper.")
	(DESC "note pad")
	(FLAGS TAKEBIT READBIT BURNBIT)
	(ACTION NOTE-PAPER-F)>

<OBJECT DESK-CALENDAR
	(IN LIBRARY-DESK)
	(DESC "desk calendar")
	(SYNONYM CALENDAR JULY)
	(ADJECTIVE DESK)
	(FLAGS TAKEBIT READBIT BURNBIT TURNBIT)
	(ACTION DESK-CALENDAR-F)
	(DESCFCN DESK-CALENDAR-F)>

<OBJECT BAXTER-PAPERS
	(IN SAFE)
	(SYNONYM STACK PAPERS)
	(FDESC "A stack of papers bound together is in the safe.")
	(DESC "stack of papers")
	(FLAGS TAKEBIT READBIT BURNBIT INVISIBLE)
	(TEXT
"Leafing through these papers, it becomes obvious that they incriminate Mr.
Baxter in wrongdoings regarding the Focus scandal. They document funds which
were embezzled by Baxter and tell how the scandal was hushed up. This evidence
would be sufficient to convict Mr. Baxter in the Focus case.")>

<OBJECT NEW-WILL
	(IN SAFE)
	(DESC "new will")
	(SYNONYM WILL)
	(ADJECTIVE NEW)
	(FLAGS TAKEBIT READBIT BURNBIT)
	(TEXT
"This is Mr. Robner's new will, disowning George and giving his entire
estate to his wife.")>

<OBJECT NEWSPAPER
	(FDESC
"Leaning against the front door is today's issue of the Daily Herald.")
	(DESC "Daily Herald")
	(SYNONYM NEWSPAPER HERALD SECTION PAPER)
	(ADJECTIVE DAILY FRONT FIRST)
	(FLAGS TAKEBIT READBIT BURNBIT)
	(ACTION NEWSPAPER-F)>

<OBJECT SECOND-SECTION
	(IN GLOBAL-OBJECTS)
	(DESC "second section of the Herald")
	(SYNONYM SECTION)
	(ADJECTIVE SECOND BACK LAST)
	(FLAGS READBIT)
	(ACTION SECOND-SECTION-F)>

<OBJECT ENVELOPE
	(FDESC
"A handwritten envelope, recently delivered, is lying on the table.")
	(DESC "handwritten envelope")
	(SYNONYM ENVELOPE)
	(ADJECTIVE HANDWR)
	(FLAGS TAKEBIT READBIT BURNBIT CONTBIT)
	(CAPACITY 2)
	(TEXT
"|
                  CANAAN CT POST OFFICE|
                   * JULY 06 * 08:00 *|
|
          Mrs. Marshall Robner|
          506 Lake View Rd.|
          Maitland, Ct.|
")
	(ACTION ENVELOPE-F)>

<OBJECT LETTER
	(IN ENVELOPE)
	(DESC "letter")
	(SYNONYM LETTER)
	(SIZE 1)
	(FLAGS TAKEBIT READBIT BURNBIT)
	(TEXT
"\"Dear Leslie,|
   I am sorry to learn that Marshall has been despondent again. His
obsessive interest in business must be causing you terrible anguish. It
doesn't surprise me that he talks of suicide when he's in this state,
but the thought of the business going to Baxter after he's gone will keep
him alive.|
   So George has finally gone too far? It's hard to believe, after all those
empty threats, that Marshall actually followed through. It serves that little
leech right, if you ask me. This means that, should the unthinkable happen,
you will be provided for as you deserve.|
   I'll see you Friday as usual.||
                      Love,|
                      Steven\"|")
	(ACTION LETTER-F)>

"Global objects"

<OBJECT GLOBAL-MURDER
	(IN GLOBAL-OBJECTS)
	(DESC "murder")
	(SYNONYM MURDER KILLING CRIME)
	(ACTION GLOBAL-MURDER-F)>

<OBJECT GLOBAL-SUICIDE
	(IN GLOBAL-OBJECTS)
	(DESC "suicide")
	(SYNONYM SUICIDE)
	(ACTION GLOBAL-MURDER-F)>

<OBJECT GLOBAL-OMNIDYNE
	(IN GLOBAL-OBJECTS)
	(DESC "Omnidyne Corporation")
	(SYNONYM OMNIDYNE)>

<OBJECT GLOBAL-ROSES
	(IN GLOBAL-OBJECTS)
	(DESC "roses")
	(SYNONYM ROSES GARDEN ROSE)
	(ADJECTIVE ROSE)>

<OBJECT GLOBAL-WEATHER
	(IN GLOBAL-OBJECTS)
	(DESC "weather")
	(SYNONYM WEATHER CLIMATE WRONG PROBLEM)>

<OBJECT GLOBAL-LIGHT 
	(IN GLOBAL-OBJECTS)
	(DESC "light")
	(SYNONYM LIGHT SUNLIGHT)>

<OBJECT GLOBAL-OLD-WILL
	(IN GLOBAL-OBJECTS)
	(DESC "present will")
	(SYNONYM WILL)
	(ADJECTIVE CURRENT PRESENT OLD)>

<OBJECT GLOBAL-NEW-WILL
	(IN GLOBAL-OBJECTS)
	(DESC "new will")
	(SYNONYM WILL)
	(ADJECTIVE NEW)>

<OBJECT FOYER-TABLE
	(IN FOYER)
	(DESC "marble-top table")
	(SYNONYM TABLE)
	(ADJECTIVE MARBLE)
	(FLAGS NDESCBIT OPENBIT CONTBIT SURFACEBIT)
	(CAPACITY 40)>

<OBJECT TELEPHONE
	(IN LOCAL-GLOBALS)
	(DESC "telephone")
	(SYNONYM TELEPHONE PHONE RECEIVER)
	(ACTION TELEPHONE-F)>
	
<OBJECT GLOBAL-FOCUS
	(IN GLOBAL-OBJECTS)
	(DESC "Focus")
	(SYNONYM FOCUS SCANDAL CASE)
	(ADJECTIVE FOCUS)>

<OBJECT GLOBAL-MR-ROBNER
	(IN GLOBAL-OBJECTS)
	(DESC "Mr. Robner")
	(SYNONYM ROBNER FATHER MARSHALL)
	(FLAGS PERSON)
	(ADJECTIVE MR MISTER)
	(ACTION GLOBAL-MR-ROBNER-F)>

<OBJECT BOOKSHELVES
	(IN LIBRARY)
	(SYNONYM BOOKSHELVES SHELVES BOOK BOOKS)
	(ADJECTIVE BOOK)
	(DESC "set of bookshelves")
	(FLAGS NDESCBIT)
	(ACTION BOOKSHELVES-F)>

<OBJECT LIBRARY-BUTTON
	(IN LIBRARY)
	(SYNONYM BUTTON)
	(ADJECTIVE BLACK)
	(DESC "black button")
	(FLAGS NDESCBIT INVISIBLE)
	(ACTION LIBRARY-BUTTON-F)>
	
<OBJECT RED-BUTTON
	(IN HIDDEN-CLOSET)
	(SYNONYM BUTTON)
	(ADJECTIVE RED)
	(DESC "red button")
	(FLAGS NDESCBIT)
	(ACTION RED-BUTTON-F)>

<OBJECT BLUE-BUTTON
	(IN HIDDEN-CLOSET)
	(SYNONYM BUTTON)
	(ADJECTIVE BLUE)
	(DESC "blue button")
	(FLAGS NDESCBIT)
	(ACTION BLUE-BUTTON-F)>

<OBJECT LADDER
	(IN SHED-ROOM)
	(SYNONYM LADDER)
	(ADJECTIVE WOODEN)
	(DESC "wooden ladder")
	(FDESC "Leaning in a corner is a wooden ladder.")
	(FLAGS TAKEBIT CLIMBBIT)
	(SIZE 50)
	(ACTION LADDER-F)>

<OBJECT GLOBAL-LADDER
	(IN GLOBAL-OBJECTS)
	(SYNONYM LADDER)
	(ADJECTIVE WOODEN)
	(DESC "ladder")
	(FLAGS NDESCBIT)
	(ACTION GLOBAL-LADDER-F)>

<OBJECT TOOLS-1
	(IN SHED-ROOM)
	(SYNONYM TOOLS SAW HAMMER ROPE)
	(DESC "collection of carpentry tools")
	(FLAGS NDESCBIT)
	(ACTION TOOLS-F)>

<OBJECT TOOLS-2
	(IN SHED-ROOM)
	(SYNONYM SPADE HOE RAKE HOSE)
	(DESC "collection of garden tools")
	(FLAGS NDESCBIT DUPLICATE)
	(ACTION TOOLS-F)>

<OBJECT S-SHELVES
	(IN SHED-ROOM)
	(SYNONYM SHELVES)
	(DESC "shelf")
	(FLAGS NDESCBIT OPENBIT CONTBIT SURFACEBIT)
	(CAPACITY 20)
	(ACTION S-SHELVES-F)>

<OBJECT CUPS
	(IN KITCHEN)
	(SYNONYM GROUP CUPS TEACUP)
	(ADJECTIVE CUPS ANTIQUE TEA)
	(DESC "group of cups")
	(FLAGS NDESCBIT)
	(ACTION CUPS-F)>

<OBJECT SAUCERS
	(IN KITCHEN)
	(SYNONYM GROUP SAUCER)
	(ADJECTIVE SAUCER ANTIQUE)
	(DESC "group of saucers")
	(FLAGS NDESCBIT)
	(ACTION SAUCERS-F)>

<OBJECT CHINA
	(IN KITCHEN)
	(SYNONYM CHINA)
	(DESC "china")
	(FLAGS NDESCBIT)
	(ACTION CHINA-F)>

<OBJECT PLATES
	(IN KITCHEN)
	(SYNONYM PLATE PLATES)
	(DESC "plates")
	(FLAGS NDESCBIT)
	(ACTION PLATES-F)>

<OBJECT CUP
	(IN LIBRARY)
	(SYNONYM CUP TEACUP)
	(ADJECTIVE TEA BEAUTIFUL)
	(DESC "cup")
	(FDESC
"Turned onto its side, lying on the floor, is a beautiful teacup.")
	(FLAGS TAKEBIT)
	(SIZE 4)
	(ACTION CUP-F)>

<OBJECT SAUCER
	(IN LIBRARY)
	(SYNONYM SAUCER)
	(ADJECTIVE BEAUTIFUL)
	(DESC "saucer")
	(FDESC
"Lying on the floor, overturned, is a beautiful saucer.")
	(FLAGS TAKEBIT)
	(SIZE 4)
	(ACTION SAUCER-F)>

<OBJECT TRASH-BASKET
	(IN LIBRARY)
	(SYNONYM BASKET)
	(ADJECTIVE WASTEP WICKER TRASH)
	(DESC "wastepaper basket")
	(FDESC
"Alongside the desk is a wicker wastepaper basket.")
	(FLAGS TAKEBIT OPENBIT CONTBIT)
	(CAPACITY 15)
	(SIZE 10)>

<OBJECT TRASH
	(IN TRASH-BASKET)
	(SYNONYM TRASH PAPERS)
	(ADJECTIVE CRUMPLED)
	(DESC "bunch of crumpled papers")
	(LDESC
"Inside the wastepaper basket are some crumpled papers.")
	(FLAGS TAKEBIT READBIT)
	(TEXT
"There are three wads of paper. One is a shopping list. Another is a list
of current stock prices. The last is the start of a letter to the Board of
Directors of the Robner Corp.  Unfortunately, it does not contain enough
information to allow even a guess about the intent of the letter.")
	(ACTION TRASH-F)>
	 
<OBJECT GLOBAL-FINGERPRINTS
	(IN GLOBAL-OBJECTS)
	(SYNONYM FINGERPRINT)
	(DESC "fingerprints")
	(ACTION GLOBAL-FINGERPRINTS-F)>

<OBJECT LIBRARY-CARPET
	(IN LIBRARY)
	(SYNONYM CARPET RUG)
	(DESC "carpet")
	(FLAGS NDESCBIT)
	(ACTION LIBRARY-CARPET-F)>

<OBJECT LIBRARY-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "oak door")
	(SYNONYM DOOR)
	(ADJECTIVE OAK BROKEN)
	(FLAGS NDESCBIT)
	(TEXT
"The door is a magnificent solid oak piece. Its metal bolt is bent and the
metal piece in which it rested has been sheared off the door frame.  It seems
clear that the door was securely locked from the inside when it was broken
down.")>

<OBJECT MUD-SPOT
	(IN LIBRARY)
	(DESC "mud spots")
	(SYNONYM SPOT MARK DIRT MUD)
	(ADJECTIVE DRIED)
	(FLAGS NDESCBIT INVISIBLE)
	(TEXT
"The spots seem to be dried dirt or mud and are bunched in the area between
the balcony and the desk.")>

<OBJECT SINK
	(IN LOCAL-GLOBALS)
	(DESC "sink")
	(SYNONYM SINK SINKS BOWL BASIN)
	(FLAGS NDESCBIT FURNITURE)
	(ACTION SINK-F)>

<OBJECT TOILET
	(IN LOCAL-GLOBALS)
	(DESC "toilet")
	(SYNONYM TOILET)
	(FLAGS NDESCBIT FURNITURE SURFACEBIT VEHBIT)
	(ACTION TOILET-F)>

<OBJECT SHOWER
	(IN LOCAL-GLOBALS)
	(DESC "shower")
	(SYNONYM SHOWER TUB BATH BATHTUB)
	(ADJECTIVE SHOWER BATH)
	(FLAGS NDESCBIT TRYTAKEBIT FURNITURE)
	(ACTION SHOWER-F)>

<OBJECT DUNBAR-CABINET
	(IN DUNBAR-BATH)
	(DESC "cabinet")
	(SYNONYM CABINET CHEST)
	(ADJECTIVE MEDICINE)
	(FLAGS NDESCBIT CONTBIT SEARCHBIT)
	(CAPACITY 50)>
	
<OBJECT BATHTUB
	(IN MASTER-BATH)
	(DESC "bathtub")
	(SYNONYM TUB BATHTUB)
	(ADJECTIVE BATH)
	(FLAGS NDESCBIT VEHBIT OPENBIT CONTBIT FURNITURE)
	(CAPACITY 50)>

<OBJECT MASTER-BATH-COUNTER
	(IN MASTER-BATH)
	(DESC "counter")
	(SYNONYM COUNTER)
	(ADJECTIVE LONG)
	(FLAGS NDESCBIT FURNITURE SURFACEBIT CONTBIT OPENBIT)
	(CAPACITY 50)>

<OBJECT CHAIR
	(IN LOCAL-GLOBALS)
	(DESC "chair")
	(SYNONYM CHAIR CHAIRS)
	(FLAGS NDESCBIT FURNITURE)>

<OBJECT SOFA
	(IN LOCAL-GLOBALS)
	(DESC "sofa")
	(SYNONYM COUCH SOFA COUCHES)
	(FLAGS NDESCBIT SURFACEBIT CONTBIT OPENBIT VEHBIT FURNITURE)>

<OBJECT LGTABLE
	(IN LOCAL-GLOBALS)
	(DESC "table")
	(SYNONYM TABLE TABLES)
	(FLAGS NDESCBIT FURNITURE)>

<OBJECT END-TABLE
	(IN LOCAL-GLOBALS)
	(DESC "pair of end tables")
	(SYNONYM TABLE TABLES)
	(ADJECTIVE END)
	(FLAGS NDESCBIT FURNITURE)>

<OBJECT LIVING-ROOM-TABLE
	(IN LIVING-ROOM)
	(DESC "living room table")
	(SYNONYM TABLE TABLES)
	(ADJECTIVE LIVING ROOM)
	(FLAGS NDESCBIT SURFACEBIT CONTBIT OPENBIT FURNITURE)
	(CAPACITY 40)>

<OBJECT BED
	(IN LOCAL-GLOBALS)
	(DESC "bed")
	(SYNONYM BED)
	(FLAGS NDESCBIT SURFACEBIT CONTBIT OPENBIT FURNITURE VEHBIT)
	(CAPACITY 30)
	(ACTION BED-F)>

<OBJECT WINDOW
	(IN LOCAL-GLOBALS)
	(DESC "window")
	(SYNONYM WINDOW)
	(FLAGS NDESCBIT)
	(ACTION WINDOW-F)>

<OBJECT KITCHEN-WINDOW
	(IN LOCAL-GLOBALS)
	(DESC "kitchen window")
	(SYNONYM WINDOW)
	(ADJECTIVE KITCHEN)
	(FLAGS NDESCBIT)
	(ACTION KITCHEN-WINDOW-F)>

<OBJECT DINING-ROOM-WINDOW
	(IN LOCAL-GLOBALS)
	(DESC "dining room window")
	(SYNONYM WINDOW)
	(ADJECTIVE DINING ROOM)
	(FLAGS NDESCBIT)
	(ACTION DINING-ROOM-WINDOW-F)>

<OBJECT MASTER-BEDROOM-DRESSER
	(IN MASTER-BEDROOM)
	(DESC "dresser")
	(SYNONYM DRESSER)
	(FLAGS NDESCBIT CONTBIT)
	(CAPACITY 30)
	(ACTION MASTER-BEDROOM-DRESSER-F)>

<OBJECT GLOBAL-HOLE
	(IN GLOBAL-OBJECTS)
	(DESC "holes")
	(SYNONYM HOLE HOLES)
	(FLAGS NDESCBIT)
	(ACTION HOLE-F)>

<OBJECT HOLE
	(IN IN-ROSES)
	(DESC "holes")
	(SYNONYM HOLE HOLES)
	(ADJECTIVE DEEP)
	(FLAGS NDESCBIT INVISIBLE)
	(ACTION HOLE-F)>
	
<OBJECT FRAGMENT
	(IN IN-ROSES)
	(DESC "fragment")
	(SYNONYM PIECE PORCELAIN FRAGMENT SHARD)
	(FLAGS INVISIBLE TAKEBIT)
	(ACTION FRAGMENT-F)>

<OBJECT SUGAR-BOWL
	(IN TRAY)
	(DESC "sugar bowl")
	(FDESC
"Sitting on the tray is a bowl containing a white powdery substance.")
	(SYNONYM BOWL SUGAR SUBSTANCE POWDER)
	(ADJECTIVE SUGAR WHITE POWDER)
	(FLAGS TAKEBIT)
	(ACTION SUGAR-BOWL-F)>

<OBJECT TRAY
	(IN LIBRARY)
	(DESC "tray")
	(FDESC
"Beside the desk is a large collapsible tray.")
	(SYNONYM TRAY)
	(ADJECTIVE LARGE COLLAPSIBLE)
	(FLAGS TAKEBIT CONTBIT OPENBIT SURFACEBIT)
	(CAPACITY 40)
	(SIZE 40)>

<OBJECT SAFE
	(IN HIDDEN-CLOSET)
	(DESC "safe")
	(SYNONYM COMBINATION SAFE DOOR)
	(ADJECTIVE SAFE WALL LARGE)
	(FLAGS NDESCBIT CONTBIT)
	(CAPACITY 15)
	(ACTION SAFE-F)>
	
<OBJECT CORNERSTONE
	(IN EAST-OF-DOOR)
	(DESC "cornerstone")
	(LDESC
"The ornately carved cornerstone of the house is nearby.")
	(SYNONYM CORNERSTONE STONE)
	(ADJECTIVE CARVED ORNATE)
	(FLAGS READBIT)
	(TEXT
"|
   DEADLINE: An INTERLOGIC Mystery|
          By Infocom, Inc.|
     Marc Blank, Chief Architect|
   Copyright 1982 by Infocom, Inc.|
        All rights reserved.|
DEADLINE and INTERLOGIC are trademarks of Infocom, Inc.|
")>

"DO DRUGS TO LIVE"

<OBJECT LOBLO-BOTTLE
	(IN DUNBAR-CABINET)
	(DESC "bottle of LoBlo")
	(SYNONYM BOTTLE LOBLO LABEL)
	(ADJECTIVE LOBLO)
	(FDESC
"On the bottom shelf is a bottle of tablets labelled 'LoBlo'.")
	(FLAGS TAKEBIT READBIT CONTBIT)
	(CAPACITY 5)
	(TEXT
"Frobizz Pharmacy   #69105|
|
Ms. S. Dunbar|
LoBLO|
Take 1 tablet 3 times daily|
|
Fizmo Labs, Ltd. - Kingston, Ont.|
LoBLO Brand of Methsparin, USP|
10mg Tablets|
|
Warning:  LoBLO may be dangerous|
when used in combination with|
other medications.  Please read|
the enclosed circular prior to|
using these tablets.|  
")>

<OBJECT GLOBAL-EBULLION
	(IN GLOBAL-OBJECTS)
	(DESC "Ebullion tablets")
	(SYNONYM TABLETS EBULLION PILLS)
	(ADJECTIVE EBULLION)>

<OBJECT GLOBAL-LOBLO
	(IN GLOBAL-OBJECTS)
	(DESC "LoBlo tablets")
	(SYNONYM TABLETS LOBLO PILLS)
	(ADJECTIVE LOBLO)>
	
<OBJECT LOBLO
	(IN LOBLO-BOTTLE)
	(DESC "couple of LoBLO tablets")
	(SYNONYM COUPLE TABLETS PILLS LOBLO)
	(ADJECTIVE LOBLO)
	(FLAGS TAKEBIT DRUGBIT)
	(SIZE 4)
	(ACTION LOBLO-F)
	(COUNT 10)>

<OBJECT ASPIRIN-BOTTLE
	(IN DUNBAR-CABINET)
	(DESC "bottle of aspirin")
	(FDESC 
"On the top shelf, among various toilet items, is a bottle of aspirin.")
	(SYNONYM BOTTLE ASPIRIN LABEL)
	(ADJECTIVE ASPIRIN)
	(FLAGS TAKEBIT READBIT CONTBIT)
	(CAPACITY 5)
	(TEXT
"|
|
Generic ASPIRIN, usp|
     30mg / 5 gr|
|
")>

<OBJECT ASPIRIN
	(IN ASPIRIN-BOTTLE)
	(DESC "handful of aspirin tablets")
	(SYNONYM PILLS TABLETS ASPIRIN HANDFUL)
	(ADJECTIVE ASPIRIN)
	(FLAGS TAKEBIT DRUGBIT)
	(SIZE 4)
	(COUNT 15)>

<OBJECT DUM-KOF-BOTTLE
	(IN DUNBAR-CABINET)
	(DESC "bottle of cough medicine")
	(FDESC
"Standing on a shelf beside some nail polish is a bottle of cough medicine.")
	(SYNONYM BOTTLE MEDICINE DUM-KOF LABEL)
	(ADJECTIVE COUGH)
	(FLAGS TAKEBIT READBIT CONTBIT)
	(CAPACITY 4)
	(TEXT
"|
General Drug Co.|
        DUM - KOF|
     Cough Supressant|
|
Directions:  1 tsp every 3-4 hrs|
Warning:  Take as Directed.  May|
cause sedation when taken with other|
drugs.|
|")>

<OBJECT DUM-KOF
	(IN DUM-KOF-BOTTLE)
	(DESC "quantity of cough syrup")
	(SYNONYM SYRUP)
	(ADJECTIVE COUGH)
	(FLAGS TAKEBIT)
	(SIZE 4)
	(ACTION DUM-KOF-F)>
	  
<OBJECT EBULLION-BOTTLE
	(IN LIBRARY)
	(DESC "bottle of Ebullion")
	(SYNONYM LABEL BOTTLE EBULLION)
	(ADJECTIVE EBULLION)
	(FLAGS TAKEBIT CONTBIT READBIT)
	(CAPACITY 5)
	(TEXT
"Head Drugs     No. 44543|
|
Mr. Marshall Robner|
|
EBULLION Tablets, 25mg.|
|
Directions: Take 1 or 2 twice|
daily for depression.|
|
Warning:  Keep out of the reach|
of children.  May be harmful or|
fatal in sufficient dosage.|
")>

<OBJECT EBULLION
	(IN EBULLION-BOTTLE)
	(DESC "couple of Ebullion tablets")
	(SYNONYM COUPLE TABLETS EBULLION)
	(ADJECTIVE EBULLION)
	(COUNT 3)
	(SIZE 4)
	(FLAGS TAKEBIT DRUGBIT)
	(ACTION EBULLION-F)>

<OBJECT LAB-REPORT
	(DESC "lab report")
	(SYNONYM REPORT PAPER NOTE SLIP)
	(ADJECTIVE LAB)	
	(FLAGS TAKEBIT READBIT)
	(TEXT
"Dear Inspector,|
|
    In response to your request for analysis of the ceramic fragment, we have
found evidence of a drug called Methsparin, which is usually sold in this
country under the name \"LoBlo\". It is a blood pressure lowering agent used
primarily in Europe, which explains the oversight in our blood analysis of the
deceased. A double check reveals a high blood level of Methsparin. While the
amount of Methsparin in the blood isn't dangerous in itself, a strong reaction
between it and various other drugs has been well documented. As you may have
gathered, one of those drugs is Amitraxin (Ebullion). The effect of Methsparin
is to displace Amitraxin from protein binding, leaving more free in the blood
and simulating an overdose.|
    Your new evidence leads me to conclude that the cause of death was
Amitraxin toxicity secondary to ingestion of Methsparin and Amitraxin in
combination.|
|
Sincerely,|
|
Arthur Chatworth, Pathologist|
")> 

<OBJECT GLOBAL-MEETING
	(IN GLOBAL-OBJECTS)
	(DESC "meeting")
	(SYNONYM MEETING RENDEZVOUS TRYST)
	(ADJECTIVE SECRET PRIVATE)>
	
<OBJECT GLOBAL-CALL
	(IN GLOBAL-OBJECTS)
	(DESC "telephone conversation")
	(SYNONYM CALL CONVERSATION LEFT RIGHT)
	(ADJECTIVE TELEPHONE PHONE)
	(ACTION GLOBAL-CALL-F)>
	
<OBJECT SHED-WINDOW
	(IN LOCAL-GLOBALS)
	(DESC "window")
	(SYNONYM WINDOW)
	(ADJECTIVE SHED DIRTY GRIMY)
	(ACTION SHED-WINDOW-F)>

<OBJECT INTNUM
	(IN GLOBAL-OBJECTS)
	(SYNONYM INTNUM)
	(DESC "number")>
	
<OBJECT PISTOL
	(DESC "smoking gun")
	(SYNONYM PISTOL GUN)
	(ADJECTIVE SMOKING)
	(FDESC "Lying beside the body is a smoking gun.")
	(FLAGS TAKEBIT)
	(ACTION PISTOL-F)>

<OBJECT CORPSE
	(DESC "body of Ms. Dunbar")
	(SYNONYM BODY DUNBAR CORPSE STIFF)
	(ADJECTIVE MS BLOODY)
	(FDESC "Sprawled on the floor is the body of Ms. Dunbar.")
	(ACTION CORPSE-F)>

<OBJECT SUICIDE-NOTE
	(DESC "suicide note")
	(SYNONYM NOTE HANDWR)
	(ADJECTIVE SUICIDE)
	(FDESC "Next to the body, near a pool of blood, is a note.")
	(FLAGS TAKEBIT READBIT)
	(ACTION SUICIDE-NOTE-F)
	(TEXT
"The note is written in thin blue ink in a very unsteady hand and
is smeared with blood from your touch.  It says:||
    \"I killed Mr. Robner.  Please forgive me.\"|
")>

<OBJECT POOL-OF-BLOOD
	(DESC "pool of blood")
	(SYNONYM POOL BLOOD)
	(LDESC "A pool of blood is at the head of the body.")>

<OBJECT GLOBAL-PEN
	(IN GLOBAL-OBJECTS)
	(DESC "pen")
	(SYNONYM PEN)
	(ADJECTIVE BLUE)
	(ACTION GLOBAL-PEN-F)>

<OBJECT SEURAT
	(IN DINING-ROOM)
	(DESC "Seurat")
	(SYNONYM SEURAT)
	(FLAGS NDESCBIT)
	(ACTION SEURAT-F)>

<OBJECT PAINTINGS
	(IN DINING-ROOM)
	(DESC "collection of paintings")
	(SYNONYM PAINTING COLLECTION PICTURE)
	(ADJECTIVE PAINTING)
	(FLAGS NDESCBIT)
	(ACTION PAINTINGS-F)>

<OBJECT SHELF-UNIT
	(IN KITCHEN)
	(DESC "shelf unit")
	(SYNONYM SHELF UNIT)
	(ADJECTIVE BEAUTIFUL SHELF)
	(FLAGS NDESCBIT)>

<OBJECT APPLIANCE-1
	(IN KITCHEN)
	(DESC "appliance")
	(SYNONYM APPLIANCE OVEN STOVE REFRIGERATOR)
	(FLAGS NDESCBIT)
	(ACTION APPLIANCE-F)>

<OBJECT APPLIANCE-2
	(IN KITCHEN)
	(DESC "appliance")
	(SYNONYM WASHER DISHWASHER DISPOSAL COMPACTOR)
	(ADJECTIVE GARBAGE DISH)
	(FLAGS NDESCBIT DUPLICATE)
	(ACTION APPLIANCE-F)>

<OBJECT DINING-ROOM-TABLE
	(IN DINING-ROOM)
	(DESC "long table")
	(SYNONYM TABLE)
	(ADJECTIVE LONG)
	(FLAGS FURNITURE NDESCBIT)>

<OBJECT TRESTLE-TABLE
	(IN DINING-ROOM)
	(DESC "trestle table")
	(SYNONYM TABLE)
	(ADJECTIVE LARGE TRESTLE)
	(FLAGS FURTINTURE NDESCBIT)>

<OBJECT PEN
	(DESC "blue pen")
	(SYNONYM PEN)
	(ADJECTIVE BLUE)
	(FLAGS TAKEBIT)
	(ACTION PEN-F)>
	
<OBJECT GLOBAL-STEVEN
	(IN GLOBAL-OBJECTS)
	(DESC "Steven")
	(SYNONYM STEVEN STEVE)>

<OBJECT GLOBAL-SAFE
	(IN GLOBAL-OBJECTS)
	(DESC "safe")
	(SYNONYM COMBINATION SAFE)>
	
<OBJECT CORRIDOR-WINDOW
	(IN CORRIDOR-4)
	(DESC "window")
	(SYNONYM WINDOW)
	(FLAGS NDESCBIT)
	(ACTION CORRIDOR-WINDOW-F)>

<OBJECT TODAY
	(IN GLOBAL-OBJECTS)
	(DESC "today")
	(SYNONYM TODAY)
	(ACTION TODAY-F)>

<OBJECT GLOBAL-WARRANT
	(IN GLOBAL-OBJECTS)
	(DESC "search warrant")
	(SYNONYM WARRANT)
	(ADJECTIVE SEARCH)
	(ACTION GLOBAL-WARRANT-F)>
	
<OBJECT GLOBAL-WATER
	(IN GLOBAL-OBJECTS)
	(DESC "water")
	(SYNONYM WATER)>

<OBJECT CIRCULAR
	(IN GLOBAL-OBJECTS)
	(DESC "circular")
	(SYNONYM CIRCULAR)>

<OBJECT GLOBAL-DUFFY
	(IN GLOBAL-OBJECTS)
	(SYNONYM DUFFY)
	(ADJECTIVE SERGEANT)
	(DESC "Sergeant Duffy")
	(ACTION GLOBAL-DUFFY-F)>

<OBJECT L-RAILING
	(IN LIBRARY-BALCONY)
	(SYNONYM RAILING)
	(ADJECTIVE METAL)
	(DESC "railing")
	(FLAGS NDESCBIT)
	(ACTION L-RAILING-F)>

<OBJECT B-RAILING
	(IN BEDROOM-BALCONY)
	(SYNONYM RAILING)
	(ADJECTIVE METAL)
	(DESC "railing")
	(FLAGS NDESCBIT)
	(ACTION B-RAILING-F)>

<OBJECT L-BALCONY
	(IN LIBRARY-BALCONY)
	(SYNONYM BALCONY)
	(DESC "balcony")
	(FLAGS NDESCBIT)
	(ACTION L-BALCONY-F)>

<OBJECT B-BALCONY
	(IN BEDROOM-BALCONY)
	(SYNONYM BALCONY)
	(DESC "balcony")
	(FLAGS NDESCBIT)
	(ACTION B-BALCONY-F)>

<OBJECT GLOBAL-MERGER
	(IN GLOBAL-OBJECTS)
	(SYNONYM MERGER)
	(ADJECTIVE OMNIDYNE)
	(DESC "merger")>

<OBJECT GLOBAL-ROOM
	(IN GLOBAL-OBJECTS)
	(SYNONYM ROOM WALL WALLS)
	(DESC "room")
	(ACTION GLOBAL-ROOM-F)>

<OBJECT COATES
	(SYNONYM COATES)
	(ADJECTIVE MR)
	(DESC "Mr. Coates")
	(FLAGS PERSON)
	(CHARACTER 7)
	(STATE 0)
	(ACTION COATES-F)
	(DESCFCN COATES-F)>

<OBJECT GLOBAL-COATES
	(IN GLOBAL-OBJECTS)
	(SYNONYM COATES)
	(ADJECTIVE MR)
	(DESC "Mr. Coates")
	(FLAGS PERSON)
	(CHARACTER 7)
	(ACTION GLOBAL-PERSON)>

<OBJECT OBJECT-PAIR
	(DESC "combination of objects specified")
	(ACTION OBJECT-PAIR-F)>

<OBJECT NOON
	(IN GLOBAL-OBJECTS)
	(DESC "noontime")
	(SYNONYM NOON)>

<OBJECT CRYSTAL-LAMP
	(IN FOYER)
	(DESC "crystal lamp")
	(SYNONYM LAMP CHANDELIER)
	(ADJECTIVE FINE CRYSTAL)
	(FLAGS NDESCBIT)>

<OBJECT FIREPLACE
	(IN LIVING-ROOM)
	(DESC "fieldstone fireplace")
	(SYNONYM FIREPL)
	(ADJECTIVE FIELDS)
	(FLAGS NDESCBIT)>

<OBJECT WOOD-PILE
	(IN LIVING-ROOM)
	(DESC "wood pile")
	(SYNONYM PILE)
	(ADJECTIVE WOOD)
	(FLAGS NDESCBIT)>

<OBJECT PORTRAITS
	(IN LIVING-ROOM)
	(DESC "collection of portraits")
	(SYNONYM PORTRAITS COLLECTION PICTURE PAINTING)
	(ADJECTIVE PORTRAITS)
	(FLAGS NDESCBIT)
	(ACTION PORTRAITS-F)>

<OBJECT LR-CABINETS
	(IN LIVING-ROOM)
	(DESC "fine wooden cabinets")
	(SYNONYM CABINET)
	(ADJECTIVE FINE WOODEN)
	(FLAGS NDESCBIT)
	(ACTION LR-CABINETS-F)>

<OBJECT K-CABINETS
	(IN KITCHEN)
	(DESC "cabinet")
	(SYNONYM CABINET)
	(FLAGS NDESCBIT CONTBIT)
	(CAPACITY 50)
	(ACTION K-CABINETS-F)>

<OBJECT SILVERWARE
	(IN K-CABINETS)
	(DESC "set of silverware")
	(SYNONYM SILVER)
	(FLAGS TRYTAKEBIT)
	(ACTION SILVERWARE-F)>

<OBJECT GLASSES
	(IN K-CABINETS)
	(DESC "glass collection")
	(SYNONYM GLASS GLASSES COLLECTION)
	(ADJECTIVE GLASS)
	(FLAGS TRYTAKEBIT)
	(ACTION GLASSES-F)>

<OBJECT P-SHELVES
	(IN PANTRY)
	(DESC "set of wooden shelves")
	(SYNONYM SHELVES)
	(ADJECTIVE WOODEN)
	(FLAGS NDESCBIT CONTBIT OPENBIT SURFACEBIT)
	(CAPACITY 30)>

<OBJECT FOODS
	(IN P-SHELVES) 
	(DESC "food assortment")
	(SYNONYM FOOD FOODS CAN CANS)
	(ADJECTIVE DRIED CANNED PACKAGED)
	(ACTION FOODS-F)>

<OBJECT FRUIT-TREES
	(IN LOCAL-GLOBALS)
	(DESC "fruit tree")
	(SYNONYM TREE)
	(ADJECTIVE FRUIT APPLE PEAR PEACH)
	(FLAGS NDESCBIT)
	(ACTION FRUIT-TREES-F)>

<OBJECT BERRY-BUSH
	(IN IN-ORCHARD)
	(DESC "berry bush")
	(SYNONYM BUSH)
	(ADJECTIVE BERRY BERRIE)
	(FLAGS NDESCBIT)
	(ACTION BERRY-BUSH-F)>

<OBJECT BATHROOM-MIRROR
	(IN MASTER-BATH)
	(DESC "mirror")
	(SYNONYM MIRROR)
	(FLAGS NDESCBIT)
	(ACTION BATHROOM-MIRROR-F)>

<OBJECT HANGING-PLANTS
	(IN MASTER-BATH)
	(DESC "hanging plant")
	(SYNONYM PLANT PLANTS)
	(ADJECTIVE HANGING)
	(FLAGS NDESCBIT)>
	
<OBJECT DUST
	(IN HIDDEN-CLOSET)
	(DESC "dust and cobwebs")
	(SYNONYM DUST COBWEBS)
	(FLAGS NDESCBIT)>

<OBJECT GLOBAL-HIDDEN-CLOSET
	(IN GLOBAL-OBJECTS)
	(DESC "hidden closet")
	(SYNONYM CLOSET)
	(ADJECTIVE HIDDEN)
	(FLAGS NDESCBIT)>

<OBJECT TREE-TOPS
	(IN BEDROOM-BALCONY)
	(DESC "treetop")
	(SYNONYM TREETOP TOP)
	(ADJECTIVE TREE)
	(FLAGS NDESCBIT)
	(ACTION TREE-TOPS-F)>

<OBJECT FOUR-POSTER
	(IN MASTER-BEDROOM)
	(DESC "four-poster bed")
	(SYNONYM BED POSTER)
	(ADJECTIVE FOUR FOUR-)
	(FLAGS NDESCBIT SURFACEBIT CONTBIT OPENBIT FURNITURE VEHBIT)
	(CAPACITY 30)
	(ACTION BED-F)>

<OBJECT LOUNGE
	(IN MASTER-BEDROOM)
	(DESC "lounge")
	(SYNONYM LOUNGE)
	(FLAGS NDESCBIT FURNITURE)>

<OBJECT BEDROOM-MIRROR
	(IN MASTER-BEDROOM)
	(DESC "large mirror")
	(SYNONYM MIRROR FRAME)
	(ADJECTIVE LARGE GILT)
	(FLAGS NDESCBIT)
	(ACTION BATHROOM-MIRROR-F)>
	
<OBJECT SHAVING-GEAR
	(IN GEORGE-BATH)
	(DESC "shaving gear")
	(SYNONYM GEAR RAZOR CREAM)
	(ADJECTIVE SHAVING)
	(FLAGS NDESCBIT)>
	
<OBJECT LIQUOR-CABINET
	(IN GEORGE-ROOM)
	(DESC "liquor cabinet")
	(SYNONYM CABINET)
	(ADJECTIVE LIQUOR)
	(FLAGS NDESCBIT CONTBIT SEARCHBIT)
	(CAPACITY 30)>

<OBJECT SCOTCH
	(IN LIQUOR-CABINET)
	(DESC "bottle of Scotch")
	(FDESC
"A half-filled bottle of Scotch is in the cabinet.")
	(SYNONYM BOTTLE SCOTCH)
	(ADJECTIVE SCOTCH)
	(FLAGS TAKEBIT)
	(ACTION LIQUOR-F)>

<OBJECT BOURBON
	(IN LIQUOR-CABINET)
	(DESC "bottle of Bourbon")
	(FDESC
"A nearly empty bottle of Bourbon is here.")
	(SYNONYM BOTTLE BOURBON)
	(ADJECTIVE BOURBON)
	(FLAGS TAKEBIT)
	(ACTION LIQUOR-F)>

<OBJECT STEREO
	(IN GEORGE-ROOM)
	(DESC "stereo")
	(SYNONYM STEREO VOLUME MUSIC HIFI)
	(FLAGS NDESCBIT)
	(ACTION STEREO-F)>

<OBJECT RECORDS
	(IN GEORGE-ROOM)
	(DESC "record collection")
	(SYNONYM RECORD)
	(FLAGS NDESCBIT)
	(ACTION RECORDS-F)>

<OBJECT TAPES
	(IN GEORGE-ROOM)
	(DESC "tape collection")
	(SYNONYM TAPE TAPES CASSETTE)
	(FLAGS NDESCBIT)
	(ACTION TAPES-F)>

<OBJECT ROURKE-SHELVES
	(IN ROURKE-BATH)
	(DESC "shelf")
	(SYNONYM SHELVES SHELF)
	(FLAGS NDESCBIT CONTBIT OPENBIT SURFACEBIT)
	(CAPACITY 30)>

<OBJECT C11-SHELVES
	(IN CLOSET-11)
	(DESC "shelf")
	(SYNONYM SHELVES SHELF)
	(FLAGS NDESCBIT CONTBIT OPENBIT SURFACEBIT)
	(CAPACITY 30)>

<OBJECT C11-LINENS
	(IN C11-SHELVES)
	(DESC "linens")
	(SYNONYM LINENS SHEETS LINEN)
	(FLAGS NDESCBIT)
	(ACTION CLOSET-STUFF-F)>

<OBJECT UC-SHELVES
	(IN UPSTAIRS-CLOSET)
	(DESC "shelf")
	(SYNONYM SHELVES SHELF)
	(FLAGS NDESCBIT CONTBIT OPENBIT SURFACEBIT)
	(CAPACITY 30)>

<OBJECT UC-LINENS
	(IN UC-SHELVES)
	(DESC "linens")
	(SYNONYM LINENS SHEETS LINEN)
	(FLAGS NDESCBIT)
	(ACTION CLOSET-STUFF-F)>

<OBJECT UC-TOWELS
	(IN UC-SHELVES)
	(DESC "towel")
	(SYNONYM TOWEL TOWELS)
	(FLAGS NDESCBIT)
	(ACTION CLOSET-STUFF-F)>

<OBJECT SNEEZO-BOTTLE
	(IN MASTER-BATH-COUNTER)
	(DESC "bottle of Sneezo brand decongestant")
	(SYNONYM BOTTLE DECONG SNEEZO)
	(ADJECTIVE BOTTLE DECONG SNEEZO BRAND)
	(FDESC
"On the counter is a bottle of Sneezo tablets.")
	(FLAGS TAKEBIT READBIT CONTBIT ;TRANSBIT)
	(CAPACITY 5)
	(ACTION MEDICINE-BOTTLE-F)
	(TEXT
"Lakeville Pharmacy   #223224|
|
Mrs. M. Robner|
Take 1 tablet every 3 hours as needed|
|
Sniffle Labs|
Sneezo Tablets|
")>

<OBJECT GLOBAL-SNEEZO
	(IN GLOBAL-OBJECTS)
	(DESC "Sneezo tablets")
	(SYNONYM TABLETS SNEEZO DECONG PILLS)
	(ADJECTIVE DECONG SNEEZO)>
	
<OBJECT SNEEZO
	(IN SNEEZO-BOTTLE)
	(DESC "handful of Sneezo tablets")
	(SYNONYM HANDFUL TABLETS DECONG SNEEZO)
	(ADJECTIVE DECONG SNEEZO)
	(FLAGS TAKEBIT DRUGBIT)
	(SIZE 4)
	(ACTION SNEEZO-F)
	(COUNT 20)>

<OBJECT ALLERGONE-BOTTLE
	(IN MASTER-BATH-COUNTER)
	(DESC "bottle of Allergone")
	(SYNONYM BOTTLE ALLERGONE)
	(ADJECTIVE BOTTLE ALLERGONE)
	(FDESC
"Beside a toothbrush is a bottle of Allergone.")
	(FLAGS TAKEBIT READBIT CONTBIT ;TRANSBIT)
	(ACTION MEDICINE-BOTTLE-F)
	(CAPACITY 5)
	(TEXT
"Lakeville Pharmacy   #220331|
|
Mrs. M. Robner|
Take 2 tablets every 4 hours as needed
for allergy symptoms.  Do not exceed
recommended dosage.|
|
Rash Labs / Allergone Tablets|
|
May cause extreme drowsiness.  Do not|
use machinery or drive while taking this|
medication.  Combination of Allergone with|
alcohol is dangerous.  In case of overdose|
consult a physician promptly.  Keep out|
of the reach of children!|
")>

<OBJECT GLOBAL-ALLERGONE
	(IN GLOBAL-OBJECTS)
	(DESC "Allergone tablets")
	(SYNONYM TABLETS ALLERGONE PILLS)
	(ADJECTIVE ALLERGONE)>
	
<OBJECT ALLERGONE
	(IN ALLERGONE-BOTTLE)
	(DESC "bunch of Allergone tablets")
	(SYNONYM BUNCH TABLETS ALLERGONE)
	(ADJECTIVE ALLERGONE)
	(FLAGS TAKEBIT DRUGBIT)
	(SIZE 4)
	(ACTION ALLERGONE-F)
	(COUNT 15)>

<OBJECT CLOSET
	(IN LOCAL-GLOBALS)
	(DESC "closet")
	(SYNONYM CLOSET)
	(ACTION GLOBAL-ROOM-F)>

<OBJECT GUEST-WINDOW
	(IN GUEST-ROOM)
	(DESC "window")
	(SYNONYM WINDOW)
	(ACTION GUEST-WINDOW-F)
	(FLAGS NDESCBIT)>

<OBJECT SOGGY-WILL
	(DESC "wet piece of paper")
	(SYNONYM PIECE PAPER)
	(ADJECTIVE PAPER WET DRENCHED SOGGY)
	(FLAGS TAKEBIT READBIT)
	(TEXT
"The paper was once some sort of document. It is now smeared and
completely unreadable.")>
	
<OBJECT PENCIL
	(IN LIBRARY)
	(DESC "pencil")
	(SYNONYM PENCIL)
	(FDESC "A pencil is lying on the floor near the desk.")
	(FLAGS TAKEBIT)> 

<OBJECT GLOBAL-HERE
	(IN GLOBAL-OBJECTS)
	(DESC "here")
	(SYNONYM HERE)
	(FLAGS NDESCBIT)
	(ACTION GLOBAL-HERE-F)>

<OBJECT GLOBAL-RED-HERRINGS
	(IN GLOBAL-OBJECTS)
	(DESC "red herring")
	(SYNONYM HERRING)
	(ADJECTIVE RED)
	(FLAGS NDESCBIT)
	(ACTION GLOBAL-RED-HERRINGS-F)>

<OBJECT RECURSIVE-BOOK
	(IN LIVING-ROOM)
	(DESC "mystery book")
	(SYNONYM BOOK)
	(ADJECTIVE HARDCOVER MYSTERY)
	(FDESC "Sitting on a table is a hardcover book.")
	(FLAGS TAKEBIT READBIT)
	(ACTION RECURSIVE-BOOK-F)>

<OBJECT GLOBAL-ENDING
	(IN GLOBAL-OBJECTS)
	(DESC "ending")
	(ADJECTIVE LAST)
	(SYNONYM ENDING END BOOK PAGE)
	(ACTION GLOBAL-ENDING-F)>
	
<OBJECT STUB
	(DESC "ticket stub")
	(SYNONYM TICKET STUB)
	(ADJECTIVE TICKET)
	(FLAGS TAKEBIT READBIT)
	(LDESC "Lying on the ground is what appears to be a ticket stub.")
	(TEXT
"|
   Hartford|
 Philharmonic|
  Orchestra|
|
 July 7, 1982|
|
   - 8PM -|
|
Row R / Seat 7|
|
-^-^-^-^-^-^-^|
|")>

<OBJECT RANDOM-MEAL
	(IN GLOBAL-OBJECTS)
	(DESC "meal")
	(SYNONYM MEAL LUNCH DINNER BREAKFAST)
	(ACTION RANDOM-MEAL-F)>

<OBJECT GLOBAL-HOUSE
	(IN GLOBAL-OBJECTS)
	(DESC "house")
	(SYNONYM HOUSE)
	(ACTION GLOBAL-HOUSE-F)>

<OBJECT GRAPE-ARBOR
	(IN IN-ORCHARD)
	(DESC "grape arbor")
	(SYNONYM ARBOR GRAPE)
	(ADJECTIVE GRAPE)
	(FLAGS NDESCBIT)
	(ACTION GRAPE-ARBOR-F)>

<OBJECT GLOBAL-CONCERT
	(IN GLOBAL-OBJECTS)
	(DESC "concert")
	(SYNONYM SYMPHONY CONCERT PERFORMANCE)
	(ADJECTIVE SYMPHONY PHILHARMONIC)>
	 