function Main(app)

app.FinishedLamp.Color = [1 0 0];
pause(2);

missing = warningFileName(app);
if missing == 1
    return
end

%% Warning Dialog
if isempty(app.FileLocationEditField.Value)
    warndlg('Please enter a file location of antenna data...Returning')
    app.array = [];
    app.elem = [];
    app.w = [];
    return
end
if ~isfile(app.FileLocationEditField.Value)
    warndlg('Please enter a valid file location of antenna data...Returning')
    app.array = [];
    app.elem = [];
    app.w = [];
    return
end

%% Gathers data from file picked
[num, txt] = xlsread(app.FileLocationEditField.Value);

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
    prompt = {'Frequency(s) [GHz]:'};
    dlgtitle = 'Frequency(s) not found';
    dims = [1 35];
    definput = {'24.5'};
    answer = inputdlg(prompt,dlgtitle,dims,definput);
    freq = str2double(answer{1})*10^9;
end
app.FrequencyGHzEditField.Value = freq*10^-9;

%% Inputs
M = app.MSpinner.Value;
N = app.NSpinner.Value;
phaseShiftBits = app.PhaseBitsSpinner.Value;

%% Calculations 
c = app.PropagationSpeedEditField.Value;
lambda = c/freq;
dm = lambda*app.dmEditField.Value;
dn = lambda*app.dnEditField.Value;

%% Uniform Rect Array
array = phased.URA('Size',[M N],'Lattice','Rectangular','ArrayNormal','z');
array.ElementSpacing = [dm dn];
%No Taper (just uniform)
rwind = ones(1,N).';
cwind = ones(1,M).';
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
% elem = phased.CardioidAntennaElement;
% elem.FrequencyRange = [0 24500000000];
% elem.NullAxisDirection = '-x';
% array.Element = elem;


% %% Array Geometry 
% arrayFigure = figure;
% viewArray(array,'ShowNormal',true,...
%   'ShowTaper',true,'ShowIndex','All',...
%   'ShowLocalCoordinates',true,'ShowAnnotation',true,...
%   'Orientation',[0;0;0]); 
% pngName = [num2str(randi(10000)) '.png'];
% saveas(arrayFigure,pngName)
% close(arrayFigure)
% app.Image.ImageSource = pngName;
% pause(2)
% delete (pngName)

%% Steering Angles
az = app.DegEditField_2.Value;
el = app.DegEditField.Value;
steeringAngles = [el;az];

%% Phase Weights for Beam Steering
steerVector = phased.SteeringVector('SensorArray', array,...
    'PropagationSpeed', c, 'NumPhaseShifterBits', phaseShiftBits);
w = step(steerVector, freq, steeringAngles);

app.element = elem;
app.array = array;
app.weights = w;

app.FinishedLamp.Color = [0 1 0];

% %% 3D Radiation Pattern Single Element
% singleElemRadPatt3D = figure;
% pattern(elem, freq(1) , 'PropagationSpeed', c,...
%  'Type','directivity', 'CoordinateSystem', 'polar',...
%   'ShowArray',false,'ShowLocalCoordinates',true,...
%   'ShowColorbar',true,'Orientation',[0;0;0]);
% pngName = [num2str(randi(10000)) '.png'];
% saveas(singleElemRadPatt3D,pngName)
% close(singleElemRadPatt3D)
% app.Image_2.ImageSource = pngName;
% pause(2)
% delete (pngName)

% %% 3D Radiation Pattern Array
% arrayRadPatt3D = figure;
% pattern(array, freq(1) , 'PropagationSpeed', c,...
%  'Type','directivity', 'CoordinateSystem', 'polar','weights', w(:,1),...
%   'ShowArray',false,'ShowLocalCoordinates',true,...
%   'ShowColorbar',true,'Orientation',[0;0;0]);
% pngName = [num2str(randi(10000)) '.png'];
% saveas(arrayRadPatt3D,pngName)
% close(arrayRadPatt3D)
% app.Image_3.ImageSource = pngName;
% pause(2)
% delete (pngName)

% %% 2D Az graph
% cutAngle = 0;
% az2D = figure;
% pattern(array, freq(1), -180:180, cutAngle, 'PropagationSpeed', c,...
%  'Type', 'directivity', 'CoordinateSystem', 'polar' ,'weights', w);
% pngName = [num2str(randi(10000)) '.png'];
% saveas(az2D,pngName)
% close(az2D)
% pause(2)
% app.Image_4.ImageSource = pngName;
% delete (pngName)

% %% 2D El graph
% cutAngle = 0;
% el2D = figure;
% pattern(array, freq(1), cutAngle, -90:90, 'PropagationSpeed', c,...
%  'Type', 'directivity', 'CoordinateSystem', 'polar' ,'weights', w);
% pngName = [num2str(randi(10000)) '.png'];
% saveas(el2D,pngName)
% close(el2D)
% pause(2)
% app.Image_5.ImageSource = pngName;
% delete (pngName)

% %% UV Pattern Whole
% uvWhole = figure;
% pattern(array,freq(1),'PropagationSpeed',c,'Type','powerdb',...
%     'CoordinateSystem','UV','weights', w);
% pngName = [num2str(randi(10000)) '.png'];
% saveas(uvWhole,pngName)
% close(uvWhole)
% pause(2)
% app.Image_6.ImageSource = pngName;
% delete (pngName)
% 
% %% UV Pattern Cut
% uvCut = figure;
% pattern(array, freq(1), -1:0.01:1, 0, 'PropagationSpeed', c,...
%  'Type','directivity','CoordinateSystem', 'uv','weights', w);
% pngName = [num2str(randi(10000)) '.png'];
% saveas(uvCut,pngName)
% close(uvCut)
% pause(2)
% app.Image_7.ImageSource = pngName;
% delete (pngName)

% %% Plot Grating Lobe Diagram
% gratingLobes = figure;
% plotGratingLobeDiagram(array,freq(1),steeringAngles(:,1),c);
% pngName = [num2str(randi(10000)) '.png'];
% saveas(gratingLobes,pngName)
% close(gratingLobes)
% pause(2)
% app.Image_8.ImageSource = pngName;
% delete (pngName)


end