function El2D(app)

app.FinishedLamp.Color = [1 0 0];
pause(2);

missing = warningFileName(app);
if missing == 1
    return
end

%% 2D El graph
Name = NameGen(app);
w = app.weights;
cutAngle = app.CutAngleEditField_2.Value;
el2D = figure('Position',[900 250 500 500],'Name',Name);
viewAng = app.StartEditField_2.Value:app.EndEditField_2.Value;
pattern(app.array, app.FrequencyGHzEditField.Value*10^9, cutAngle, viewAng,...
    'PropagationSpeed', app.PropagationSpeedEditField.Value,...
    'Type', 'directivity', 'CoordinateSystem', 'polar' ,'weights', w);

app.FinishedLamp.Color = [0 1 0];

end