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
delta  = varargin{3};
% value  = varargin{4};

score = RL.Env.PolicyFcn('GetScore',x,a);


for i = 1:RL.Env.Adim
RL.Env.W(i,:) = RL.Env.W(i,:) + RL.alpha*score(i,:)*delta;
end


function [ ] = UpdateValue( RL , varargin  )

% x = varargin{1};
% a = varargin{2}; 
% r = varargin{3}; 
% xp = varargin{4}; 
% ap = varargin{5}; 

tiles  = varargin{1};
delta  = varargin{2};

 if RL.replacing_traces
     
    RL.Ev(tiles) = 1;  
    RL.V(RL.Etiles) =  RL.V(RL.Etiles) + (RL.beta/RL.VnTilings) * delta * RL.Ev(RL.Etiles); 
    
    RL.Ev(RL.Etiles) = RL.gamma*RL.lambda*RL.Ev(RL.Etiles);  

else
    
    RL.Ev(tiles) = RL.Ev(tiles)+1; 
    RL.V((RL.Etiles)) =  RL.V((RL.Etiles)) + (RL.beta/RL.VnTilings) * delta * RL.Ev(RL.Etiles); 
    
    RL.Ev(RL.Etiles) = RL.gamma*RL.lambda*RL.Ev(RL.Etiles);  
 end