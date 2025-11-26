%parameter initialization
basisDimension = 1000; %start from 100 can go till 1000
filename = 'river_flows_in_you.mp3';
fs = 44100;
duration = 7; %please keep this small it requires a lot of processing
offset= 44;

%main
% Read the audio and preprocessing
[y,fs] = audioread(filename);
if size(y, 2) > 1
    y = mean(y, 2); % converting stereo to mono
end
y_clipped = y(offset*fs:(offset+duration)*fs);
disp('Playing original Signal');
sound(y_clipped,fs)
L = length(y_clipped);                  
time = (0:L-1)' / fs;       
basisVectorsFrequency = blackBox(basisDimension, y_clipped,fs);


%plot original signal amplitude vs time
figure;
subplot(2,1,1)
plot(time, y_clipped);
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Audio Signal Waveform');
drawnow;


% Reconstruction using Projection
y_reconstructed = zeros(L, 1);
for k = 1:basisDimension
    freq = basisVectorsFrequency(k);
    
    %DC Component
    if freq == 0
        % Projection onto a constant vector of ones
        basis_dc = ones(L, 1);
        coeff = dot(y_clipped, basis_dc) / dot(basis_dc, basis_dc);
        y_reconstructed = y_reconstructed + (coeff * basis_dc);
        
    %AC Components (Sin and Cos)
    else
        %Basis Vectors
        cos_basis = cos(2 * pi * freq * time);
        sin_basis = sin(2 * pi * freq * time);
        
        % Calculate Projections (Amplitudes)
        a_k = dot(y_clipped, cos_basis) / dot(cos_basis, cos_basis);
        b_k = dot(y_clipped, sin_basis) / dot(sin_basis, sin_basis);
        
        error_signal = y_clipped - y_reconstructed;
        MSE = mean(error_signal.^2);

        if mod(k,ceil(basisDimension/25)) == 0
        subplot(2,1,1)
        hold on;
        plot(time, y_reconstructed,'r--');
        xlabel('Time (seconds)');
        ylabel('Amplitude');
        legend('Original Signal', 'Reconstructed Signal');
        title(['Number of basis vectors = ', num2str(k)]);
        drawnow;
        hold off;


        subplot(2,1,2)
        plot(time, error_signal, 'g--');
        xlabel('Time (seconds)');
        ylabel('Error Amplitude');
        title({'Reconstruction Error Signal', [' RMSE error = ',num2str(sqrt(MSE))]});
        drawnow;
        pause(0.01)
        end

        y_reconstructed = y_reconstructed + (a_k * cos_basis) + (b_k * sin_basis);
    end
end

%Play Sound
disp('Playing reconstructed Signal');
soundsc(y_reconstructed, fs);















function [prominent_frequencies] = blackBox(basisDimension,y_clipped,fs)
L = length(y_clipped);       
N_prominent = basisDimension;           

Y = fft(y_clipped);
P2 = abs(Y/L);
P1 = P2(1:floor(L/2)+1);
P1(2:end-1) = 2*P1(2:end-1); 
f = fs*(0:floor(L/2))/L;

% Identify Prominent Frequencies
[~, sortIndices] = sort(P1, 'descend');

% Get the indices and values of the top N frequencies
top_indices = sortIndices(1:N_prominent);
prominent_frequencies = f(top_indices);
end