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


mu =  Env.W*x;


sigma = 0.05;


% make sure a is within the 95% boundaries:
ok95 = 0;
iter = 0;
while ~ok95
    
    a = normrnd(mu,sigma);
    if a<(mu+2*sigma) && a>(mu-2*sigma)
    ok95=1;
    end
iter = iter +1;
if iter>10
    iter
    error('max iterations')
end
end


function score = GetScore(Env,varargin)

x = varargin{1};
a = varargin{2};

[~,mu,sigma] = GetAction(Env,x);

x1 = x(1);
x2 = x(2);


phi = [x1 x2]; 

% score1 = (a1-mu1)*phi;
% score2 = (a2-mu2)*phi;
% 
 score = (a-mu)*phi;


