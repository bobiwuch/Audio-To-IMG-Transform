function IMG = audToImgBlockOpp(audioFileName) %Give it the name of the audio file
%Converts mono .wav file into image, comprised of 210x210 blocks

%y is the row vector that contanins the audio samples, Fs is the frequency
%of the file
[amp,Fs] = audioread(audioFileName,'native');

numSamples = length(amp);

if numSamples/Fs < 10
    numBlockCols = ceil(numSamples/44100);    %This paramater determines the width of the final image
else
    numBlockCols = 10;
end

blockSize = 210;
numBlockRows = ceil((numSamples/(blockSize^2))/numBlockCols);
amp = cast(amp,'double');
ampNew = amp + 32768;

%totalBlocks = ceil(numSamples / blockSize^2);

hashTable = buildLookupOpp();
IMG = zeros(numBlockRows*blockSize, numBlockCols*blockSize, 3); %IMG is the final RGB matrix



samp = 1;

for x = 1:blockSize:(numBlockRows)*(blockSize)
    for y = 1:blockSize:(numBlockCols)*(blockSize)
        for i = x: x+blockSize-1            
            for j = y: y+blockSize-1
               if(samp > numSamples)
                   break;
               end
               p = ampNew(samp);
               IMG(i,j,:) = hashTable(p+1,:);
               samp = samp+1;
               
            end
        end
    end
end

IMG = cast(IMG,'uint8');
imshow(IMG);
imwrite(IMG,strcat(audioFileName,'.bmp'));
end