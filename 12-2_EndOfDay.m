% brick = ConnectBrick('EV3');
% brick.beep();

% ColorSensor Usage:
%
% Set ColorMode For Color Sensor:
%    Syntax:  brick.SetColorMode(SensorPort, Mode);
%    Example: brick.SetColorMode(2, 2);
%             (Color Sensor Port 2, Mode ColorCode) : ColorCode Returns Number Specifying Color Sensor Data
%              ColorCode Return Values : 0 Unknown Color, 1 Black, 2 Blue, 3 Green, 4 Yellow, 5 Red, 6 White, 7 Brown
% ColorMode Call Example:
%    Syntax:  color = brick.ColorCode(2);
%    Example: Set variable color equal to return value from ColorSensor on Port 2.

% Setup Color Sensor
colorSensorPort = 1;
colorSensorMode = 2; % Mode (2) is ColorCode Mode.
brick.SetColorMode(colorSensorPort, colorSensorMode); % Set Color Sensor In Port 2 To ColorMode.
% colorBlue = 2;
% colorGreen = 3;
colorYellow = 4;
% colorRed = 5;

% TouchSensor Usage:
%
% SensorPort Is Port Number Where TouchSensor Is Connected: Must Be Between 1-4.
% Return Value: 1 If Touch Sensor Is Pressed, 0 Otherwise.
% 
% Setup Touch Sensor
leftTouchSensorPort = 2;
rightTouchSensorPort = 3;

% UltraSonic Sensor Usage:
%    Return Value: Returns Distance From Front Of Sensor To Nearest Object.
%    Syntax:  distance = brick.UltrasonicDist(SensorPort);
% Setup UltraSonic Sensor
ultrasonicSensorPort = 4;

% Motors
%    Syntax: brick.MoveMotor(MotorPort, Speed);
%       MotorPort: Must Be 'A', 'B', 'C', 'D' or a combination of those.
%       Speed: Desired Speed Of Motor. Signed Number Between -100 And 100. 0 Is Stop Motor, Negative Numbers Are Reverse.

% Initialize Variables Used For Main Program Loop
pollingRate = 0.1 % Pause Time Between Loop Iterations
% Values To Save If Color Has Already Occurred
 blueReached = 0;
 greenReached = 0;
 yellowReached = 0;
% distance = 0;

% Pseudocode:
%{
START:
  1. While (not at the exit of the maze):
      - Refresh Sensors:
          - Read the front touch sensor.
          - Read the right ultrasound sensor.
      
      - Decisions:
			// No wall on right: maze opening, turn right and go forward.
      	    - If (right_wall is False):
         	     TURN RIGHT

            // If there is right wall, and no front obstacle, go forwards.
			- Else if (front_obstacle is False):
				MOVE FORWARD
				
			// If there is right wall, and front obstacle, turn left.
			- Else:
				TURN LEFT
              
      - Loop until correct color on ground.
%}


% Adjust Right Distance To Determine If There Is A Wall
% May Need To Adjust Turning Pause Time To Complete Turn
%
%
% Test / Adjust [Std] L/R Turn Amounts
% Test / Adjust L/R Slight Turn Amounts
% [Turns Might Not Be Going Right Direction, Test] 
%
% (Standard Forward Motor Speed = 25)
% (Red Is 2 Seconds Past @ 25)
%
% Check If Green/Yellow Centering Is Right (can measure) (bring tape)

brick.StopAllMotors('Brake');
recentRed = 0;

global key;
InitKeyboard();
% callManualInput();

i = 0;
while i == 1
    % Refresh Sensor Values
    color = brick.ColorCode(colorSensorPort);
    frontTouchSensor = brick.TouchPressed(leftTouchSensorPort); 
    rightDistance = brick.UltrasonicDist(ultrasonicSensorPort);
    
	% Check For Manual Input Control (Space Key Held)
    if key == 'space'
		fprintf("Space, waiting for input.\n");
		pause(1);
		getInput = 1;
		while getInput == 1
			switch key
			   case 'uparrow'
				   disp('Up Arrow Pressed!');
				   % move forwards
					brick.MoveMotor('AB', 50);
					pause(.5);
					brick.StopAllMotors('Brake');
			   case 'downarrow'
				   disp('Down Arrow Pressed!');
				   %moveBackwards();
					brick.MoveMotor('AB', -50);
					pause(.5);
					brick.StopAllMotors('Brake');			   
			   case 'leftarrow'
				   disp('Left Arrow Pressed!');
				   %turnLeft();
					brick.MoveMotor('A', -70);
					brick.MoveMotor('B', 70);
					pause(2.75); % pause(2.5); this was 2.75
					brick.StopAllMotors('Brake');			   
			   case 'rightarrow'
				   disp('Right Arrow Pressed!');
				   %turnRight();
					brick.MoveMotor('A', 70);
					brick.MoveMotor('B', -70);
					pause(2.75); % pause(2.5); this was 2.5
					brick.StopAllMotors('Brake');	
  			   case 'k'
				   disp('k Pressed!');
				   %turnLeftSlow();
					brick.MoveMotor('A', -50);  % Left Motor Forward
					brick.MoveMotor('B', 50); % Right Motor Backward
					pause(3.5); 			   % Turn Time For 90-Degree Left Turn
					brick.StopAllMotors('Brake');		   
 			   case 'l'
				   disp('l Pressed!');
				   %turnRightSlow();
					brick.MoveMotor('A', 50);
					brick.MoveMotor('B', -50); 
					pause(3.5);
					brick.StopAllMotors('Brake');					
			   case 'a'
				   disp('a is pressed');
				   %moveArmUp();
					fprintf("Called: MoveArmUp.\n");
					brick.MoveMotorAngleRel('C', 20, 30);
					brick.WaitForMotor('C');				   
			   case 'b'
				   disp('b is pressed');
				   %moveArmDown();
					% brick.MoveMotorAngleRel('C', 20, -10);
					brick.MoveMotorAngleRel('C', 20, -30);
					brick.WaitForMotor('C');			   
			   case 'e'
				   disp('e is pressed');	
				   %turnSlightLeft();
					brick.MoveMotor('A', -20);
					brick.MoveMotor('B', 20);
					pause(1);
					brick.StopAllMotors('Brake');			   
			   case 'r'
				   disp('f is pressed');	
				   %turnSlightRight();
					brick.MoveMotor('A', 20);
					brick.MoveMotor('B', -20);
					pause(1);
					brick.StopAllMotors('Brake');			   
			   case 0
				   disp('No Key Pressed!');
			   case 'q'
				   % disp('q');
				   % If 'q' then end outer while loop.
				   getInput = 0;
			end % End Switch
			if key ~= 0
				fprintf("Key: %s.\n", key);
			end
			pause(1); % Polling Rate
		brick.StopAllMotors('Brake');    
		end % While Loop Switch
		fprintf("Exit manual control.\n");
    end
	
    % Check If Yellow Zone 	(Drop Off Zone, End Maze)
    if (color == colorYellow) && (yellowReached == 0) && (greenReached == 1)
		% Center Within Zone
		brick.MoveMotor('AB', 25);
		pause(2);	
		brick.StopAllMotors('Brake');
		
		% Yellow Drop Off Zone: Pass To Manual Control
		% callManualInput();
		getInput = 1;
		while getInput == 1
			switch key
			   case 'uparrow'
				   disp('Up Arrow Pressed!');
				   % move forwards
					brick.MoveMotor('AB', 50);
					pause(.5);
					brick.StopAllMotors('Brake');
			   case 'downarrow'
				   disp('Down Arrow Pressed!');
				   %moveBackwards();
					brick.MoveMotor('AB', -50);
					pause(.5);
					brick.StopAllMotors('Brake');			   
			   case 'leftarrow'
				   disp('Left Arrow Pressed!');
				   %turnLeft();
					brick.MoveMotor('A', -70);
					brick.MoveMotor('B', 70);
					pause(2.75); % pause(2.5); this was 2.75
					brick.StopAllMotors('Brake');			   
			   case 'rightarrow'
				   disp('Right Arrow Pressed!');
				   %turnRight();
					brick.MoveMotor('A', 70);
					brick.MoveMotor('B', -70);
					pause(2.75); % pause(2.5); this was 2.5
					brick.StopAllMotors('Brake');			
  			   case 'k'
				   disp('k Pressed!');
				   %turnLeftSlow();
					brick.MoveMotor('A', -50);  % Left Motor Forward
					brick.MoveMotor('B', 50); % Right Motor Backward
					pause(3.5); 			   % Turn Time For 90-Degree Left Turn
					brick.StopAllMotors('Brake');		   
 			   case 'l'
				   disp('l Pressed!');
				   %turnRightSlow();
					brick.MoveMotor('A', 50);
					brick.MoveMotor('B', -50); 
					pause(3.5);
					brick.StopAllMotors('Brake');					
			   case 'a'
				   disp('a is pressed');
				   %moveArmUp();
					fprintf("Called: MoveArmUp.\n");
					brick.MoveMotorAngleRel('C', 20, 30);
					brick.WaitForMotor('C');				   
			   case 'b'
				   disp('b is pressed');
				   %moveArmDown();
					% brick.MoveMotorAngleRel('C', 20, -10);
					brick.MoveMotorAngleRel('C', 20, -30);
					brick.WaitForMotor('C');			   
			   case 'e'
				   disp('e is pressed');	
				   %turnSlightLeft();
					brick.MoveMotor('A', -20);
					brick.MoveMotor('B', 20);
					pause(1);
					brick.StopAllMotors('Brake');			   
			   case 'r'
				   disp('f is pressed');	
				   %turnSlightRight();
					brick.MoveMotor('A', 20);
					brick.MoveMotor('B', -20);
					pause(1);
					brick.StopAllMotors('Brake');			   
			   case 0
				   disp('No Key Pressed!');
			   case 'q'
				   % disp('q');
				   % If 'q' then end outer while loop.
				   getInput = 0;
			end % End Switch
			if key ~= 0
				fprintf("Key: %s.\n", key);
			end
			pause(1); % Polling Rate
		brick.StopAllMotors('Brake');    
		end % While Loop Switch
		fprintf("Exit manual control.\n");
		
		
		% After Yellow Drop Off, Maze Complete
		yellowReached = 1;
		recentRed = 0;
		i = 0;
		
	% Check If Red Zone 	(Stop Light)
	elseif color == colorRed
		% If At Red, Stop, Then Proceed
		brick.StopAllMotors('Brake');
		pause(2);
		% Proceed Past Red
		brick.MoveMotor('AB', 25);
		pause(3.5);
		% Moved Past Red, Stop
		brick.StopAllMotors('Brake');
		% Set RecentRed To Adjust Distance In Logic For Having Moved Forward Past Red
		recentRed = 1;
		
	% Cehck If Green Zone 	(Pick Up Zone)
	elseif (color == colorGreen) && (greenReached == 0)
		% Center Within Zone
		brick.MoveMotor('AB', 25);
		pause(2);
		brick.StopAllMotors('Brake');
		
		% Green Pick Up Zone: Pass To Manual Controlc
		% callManualInput();
		getInput = 1;
		while getInput == 1
			switch key
			   case 'uparrow'
				   disp('Up Arrow Pressed!');
				   % move forwards
					brick.MoveMotor('AB', 50);
					pause(.5);
					brick.StopAllMotors('Brake');
			   case 'downarrow'
				   disp('Down Arrow Pressed!');
				   %moveBackwards();
					brick.MoveMotor('AB', -50);
					pause(.5);
					brick.StopAllMotors('Brake');			   
			   case 'leftarrow'
				   disp('Left Arrow Pressed!');
				   %turnLeft();
					brick.MoveMotor('A', -70);
					brick.MoveMotor('B', 70);
					pause(2.75); % pause(2.5); this was 2.75
					brick.StopAllMotors('Brake');			   
			   case 'rightarrow'
				   disp('Right Arrow Pressed!');
				   %turnRight();
					brick.MoveMotor('A', 70);
					brick.MoveMotor('B', -70);
					pause(2.75); % pause(2.5); this was 2.5
					brick.StopAllMotors('Brake');				   
			   case 'a'
				   disp('a is pressed');
				   %moveArmUp();
					fprintf("Called: MoveArmUp.\n");
					brick.MoveMotorAngleRel('C', 20, 30);
					brick.WaitForMotor('C');				   
			   case 'b'
				   disp('b is pressed');
				   %moveArmDown();
					% brick.MoveMotorAngleRel('C', 20, -10);
					brick.MoveMotorAngleRel('C', 20, -30);
					brick.WaitForMotor('C');			   
			   case 'e'
				   disp('e is pressed');	
				   %turnSlightLeft();
					brick.MoveMotor('A', -20);
					brick.MoveMotor('B', 20);
					pause(1);
					brick.StopAllMotors('Brake');			   
			   case 'r'
				   disp('f is pressed');	
				   %turnSlightRight();
					brick.MoveMotor('A', 20);
					brick.MoveMotor('B', -20);
					pause(1);
					brick.StopAllMotors('Brake');			   
			   case 0
				   disp('No Key Pressed!');
			   case 'q'
				   % disp('q');
				   % If 'q' then end outer while loop.
				   getInput = 0;
			end % End Switch
			if key ~= 0
				fprintf("Key: %s.\n", key);
			end
			pause(1); % Polling Rate
		brick.StopAllMotors('Brake');    
		end % While Loop Switch
		fprintf("Exit manual control.\n");

		
		% Green Reached, Don't Repeat
		greenReached = 1;
		recentRed = 0;
	
    else
		% Else : General Maze Logic
		%
		% [1] No Right Wall: Turn Right
        if rightDistance > 65 
			% Go Past Wall:
			%    If RecentRed 	 : Already Went Past Wall
			%    If No Red Light : Go Forward Past Wall
			if recentRed == 0
				brick.MoveMotor('AB', 25);
				pause(2.8);
				brick.StopAllMotors('Brake');
			end
			% Stop, Turn Right
			brick.StopAllMotors('Brake');
			%turnRightSlow();
			brick.MoveMotor('A', 50);
			brick.MoveMotor('B', -50); 
			pause(3.5);
			brick.StopAllMotors('Brake');				
			% Forward To Complete Turn
            brick.MoveMotor('AB', 25);
            while rightDistance > 65
                rightDistance = brick.UltrasonicDist(ultrasonicSensorPort);
            end
            brick.StopAllMotors('Brake');
			% Reset Red Light Adjustment
			recentRed = 0;
		%
		% [2] Right Wall And Front Clear: Move Forward
        elseif frontTouchSensor == 0 
            brick.MoveMotor('AB', 25);
		%	
		% [3] Right Wall And Front Wall: Turn Left
        else 
            % Reverse, Turn Left:
			%    Reverse
			%    Turn Left
			% Stop, Reverse Away From Wall
			brick.StopAllMotors('Brake');
			brick.MoveMotor('AB', 25);
			pause(0.75);
			% Stop, Turn Left
			brick.StopAllMotors('Brake');
			%turnLeftSlow();
			brick.MoveMotor('A', -50);  % Left Motor Forward
			brick.MoveMotor('B', 50); % Right Motor Backward
			pause(3.5); 			   % Turn Time For 90-Degree Left Turn
			brick.StopAllMotors('Brake');				
			% Forward To Complete Turn
            brick.MoveMotor('AB', 25);
            pause(1);
			% Reset Red Light Adjustment
			recentRed = 0;
        end
    end
	% Continue Looping
    pause(pollingRate);
end
CloseKeyboard();
disp('end');