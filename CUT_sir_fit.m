t = 798;

load COVIDdata.mat COVID_STLmetro STLmetroPop;

data = [COVID_STLmetro.cases, COVID_STLmetro.deaths];

data_1st = data(15:100,:);

% The following line creates an 'anonymous' function that will return the cost (i.e., the model fitting error) given a set
% of parameters.  There are some technical reasons for setting this up in this way.
% Feel free to peruse the MATLAB help at
% https://www.mathworks.com/help/optim/ug/fmincon.html
% and see the sectiono on 'passing extra arguments'
% Basically, 'sirafun' is being set as the function siroutput (which you
% will be designing) but with t and coviddata specified.
sirafun= @(x)siroutput(x, 86, data_1st);

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
     1.0;%\
     0;%   \-> Initial input values
     0; % /
     0];%/

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
beq = [0,0,0,0,x0(5),x0(6),x0(7),x0(8)];



% This is the key line that tries to opimize your model parameters in order to
% fit the data
% note tath you

x = fmincon(sirafun,x0,A,b,Aeq,beq,lb,ub);

%plot(Y);
%legend('S','I','R','D');
%xlabel('Time')

Y_fit = siroutput_full(x,86);


% Make some plots that illustrate your findings.
figure();
plot(Y_fit)