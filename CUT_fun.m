function [f, x]  = CUT_fun(ic, start_time, end_time)

t = 798;

load COVIDdata.mat COVID_STLmetro STLmetroPop;

data = [COVID_STLmetro.cases, COVID_STLmetro.deaths];

data_1st = data(start_time:end_time,:);

% The following line creates an 'anonymous' function that will return the cost (i.e., the model fitting error) given a set
% of parameters.  There are some technical reasons for setting this up in this way.
% Feel free to peruse the MATLAB help at
% https://www.mathworks.com/help/optim/ug/fmincon.html
% and see the sectiono on 'passing extra arguments'
% Basically, 'sirafun' is being set as the function siroutput (which you
% will be designing) but with t and coviddata specified.
sirafun= @(x)siroutput(x, end_time-start_time+1, data_1st);

%% set up upper and lower bound constraints
% Set upper and lower bounds on the parameters
% lb < x < ub
% here, the inequality is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.
 ub = [1; 1; .2; .01; 1; 1; 1; 1];
lb = [0; 0; 0; 0; 0; 0; 0; 0];

% Specify some initial parameters for the optimizer to start from
x0 = [.05;%\
     .14;%  |-> Update matrix inputs
     .025;% |
     0.002;%/
     ic(1);%\
     ic(2);%   \-> Initial input values
     ic(3); % /
     ic(4)];%/

%% set up rate and initial condition constraints
% Set A and b to impose a parameter inequality constraint of the form A*x < b
% Note that this is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.
A = [];
b = [];

%% set up some fixed constraints
% Set Af and bf to impose a parameter constraint of the form Af*x = bf
% Hint: For example, the sum of the initial conditions should be
% constrained
% If you don't want such a constraint, keep these matrices empty.
Aeq = eye(8, 8);
Aeq(1:4, :) = 0;
beq = [0,0,0,0,ic(1),ic(2),ic(3),ic(4)];



% This is the key line that tries to opimize your model parameters in order to
% fit the data
% note tath you

x = fmincon(sirafun,x0,A,b,Aeq,beq,lb,ub);

Y_fit = siroutput_full(x,end_time-start_time+1);
Y_prop = siroutput_prop(x,end_time-start_time+1);

f = [Y_fit, Y_prop];