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

% 
% mu =  Env.W*x;


 mu = [-1 , 2]*x; 
sigma = 0.05;


% make sure a is within the 95% boundaries:
% ok95 = 0;
% iter = 0;
% while ~ok95
%     
    a = normrnd(mu,sigma);
%     if a<(mu+2*sigma) && a>(mu-2*sigma)
%     ok95=1;
%     end
% iter = iter +1;
% if iter>10
%     iter
%     error('max iterations')
% end
% end


function score = GetScore(Env,varargin)

x = varargin{1};
a = varargin{2};

[~,mu,sigma] = GetAction(Env,x);


score = (a-mu)*[x(1) x(2)];


