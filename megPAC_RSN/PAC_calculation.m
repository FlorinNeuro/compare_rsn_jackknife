function [mod2directall]=PAC_calculation (F, sRate,flow1,gamma_lowend,gamma_low_high_end,run_subject)
% F -  source or sensor data as input (signals x timepoints)
% sRate - sampling rate
% flow1 -Range of low-frequencies fpr phase calculation - for example:[2:0.5:12 14:2:30];
% gamma_lowend : Lowest frequency of the gamma-amplitude tested in the PAC calculation (40 Hz);
% gamma_low_high_end: Highest frequency of the gamma-amplitude tested in the PAC calculation (150 Hz);
% run_subject - some name for saving the data in the end

% === Defining the sampling Rate and number of samples===
% Process all the files
% Author: Esther Florin

nfLow = length(flow1);
dl =size(F,2);
allsources=size(F,1);

sp=get_signal_parameters('sampling_rate',sRate,...
    'number_points_time_domain',dl);

%Parameters - This is based on code from Canolty from the Canolty et al.,
%2006 paper
lf_g.fractional_bandwidth = 0.15;
lf_g.chirp_rate = 0; 
cf_list=make_center_frequencies(1,250,70,0.75); % min_freq, max_freq, numfreqs, min_freq_step

% filter and extract triggering phase indicies for later averaging:
hfreq = find( cf_list >= gamma_lowend & cf_list < gamma_low_high_end);
nfHigh = length(hfreq);
HFREQ = cf_list(hfreq);

% Prepare chirplets for later
% Dummy call to make_signal_structure top capture some parameters in the
% signal structure s
s = make_signal_structure(...
    'raw_signal',F(1,:),...
    'output_type','analytic',...
    'signal_parameters',sp);
allFreqs = [flow1, cf_list(hfreq)];
chirpF = zeros(1, length(s.frequency_domain), length(allFreqs));
for iif = 1:length(allFreqs)
    f_g=[];
    f_g.center_frequency = allFreqs(iif); % Hz
    f_g.fractional_bandwidth = 0.15;
    f_g.chirp_rate = 0;
    chirp_f = make_chirplet(...
        'chirplet_structure',f_g,...
        'signal_parameters',sp);
    
    chirpF(1, chirp_f.signal_frequency_support_indices , iif) = ...
        chirp_f.filter;
end
clear chirp_f

mod2directall= zeros(allsources, length(flow1), length(hfreq));
for source =1:allsources  % Loop over all input signals
    % Transform  time series into analytic signals
    s.frequency_domain = fft(F(source,:),...
        sp.number_points_frequency_domain,2);
    
    s.frequency_domain(:,sp.frequency_support<0)=0;
    s.frequency_domain(:,sp.frequency_support>0)=...
        2*s.frequency_domain(:,sp.frequency_support>0);
    
    
   % Define minimal frequency support with non-zeros chirplet coefficients
[~,scol] = find(s.frequency_domain ~= 0);
scol = max(scol)+1;
[chirprow] = find((chirpF(:,:)) ~= 0);
chirprow = max(chirprow)+1;
nfcomponents = min(chirprow,scol); % Minimal number of frequency coefficients
clear chirprow scol

BLKchirpF = chirpF( ones(1,1),1:nfcomponents, :);

     
    src_fs = s.frequency_domain(1:nfcomponents);
    fs = ifft( src_fs( :,: , ones(1,length(allFreqs) ) ) .* BLKchirpF,...
        sp.number_points_frequency_domain, 2);
    clear src_fs
    
    AMP = abs( fs(: , 1:sp.number_points_time_domain, nfLow+1:end ) ); % Calculation of the amplitude
    PHASE = exp (1i * angle( fs(: , 1:sp.number_points_time_domain , 1:nfLow ) ) ); % Calculation of the phase
    clear fs
    for ihf = 1:nfHigh
        
        tmp2 =  AMP(: ,:, ihf);
        mod2directall(source,:,ihf) = squeeze( sum( PHASE .* ...
            tmp2(:,:,ones(1,nfLow)), 2 ) ); %Beginning of PAC calculation based on the Özkurt and Schnitzler paper in 2011.
        
    end
    clear tmp2
    
    tmp2 = sqrt( ( sum(AMP.*AMP, 2) ) );
    mod2directall(source,:,:) = abs( mod2directall(source,:,:) ) ...
        ./ tmp2(:,ones(1,size(mod2directall,2)),:);
   mod2directall(source,:,:)= mod2directall(source,:,:)./sqrt(size(AMP,2));
        
end
    save([run_subject '.mat'], 'mod2directall')

end

