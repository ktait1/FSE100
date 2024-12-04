% brick = ConnectBrick('EV3');
% brick.beep();

% *******************************
% *** SETUP AND DOCUMENTATION ***
% *******************************

% Color Sensor Usage:
% Before Use: Set ColorMode For Sensor: brick.SetColorMode(SensorPort, Mode); | brick.SetColorMode(2, 2);
%             Mode 2: ColorCode - Returns Number Specifying Color
%            (0 Unknown Color, 1 Black, 2 Blue, 3 Green, 4 Yellow, 5 Red, 6 White, 7 Brown)
% Color Sensor Setup:
colorSensorPort = 1;
colorSensorMode = 2; % Mode (2) is ColorCode Mode.
brick.SetColorMode(colorSensorPort, colorSensorMode); % Set Color Sensor In Port 2 To ColorMode.
% Variables To Use ColorCode w/ Color Names
colorGreen = 3;
colorYellow = 4;
colorRed = 5;
% Example Call (Color Equal To Port 2): color = brick.ColorCode(2);

% Touch Sensor Usage:
% Sensor Port Is Port Number Where TouchSensor Is Connected (Must Be Between 1-4)
% Return Value: 1 If Touch Sensor Pressed, 0 Otherwise.
% Touch Sensor Setup:
leftTouchSensorPort = 2;
rightTouchSensorPort = 3;
% Example Call: frontTouchSensor = brick.TouchPressed(leftTouchSensorPort); 

% UltraSonic Sensor Usage:
% Returns Distance From Front Of Sensor To Nearest Object.
% Setup UltraSonic Sensor:
ultrasonicSensorPort = 4;
% Example Call: rightDistance = brick.UltrasonicDist(ultrasonicSensorPort);

% Motors
% Syntax: brick.MoveMotor(MotorPort, Speed);
% MotorPort: Must Be 'A', 'B', 'C', 'D' or a combination of those.
% Speed: Desired Speed Of Motor. Signed Number Between -100 And 100. 0 Is Stop Motor, Negative Numbers Are Reverse.
% Example Call: brick.StopAllMotors('Brake');
% Example Call: brick.MoveMotor('AB', 50);

% *******************************
% ** MAZE LOGIC IMPLEMENTATION **
% *******************************

% Variables To Save If Color Occurred (Set To 1)
greenReached = 0;
% Variable To Account For Red Zone (Stop Sign) : Set To 1 After Red Zone, Reset By Next Maze Logic
recentRed = 0;

% Code For Manual Control
global key;
InitKeyboard();

% Pause Between Loop Iterations
pollingRate = 0.1;
brick.StopAllMotors('Brake');

% Maze Loop Logic:
% [0] [While] Refresh Sensors And Check For Manual Control
% [1]    [If]     Check For Yellow Zone [Drop Off]  / Only After Green Zone [Pick Up] Completed : Maze Complete.
% [2]    [Elseif] Check For Red Zone    [Stop Sign]	
% [3]    [Elseif] Check For Green Zone  [Pick Up]
% [4]    [Else]   General Maze Logic    (Turn Right, Move Forward, Or Turn Left)
%                 [a] No Right Wall: Turn Right
%                 [b] Right Wall And Front Clear: Move Forward
%                 [c] Right Wall And Front Wall: Turn Left

i = 0;
while i == 1
    % [0] Refresh Sensors
    color = brick.ColorCode(colorSensorPort);
    frontTouchSensor = brick.TouchPressed(leftTouchSensorPort); 
    rightDistance = brick.UltrasonicDist(ultrasonicSensorPort);
	% [0] Check For Manual Control (Space Key Held)
    if key == 'space'
		fprintf("Space, waiting for input.\n");
		pause(1);
		getInput = 1;
		while getInput == 1
			switch key
			   case 'uparrow'
					brick.MoveMotor('AB', 50);
					pause(.5);
			   case 'downarrow'
					brick.MoveMotor('AB', -50);
					pause(.5);			   		   
  			   case 'k'
					brick.MoveMotor('A', -50);
					brick.MoveMotor('B', 50);
					pause(3.5);   
 			   case 'l'
					brick.MoveMotor('A', 50);
					brick.MoveMotor('B', -50); 
					pause(3.5);					
			   case 'a'
					brick.MoveMotorAngleRel('C', 20, 30);
					brick.WaitForMotor('C');				   
			   case 'b'
					brick.MoveMotorAngleRel('C', 20, -30);
					brick.WaitForMotor('C');			   
			   case 'e'
					brick.MoveMotor('A', -20);
					brick.MoveMotor('B', 20);
					pause(1);			   
			   case 'r'
					brick.MoveMotor('A', 20);
					brick.MoveMotor('B', -20);
					pause(1);			   
			   case 0
				   disp('No Key Pressed!');
			   case 'q' % 'q' Is Exit Manual Control
				   getInput = 0;
			end % End Switch
			if key ~= 0
				fprintf("Key: %s.\n", key);
			end
			pause(1); % Manual Input - Polling Rate
			brick.StopAllMotors('Brake');    
		end % While Loop
		fprintf("Exit manual control.\n");
    end % End Manual Control
	
	
    % [1] Check For Yellow Zone [Drop Off]  / Only After Green Zone [Pick Up] Completed.
    if (color == colorYellow) && (greenReached == 1)
		% Move Car Into Zone (Sensor Is At Front)
		brick.MoveMotor('AB', 25);
		pause(2);	
		brick.StopAllMotors('Brake');
		
		% Yellow Zone [Drop Off]: Pass To Manual Control
		getInput = 1;
		while getInput == 1
			switch key
			   case 'uparrow'
					brick.MoveMotor('AB', 50);
					pause(.5);
			   case 'downarrow'
					brick.MoveMotor('AB', -50);
					pause(.5);			   		   
  			   case 'k'
					brick.MoveMotor('A', -50);
					brick.MoveMotor('B', 50);
					pause(3.5);   
 			   case 'l'
					brick.MoveMotor('A', 50);
					brick.MoveMotor('B', -50); 
					pause(3.5);					
			   case 'a'
					brick.MoveMotorAngleRel('C', 20, 30);
					brick.WaitForMotor('C');				   
			   case 'b'
					brick.MoveMotorAngleRel('C', 20, -30);
					brick.WaitForMotor('C');			   
			   case 'e'
					brick.MoveMotor('A', -20);
					brick.MoveMotor('B', 20);
					pause(1);			   
			   case 'r'
					brick.MoveMotor('A', 20);
					brick.MoveMotor('B', -20);
					pause(1);			   
			   case 0
				   disp('No Key Pressed!');
			   case 'q' % 'q' Is Exit Manual Control
				   getInput = 0;
			end % End Switch
			if key ~= 0
				fprintf("Key: %s.\n", key);
			end
			pause(1); % Polling Rate
		brick.StopAllMotors('Brake');    
		end % While Loop Switch
		fprintf("Exit manual control.\n");
			
		% After Yellow Zone (Drop Off), Maze Is Complete.
		i = 0;
	

	% [2] Check For Red Zone [Stop Sign]
	elseif (color == colorRed) && (recentRed == 0)
		% At Red: Stop, Flag
		brick.StopAllMotors('Brake');
		pause(2);
		% Set RecentRed To True, Stop Completed, Continue Maze Logic
		recentRed = 1;
		
		
	% [3] Check For Green Zone [Pick Up]
	elseif (color == colorGreen) && (greenReached == 0)
		% Center Within Zone
		brick.MoveMotor('AB', 25);
		pause(2);
		brick.StopAllMotors('Brake');
		
		% Green Zone [Pick Up]: Pass To Manual Control
		getInput = 1;
		while getInput == 1
			switch key
			   case 'uparrow'
					brick.MoveMotor('AB', 50);
					pause(.5);
			   case 'downarrow'
					brick.MoveMotor('AB', -50);
					pause(.5);			   		   
  			   case 'k'
					brick.MoveMotor('A', -50);
					brick.MoveMotor('B', 50);
					pause(3.5);   
 			   case 'l'
					brick.MoveMotor('A', 50);
					brick.MoveMotor('B', -50); 
					pause(3.5);					
			   case 'a'
					brick.MoveMotorAngleRel('C', 20, 30);
					brick.WaitForMotor('C');				   
			   case 'b'
					brick.MoveMotorAngleRel('C', 20, -30);
					brick.WaitForMotor('C');			   
			   case 'e'
					brick.MoveMotor('A', -20);
					brick.MoveMotor('B', 20);
					pause(1);			   
			   case 'r'
					brick.MoveMotor('A', 20);
					brick.MoveMotor('B', -20);
					pause(1);			   
			   case 0
				   disp('No Key Pressed!');
			   case 'q' % 'q' Is Exit Manual Control
				   getInput = 0;
			end % End Switch
			if key ~= 0
				fprintf("Key: %s.\n", key);
			end
			pause(1); % Polling Rate
		brick.StopAllMotors('Brake');    
		end % While Loop Switch
		fprintf("Exit manual control.\n");

		% Green Zone [Pick Up] Completed
		greenReached = 1;
		recentRed = 0;


	% [4] General Maze Logic
    else
		% [4a] No Right Wall: Turn Right
        if rightDistance > 65 
			% Wall Opening Found: Move Completely Past Wall Opening Before Turning
			brick.MoveMotor('AB', 25);
			pause(2.8);
			brick.StopAllMotors('Brake');
			
			% Before Executing Turn: Ensure Car Isn't Above Yellow Zone [Drop Off] Or Green Zone [Pick Up]
			%    (Because The Wall Gap Can Be Before The Colored Zone, Check After Passing The Wall.
			% Get Current Color, Only Turn If Car Is Not Over Yellow Or Green
			color = brick.ColorCode(colorSensorPort);
			if color ~= colorYellow
				if (color ~= colorGreen) || (greenReached == 1)
					% Now Past Wall, Turn Right
					brick.MoveMotor('A', 50);
					brick.MoveMotor('B', -50); 
					pause(3.5);
					brick.StopAllMotors('Brake');				
					% Move Forward (Until New Wall Found) To Complete Turn
					brick.MoveMotor('AB', 25);
					while rightDistance > 65
						rightDistance = brick.UltrasonicDist(ultrasonicSensorPort);
					end
					% Turn Completed: Ready For Next Maze Logic
					brick.StopAllMotors('Brake');
					% Reset Red Light Adjustment
					recentRed = 0;
				end
			end	
		%
		% [4b] Right Wall And Front Clear: Continue Forward
        elseif frontTouchSensor == 0 
            brick.MoveMotor('AB', 25);
		%	
		% [4c] Right Wall And Front Wall: Turn Left
        else 
			% Front Wall Contacted: Stop, Slightly Reverse 
			brick.StopAllMotors('Brake');
			brick.MoveMotor('AB', 25);
			pause(0.75);
			brick.StopAllMotors('Brake');
			% Turn Left
			brick.MoveMotor('A', -50);
			brick.MoveMotor('B', 50);
			pause(3.5);
			% Turn Completed: Ready For Next Maze Logic
			brick.StopAllMotors('Brake');
			% Reset Red Light Adjustment
			recentRed = 0;
        end
    end
	% Loop Logic Until Green Zone [Drop Off] Complete
    pause(pollingRate);
end
CloseKeyboard();
disp('end');