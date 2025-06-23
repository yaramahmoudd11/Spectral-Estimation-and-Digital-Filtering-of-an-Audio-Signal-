clc; clear; close all;

% CONFIGURATION
num_syms = 1e5;                    % Total number of symbols
mod_orders = [2, 4, 8];            % PAM modulation orders
snr_range_db = 0:2:20;             % SNR values in dB
samples_to_display = 100;          % Number of signal samples to visualize

% Initialize result matrices

ber_measured = zeros(length(mod_orders), length(snr_range_db));
ber_expected = zeros(length(mod_orders), length(snr_range_db));
ser_measured = zeros(length(mod_orders), length(snr_range_db));

% Loop over each modulation order

for mod_idx = 1:length(mod_orders)
    M = mod_orders(mod_idx);               % Current modulation order
    bits_per_sym = log2(M);                % Bits per symbol
    energy_sym = (M^2 - 1) / 3;             % Avg symbol energy for M-PAM

    % Generate random data and modulate

    symbol_stream = randi([0 M-1], num_syms, 1);
    tx_signal = pammod(symbol_stream, M);

    % Show sample of input and modulated signals (only for first case)

    if mod_idx == 1
        figure;
        subplot(2,1,1);
        stem(symbol_stream(1:samples_to_display), 'filled');
        title('Original Data Symbols');
        xlabel('Index'); ylabel('Value'); grid on;

        subplot(2,1,2);
        plot(tx_signal(1:samples_to_display), 'b', 'LineWidth', 1.5);
        title('Transmitted PAM Signal');
        xlabel('Index'); ylabel('Amplitude'); grid on;
    end

    % Sweep through SNR values

    for snr_idx = 1:length(snr_range_db)
        snr_db = snr_range_db(snr_idx);
        snr_linear = 10^(snr_db / 10);
        eb_n0 = snr_linear / bits_per_sym;
        noise_var = energy_sym / (2 * eb_n0);

        % AWGN Channel

        awgn = sqrt(noise_var) * randn(num_syms, 1);
        rx_signal = tx_signal + awgn;

        % Visualize at SNR = 10 dB

        if snr_db == 10
            figure;
            subplot(3,1,1);
            plot(tx_signal(1:samples_to_display), 'b', 'LineWidth', 1.5);
            title(sprintf('%d-PAM - Clean Signal (10 dB SNR)', M));
            xlabel('Index'); ylabel('Amplitude'); grid on;

            subplot(3,1,2);
            plot(rx_signal(1:samples_to_display), 'r', 'LineWidth', 1.5);
            title('Noisy Received Signal'); xlabel('Index');
            ylabel('Amplitude'); grid on;
        end

        % Demodulate

        sym_received = pamdemod(rx_signal, M);

        % Plot demodulation results
        if snr_db == 10
            subplot(3,1,3);
            stem(sym_received(1:samples_to_display), 'filled', 'MarkerSize', 4);
            hold on;
            stem(symbol_stream(1:samples_to_display), 'r--', 'MarkerSize', 2);
            title('Demodulated vs Original Symbols');
            legend('Received', 'Original');
            xlabel('Index'); ylabel('Value'); grid on;
        end

        % Error calculations

        ser_measured(mod_idx, snr_idx) = mean(sym_received ~= symbol_stream);

        bits_tx = de2bi(symbol_stream, bits_per_sym, 'left-msb');
        bits_rx = de2bi(sym_received, bits_per_sym, 'left-msb');
        total_bit_errors = sum(bits_tx ~= bits_rx, 'all');
        ber_measured(mod_idx, snr_idx) = total_bit_errors / (num_syms * bits_per_sym);

        % Theoretical BER
        if M == 2
            ber_expected(mod_idx, snr_idx) = qfunc(sqrt(2 * eb_n0));
        else
            ber_expected(mod_idx, snr_idx) = ...
                2 * (M - 1) / M * qfunc(sqrt((6 * log2(M) / (M^2 - 1)) * eb_n0));
        end
    end
end

% Visualization of BER results
line_styles = {'^-', 'x--', '*-.'};
line_colors = {'m', 'c', 'k'};

for mod_idx = 1:length(mod_orders)
    figure;
    subplot(length(mod_orders), 1, mod_idx); hold on;

    semilogy(snr_range_db, ber_measured(mod_idx,:), line_styles{mod_idx}, ...
        'Color', line_colors{mod_idx}, 'LineWidth', 2, 'MarkerSize', 6);
    
    semilogy(snr_range_db, ber_expected(mod_idx,:), line_styles{mod_idx}, ...
        'Color', line_colors{mod_idx}, 'LineWidth', 2, ...
        'MarkerFaceColor', 'none', 'MarkerSize', 6);

    title(sprintf('BER vs. SNR for %d-PAM', mod_orders(mod_idx)), 'FontSize', 14);
    xlabel('SNR (dB)'); ylabel('Bit Error Rate'); grid on;
    legend('Simulated', 'Theoretical', 'Location', 'northeast');
end

sgtitle('BER Performance of M-PAM Using Correlation Receiver', 'FontSize', 16);

% Print SER Table

fprintf('\n--- SYMBOL ERROR RATE REPORT ---\n');
for mod_idx = 1:length(mod_orders)
    fprintf('\nM = %d-PAM\n', mod_orders(mod_idx));
    fprintf('SNR (dB) | SER (Simulated)\n');
    for snr_idx = 1:length(snr_range_db)
        fprintf('%8.2f | %.5f\n', snr_range_db(snr_idx), ser_measured(mod_idx, snr_idx));
    end
end