function f = vax_siroutput_prop(x, t, data)

% set up transmission constants
k_infections = x(1);
k_fatality = x(2);
k_recover = x(3);
k_reinfect = x(4);
k_vaccination = x(5);
k_recovervaxxed = x(6);
k_breakthrough = x(7);

% set up initial conditions
ic_susc = x(8);
ic_inf = x(9);
ic_rec = x(10);
ic_fatality = x(11);
ic_vax = x(12);

% Set up SIRD within-population transmission matrix
A = [1-(k_infections+k_vaccination),    0,                   0, 0, 0;
     k_infections, 1-(k_recover+k_fatality), k_reinfect, 0, k_breakthrough;
     0,             k_recover,               1-(k_reinfect+k_recovervaxxed), 0,0;
     0,            k_fatality,               0, 1, 0
     k_vaccination, 0, k_recovervaxxed, 0, 1-k_breakthrough];
B = zeros(5,1);

% Set up the vector of initial conditions
x0 = [ic_susc, ic_inf, ic_rec, ic_fatality, ic_vax];

% simulate the SIRD model for t time-steps
sys_sir_base = ss(A,B,eye(5),zeros(5,1),1);
y = lsim(sys_sir_base,zeros(t,1),linspace(0,t-1,t),x0);

% return a "cost".  This is the quantitity that you want your model to
% minimize.  Basically, this should encapsulate the difference between your
% modeled data and the true data. Norms and distances will be useful here.
% Hint: This is a central part of this case study!  choices here will have
% a big impact!

f = y;