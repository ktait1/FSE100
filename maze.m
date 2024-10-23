%brick = ConnectBrick('EV31');
brick.beep();

%brick.MoveMotor('AB', -50); % Motor A, B forward at half speed.


%brick.MoveMotor('A', 50); 
%pause(1.4); % Let the motors turn for 1 second.
%brick.StopAllMotors('Brake'); % Hard Stop, all motors.

%distance = 0;
%distance = brick.UltrasonicDist(1);
%display('Distance:');
%disp(distance);

i = 1;
counter = 0;
brick.SetColorMode(2, 2); % Set Color Sensor connected to Port 1 to Color RGB Mode.

%disp(counter);

distance = 0;
while i == 1
    %fprintf("loop val: %d\n", counter);
    %fprintf("i: %d\n", i);
   
    color = brick.ColorCode(2);
    distance = brick.UltrasonicDist(1);

    if color == 5
        pause(2);
    elseif color == 3
        brick.beep();
        pause(2);
    elseif color == 4
        brick.beep();
        pause(2);    
        i = 0;
    elseif distance < 18 % if dist low, rotate right
        brick.beep();
        brick.StopAllMotors('Brake');
        brick.MoveMotor('A', 30); 
        brick.MoveMotor('B', -30);
        pause(2.1); % Let the motors turn for 1 second.
        brick.StopAllMotors('Brake'); % Hard Stop, all motors.  
    end

    brick.MoveMotor('AB', 25);
    pause(0.3); % polling rate
    counter = counter + 1;
    fprintf("color code: %d\n\n", color);
end

brick.StopAllMotors('Brake');



disp(color);

% 0 no color, 1 black, 2 blue, 3 green, 4 yellow, 5 red, 6 white, 7 brown


% rotate right
%brick.MoveMotor('A', 25); 
%pause(2.65); % Let the motors turn for 1 second.
%brick.StopAllMotors('Brake'); % Hard Stop, all motors.

%brick.beep();