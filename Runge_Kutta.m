function Runge_Kutta_4(InitialPop,Rate,AverDeg,Iter)

%Initial population is a vector representing the infected population,
%InitialPop(i) is fraction of population in state Infected-i 
% NOTE: No susceptible in population representation so no sum to 1 required

% Rate is a vector representing the rate of transition between states
% Rate(end) is the infection rate and rate(i) other than end is the rate of
% leaving the state. thus length(rate) = length(InitialPop) + 1;

%AverDeg and Iter is the average Degree of the graph assumed and number of Iteration

i=1;
h = 0.5;                                                                   % Runge-Kutta time step
t(i) = 0;
w(i,:) = InitialPop;                                                       %Initial population allocated
colorcode=['m','r','b','c','k','g','y'];                                   %for ploting the variable number of states
fprintf('Step 0: t = %12.8f, w = %12.8f\n', t(i), w(i));

for i=1:2*Iter                                                             %calculating values for approximation
    k1 = h*Infect(t(i)    , w(i,:)      ,Rate ,AverDeg);
    k2 = h*Infect(t(i)+h/2, w(i,:)+k1/2 ,Rate ,AverDeg);
    k3 = h*Infect(t(i)+h/2, w(i,:)+k2/2 ,Rate ,AverDeg);
    k4 = h*Infect(t(i)+h  , w(i,:)+k3   ,Rate ,AverDeg);
    w(i+1,:) = w(i,:) + (k1 + 2*k2 + 2*k3 + k4) / 6;                       %weighted average for the next value
    t(i+1) = t(i) + h;
end
fprintf('Step %d: t = %6.4f, w = %18.15f\n', i, t(i+1), w(i+1));

plot(t,1-sum(w,2),'g');                                                    %Plot for the susceptible population

for i=1:length(w(1,:))                                                     %Plot fo r various states
    hold on;
    plot(t(:),w(:,i),colorcode(i));
end
%%%%%%%%%%%%%%%%%%
function v = Infect(t,I,r,deg)                                             %Functions to be plotted
    v(1) = r(end)*deg*(1-sum(I))*sum(I)  - r(1)*I(1);                      %Seperate for state 1
    for j=2:length(I)
        v(j) = r(j-1)*I(j-1) - r(j)*I(j);                                  % Calculation of transition between different states
    end
