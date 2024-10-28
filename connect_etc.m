brick = ConnectBrick('EV31');
brick.beep();


%brick.StopAllMotors('Brake');

%brick.SetColorMode(2, 2);
%color = brick.ColorCode(2);
%disp(color);

% rotate right
%brick.MoveMotor('A', 50); 
%brick.MoveMotor('B', -50);
%pause(6); % Let the motors turn for 1 second.
brick.StopAllMotors('Brake'); % Hard Stop, all motors.
i = 1
while i == 1
    left = brick.TouchPressed(3);
    right = brick.TouchPressed(4);
    display("left: ");
    disp(left);
    display("right: ");
    disp(right);
end

%distance = 0;
%distance = brick.UltrasonicDist(1);
%display('Distance:');
%disp(distance);

%0 no color
% 1 black, 2 blue, 3 green, 4 yellow, 5 red, 6 white, 7 brown