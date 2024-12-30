clear
clc

%% Finding HFSS data file
fileName = 'Gain Table 1';
ext = '.csv';
file = ['C:\Users\peter\Documents\UMass Masters\ECE 697L\Project\' fileName ext];
[num, txt] = xlsread(file);

%% Data from HFSS antenna
freqCol = find(contains(txt,'Freq'));
phiCol = find(contains(txt,'Phi'));
thetaCol = find(contains(txt,'Theta'));
magPattCol = find(contains(txt,'Gain'));

phiAng = unique(num(:,phiCol),'stable');
thetaAng = unique(num(:,thetaCol),'stable');
magList = num(:,magPattCol);
magPatt = reshape(magList,length(thetaAng),length(phiAng));
phasePatt = zeros(size(magPatt));

if ~isempty(freqCol)
    freq = num(1,freqCol);
    if contains(txt(freqCol),'GHz')
        freq = freq*10^9;
    elseif contains(txt(freqCol),'MHz')
        freq = freq*10^6;
    end
else
    %Input if not found
    freq = 24.5e9;
end

%% Inputs
M = 10;
N = M;
phaseShiftBits = 5;

%% Calculations 
c = 3e8;
lambda = c/freq;
d = lambda/2;

%% Uniform Rect Array
array = phased.URA('Size',[M N],'Lattice','Rectangular','ArrayNormal','z');
array.ElementSpacing = [d d];
%No Taper (just uniform)
rwind = ones(1,10).';
cwind = ones(1,10).';
taper = rwind*cwind.';
array.Taper = taper.';

%% Custom antenna element creation
elem = phased.CustomAntennaElement;
elem.PatternCoordinateSystem = 'phi-theta';
elem.PhiAngles = phiAng;
elem.ThetaAngles = thetaAng;
elem.MagnitudePattern = magPatt;
elem.PhasePattern = phasePatt;
elem.MatchArrayNormal = true;
array.Element = elem;

%% Steering Angles
azel = phitheta2azel([0;0]);
steeringAngles = [azel(1);azel(2)];

%% Array Geometry 
figure;
viewArray(array,'ShowNormal',true,...
  'ShowTaper',true,'ShowIndex','All',...
  'ShowLocalCoordinates',true,'ShowAnnotation',true,...
  'Orientation',[0;0;0]);

%% Phase Weights for Beam Steering
w = zeros(getNumElements(array), length(freq));
steerVector = phased.SteeringVector('SensorArray', array,...
 'PropagationSpeed', c, 'NumPhaseShifterBits', phaseShiftBits(1));
for idx = 1:length(freq)
    w(:, idx) = step(steerVector, freq(idx), steeringAngles(:, idx));
end

%% 3D Radiation Pattern
figure;
pattern(array, freq(1) , 'PropagationSpeed', c,...
 'Type','directivity', 'CoordinateSystem', 'polar','weights', w(:,1),...
  'ShowArray',false,'ShowLocalCoordinates',true,...
  'ShowColorbar',true,'Orientation',[0;0;0]);

%% 2D Az graph
cutAngle = 0;
figure;
pattern(array, freq(1), -180:180, cutAngle, 'PropagationSpeed', c,...
 'Type', 'directivity', 'CoordinateSystem', 'polar' ,'weights', w);

%% 2D El graph
cutAngle = 0;
figure;
pattern(array, freq(1), cutAngle, -90:90, 'PropagationSpeed', c,...
 'Type', 'directivity', 'CoordinateSystem', 'polar' ,'weights', w);

%% UV Pattern Whole
figure;
pattern(array,freq(1),'PropagationSpeed',c,'Type','powerdb',...
    'CoordinateSystem','UV','weights', w);

%% UV Pattern
figure;
pattern(array, freq(1), -1:0.01:1, 0, 'PropagationSpeed', c,...
 'Type','directivity','CoordinateSystem', 'uv','weights', w);

%% Plot Grating Lobe Diagram
figure;
plotGratingLobeDiagram(array,freq(1),steeringAngles(:,1),c);
