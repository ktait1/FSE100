% brick = ConnectBrick('EV31');
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
colorBlue = 2;
colorGreen = 3;
colorYellow = 4;
colorRed = 5;

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
 redReached = 0;
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

% Milestone 2 - Wednesday 11/13
% Your robot stops for one second when it sees red.
% Your robot stops and beeps two times when it sees blue.
% Your robot stops and beeps three times when it sees green.
%
% colorBlue = 2;
% colorGreen = 3;
% colorYellow = 4;
% colorRed = 5;
%
% Foward Only, To Test Color Response
brick.StopAllMotors('Brake');
i = 0;
while i == 1
    % Refresh Sensor Values
    color = brick.ColorCode(colorSensorPort);
    frontTouchSensor = brick.TouchPressed(leftTouchSensorPort); 
    rightDistance = brick.UltrasonicDist(ultrasonicSensorPort);
	% Go Forward
    brick.MoveMotor('AB', 50);
	
	% Your robot stops for one second when it sees red.
	if (color == colorRed) && (redReached == 0)
		brick.StopAllMotors('Brake');
		pause(1);
		redReached = 1;
	
    % Your robot stops and beeps two times when it sees blue.
    elseif (color == colorBlue) && (blueReached == 0)
        brick.StopAllMotors('Brake');
		brick.beep();
		brick.beep();
		pause(1);
        blueReached = 1;
		
	% Your robot stops and beeps three times when it sees green.
	elseif (color == green) && (greenReached == 0)
		brick.StopAllMotors('Brake');
		brick.beep();
		brick.beep();
		brick.beep();
		pause(1);
		greenReached = 1;

	% Once all colors reached, stop.
	elseif (redReached == 1) && (blueReached == 1) && (greenReached == 1)
		brick.StopAllMotors('Brake');
		% Exit Loop
		i = 0; 
	end
	% Continue Looping
    pause(pollingRate);
end