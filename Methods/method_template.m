function varargout = method_template(RL,varargin)

if nargin && ischar(varargin{1})
    method_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = method_Callback(RL, varargin{:});
else
    method_Callback(RL, varargin{:});
end

function [total_reward,steps] = RunEpisode(RL,varargin)

total_reward = 1;
steps = 1;
        
function [a] = GetBestAction(RL,varargin)   

s = varargin{2};
draw = rand();

if (draw>RL.eps) 
    [~ , a] = max(RL.Q(:,s));   
else
    a = randi(RL.Adim);
end

function [ ] = UpdatePolicy( RL , varargin  )



