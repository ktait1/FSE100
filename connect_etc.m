
% after bluetooth connected,
% below command will say connecting... 
% might then say disconnected or something, but then comment out line with %
% and see if beep works, if so it is connected
brick = ConnectBrick('EV31');
brick.beep();
% motors/sensors must be connected to the correct ports, referenced in code


%brick.StopAllMotors('Brake');

%brick.SetColorMode(2, 2);
%color = brick.ColorCode(2);
%disp(color);

% rotate right
%brick.MoveMotor('A', 50); 
%brick.MoveMotor('B', -50);
%pause(6); % Let the motors turn for 1 second.

brick.StopAllMotors('Brake'); % Hard Stop, all motors.

% loop to test touch buttons
%i = 1
%while i == 1
%    left = brick.TouchPressed(3);
%    right = brick.TouchPressed(4);
%    display("left: ");
%    disp(left);
%    display("right: ");
%    disp(right);
%end

%distance = 0;
%distance = brick.UltrasonicDist(1);
%display('Distance:');
%disp(distance);

%0 no color
% 1 black, 2 blue, 3 green, 4 yellow, 5 red, 6 white, 7 brown
