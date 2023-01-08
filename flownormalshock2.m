function [MACH, T, P, RHO, M, P0, P1] = flownormalshock2(GAMMA, VAR, MTYPE)
%   [MACH, T, P, RHO, M, P0, P1] = FLOWNORMALSHOCK2(GAMMA, VAR, MTYPE)
%   returns the normal shock relations for a given specific heat ratio, 
%   GAMMA, and any one of the normal shock relations.  The normal shock 
%   relations are selected by the string, MTYPE.  The outputs are the Mach
%   number, MACH, temperature ratio, T, the (static) pressure ratio, P, the
%   density ratio, RHO, downstream Mach number, M, and the total
%   (stagnation) pressure ratio, P0.  All of these ratios are downstream
%   value over upstream value.  P1 is the Rayleigh-Pitot ratio, which is
%   the ratio of upstream static pressure over the downstream stagnation
%   pressure.  Note that upstream is said to be "before" or "ahead" of the
%   shock.  Downstream is said to be "after" or "behind" the shock.

%   Inputs for FLOWNORMALSHOCK2 are:
%
%   GAMMA :  Specific heat ratio.
%
%   VAR   :  Numerical values for one of the isentropic flow relations.
%
%            MACH :  Mach number. MACH is used with MTYPE variable 'mach'. 
%
%   MTYPE  :  A string for selecting the isentropic flow variable
%             represented by VAR.
%
%             'mach'  :  Default value.  Indicates that the function is in
%                        Mach number input mode.
%
%   Outputs calculated for FLOWNORMALSHOCK are:
%
%   MACH    :  Upstream Mach number.
%
%   T       :  Temperature ratio.  The temperature ratio is defined as the
%              static temperature downstream of the shock over the static 
%              temperature upstream of the shock.
%
%   P       :  Pressure ratios.  The pressure ratio is defined as the 
%              static pressure downstream of the shock over the static
%              pressure upstream of the shock.
%
%   RHO     :  Density ratio.  The density ratio is defined as the density
%              of the fluid downstream of the shock over the density 
%              upstream of the shock.
%
%   M       :  Downstream Mach number.
%
%   P0      :  Total pressure ratio.  The total pressure ratio is defined
%              as the total pressure downstream of the shock over the total
%              pressure upstream of the shock.
%
%   P1      :  Rayleigh-Pitot ratio.  The Rayleigh-Pitot ratio is defined 
%              as the static pressure upstream of the shock over the total 
%              pressure downstream of the shock.
%
% Kyle Lynch - k.p.lynch at tudelft.nl

% Parse arguments and calculate the upstream Mach number.
if (numel(GAMMA) > 1 || numel(VAR) > 1)
    error('Array arguments not supported. Use this function in a loop.');
elseif strcmp(MTYPE,'mach')
    MACH = VAR;
else
    error('Unsupported mode.');
end

% Make sure upstream Mach number at least 1.
if (MACH < 1)
    error('Upstream Mach number less than 1.');
end

% Constants.
cp = 1.01 * 1000;
R = 287;

% Organize outputs.
t1 = (1+(2*GAMMA)/(GAMMA+1)*(MACH^2-1));
t2 = (2+(GAMMA-1)*MACH^2) / ((GAMMA+1)*MACH^2);
T = t1*t2;

P = 1 + ((2*GAMMA)/(GAMMA+1))*(MACH^2-1);
RHO = ((GAMMA+1)*MACH^2)/(2+(GAMMA-1)*MACH^2);
M = sqrt( (1+((GAMMA-1)/2)*MACH^2) / (GAMMA*MACH^2-(GAMMA-1)/2) );

ds = cp*log( (1+((2*GAMMA)/(GAMMA+1))*(MACH^2-1)) * (2+(GAMMA-1)*MACH^2)/((GAMMA+1)*MACH^2) ) - ...
    R*log(1+(2*GAMMA/(GAMMA+1))*(MACH^2-1));

P0 = exp(-ds/R);

p1 = ( (GAMMA+1)^2*MACH^2 / (4*GAMMA*MACH^2-2*(GAMMA-1)) )^(GAMMA/(GAMMA-1));
p2 = ( 1 - GAMMA + 2*GAMMA*MACH^2 ) / ( GAMMA + 1 );
P1 = 1/(p1*p2);

end