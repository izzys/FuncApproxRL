function varargout = ValueFcn(RL,varargin)


if nargin && ischar(varargin{1})
    ValueFcn_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = ValueFcn_Callback(RL, varargin{2:end});
else
    ValueFcn_Callback(RL, varargin{2:end});
end

function [] = Init(RL,varargin)

if nargin>=2

end

function [Q , tiles] = GetValue(RL,varargin)

x = varargin{1};
a = varargin{2};

% scale our state so that it is within unit intervals:
for i = 1:length(x)
xs(i)   = x(i)/RL.Env.dX(i); 
end

% scale our action so that it is within unit intervals:
as   = 1;%a/RL.Env.dA; 

tiles  = GetTiles_Mex(RL.VnTilings,xs,RL.V_memory_size,as);
Q = sum( RL.V(tiles) ); 



function [] = Plot(RL,varargin)

%text(0,0,num2str(RL.V))


