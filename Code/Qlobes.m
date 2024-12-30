function Qlobes(app)

app.FinishedLamp.Color = [1 0 0];
pause(2);

missing = warningFileName(app);
if missing == 1
    return
end

phaseRange = app.LeastSpinner.Value:app.MostSpinner.Value;

%% Steering Angles
%el = app.DegEditField_2.Value;
az = app.DegEditField.Value;
el = app.DegEditField_2.Value;
cutAngle = az;
steeringAngles = [az;el];
viewAng = -90:90;

if app.StandardCheckBox.Value == 1

    %figure;
    perf = pattern(app.array, app.FrequencyGHzEditField.Value*10^9, cutAngle, viewAng,...
        'PropagationSpeed', app.PropagationSpeedEditField.Value,...
        'Type', 'directivity', 'CoordinateSystem', 'polar');
    [pks,locs] = findpeaks(perf);
    figure;
    legend();
    hold on
    xrange = 1:length(pks);
    %plot(xrange,pks,'DisplayName','Perf')

    % maxi = max(perfect);
    % perfect(perfect>maxi-3.01) = nan;
    % avgPwrPerf = mean(perfect,"all")
    % varPerf = sum((perfect - avgPwrPerf).^2,'all')/numel(perfect)


    for i = phaseRange
        steerVector = phased.SteeringVector('SensorArray', app.array,...
            'PropagationSpeed', app.PropagationSpeedEditField.Value,...
            'NumPhaseShifterBits', i);
        w = step(steerVector, app.FrequencyGHzEditField.Value*10^9, steeringAngles);
        %figure;
        weighted = pattern(app.array, app.FrequencyGHzEditField.Value*10^9, cutAngle, viewAng,...
            'PropagationSpeed', app.PropagationSpeedEditField.Value,...
            'Type', 'directivity', 'CoordinateSystem', 'polar','weight',w);
        %maxi = max(weighted);
        %weighted(weighted>maxi-3.01) = nan;
        %avg(i-2) = mean(weighted,"all");
        %var(i-2) = sum((weighted - avgPwrWt).^2,'all')/numel(weighted);
        [pks,locs] = findpeaks(weighted);

        if i == 5
            hold off
            figure;
            legend();
            hold on
        end

        xrange = 1:length(pks);
        name = "std"+ string(i);
        plot(xrange,pks,'DisplayName',name)
    end

    hold off

    % pBits = phaseRange;
    % figure;
    % plot(pBits,avg);
    % figure;
    % plot(pBits,var)
end

if app.TDQCheckBox.Value == 1

    figure;
    hold on
    legend();

    for i = phaseRange

        %w = step(steerVector, app.FrequencyGHzEditField.Value*10^9, steeringAngles);
        %wV = angleManipulation(app,'vert',i,'TDQ');
        wH = angleManipulation(app,'horz',i,'TDQ');
        %wH = flip(wV,1);
        newW = wH;

        %newW = w1+w2;
        weighted = pattern(app.array, app.FrequencyGHzEditField.Value*10^9, cutAngle, viewAng,...
            'PropagationSpeed', app.PropagationSpeedEditField.Value,...
            'Type', 'directivity', 'CoordinateSystem', 'polar','weight',newW);
        %maxi = max(weighted);
        %weighted(weighted>maxi-3.01) = nan;
        %avg(i-2) = mean(weighted,"all");
        %var(i-2) = sum((weighted - avgPwrWt).^2,'all')/numel(weighted);
        %[pks,locs] = findpeaks(weighted);
        [pks,locs] = findpeaks(weighted);

        if i == 5
            hold off
            figure;
            legend();
            hold on
        end

        xrange = 1:length(pks);
        name = "TDQ"+ string(i);
        plot(xrange,pks,'DisplayName',name)
    end

    % pBits = phaseRange;
    % figure;
    % plot(pBits,avg);
    % figure;
    % plot(pBits,var)

end

% yes = reshape(newW,32,32);
% figure; imagesc(angle(yes)),axis xy

if app.MPEZCheckBox.Value == 1

    figure;
    hold on
    legend();

    for i = phaseRange

        wR = angleManipulation(app,'horz',i,'MPEZ');
        %wH = flip(wV,1);
        newW = wR;

        %newW = w1+w2;
        weighted = pattern(app.array, app.FrequencyGHzEditField.Value*10^9, cutAngle, viewAng,...
            'PropagationSpeed', app.PropagationSpeedEditField.Value,...
            'Type', 'directivity', 'CoordinateSystem', 'polar','weight',newW);
        %maxi = max(weighted);
        %weighted(weighted>maxi-3.01) = nan;
        %avg(i-2) = mean(weighted,"all");
        %var(i-2) = sum((weighted - avgPwrWt).^2,'all')/numel(weighted);
        %[pks,locs] = findpeaks(weighted);
        [pks,locs] = findpeaks(weighted);

        if i == 5
            hold off
            figure;
            legend();
            hold on
        end

        xrange = 1:length(pks);
        name = "MPEZ"+ string(i);
        plot(xrange,pks,'DisplayName',name)

    end

end

app.FinishedLamp.Color = [0 1 0];
