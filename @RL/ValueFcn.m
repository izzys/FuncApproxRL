function varargout = ValueFcn(RL,varargin)


if nargin && ischar(varargin{1})
    ValueFcn_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = ValueFcn_Callback(RL, varargin{:});
else
    ValueFcn_Callback(RL, varargin{:});
end

function [] = Init(RL,varargin)

if nargin>=2

end


