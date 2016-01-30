function varargout = Natural_actor_critic(Obj,varargin)


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

x = varargin{1};
a = varargin{2}; 
r = varargin{3}; 
xp = varargin{4}; 
ap = varargin{5}; 

[Q,tiles] = RL.ValueFcn('GetValue',x,a);
[Qp,tiles_p] = RL.ValueFcn('GetValue',xp,ap);

delta =  r + RL.gamma*Qp - Q ;

disp('why i am here????')  %fix

if RL.replacing_traces
    
    
    RL.E(:,s) = 0; %fix
    RL.E(a,s) = 1;  %fix
    RL.V =  RL.V + RL.beta * delta * RL.E;  %fix
    
    RL.E = RL.gamma*RL.lambda*RL.E;  %fix
    
    
else
    
    RL.E(a,s) = RL.E(a,s)+1;  %fix
    RL.V =  RL.V + RL.beta * delta * RL.E;  %fix
    
    RL.E = RL.gamma*RL.lambda*RL.E;  %fix
end