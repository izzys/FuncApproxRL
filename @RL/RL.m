classdef RL < handle
 
    properties 
        
        % Contains a handle to the selected learning method. The handle has 
        % the form @Selected_Method. Make sure that Selected_Method is in the
        % Matlab path and that it follows the method_template that is given 
        % in the Methods folder.
        MethodFcn;  
        
        % Contains a handle to the environment object. The handle is passed 
        % by constructing the selected model Env = SelectedModel(). Make sure 
        % that SelectedModel is in the Matlab path and that is follows the 
        % Environment empty template given in the Models folder.
        Env;
        
        % Contains a cell with a list of available methods. Each method
        % name must match the name of its corresponding scriptin the Methods 
        % folder. Make sure that the list order matches the order of the
        % method list in RLgui:
        MethodList = {'SARSA_lambda',...
                      'Q_lambda',...
                      []};
            
        % Contains a cell with a list of available models. Each model name 
        % must match the name of its corresponding class in the Models folder,
        % with a parenthesis added.  Make sure that the list order matches the 
        % order of the model list in RLgui.:
        ModelList = {'CartPole()',... 
                     'AcroBot()',...
                     []};
        
        % learning parameters:       
        gamma;
        alpha;
        alpha_decrease;
        alpha_decrease_val
        eps;
        eps_decrease;
        eps_decrease_val;
        max_steps ;
             
        % Running params:
        MaxEpisodes = 1e6;
        StopLearn;
        StopSim;
        stopping_criteria = 1e-8;
        delta;
        
        % Eligibility traces params:
        lambda
        E;
        replacing_traces;

        
        % inital conditions for each episode:
        enable_random_IC;
        
        % graphics:
        graphics;
        plot_learning_handle;
        plot_Q_handle;
        plot_model_handle;
        figure_handle;
        LearnPlotColor;
        
        PlotObj;
        
        Xpoints;
        Ypoints;
        
        InitDone = 0;
    end
    
    methods
        
        % class constructor:
        function [RL] = RL(varargin)
            
             switch nargin
            
                 case 0
                     %do nothing
                     
                 case 2
                     RL.MethodFcn = str2func( varargin{1} );
                     RL.Env = varargin{2};
             end
        end
        
        % Initialize agent before new learning session:
        function [] = Init(RL,varargin)
            
            RL.Env.Init();
            
            RL.StopLearn = 0;
            
            RL.Xpoints     = [];
            RL.Ypoints     = [];
            
            RL.InitDone = 1;
            RL.delta = 0;
            
            % Init plots:
            set(RL.plot_Q_handle,'XTick',[],...
                                 'YTick',[],... 
                                 'XTickLabel',[],... 
                                 'YTickLabel',[]);
                             
            colormap(RL.plot_Q_handle, 'Jet')
           
            RL.LearnPlotColor = [rand() rand() rand()];
          
            RL.PlotObj.curve = plot(RL.plot_learning_handle,0,0,'Color',RL.LearnPlotColor)  ; 
            
            RL.PlotObj.title = title(RL.plot_learning_handle,'Episode:       epsilon:        alpha:')  ;

            xlabel(RL.plot_learning_handle,'Episodes')
            ylabel(RL.plot_learning_handle,'Reward') 
            
        end
          
        % Start and run the learning process:
        function [] = StartLearning(RL,varargin)
           
            if (nargin== 1) %RL is used without GUI
                  if isempty(RL.plot_learning_handle)
                      RL.plot_learning_handle = figure; 
                  end
                  
                  if isempty(RL.plot_Q_handle)
                      RL.plot_Q_handle = figure;
                  end
                  
                  if isempty(RL.plot_model_handle)
                      RL.plot_model_handle = figure;
                  end
            end

            if isvalid(RL.Env)  % Run RL only if a environment is loaded
                  RL.Init();
            else
                  error('Environment is not loaded')
            end
           
            episode=1;
            RL.delta = Inf;
            
            while episode<=RL.MaxEpisodes && ~RL.StopLearn  && (RL.delta>RL.stopping_criteria) 
 
                [total_reward,steps] = RL.LearningEpisode(); 

                disp(['Espisode: ',int2str(episode),'  Steps:',int2str(steps),'  Reward:',num2str(total_reward)])

                if RL.eps_decrease
                    RL.eps = RL.eps_decrease_val*RL.eps;
                    RL.Facade('PassEpsUpdated');
                end
                    
                if RL.alpha_decrease
                    RL.alpha = RL.alpha_decrease_val*RL.alpha;
                    RL.Facade('PassAlphaUpdated');
                end
                 
                RL.PlotLearningCurve(episode,total_reward,steps)
                
                episode = episode+1;

            end
        end
        
        % Stop the learning process:
        function [] = StopLearning(RL)
            
            RL.StopLearn=1;
            RL.StopEpisode()
            
        end
        
        % Get action for next step - based on current policy:
        function [a] = GetAction(RL,s)
          
            if ~isempty(RL.Env.Adim)
                if isempty(RL.MethodFcn)
                    a = randi(RL.Env.Adim);
                else
                    a = feval(RL.MethodFcn,RL,'GetBestAction',s) ;
                end           
            else
                error('Model must be selected first')
            end 
            
        end
               
        % An episode runs for #steps or until the goal is reached:
        function [total_reward,steps] = LearningEpisode(RL)
  
            if ~RL.InitDone
                RL.Init();
            end
            
            RL.Env.Init();
            
            [total_reward,steps] = feval(RL.MethodFcn,RL,'RunEpisode') ;
                 
        end
        
        % An episode for demonstration of learned policy:
        function [total_reward,steps] = Episode(RL)
  
            if ~RL.InitDone
                RL.Init();
            end
            
            RL.Env.Init();
            
            if RL.enable_random_IC
                x  = str2num( RL.Env.random_IC );
            else
                x = RL.Env.const_IC;
            end

            steps        = 0;
            total_reward = 0;

            % convert the continous state variables to an index of the statelist:
            s   = RL.Env.DiscretizeState(x);
            % selects an action using the current strategy:
            a   = RL.GetAction(s);

            RL.StopSim = 0;

            while steps<RL.max_steps  && ~RL.StopSim    

                % do the selected action and get the next state:   
                xp  = RL.Env.GetNextState( x , a  );    

                % observe the reward at state xp
                [r]   = RL.Env.GetReward(x,a);
                stop_episode = RL.Env.IsTerminal(x,a);
                total_reward = total_reward + (RL.gamma)^steps*r;

                % convert the continous state variables in [xp] to an index of the statelist    
                sp  = RL.Env.DiscretizeState(xp);

                % select action prime
                ap = RL.GetAction(sp);

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
                 
        end
        
        % Stop the episode;
        function [] = StopEpisode(RL)
            
            RL.StopSim=1;
            
        end
        
        % Plot a learning curve and a heat map of Q:
        function [] = PlotLearningCurve(RL,episode,total_reward,steps)
            
          RL.Xpoints(episode)=episode;
          RL.Ypoints(episode)=total_reward;    

          set(RL.PlotObj.curve,'Xdata',RL.Xpoints,'Ydata',RL.Ypoints)  
          set(RL.PlotObj.title,'String',['Episode: ',int2str(episode), '  steps: ',num2str(steps) , '  epsilon: ',num2str(RL.eps) , '  alpha: ' num2str(RL.alpha)]) 
          drawnow
          
          
          axes(RL.plot_Q_handle)  
          imagesc(RL.Q)    
          
          set(RL.plot_Q_handle,'XTick',[],...
                               'YTick',[],... 
                               'XTickLabel',[],... 
                               'YTickLabel',[]);
          drawnow
          
        end
        
        % Clear the heat map of Q:
        function [] = ClearLearningCurve(RL)
            
            cla(RL.plot_Q_handle)
            cla(RL.plot_learning_handle )
            RL.Init();
            
          
        end
   end
    
    
end