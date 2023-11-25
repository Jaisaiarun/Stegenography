function em = Embed(mat,str)
    [x,y,z] = size(mat);
    imgpix = x*y*z;
    permutmat = permute(mat,[3 1 2]); %permute change the dimensions
    matbin = cellstr(dec2bin(permutmat)); % Image matrix converted to array of the corresponding binary values
    strbin = dec2bin(double(str));  % String characters converted to their binary values
    [nchar,nbits] = size(strbin); 
    %main variable 
    idx4 = ceil(imgpix/8)+1; % Variable to control movement between the 8 blocks 
    idx3 = 0; % Variable to move to next character
    idx2 = 0; % Variable to account for the bits of the character
    % 2 6 4 8 3 7 1 5 
    for idx1 = 1:nchar*4
        %rem - reminder 
        if rem(idx1,4)==1 % idx2 and idx3 updated on each character
            idx2 = nbits;
            idx3 = idx3+1;
        end
        val = char(matbin(idx4));
        if idx2-1 > 0 % Logic for embedding the character's bits 
            val(7:8) = strbin(idx3,(idx2-1:idx2));
            idx2 = idx2-2;
        elseif idx2-1 == 0
            val(7) = '0';
            val(8) = strbin(idx3,idx2);
        elseif idx2 <= 0
            val(7:8) = '0';
        end
        matbin(idx4) = cellstr(val);
        switch true % Maintain idx4 to remain in the same block or to move to the next block 
            case idx4 == ceil(imgpix/8)*2
                idx4 = ceil(imgpix/8)*5+1;
            case idx4 == ceil(imgpix/8)*6
                idx4 = ceil(imgpix/8)*3+1;
            case idx4 == ceil(imgpix/8)*4
                idx4 = ceil(imgpix/8)*7+1;
            case idx4 == imgpix
                idx4 = ceil(imgpix/8)*2+1;
            case idx4 == ceil(imgpix/8)*3
                idx4 = ceil(imgpix/8)*6+1;
            case idx4 == ceil(imgpix/8)*7
                idx4 = 1;
            case idx4 == ceil(imgpix/8)
                idx4 = ceil(imgpix/8)*4+1;
            otherwise
                idx4 = idx4+1;
        end
    end
    % Reformed matrix of binary value of pixels after embedding
    embin = permute(reshape(matbin,size(permutmat)),[2 3 1]);
    % Matrix form of the embedded image being returned
    em = uint8(reshape(bin2dec(embin),size(embin))); 
end