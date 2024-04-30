clear all;

% Define LoRa parameters
BW = 125e3; % Bandwidth 125 kHz
SF = 18; % Spreading Factor
binaryData = [1 1 0 0]; % Binary data to be modulated

% Calculate chirp duration and samples per chirp
chirpDuration = (2^SF) / BW;
Fs = 2 * BW; % Sampling frequency, at least twice the bandwidth
numSamplesPerChirp = Fs * chirpDuration;

% Generate the time vector for one chirp
t = linspace(0, chirpDuration, numSamplesPerChirp);

loraSignal = []; % Initialize the LoRa signal

for bit = binaryData
    if bit == 0
        % Generate downchirp for '0'
        f0 = BW; % Start frequency at BW
        f1 = 0; % End frequency at 0
    else
        % Generate upchirp for '1'
        f0 = 0; % Start frequency at 0
        f1 = BW; % End frequency at BW
    end
    
    % Generate linear chirp for the duration of the chirp
    chirpSignal = chirp(t, f0, chirpDuration, f1, 'linear');
    
    loraSignal = [loraSignal, chirpSignal]; % Append chirp signal to total signal
end
disp(['Current directory: ', pwd]);
cd('/Users/stuart/Group-15-LoRa-Modulation/api_code');
disp(['Current directory: ', pwd]);
% Save the signal to a wav file
audiowrite('loraSignal.wav', loraSignal, Fs);

% Play sound
sound(loraSignal, Fs);

% Optionally, plot the time-domain and frequency-domain representations
figure;
subplot(2, 1, 1);
plot(loraSignal);
title('LoRa Signal in Time Domain');
xlabel('Samples');
ylabel('Amplitude');

subplot(2, 1, 2);
spectrogram(loraSignal, 1024, 3/4 * 1024, 1024, Fs, 'yaxis');
title('Spectrogram of LoRa Signal');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
