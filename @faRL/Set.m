function [] = Set( RL, varargin )
% Sets desired object properties

nParams = (nargin-1)/2;
if rem(nParams,1)~=0 || nargin<1
    error('Set failed: not enough inputs')
else
    for p = 1:nParams
        key = varargin{2*p-1};
        value = varargin{2*p};
%         if ~isnumeric(value)
%             error('Set failed: property value must be numeric');
%         end
        
        switch key

            case 'alpha'
                RL.alpha = value;
            case 'alpha_decrease'
                RL.alpha_decrease = value;
            case 'alpha_decrease_val'
                RL.alpha_decrease_val = value; 
            case 'beta'
                RL.beta = value; 
            case 'beta_decrease'
                RL.beta_decrease = value;
            case 'beta_decrease_val'
                RL.beta_decrease_val = value;   
            case 'gamma'
                RL.gamma = value; 
            case 'max_steps'
                RL.max_steps = value; 
            case 'lambda'
                RL.lambda = value; 
            case 'replacing_traces'
                RL.replacing_traces = value;
            case 'MethodFcn'
                RL.MethodFcn = value;
            case 'Env'
                RL.Env = value;
            case 'enable_random_IC'
                RL.enable_random_IC = value;  
            case 'graphics'
                RL.graphics = value;  
            case 'plot_learning_handle'
                RL.plot_learning_handle = value;  
            case 'plot_Q_handle'
                RL.plot_Q_handle = value;    
            case 'plot_model_handle'
                RL.plot_model_handle = value;    
            otherwise
                error(['Set failed: ',key,' property not found']);
        end
    end
end

