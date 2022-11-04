%% Generate Model
load COVIDdata.mat;
[A2, x2] = CUT_fun([1, 0, 0, 0], 15, 100);
[A3, x3]  = CUT_fun([A2(end, 3), A2(end, 4), A2(end, 5), A2(end, 6)], 101, 145);
[A4, x4] = CUT_fun([A3(end, 3), A3(end, 4), A3(end, 5), A3(end, 6)], 146, 226);
[A5, x5] = CUT_fun([A4(end, 3), A4(end, 4), A4(end, 5), A4(end, 6)], 227, 257);
[A6, x6] = CUT_fun([A5(end, 3), A5(end, 4), A5(end, 5), A5(end, 6)], 258, 297);
[A7, x7] = CUT_fun([A6(end, 3), A6(end, 4), A6(end, 5), A6(end, 6)], 298, 312);
[A8, x8] = CUT_fun([A7(end, 3), A7(end, 4), A7(end, 5), A7(end, 6)], 313, 421);
[A9, x9] = CUT_fun([A8(end, 3), A8(end, 4), A8(end, 5), A8(end, 6)], 422, 517);%
[A10, x10] = CUT_fun([A9(end, 3), A9(end, 4), A9(end, 5), A9(end, 6)], 518, 555);%
[A11, x11] = CUT_fun([A10(end, 3), A10(end, 4), A10(end, 5), A10(end, 6)], 556, 605);%
[A12, x12] = CUT_fun([A11(end, 3), A11(end, 4), A11(end, 5), A11(end, 6)], 605, 659);
[A13, x13] = CUT_fun([A12(end, 3), A12(end, 4), A12(end, 5), A12(end, 6)], 660, 673);
[A14, x14] = CUT_fun([A13(end, 3), A13(end, 4), A13(end, 5), A13(end, 6)], 674,728);
[A15, x15] = CUT_fun([A14(end, 3), A14(end, 4), A14(end, 5), A14(end, 6)], 729,798);
%Concatonate variables
A = [A2; A3; A4; A5; A6; A7; A8; A9; A10; A11; A12; A13; A14; A15];
X = [x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15];
%% Plot Model
%Plot infections
figure()
hold on;
plot(A(:,1))
plot(COVID_STLmetro.cases)
title("Infections vs. Days")
ylabel("Number of Infections")
xlabel("Days")
legend("Model", "True")

%Plot Deaths
figure()
hold on;
plot(A(:,2))
plot(COVID_STLmetro.deaths)
title("Deaths vs. Days")
ylabel("Number of Deaths")
xlabel("Days")
legend("Model", "True")

%% Shift time steps of model to fit constraints
load COVIDdata.mat;
[A2, x2] = CUT_fun([1, 0, 0, 0], 15, 100);
[A3, x3]  = CUT_fun([A2(end, 3), A2(end, 4), A2(end, 5), A2(end, 6)], 101, 145);
[A4, x4] = CUT_fun([A3(end, 3), A3(end, 4), A3(end, 5), A3(end, 6)], 146, 226);
[A5, x5] = CUT_fun([A4(end, 3), A4(end, 4), A4(end, 5), A4(end, 6)], 227, 257);
[A6, x6] = CUT_fun([A5(end, 3), A5(end, 4), A5(end, 5), A5(end, 6)], 258, 297);
[A7, x7] = CUT_fun([A6(end, 3), A6(end, 4), A6(end, 5), A6(end, 6)], 298, 312);
[A8, x8] = CUT_fun([A7(end, 3), A7(end, 4), A7(end, 5), A7(end, 6)], 313, 421);
[A9, x9] = CUT_fun([A8(end, 3), A8(end, 4), A8(end, 5), A8(end, 6)], 422, 605);%
A = [A2; A3; A4; A5; A6; A7; A8; A9];
X = [x2, x3, x4, x5, x6, x7, x8, x9];


%% Plot policy output
y_policy = policy_siroutput_full(x9,605-422);
y_no_policy = siroutput_full(x9,605-422);

%Infections Plot
figure()
hold on;
plot(y_policy(:, 1));
plot(y_no_policy(:, 1));
hold off;
title("Infections Policy Comparison")
ylabel("Number of Infections")
xlabel("Days")
legend("Policy","No Policy")

%Deaths Plot
figure()
hold on;
plot(y_policy(:, 2));
plot(y_no_policy(:, 2));
hold off;
title("Deaths Policy Comparison")
ylabel("Number of Deaths")
xlabel("Days")
legend("Policy","No Policy")