function varargout = Q_actor_critic(Obj,varargin)

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
xp = varargin{3};
ap = varargin{4};

% get values:
[Q, tiles] = RL.ValueFcn('GetValue',x,a);
          
RL.Env.W =  RL.Env.W + RL.alpha*Q ; 


function [ ] = UpdateValue( RL , varargin  )

x = varargin{1};
a = varargin{2}; 
r = varargin{3}; 
xp = varargin{4}; 
ap = varargin{5}; 

[Q,tiles] = RL.ValueFcn('GetValue',x,a);
[Qp,~] = RL.ValueFcn('GetValue',xp,ap);

delta =  r + RL.gamma*Qp - Q ;

RL.V(tiles) =  RL.V(tiles) + RL.beta * delta; 
