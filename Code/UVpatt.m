function UVpatt(app)

app.FinishedLamp.Color = [1 0 0];
pause(2);

missing = warningFileName(app);
if missing == 1
    return
end

Name = NameGen(app);

w = app.weights;
UV = figure('Position',[900 250 500 500],'Name',Name);

if app.UCheckBox.Value == 0 && app.VCheckBox.Value == 0
    %% UV Pattern Whole
    pattern(app.array,app.FrequencyGHzEditField.Value*10^9,...
        'PropagationSpeed',app.PropagationSpeedEditField.Value,...
        'Type','powerdb','CoordinateSystem','UV','weights', w);
else
    %% UV Pattern Cut
    UVstart = app.StartEditField_3.Value;
    UVend = app.EndEditField_3.Value;
    range = UVstart:0.01:UVend;
    cut = app.CutAngleEditField.Value;
    if app.UCheckBox.Value == 1
        pattern(app.array, app.FrequencyGHzEditField.Value*10^9, range, cut,...
            'PropagationSpeed', app.PropagationSpeedEditField.Value,...
            'Type','directivity','CoordinateSystem', 'uv','weights', w);
    else
        temp = pattern(app.array,app.FrequencyGHzEditField.Value*10^9,...
        'PropagationSpeed',app.PropagationSpeedEditField.Value,...
        'Type','powerdb','CoordinateSystem','UV','weights', w);
        
        temp2 = pattern(app.array, app.FrequencyGHzEditField.Value*10^9,...
            'PropagationSpeed', app.PropagationSpeedEditField.Value,...
            'Type','directivity', 'CoordinateSystem', 'polar',...
            'ShowArray',false,'ShowLocalCoordinates',true,...
            'ShowColorbar',true,'Orientation',[0;0;0], 'weight', w);
        offset = max(temp2,[],'all');
 
        vLine = 1:201;
        vLine = (vLine -101)/100;
        vIdx = find(vLine == cut);
        v = temp(:,vIdx)+offset;%%%%%%
        plot(range,v);
        grid on
        ylim([-85 round(max(v))+10])
        title('Response in V Space');
        xlabel('V')
        ylabel('Directivity (dBi)')
    end
end

app.FinishedLamp.Color = [0 1 0];

end