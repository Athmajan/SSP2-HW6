%% Lab 6
clear;clc;close all

figure
Ntrial = 1000;
Nsample = 25;
SNR_dB = -20:1:10;
Pfa = [1e-1,1e-2,1e-3,1e-4,1e-5];
num_colors = length(Pfa);

% Generate a color palette
color_palette = lines(num_colors);

grid on
hold on
xlabel('Signal-to-noise ratio (dB)');
ylabel('Probability of detection P_d');
ylim([0 1]);
for j=1:length(Pfa)
    for i=1:length(SNR_dB)
        SNR = 10.^(SNR_dB(i)/10);
        a = chi2inv(1-Pfa(j),Nsample);
        Pd(i,j) = 0;
        for itrial = 1:Ntrial
            %% signal generation            SNR = sigma_s^2/sigma^2
            s = sqrt(SNR) * randn(Nsample,1);
            w = sqrt(1) * randn(Nsample,1);
            x = s + w;
            
            % Since M is known matrix.
            % Generatng an invertible MM' square matrix
            %MMt = generate_invertible_matrix(Nsample);
            
            %% detection            
            % calculate Tx
            Tx = sum(x.^2);

            % determine threshold gamma''
            threshold_pp = a*var(w);
                
            
            if Tx > threshold_pp
                Pd(i,j) = Pd(i,j) + 1/Ntrial;
            end
        end
    end
    plot(SNR_dB, Pd(:,j) ,'Color', color_palette(j, :),'DisplayName', ['N = 25 and P_{fa} = ', num2str(Pfa(j))]);
end



legend('show');


function A = generate_invertible_matrix(n)
    % Initialize a flag to check if the matrix is invertible
    invertible = false;

    while ~invertible
        % Generate a random square matrix of size n x n
        A = rand(n);

        % Check if the matrix is invertible (i.e., determinant is non-zero)
        if det(A) ~= 0
            invertible = true;
        end
    end
end

