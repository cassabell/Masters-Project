%Loadsol and Pupil Labs Invisible Eye Tracking Synchronization 

%By: Cassie Fileccia
%4/30/2021

%This allows users to import Loadsol and eye tracking data, synchronize the
%data points start time, and export relevant information into excel
%sheets. For this code to be properly executed the loadsol and eye tracking
%need to be recorded on the same device and the loadsol should start
%recording first.This code was written using Matlab R2019a. Novel.de's 3
%sensor loadsols were set to a frequency of 120 Hz.  Pupil Labs data is from
%Pupil Player v3.2.20. 


%Import gaze positions data
gazepositions = importfileGazePositions(filename, dataLines);
%Import pupil positions 
pupilpositions = importfilePupilPositions(filename, dataLines);
%Import loadsol data
loadsol = importfileLoadsolData(filename, dataLines);

%Extract File Name from loadsol data
%Select name of Loadsol file (make sure file is within your path)
"Select loadsol file (make sure it is within your path)"
[file,path] = uigetfile('*.txt');

%Extract time stamp from file name 
loadsolFileName = file;
a = extractAfter(loadsolFileName," ");
b = regexp(a, '[\d\.]+', 'match');
c = cell2mat(b);
d = num2str(c(1:6)) ;

%Get loadsol start time
loadsolTime = duration(str2double(regexp(d,'\d\d', 'match')));


%Get file name from eye tracking data by prompting user to enter file name
 userinput = input('Enter the name of the eye tracking folder: ' , 's')
 fileName = userinput;


%Seperate string to isolate time
eyeTrackFileName = strsplit(fileName, '_');
eyeTrackFileName = eyeTrackFileName(1,2);
eyeTrackFileName = char(eyeTrackFileName);
eyeTrackingTime = eyeTrackFileName(1:8);

%Get eye tracking start time
eyeTrackTime = duration(sscanf(eyeTrackingTime, '%2d-%2d-%2d').');


%downsample eye tracking data to 120 Hz
newGazePositions = downsample(gazepositions, 8);
newPupilPositions = downsample(pupilpositions, 8);

%Subtract the times to determine the start time discrepency
difference = eyeTrackTime - loadsolTime;

%Disregard the difference from loadsol data
L = seconds(difference);
newLoadsol = loadsol(loadsol.VarName1 > L,:);

%Delete unused columns
newLoadsol.VarName11 = [];
newLoadsol.VarName12 = [];
newLoadsol.VarName13 = [];
newLoadsol.VarName14 = [];
newLoadsol.VarName15 = [];

%Seperate variables that want to be exported
newGazePositions1 = newGazePositions(:,[1,4:5]);
newPupilPositions1 = newPupilPositions(:,[1,3,7]);


%Export lined up values to .xcel including L & R heel, medial, lateral, and
%peak force & normalGazePositionX, normalGazePositionY & pupil diameter
writetable(newLoadsol, 'Loadsol Force Data.xlsx')
writetable(newGazePositions1, 'Gaze Positions.xlsx')
writetable(newPupilPositions1, 'Pupil Diameter.xlsx')





