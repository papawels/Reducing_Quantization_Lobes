function arrayPatt(app)

app.FinishedLamp.Color = [1 0 0];
pause(2);

missing = warningFileName(app);
if missing == 1
    return
end

%% 3D Radiation Pattern Array
Name = NameGen(app);
w = app.weights;
arrayRadPatt3D = figure('Position',[900 250 500 500],'Name',Name);
pattern(app.array, app.FrequencyGHzEditField.Value*10^9,...
    'PropagationSpeed', app.PropagationSpeedEditField.Value,...
    'Type','directivity', 'CoordinateSystem', 'polar',...
    'ShowArray',false,'ShowLocalCoordinates',true,...
    'ShowColorbar',true,'Orientation',[0;0;0], 'weight', w);

app.FinishedLamp.Color = [0 1 0];

end