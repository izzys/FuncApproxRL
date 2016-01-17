function varargout = PolicyFcn(RL,varargin)


if nargin && ischar(varargin{1})
    PolicyFcn_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = PolicyFcn_Callback(RL, varargin{:});
else
    PolicyFcn_Callback(RL, varargin{:});
end

function [] = Init(RL,varargin)

if nargin>=2

end
