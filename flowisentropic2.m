function [MACH, T, P, RHO, A] = flowisentropic2(GAMMA, VAR, MTYPE)
%   [MACH, T, P, RHO, A] = FLOWISENTROPIC2(GAMMA, VAR, MTYPE) returns the
%   isentropic flow Mach number, MACH, temperature ratio, T,
%   pressure ratio, P, density ratio, RHO, and area ratio, A.
%   FLOWISENTROPIC calculates these arrays given the specific heat
%   ratio, GAMMA, and any one of the isentropic flow variables.  The
%   isentropic flow variable is selected by the string, MTYPE. The
%   temperature, pressure, and density ratios are a comparison of the local
%   static conditions over the stagnation (or total) conditions.  The area
%   ratio is a comparison of the instantaneous streamtube area for a
%   quasi-one-dimensional flow over the reference area (throat area or
%   minimum area) where the Mach number of the flow becomes unity.
%
%   Inputs for FLOWISENTROPIC2 are:
%
%   GAMMA :  Specific heat ratio.
%
%   VAR   :  Numerical values for one of the isentropic flow relations.
%
%            MACH :  Mach number. MACH is used with MTYPE variable 'mach'. 
%
%            T    :  Temperature ratio.  The temperature ratio is defined 
%                    as the local static temperature over the stagnation
%                    temperature. T is used with MTYPE variable 'temp'.
%
%            P    :  Pressure ratio.  The pressure ratio is defined as the
%                    local static pressure over the stagnation pressure. P 
%                    is used with MTYPE variable 'pres'.
%
%            RHO  :  Density ratio.  The density ratio is defined as the 
%                    local density over the stagnation density.  RHO is 
%                    used with MTYPE variable 'dens'.
%
%            A    :  Area ratio.  A is used with MTYPE variables 'sub' or
%                    'sup'.
%
%   MTYPE :  A string for selecting the isentropic flow variable
%             represented by VAR.
%
%             'mach'  :  Default value.  Indicates that the function is in
%                        Mach number input mode.
%   
%             'temp'  :  Indicates that the function is in temperature
%                        ratio input mode.
%
%             'pres'  :  Indicates that the function is in pressure ratio
%                        input mode.
%
%             'dens'  :  Indicates that the function is in density ratio
%                        input mode.
%
%             'sub'   :  Indicates that the function is in subsonic area
%                        ratio input mode.  The subsonic area ratio is
%                        defined as the local subsonic streamtube area over
%                        the reference streamtube area for sonic
%                        conditions.
%
%             'sup'   :  Indicates that the function is in supersonic area
%                        ratio input mode.  The supersonic area ratio is
%                        defined as the local supersonic streamtube area
%                        over the reference streamtube area for sonic
%                        conditions.
%
%   Outputs calculated for FLOWISENTROPIC2 are:
%
%   MACH    :  Mach number.
%
%   T       :  Temperature ratio.  The temperature ratio is defined as the 
%              local static temperature over the stagnation temperature.
%
%   P       :  Pressure ratio.  The pressure ratio is defined as the local 
%              static pressure over the stagnation pressure.
%
%   RHO     :  Density ratio.  The density ratio is defined as the local 
%              density over the stagnation density.
%
%   A       :  Area ratio.  The area ratio is defined as the local 
%              streamtube area over the reference streamtube area for
%              sonic conditions.
%
% Kyle Lynch - k.p.lynch at tudelft.nl

% Parse arguments and calculate the Mach number.
if (numel(GAMMA) > 1 || numel(VAR) > 1)
    error('Array arguments not supported. Use this function in a loop.');
elseif strcmp(MTYPE,'mach')
    M = VAR;
elseif strcmp(MTYPE,'sub')
    % Subsonic area ratio solution.
    % http://www.grc.nasa.gov/WWW/winddocs/utilities/b4wind_guide/mach.html
    P = 2/(GAMMA+1);
    Q = 1-P;
    R = VAR^2;
    a = P^(1/Q);
    r = (R-1)/(2*a);
    X = 1/( (1+r) + sqrt(r*(r+2)) );
    for i = 1:3
        X = P*(X-1)/(1-R*(P+Q*X)^(-P/Q));
    end
    M = sqrt(X);
elseif strcmp(MTYPE,'sup')
    % Supersonic area ratio solution.
    % http://www.grc.nasa.gov/WWW/winddocs/utilities/b4wind_guide/mach.html
    P = 2/(GAMMA+1);
    Q = 1-P;
    R = VAR^(2*Q/P);
    a = Q^(1/P);
    r = (R-1)/(2*a);
    X = 1/( (1+r) + sqrt(r*(r+2)) );
    for i = 1:3
        X = Q*(X-1)/(1-R*(Q+P*X)^(-Q/P));
    end
    M = 1/sqrt(X);
elseif strcmp(MTYPE,'pres')
    % Pressure ratio solution.
    M = sqrt((2/(GAMMA-1))*(VAR^(-(GAMMA-1)/GAMMA)-1));
elseif strcmp(MTYPE,'dens')
    % Density ratio solution.
    M = sqrt((2/(GAMMA-1))*(VAR^(-(GAMMA-1)/1)-1));
elseif strcmp(MTYPE,'temp')
    % Temperature ratio solution.
    M = sqrt((2/(GAMMA-1))*(VAR^(-1)-1));
else
    error('Unsupported mode.');
end

% Organize outputs.
MACH = M;
T = 1 / (1 + 0.5*(GAMMA-1)*M^2);
P = 1 / ((1 + 0.5*(GAMMA-1)*M^2)^(GAMMA/(GAMMA-1)));
RHO = 1 / ((1 + 0.5*(GAMMA-1)*M^2)^(1/(GAMMA-1)));
A = sqrt( (1/M^2)*((2/(GAMMA+1))*(1+0.5*(GAMMA-1)*M^2))^((GAMMA+1)/(GAMMA-1)) );

end