function [ift] = myFilter( R, xp, typeOfFilter, L)
    [a, b] = size(R);
    ift = 0;
    frequency = linspace(-1,1,length(xp'));%xp';
    rectW = zeros(1, length(xp));
    L = L*max(frequency);
    ft = fft(R,[],1); %Fourier transform across the first dimension
    ft = fftshift(ft,1); % FFT shift along the 1st dimension
    absFrequency = abs(frequency);
    rectW(find(absFrequency<=L)) = 1;
    if(strcmp(typeOfFilter, 'RL'))    %Ram-Lak filter
        filter = absFrequency.*rectW;
    elseif(strcmp(typeOfFilter, 'SL'))    %Shepp Logan filter
        filter = double((absFrequency.*rectW.*sin(0.5*pi*frequency/L)));
        for i = 1:1:length(frequency)
            if(frequency(i) == 0)
                filter(i) = 1;
            else
                filter(i) = filter(i)/double((0.5*pi*frequency(i)/L));
            end
        end
    elseif(strcmp(typeOfFilter, 'C'))    %Cosine filter
        filter = absFrequency.*rectW.*cos(0.5*pi*frequency/L);
    end
    filter = repmat(filter', [1 b]);
    filteredBackProjection = filter .* ft;
    filteredBackProjection = ifftshift(filteredBackProjection,1);
    ift = abs(ifft(filteredBackProjection,[],1));
end

