function AMP = ImgToAudBlockOpp(imageFileName,Fs) 
%Give it the name of the image file and the frequency(Fs) of the underlying
%audiofile.

IMG = imread(imageFileName);

[r,c,w] = size(IMG);

numSamples = r*c;

if numSamples/Fs < 10
    numBlockCols = ceil(numSamples/44100);    %This paramater determines the width of the final image
else
    numBlockCols = 10;
end

blockSize = 210;
numBlockRows = ceil((numSamples/(blockSize^2))/numBlockCols);

amp = zeros(numSamples,1);
amp = cast(amp,'double');


%totalBlocks = ceil(numSamples / blockSize^2);

hashTable = buildLookupOpp();

keySetA = cell(1,65536);
for i = 1: length(hashTable)
    a = num2str(hashTable(i,1));
    b = num2str(hashTable(i,2));
    c = num2str(hashTable(i,3));
    keySetA{i} = strcat(a,'*',b,'#',c);
end

valueSet = (0:65535);
mapObj = containers.Map(keySetA,valueSet);
samp = 1;
temp = zeros(1,3);
tic;
for x = 1:blockSize:(numBlockRows)*(blockSize)
    for y = 1:blockSize:(numBlockCols)*(blockSize)
        for i = x: x+blockSize-1            
            for j = y: y+blockSize-1
               if(samp >= numSamples)
                   break;
               end
               
               temp(1,:) = IMG(i,j,:);
               a = num2str(temp(1,1));
               b = num2str(temp(1,2));
               c = num2str(temp(1,3));
               hVal = strcat(a,'*',b,'#',c);
                                  
               amp(samp) = mapObj(hVal);
               if (temp(1,1) == 0 && temp(1,2) == 0 && temp(1,3) == 0)
                   amp(samp) = 0+32768;
               elseif (temp(1,1) == 0 && temp(1,2) == 1 && temp(1,3) == 255)
                   amp(samp) = -2+32768;
               end
               samp = samp+1;
            end
        end
    end
end

amp = amp-32768;
amp = cast(amp,'int16');

audiowrite(strcat(imageFileName,'.wav'),amp,Fs);
AMP = amp;
toc

end