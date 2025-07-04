clear;
clc;

% part a

N = 49;
h = 1/(N+1);
j = 0:N+1;
x_j = j*h;

syms x
f(x) = 12*x^2-12*x+2-100*x^2*(1-x)^2;
u(x) = x^2*(1-x)^2;

% part b

F = zeros(N,1);
for i = 1:N
    F(i,1) = f(x_j(i+1));
end

A0 = -2*eye(N);
A1 = diag(ones(N-1,1),1);
A2 = diag(ones(N-1,1),-1);
A = (A0+A1+A2)/h^2-100*eye(N);

U = [];

% part c

L1 = zeros(N,N);
U1 = eye(N);
Z = zeros(N,1);

L1(1,1) = A(1,1);
U1(1,2) = A(1,2)/L1(1,1);
Z(1,1) = F(1,1)/L1(1,1);

for i = 2:N-1
    L1(i,i-1) = A(i,i-1);
    L1(i,i) = A(i,i) - L1(i,i-1)*U1(i-1,i);
    U1(i,i+1) = A(i,i+1)/L1(i,i);
    Z(i,1) = (F(i,1) - L1(i,i-1)*Z(i-1,1))/L1(i,i);
end
L1(N,N-1) = A(N,N-1);
L1(N,N) = A(N,N) - L1(N,N-1)*U1(N-1,N);
Z(N,1) = (F(N,1) - L1(N,N-1)*Z(N-1,1))/L1(N,N);

U(N,1) = Z(N,1);
for i = 1:N-1
    j = N-i;
    U(j,1) = Z(j,1) - U1(j,j+1)*U(j+1);
end

U_GE = [0 U' 0]';

figure(1)
plot(x_j,u(x_j))
hold on
plot(x_j,U_GE)
title('Graph for c: the solutions')
grid on

% part d

D = diag(diag(A));
L2 = -triu(A)+D;
U2 = -tril(A)+D;
T_j = D^(-1)*(L2+U2);
c_j = D^(-1)*F;
x = zeros(N,1);
for i = 1:20
    x = T_j*x+c_j;
end

U_J = [0 x' 0]';

figure(2)
subplot(1,2,1)
plot(x_j,u(x_j))
hold on
plot(x_j,U_J)
title('Graph for d: the solutions')
grid on
subplot(1,2,2)
plot(x_j,abs(u(x_j)'-U_J))
title('Graph for d: the pointwise error')
grid on

% part e

T_g = (D-L2)^(-1)*U2;
c_g = (D-L2)^(-1)*F;

x = zeros(N,1);
for i = 1:20
    x = T_g*x+c_g;
end

U_GS = [0 x' 0]';

figure(3)
subplot(1,2,1)
plot(x_j,u(x_j))
hold on
plot(x_j,U_GS)
title('Graph for e: the solutions')
grid on
subplot(1,2,2)
plot(x_j,abs(u(x_j)'-U_GS))
grid on
title('Graph for e: the pointwise error')

% part f

omega = 2/(1+sin(pi/N));
T_omega = (D-omega*L2)^(-1)*((1-omega)*D+omega*U2);
c_omega = omega*(D-omega*L2)^(-1)*F;

x = zeros(N,1);
for i = 1:20
    x = T_omega*x+c_omega;
end

U_SOR = [0 x' 0]';

figure(4)
title('Graph for f')
subplot(1,2,1)
plot(x_j,u(x_j))
hold on
plot(x_j,U_SOR)
title('Graph for f: the solutions')
grid on
subplot(1,2,2)
plot(x_j,abs(u(x_j)'-U_SOR))
grid on
title('Graph for f: the pointwise error')