function newW = angleManipulation(app,dir,bits,method)

 w = app.weights;
    wAngs = angle(w)*180/pi+180;

    M = app.MSpinner.Value;
    N = app.NSpinner.Value;

    wAngs = reshape(wAngs,M,N);

if strcmp(method,'TDQ')

    tdqArrayOffset = tdqArray(M,dir);

    wAngs = wAngs - tdqArrayOffset*360/2^bits;

    wAngs(wAngs>360) = 360;
    wAngs = (wAngs-180)*pi/180;

    wAngs = reshape(wAngs,M^2,1);

    newW = 1*exp(1i*wAngs);
end

if strcmp(method,'MPEZ')

    MPEZ = mpezArray(M,bits);

    roundUp = (MPEZ == 1);
    roundDown = (MPEZ == 2);

    wAngs = wAngs - roundDown*360/2^bits;
    wAngs = wAngs + roundUp*360/2^bits;

    wAngs(wAngs>360) = 360;
    wAngs = (wAngs-180)*pi/180;

    wAngs = reshape(wAngs,M^2,1);

    newW = 1*exp(1i*wAngs);

end


