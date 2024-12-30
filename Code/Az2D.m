function Az2D(app)

app.FinishedLamp.Color = [1 0 0];
pause(2);

missing = warningFileName(app);
if missing == 1
    return
end

%% 2D Az graph
Name = NameGen(app);
w = app.weights;
cutAngle = app.CutAngleEditField.Value;
viewAng = app.StartEditField.Value:app.EndEditField.Value;
az2D = figure('Position',[900 250 500 500],'Name',Name);
pattern(app.array, app.FrequencyGHzEditField.Value*10^9, viewAng, cutAngle,...
    'PropagationSpeed', app.PropagationSpeedEditField.Value,...
    'Type', 'directivity', 'CoordinateSystem', 'polar' ,'weights', w);

app.FinishedLamp.Color = [0 1 0];

end