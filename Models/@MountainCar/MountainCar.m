classdef  MountainCar < handle

    properties 
        
        const_IC = [0.1 0] ;
        random_IC = '0.1*[rand()-0.5 rand()-0.5  ]';
        
        %  state params:
        x1_min = -1.2;
        x1_max = 0.5;
        x1_dim = 8;
        
        x2_min = -0.07;
        x2_max =  0.07;
        x2_dim = 8;

        % control params:
        a_min = -1;
        a_max = 1;
          
        % render
        RenderObj;
           
        % env dim:
        Xdim;
        Adim = 1;

        %Policy function:
        Wdim = 2;
        W;

        % discritixation matrix:
        dX;
        dA;
        
    end
    
    methods
        
        % class cunstructor:
        function [Env] = MountainCar()
            
        end
        
        
        %%%    ~  Abstract fucntions ~  %%%
        
        function [] = Init(Env)
                               
            
            if ~isempty(Env.RenderObj)
                
                names = fieldnames(Env.RenderObj);
                for i=1:length(names)
                    hi = eval(['Env.RenderObj.' names{i}]);
                    if isnumeric( hi )  
                        delete(hi);
                   else %object is a structue of handles
                        names2 = fieldnames(hi); 
                        h2 = eval(['Env.RenderObj.' names{i} '.' names2{1}]);
                        delete(h2);
                    end
                end
                Env.RenderObj = [];
            else
                Env.RenderObj = [];
            end
            
            Env.Xdim = [Env.x1_dim Env.x2_dim ];
            
            
            Env.dX(1) = diff([ Env.x1_min  Env.x1_max ])/ Env.x1_dim ;
            Env.dX(2) = diff([ Env.x2_min  Env.x2_max ])/ Env.x2_dim ;
   
         %   Env.dA  = diff([ Env.a_min  Env.a_max ])/ Env.a_dim; 
            
        end

        function [r] = GetReward(Env,s,a)
            
            r=-1;
            if s(1)>=Env.x1_max
                r=10;
            end
     
        end

        function [s] = GetNextState(Env,s,a)
            
            p = s(1);
            v = s(2);
          
            vNext = v + 0.001 * a - 0.0025 * cos(3 * p);
            vNext = min(max(vNext, Env.x2_min), Env.x2_max);
            
            pNext = p + vNext;
            pNext = min(max(pNext, Env.x1_min), Env.x1_max);
            
            % Inelastic wall on the left side
            if pNext <= Env.x1_min
                vNext = 0;
            end
            
            s = [pNext;vNext];
               
        end
        
        function e = IsTerminal(Env,s,a)
            
            e=0;
            if s(1)>=Env.x1_max
                e=1;
            end
            
        end
            
        
        %%%    ~  Added fucntions ~  %%%
        function [ind] = subsindex(Env)
            ind = 0;
        end


              


    end
        
end