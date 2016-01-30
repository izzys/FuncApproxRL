function varargout = TD_actor_critic(Obj,varargin)


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

score = RL.Env.PolicyFcn('GetScore',x,a);
value = RL.ValueFcn('GetValue',x,a);

for i = 1:RL.Env.Adim
RL.Env.W(i,:) = RL.Env.W(i,:) + 1e-4*RL.alpha*score(i)*value;
end

function [ ] = UpdateValue( RL , varargin  )

x = varargin{1};
a = varargin{2}; 
r = varargin{3}; 
xp = varargin{4}; 
ap = varargin{5}; 

[Q,tiles] = RL.ValueFcn('GetValue',x,a);
[Qp,~] = RL.ValueFcn('GetValue',xp,ap);

delta =  r + RL.gamma*Qp - Q ;
% x
% a
% r
RL.Env.W

if RL.replacing_traces
    
    
    %RL.E(:,s) = 0; %fix
   % RL.E(a,s) = 1;  %fix
    RL.V(tiles) =  RL.V(tiles) + (RL.beta/RL.VnTilings) * delta ;%* RL.E;  %fix
    
    %RL.E = RL.gamma*RL.lambda*RL.E;  %fix
    
    
else
    
  %  RL.E(a,s) = RL.E(a,s)+1;  %fix
    RL.V(tiles) =  RL.V(tiles) + (RL.beta/RL.VnTilings) * delta ;%* RL.E;  %fix
    
   % RL.E = RL.gamma*RL.lambda*RL.E;  %fix
end