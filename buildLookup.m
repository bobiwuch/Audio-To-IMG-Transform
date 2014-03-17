function Hash = buildLookup()
%Builds the lookup table for audToImg

r=0;g=255;b=255;



x=1;
Hash = zeros(65536,3);
Hash(x,:) = [r,g,b];
x=x+1;
while x<65537
    
    
    if x<=32768
        g = g-1;
        if g == -1
            g = 255;
            b = b-2;
%             if b>255
%                 b=255;
%             end
        end
        Hash(x,:) = [r,g,b];
    elseif x == 32769
        r=0;g=0;b=0;
        Hash(x,:) = [r,g,b];
    else
        if x == 32770
            r = 1;
        end
        
        g = g+1;
        if g == 256
            g = 0;
            r = r+2;
        end
        Hash(x,:) = [r,g,b];
    end
    
    x = x+1;
end
  
end