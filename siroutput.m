function f = siroutput(x, t, data)

% set up transmission constants
k_infections = x(1);
k_fatality = x(2);
k_recover = x(3);
k_resusceptible = x(4);

% set up initial conditions
ic_susc = x(5);
ic_inf = x(6);
ic_rec = x(7);
ic_fatality = x(8);

% Set up SIRD within-population transmission matrix
A = [1-k_infections,    0,                   k_resusceptible, 0;
     k_infections, 1-(k_recover+k_fatality), 0, 0;
     0,             k_recover,               1-k_resusceptible, 0;
     0,            k_fatality,               0, 1];
B = zeros(4,1);

% Set up the vector of initial conditions
x0 = [ic_susc, ic_inf, ic_rec, ic_fatality];

% simulate the SIRD model for t time-steps
sys_sir_base = ss(A,B,eye(4),zeros(4,1),1);
y = lsim(sys_sir_base,zeros(t,1),linspace(0,t-1,t),x0);

% return a "cost".  This is the quantitity that you want your model to
% minimize.  Basically, this should encapsulate the difference between your
% modeled data and the true data. Norms and distances will be useful here.
% Hint: This is a central part of this case study!  choices here will have
% a big impact!
population = 27.3714*100000;
y_cumulative_infect = zeros(t, 1);
y_cumulative_death = zeros(t, 1);
for index  = 1:t
    temp_infect = y(1:index, 2)*population; %Change to number of number of infect+recovered+dead at index
    temp_death = y(1:index, 4)*population;
     y_cumulative_infect(index) = sum(temp_infect);
    y_cumulative_death(index) = sum(temp_death);
end
f = norm(y_cumulative_infect-data(:,1))+(norm(y_cumulative_death-data(:,2)));