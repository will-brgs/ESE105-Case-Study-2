function [f, x]  = vax_sir_fit(x_init, start_time, end_time)

load mockdata.mat newInfections cumulativeDeaths;
data = [newInfections.', cumulativeDeaths.'];
disp("data: "+data)
t = end_time-start_time+1;
population = 27.3714*100000;
data_cumulative_infect = zeros(t, 1);
data_cumulative_death = zeros(t, 1);
for index  = 1:t
    temp_infect = data(index, 1)*population;
    temp_death = data(index, 2)*population;
     data_cumulative_infect(index) = sum(temp_infect);
    data_cumulative_death(index) = sum(temp_death);
end

data = [data_cumulative_infect, data_cumulative_death];

data_1st = data(1:end_time-start_time+1,:);

% The following line creates an 'anonymous' function that will return the cost (i.e., the model fitting error) given a set
% of parameters.  There are some technical reasons for setting this up in this way.
% Feel free to peruse the MATLAB help at
% https://www.mathworks.com/help/optim/ug/fmincon.html
% and see the sectiono on 'passing extra arguments'
% Basically, 'sirafun' is being set as the function siroutput (which you
% will be designing) but with t and coviddata specified.
sirafun= @(x)vax_siroutput(x, end_time-start_time+1, data_1st);

%% set up upper and lower bound constraints
% Set upper and lower bounds on the parameters
% lb < x < ub
% here, the inequality is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.
 ub = [1; 1; 1; 1; 1; .5; 1; 1; 1; 1; 1; 1];
lb = [0.01; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];

% Specify some initial parameters for the optimizer to start from
x0 = x_init;

%% set up rate and initial condition constraints
% Set A and b to impose a parameter inequality constraint of the form A*x < b
% Note that this is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.
A = eye(12, 12);
A(1, 5) = 1;
A(2, 3) = 1;
A(4, 6) = 1;

b = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1];

%% set up some fixed constraints
% Set Af and bf to impose a parameter constraint of the form Af*x = bf
% Hint: For example, the sum of the initial conditions should be
% constrained
% If you don't want such a constraint, keep these matrices empty.
Aeq = eye(12, 12);
Aeq(1:7, :) = 0;
beq = [0,0,0,0,0,0,0,x_init(8),x_init(9),x_init(10),x_init(11),x_init(12)];



% This is the key line that tries to opimize your model parameters in order to
% fit the data
% note tath you

x = fmincon(sirafun,x0,A,b,Aeq,beq,lb,ub);

%plot(Y);
%legend('S','I','R','D');
%xlabel('Time')

Y_fit = vax_siroutput_full(x,end_time-start_time+1);
Y_prop = vax_siroutput_prop(x,end_time-start_time+1);

f = [Y_fit, Y_prop];