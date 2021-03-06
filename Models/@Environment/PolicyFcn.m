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

function a = GetAction(Env,varargin)

function [] = UpdatePolicy(Env,varargin)

