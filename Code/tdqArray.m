function tdqArrayMat = tdqArray(M,direct)

N = M;
tdqArrayMat = zeros(M,N);
check = log2(32);

if mod(check,1) ~= 0 
    warndlg('This method works best when the dimensions of the array are a power of 2. Please change and try again...Returning')
    return
end

for i = 1:M
    if i == 1
        continue
    end
    begin = M/i;
    step = begin;
    last = begin*(i-1);
    idxs = begin:step:last;
    idxs = round(idxs);
    tdqArrayMat(i,idxs) = 1;
end

if strcmp(direct,'horz')
    tdqArrayMat = permute(tdqArrayMat,[2 1]);
end

end