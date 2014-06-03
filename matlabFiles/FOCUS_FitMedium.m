function output = FOCUS_FitMedium(Q,range)
%This funcion uses a gaussian fitting algorithm to guess where the focus is.

%This is the x coordinate of the max contrast
max_x = find(Q.y==max(Q.y));

if (((max_x+range) <= length(Q.x)) && (max_x>range))
    vec_y = Q.y((max_x-range):(max_x+range));
    vec_x = Q.x((max_x-range):(max_x+range));
    
elseif((max_x+range) <= length(Q.x))
    vec_y = Q.y(1:(max_x+range));
    vec_x = Q.x(1:(max_x+range));
elseif(max_x>range)
    vec_y = Q.y((max_x-range):end);
    vec_x = Q.x((max_x-range):end);
else
    vec_y = Q.y(1:end);
    vec_x = Q.x(1:end);
end

%We want on the order of 1e2 repeats for each value
while(mean(vec_y)>1000)
    vec_y = vec_y/10;
end
vec_y = round(vec_y);

temp = [1 cumsum(vec_y)];
in = ones(temp(end),1);

for i = 1:length(vec_y)
    in(temp(i):temp(i+1)) = vec_x(i);
end

[u,sig,t,iter] = fit_mix_gaussian(in,1);
focus = u;
output = focus;

function [u,sig,t,iter] = fit_mix_gaussian(X,M)

if ~nargin
    M   = round(rand*5)+1;
    sig = rand(1,M)*3;
    u   = randn(1,M)*8;
    prob= rand(1,M);
    [u,sig,t,iter] = fit_mix_gaussian( build_mix_gaussian( u,sig,prob,2000*M ),M );
    return
end
% initialize and initial guesss
N           = length( X );
Z           = ones(N,M) * 1/M;                  % indicators vector
P           = zeros(N,M);                       % probabilities vector for each sample and each model
t           = ones(1,M) * 1/M;                  % distribution of the gaussian models in the samples
u           = linspace(min(X),max(X),M);        % mean vector
sig2        = ones(1,M) * var(X) / sqrt(M);     % variance vector
C           = 1/sqrt(2*pi);                     % just a constant
Ic          = ones(N,1);                        % - enable a row replication by the * operator
Ir          = ones(1,M);                        % - enable a column replication by the * operator
Q           = zeros(N,M);                       % user variable to determine when we have converged to a steady solution
thresh      = 1e-3;
step        = N;
last_step   = inf;
iter        = 0;
min_iter    = 10;

while ((( abs((step/last_step)-1) > thresh) & (step>(N*eps)) ) | (iter<min_iter) )
    
    % E step
    % ========
    Q   = Z;
    P   = C ./ (Ic*sqrt(sig2)) .* exp( -((X*Ir - Ic*u).^2)./(2*Ic*sig2) );
    for m = 1:M
        Z(:,m)  = (P(:,m)*t(m))./(P*t(:));
    end
    
    % estimate convergence step size and update iteration number
    prog_text   = sprintf(repmat( '\b',1,(iter>0)*12+ceil(log10(iter+1)) ));
    iter        = iter + 1;
    last_step   = step * (1 + eps) + eps;
    step        = sum(sum(abs(Q-Z)));
    
    % M step
    % ========
    Zm              = sum(Z);               % sum each column
    Zm(find(Zm==0)) = eps;                  % avoid devision by zero
    u               = (X')*Z ./ Zm;
    sig2            = sum(((X*Ir - Ic*u).^2).*Z) ./ Zm;
    t               = Zm/N;
end
sig     = sqrt( sig2 );