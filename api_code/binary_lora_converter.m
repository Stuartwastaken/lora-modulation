function binary_lora_converter()
    % Temporarily turn off all warnings
    warning('off','all');

    % Read the signal from the .wav file
    [signal, Fs] = audioread('lora_recording.m4a');

    % Define LoRa parameters
    BW = 125e3; % 125 kHz bandwidth
    SF = 18; % Spreading Factor

    % Calculate the number of samples per chirp based on the SF and BW
    chirpDuration = (2^SF) / BW;
    numSamplesPerChirp = Fs * chirpDuration;

    % Initialize binary data array
    binaryData = [];

    % Process each chirp
    for idx = 1:numSamplesPerChirp:length(signal)-numSamplesPerChirp+1
        % Extract one chirp from the signal
        chirp = signal(idx:idx+numSamplesPerChirp-1);

        % Apply Hilbert transform to the chirp
        analyticSignal = hilbert(chirp);
        instantaneousPhase = unwrap(angle(analyticSignal));
        instantaneousFrequency = diff(instantaneousPhase) * Fs / (2*pi);

        % Fit a line to the instantaneous frequency data
        p = polyfit((1:length(instantaneousFrequency))', instantaneousFrequency, 1);
        slope = p(1);

        % Decide if the chirp is an upchirp or downchirp based on the slope
        if slope > 0
            binaryData(end+1) = 1;
        else
            binaryData(end+1) = 0;
        end
    end

    % Display the demodulated binary data
    disp([num2str(binaryData)]);

    % Restore warning settings
    warning('on','all');
end
