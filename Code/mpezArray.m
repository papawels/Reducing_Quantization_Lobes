function MPEZ = mpezArray(M,bits)

MPEZ = zeros(M^2,1);
check = log2(32);

if mod(check,1) ~= 0 
    warndlg('This method works best when the dimensions of the array are a power of 2. Please change and try again...Returning')
    return
end

if bits <4
    y = round(M^2/8);
else
    y = round(M^2/4);
end


for i = 1:y
    x = randi(M^2);
    while MPEZ(x) == 1
        x = randi(M^2);
    end
    MPEZ(x) = 1;
end

for i = 1:y
    x = randi(M^2);
    while MPEZ(x) == 1 || MPEZ(x) == 2
        x = randi(M^2);
    end
    MPEZ(x) = 2;
end

MPEZ= reshape(MPEZ,32,32);
% figure;
% imagesc(MPEZ);
% axis xy


