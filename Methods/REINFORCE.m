function varargout = REINFORCE(Obj,varargin)


if nargin && ischar(varargin{1})
    method_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = method_Callback(Obj, varargin{2:end});
else
    method_Callback(Obj, varargin{2:end});
end

function [ ] = UpdatePolicy( RL , varargin  )

x = varargin{1};
a = varargin{2};
% delta  = varargin{3};
value  = varargin{4};

score = RL.Env.PolicyFcn('GetScore',x,a);

for i = 1:RL.Env.Adim
RL.Env.W(i,:) = RL.Env.W(i,:) + RL.alpha*score(i,:)*value;
end

function [ ] = UpdateValue( RL , varargin  )


tiles  = varargin{1};
delta  = varargin{2};

RL.V(tiles) =  RL.V(tiles) + (RL.beta/RL.VnTilings) * delta ;
    
