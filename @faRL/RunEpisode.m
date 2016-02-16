function [total_reward,steps] = RunEpisode(RL,varargin)


        if RL.enable_random_IC
            x  = eval( RL.Env.random_IC );
        else
            x = RL.Env.const_IC;
        end
        
        [row_dim,col_dim] = size(x);
        if col_dim>row_dim
            x = x';
        end
            
        steps        = 0;
        total_reward = 0;

        % selects an action using the current strategy:
        a   = RL.Env.PolicyFcn('GetAction',x);

        RL.StopSim = 0;
 
        while steps<RL.max_steps  && ~RL.StopSim 
           % do the selected action and get the next state:   
            xp  = RL.Env.GetNextState( x , a  );    

            % observe the reward at state xp
            r   = RL.Env.GetReward(x,a);
            stop_episode = RL.Env.IsTerminal(x,a);
            total_reward = total_reward + (RL.gamma)^steps*r;

            % select action prime
            ap   = RL.Env.PolicyFcn('GetAction',xp);

            
            [Q,tiles] = RL.ValueFcn('GetValue',x,a);
            [Qp,~] = RL.ValueFcn('GetValue',xp,ap);
            
            delta =  r + RL.gamma*Qp - Q ;
            
            % Update the policy 
            feval(RL.MethodFcn,RL,'UpdatePolicy',x,a,delta,Q);
            
            % Update the value function
            feval(RL.MethodFcn,RL,'UpdateValue',tiles,delta);

            % Plot of the model
            if RL.graphics        
               RL.Env.Render(x,a,steps,RL.plot_model_handle);    
            end

            %update the current variables
            a = ap;
            x = xp;

            %increment the step counter.
            steps=steps+1;

            % if the goal is reached break the episode
            if stop_episode
                RL.StopSim=1;
            end

        end
        
        W = RL.Env.W  