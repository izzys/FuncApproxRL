function varargout = method_template(Obj,varargin)

if nargin && ischar(varargin{1})
    method_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = method_Callback(Obj, varargin{2:end});
else
    method_Callback(Obj, varargin{2:end});
end


function [ ] = UpdatePolicy( RL , varargin  )


function [ ] = UpdateValue( RL , varargin  )


