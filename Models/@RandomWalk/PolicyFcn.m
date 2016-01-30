function varargout = PolicyFcn(Env,varargin)


if nargin && ischar(varargin{1})
    PolicyFcn_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = PolicyFcn_Callback(Env, varargin{2:end});
else
    PolicyFcn_Callback(Env, varargin{2:end});
end

function [] = Init(Env,varargin)

if nargin>=2

end

function [a,mu,sigma] = GetAction(Env,varargin)

x = varargin{1};

mu1 =  Env.W(1,1)*x(1)+ Env.W(1,2)*x(2) ;
mu2 =  Env.W(2,1)*x(2)+ Env.W(2,2)*x(2) ;

sigma1 = 0.01;
sigma2 = 0.01;

a1 = normrnd(mu1,sigma1);
a2 = normrnd(mu2,sigma2);

a = [a1;a2];
mu = [mu1 mu2];
sigma = [sigma1 sigma2];

function score = GetScore(Env,varargin)

x = varargin{1};
a = varargin{2};

[~,mu,sigma] = GetAction(Env,x);

x1 = x(1);
x2 = x(2);

a1 = a(1);
a2 = a(2);

mu1 =  mu(1) ;
mu2 =  mu(2) ;

sigma1 = sigma(1);
sigma2 = sigma(2);

phi1 = x1;
phi2 = x2;

score1 = (a1-mu1)*phi1/sigma1^2;
score2 = (a2-mu2)*phi2/sigma2^2;

score = [score1 score2];