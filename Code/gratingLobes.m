function gratingLobes(app)

app.FinishedLamp.Color = [1 0 0];
pause(2);

missing = warningFileName(app);
if missing == 1
    return
end

%% Steering Angles
phi = app.DegEditField_2.Value;
theta = app.DegEditField.Value;
azel = phitheta2azel([phi;theta]);
steeringAngles = [azel(1);azel(2)];

%% Plot Grating Lobe Diagram
Name = NameGen(app);
gratingLobes = figure('Position',[900 250 500 500],'Name',Name);
plotGratingLobeDiagram(app.array,app.FrequencyGHzEditField.Value*10^9,...
    steeringAngles(:,1),app.PropagationSpeedEditField.Value);

app.FinishedLamp.Color = [0 1 0];

end