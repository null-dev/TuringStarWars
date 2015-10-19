% Oct 2015
% Andy Bao
% Animation Project

% The 'TuringStarWars' program.

% Declare constants
const DELAY := 67 % How much do we want to delay between frames?
const CHARS_PER_LINE := 67 % How many characters are supposed to be in each line
const FILM_FILE := "tsw.final.film" % Where is the film stored?

% Declare variables
var line := 0 % The line we are on (out of 14)
var nextDelay := 0 % The delay for the next frame
var lineCount := 1 % The total line count
var lastRender := 0 % The last render time
var lag := 0 % The total lag since the last frame (in ms)
var ignoreLag := false % Allows us to ignore the lag caused by the normal delay
var tmp : string % Stores the current line read
var lagTmp : int % The current time in milliseconds
var theaterEdge := "+" % The top and bottom edge of the canvas
var streamin : int % An integer to store the file metadata in
var stringToPrint : string := "" % Temporary variable used while printing a line

% Check if the film file exists
if not File.Exists (FILM_FILE) then
    % No it doesn't :/, yell at the user!
    put "ERROR: Could not find the film file!"
    put "ERROR: Please make sure the file '", FILM_FILE, "' exists in the current folder!"
    quit
end if

% Open the file
open : streamin, FILM_FILE, get % Actually open the file

% Build the theater edge
for i : 1 .. CHARS_PER_LINE
    theaterEdge := theaterEdge + "-"
end for
theaterEdge := theaterEdge + "+" % Append a '+' at the end to finish it off!

% Loop until we reach the end of the file
loop
    exit when eof (streamin) % Exit when we reach the end of the file
    get : streamin, tmp : * % Read the (entire) next line
    if not ignoreLag then % Make sure we don't track the next lagtime (because we just had a delay)
	sysclock (lagTmp) % Get the current time
	lag += lagTmp - lastRender % Add onto the lag the current lag from the last frame render
    else
	ignoreLag := false % Stop ignoring the lag
    end if
    sysclock (lastRender) % Track the last render
    if line = 0 then % Render the debug console and delay once we reach the last line in the frame
	put theaterEdge % Render the canvas edge
	put "\nTuring Star Wars v1.0 By: Andy Bao" % Print the details of this program
	put "Insipred and based on: http://asciimation.co.nz/!" % Some extra credits
	put "\nAdvanced (Nerd) Information"
	put "Wait: ", nextDelay, "ms" % Display how long we are waiting
	put "Line: ", lineCount % Display what line we are on
	put "Frame: ", (lineCount - 1) / 14 % Display what frame are on
	put "Lag: The last frame lagged ", lag, "ms behind!" % Display how much lag there is
	lag := 0 % Reset the lag
	ignoreLag := true % Ignore the next lagtime because we just delayed
	delay (nextDelay) % Execute this frame's delay
	nextDelay := strint (tmp) * DELAY % Calculate the next frame's delay
	%cls % Clear the screen for the next print sequence (REMOVED BECAUSE IT CAUSES FLICKERING)
	locate (1, 1) % We use locate instead of cls to minimize flickering (try it using cls instead)
	put theaterEdge
    else
	stringToPrint := "|" + tmp % Set string to print to '|' and tmp
	for i : length (tmp) + 1 .. CHARS_PER_LINE % Add on any extra spaces necessary
	    stringToPrint := stringToPrint + " "
	end for
	stringToPrint := stringToPrint + "|" % Add of the finishing bar
	put stringToPrint % Print out the finished product!
    end if
    line += 1 % Increment the line counter
    if line = 14 then % If the we've reached line 14, just say we are back at line 0 :)
	line := 0
    end if
    lineCount += 1 % Increment the (other) line counter
end loop % Bye bye :)
