%brick = ConnectBrick('EV3');
%brick.beep();

global key;
InitKeyboard();
while 1
   pause(0.1);
   switch key
       case 'uparrow'
           disp('Up Arrow Pressed!');
           brick.MoveMotor('AB', 50);
           pause(.5);
           brick.StopAllMotors('Brake');
      
       case 'downarrow'
           disp('Down Arrow Pressed!');
           brick.MoveMotor('AB', -50);
           pause(.5);
           brick.StopAllMotors('Brake');
      
       case 'leftarrow'
           disp('Left Arrow Pressed!');
           brick.MoveMotor('A', -70);
           brick.MoveMotor('B', 70);
           pause(2.75);
           brick.StopAllMotors('Brake');
      
       case 'rightarrow'
           disp('Right Arrow Pressed!');
           brick.MoveMotor('A', 70);
           brick.MoveMotor('B', -70);
           pause(2.5);
           brick.StopAllMotors('Brake');
      
       case 'a'
           disp('a is pressed');
           brick.MoveMotorAngleRel('C', 20, 30);
           brick.WaitForMotor('C');
      
       case 'b'
           disp('b is pressed');
           brick.MoveMotorAngleRel('C', 20, -10);
           brick.WaitForMotor('C');
       case 'd'
           position = brick.GetMotorAngle('C');
           display(position);
      
       case 'e'
           brick.MoveMotor('A', -20);
           brick.MoveMotor('B', 20);
           pause(1);
           brick.StopAllMotors('Brake');
      
       case 'f'
           brick.MoveMotor('A', 20);
           brick.MoveMotor('B', -20);
           pause(2);
           brick.StopAllMotors('Brake');
      
       case 0
           disp('No Key Pressed!');
      
       case 'q'
           brick.StopAllMotors('Brake');
           break;
   end
end
CloseKeyboard();

