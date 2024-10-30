% RunMaze.m - For Milestone 1 / Implementation 2 - October 30th
%
% Demonstrate :
%    Using a touch sensor without any failure.
%    Using ultrasonic sensor without any failure.
%    Your robot goes straight without shifting left or right.
%    Your robot turns smoothly with a specific angle (90 degrees).
%    Your robot navigates the maze long enough to show it is bug-free (15%).
%    - Photo of team with vehicle, link to code, link to short YouTube video navigating maze.

% Code to initialize connection to robot.
% brick = ConnectBrick('EV31');

% Initial Beep To Show File Is Being Run
brick.beep();

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
colorRed = 5; % Red Is Stoplight, Pause, Then Go.

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
% Variables For Looping:
counter = 0;
distance = 0;

% Main Loop For Maze Navigation
%    Maze Navigation: (Start) Blue [2], (Pickup) Green [3],(Dropoff) Yellow [4].
%    While Loop Will Exit When Color Detected Is Yellow (4).
%
% Loop:
%    Refresh data from sensors.
%    Check if there is input from touch sensors to initiate a turn.
%    
%    
%    
%    

% after green, check if wall, if so go backwards far first

ii = 0
while ii == 1
	frontTouchSensor = brick.TouchPressed(2)
	%leftDistance = brick.UltrasonicDist(2);
	rightDistance = brick.UltrasonicDist(3);
	fprintf("frontTouchSensor: %d\n", frontTouchSensor);
	%fprintf("leftDistance: %d\n", frontTouchSensor);
	fprintf("rightDistance: %d\n", rightDistance);
	pause(0.5);
end

i = 1;
while i == 1
	% Each Loop Iteration, Refresh Sensor Values
	% Touch Sensor (L+R)
    %leftTouchSensor = brick.TouchPressed(leftTouchSensorPort);
    %rightTouchSensor = brick.TouchPressed(rightTouchSensorPort);
	% Color Sensor
    %color = brick.ColorCode(colorSensorPort);
	% UltraSonic Sensor
    %distance = brick.UltrasonicDist(ultrasonicSensorPort);
	%if distance < 18
	frontTouchSensor = brick.TouchPressed(2)
	rightDistance = brick.UltrasonicDist(3);
    brick.MoveMotor('AB', 25);
    fprintf("front sensor: %d\n", frontTouchSensor);
    fprintf("rightDistance: %d\n", rightDistance);
	%if frontTouchSensor == 1
	% If Close To Wall Ahead, Decide Turn Direction - Execute Turn
	%brick.beep();

	disp(rightDistance);
    if frontTouchSensor == 1
        brick.StopAllMotors('Brake'); % turn left
		brick.MoveMotor('A', 50); 	
		brick.MoveMotor('B', -50);  
		pause(3.1);       
    end
    %brick.StopAllMotors('Brake');        pause(2);
    %brick.MoveMotor('AB', -25);
    %pause(0.5);
	if (rightDistance > 65) % turn right
        pause(3);
		brick.StopAllMotors('Brake');
		brick.MoveMotor('A', -50); 	% Left Motor Backwards
		brick.MoveMotor('B', 50);  	% Right Motor Forwards
		pause(3.1);					% Turn For 1 Second
	%else
%  		brick.StopAllMotors('Brake'); % turn left
	%	brick.MoveMotor('A', 50); 	
%		brick.MoveMotor('B', -50);  
%		pause(3.1);
	end

    brick.MoveMotor('AB', 25);
    %end
	% Wait Then Loop Again: Refresh Sensors, Check For New Color, Check For Obstruction, Continue Forward
    pause(pollingRate);
end
brick.StopAllMotors('Brake');
