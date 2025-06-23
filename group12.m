% Parameters
EbNoVec = 0:2:20;  % Eb/No range (dB)
M = 2;             % PAM-2 (Binary PAM)
numBits = 1e6;     % Number of bits to transmit (larger for better accuracy)
simBER = zeros(length(EbNoVec), 1);  % Simulated BER
theoreticalBER = zeros(length(EbNoVec), 1);  % Theoretical BER

% Loop over each Eb/No value
for i = 1:length(EbNoVec)
    EbNo = EbNoVec(i);  % Current Eb/No value
    
    % Generate random bit stream
    transmittedBits = randi([0 M-1], numBits, 1);  % Random bits (0 or 1 for PAM-2)
    
    % Modulate: PAM-2 (Map bits to 2 symbols, e.g., 0 -> -1, 1 -> 1)
    transmittedSymbols = 2 * transmittedBits - 1;

    % Calculate SNR in linear scale (SNR = Eb/No for PAM-2)
    SNR = 10^(EbNo / 10);  % Convert Eb/No to linear SNR
    
    % Noise variance adjusted based on SNR (signal power is 1 for PAM-2)
    noiseVariance = 1 / (2 * SNR);  % Noise variance for the SNR in linear scale
    noise = sqrt(noiseVariance) * randn(numBits, 1);  % Add Gaussian noise

    % Received symbols with noise
    receivedSymbols = transmittedSymbols + noise;

    % Demodulate: Decision based on received symbols
    receivedBits = receivedSymbols > 0;  % Threshold decision (0 or 1)
    
    % Compute the BER (Bit Error Rate)
    numErrors = sum(receivedBits ~= transmittedBits);  % Count bit errors
    simBER(i) = numErrors / numBits;  % Simulated BER

    % Theoretical BER using Q-function for 2-PAM
    theoreticalBER(i) = qfunc(sqrt(2 * SNR));  % Q-function for PAM-2
    
    % Print progress (Optional)
    fprintf('Simulating for Eb/No = %.1f dB, Simulated BER = %.5f, Theoretical BER = %.5f\n', EbNo, simBER(i), theoreticalBER(i));
end

% Plot the BER vs Eb/No
figure;
semilogy(EbNoVec, simBER, '-o', 'DisplayName', 'Simulated BER'); % Simulated BER
hold on;
semilogy(EbNoVec, theoreticalBER, '-x', 'DisplayName', 'Theoretical BER'); % Theoretical BER
xlabel('Eb/No (dB)');
ylabel('BER');
title('BER vs Eb/No for 2-PAM');
legend('show');
grid on;

%---------------------------------------------pam4---------------------
% Parameters
EbNoVec = 0:2:20;  % Eb/No range (dB)
M = 4;             % PAM-4 (4-PAM)
numBits = 1e6;     % Number of bits to transmit (larger for better accuracy)
simBER = zeros(length(EbNoVec), 1);  % Simulated BER
theoreticalBER = zeros(length(EbNoVec), 1);  % Theoretical BER

% Loop over each Eb/No value
for i = 1:length(EbNoVec)
    EbNo = EbNoVec(i);  % Current Eb/No value
    
    % Generate random bit stream (2 bits per symbol for 4-PAM)
    transmittedBits = randi([0 M-1], numBits, 1);  % Random bits (0,1,2,3 for PAM-4)
    
    % Modulate: 4-PAM (Map bits to 4 symbols, e.g., 0 -> -3, 1 -> -1, 2 -> 1, 3 -> 3)
    transmittedSymbols = 2*transmittedBits - (M-1);  % Symmetric mapping: [-3, -1, 1, 3]
    
    % Calculate SNR in linear scale (SNR = Eb/No for PAM-4)
    SNR = 10^(EbNo / 10);  % Convert Eb/No to linear SNR
    
    % Noise variance adjusted based on SNR (signal power is 1 for PAM-4)
    noiseVariance = 1 / (2 * SNR);  % Noise variance for the SNR in linear scale
    noise = sqrt(noiseVariance) * randn(numBits, 1);  % Add Gaussian noise

    % Received symbols with noise
    receivedSymbols = transmittedSymbols + noise;

    % Demodulate: Decision based on received symbols (4 decision thresholds)
    receivedBits = round((receivedSymbols + (M-1))/2);  % Decision rule: map to nearest symbol
    
    % Compute the BER (Bit Error Rate)
    numErrors = sum(receivedBits ~= transmittedBits);  % Count bit errors
    simBER(i) = numErrors / numBits;  % Simulated BER

    % Theoretical BER for 4-PAM (using Q-function)
    theoreticalBER(i) = (2 / log2(M)) * (1 - 1/sqrt(M)) * qfunc(sqrt(6 * SNR / (M - 1)));

    % Print progress (Optional)
    fprintf('Simulating for Eb/No = %.1f dB, Simulated BER = %.5f, Theoretical BER = %.5f\n', EbNo, simBER(i), theoreticalBER(i));
end

% Plot the BER vs Eb/No
figure;
semilogy(EbNoVec, simBER, '-o', 'DisplayName', 'Simulated BER'); % Simulated BER
hold on;
semilogy(EbNoVec, theoreticalBER, '-x', 'DisplayName', 'Theoretical BER'); % Theoretical BER
xlabel('Eb/No (dB)');
ylabel('BER');
title('BER vs Eb/No for 4-PAM');
legend('show');
grid on;


%---------------------------------------------pam4---------------------


% Parameters
EbNoVec = 0:2:20;  % Eb/No range (dB)
M = 8;             % PAM-8 (8-PAM)
numBits = 1e6;     % Number of bits to transmit (larger for better accuracy)
simBER = zeros(length(EbNoVec), 1);  % Simulated BER
theoreticalBER = zeros(length(EbNoVec), 1);  % Theoretical BER

% Loop over each Eb/No value
for i = 1:length(EbNoVec)
    EbNo = EbNoVec(i);  % Current Eb/No value
    
    % Generate random bit stream (3 bits per symbol for 8-PAM)
    transmittedBits = randi([0 M-1], numBits, 1);  % Random bits (0,1,2,...,7 for PAM-8)
    
    % Modulate: 8-PAM (Map bits to 8 symbols, e.g., 0 -> -7, 1 -> -5, ..., 7 -> 7)
    transmittedSymbols = 2*transmittedBits - (M-1);  % Symmetric mapping: [-7, -5, -3, -1, 1, 3, 5, 7]
    
    % Calculate SNR in linear scale (SNR = Eb/No for PAM-8)
    SNR = 10^(EbNo / 10);  % Convert Eb/No to linear SNR
    
    % Noise variance adjusted based on SNR (signal power is 1 for PAM-8)
    noiseVariance = 1 / (2 * SNR);  % Noise variance for the SNR in linear scale
    noise = sqrt(noiseVariance) * randn(numBits, 1);  % Add Gaussian noise

    % Received symbols with noise
    receivedSymbols = transmittedSymbols + noise;

    % Demodulate: Decision based on received symbols (8 decision thresholds)
    receivedBits = round((receivedSymbols + (M-1))/2);  % Decision rule: map to nearest symbol
    
    % Compute the BER (Bit Error Rate)
    numErrors = sum(receivedBits ~= transmittedBits);  % Count bit errors
    simBER(i) = numErrors / numBits;  % Simulated BER

    % Theoretical BER for 8-PAM (using Q-function)
    theoreticalBER(i) = (2 / log2(M)) * (1 - 1/sqrt(M)) * qfunc(sqrt(6 * SNR / (M - 1)));

    % Print progress (Optional)
    fprintf('Simulating for Eb/No = %.1f dB, Simulated BER = %.5f, Theoretical BER = %.5f\n', EbNo, simBER(i), theoreticalBER(i));
end

% Plot the BER vs Eb/No
figure;
semilogy(EbNoVec, simBER, '-o', 'DisplayName', 'Simulated BER'); % Simulated BER
hold on;
semilogy(EbNoVec, theoreticalBER, '-x', 'DisplayName', 'Theoretical BER'); % Theoretical BER
xlabel('Eb/No (dB)');
ylabel('BER');
title('BER vs Eb/No for 8-PAM');
legend('show');
grid on;
