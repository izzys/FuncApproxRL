classdef  RandomWalk < handle


    properties 
                        
        %  state params:
        x1_min = -1;
        x1_max =  1;
        x1_dim =  8;
        
        x2_min = -1;
        x2_max =  1;
        x2_dim =  8;
        
        % control params:
        a1_min = -1;
        a1_max = 1;
        a1_dim = 2;
        
        a2_min = -1;
        a2_max = 1;
        a2_dim = 2; 
        
        const_IC = [1 1];
        random_IC = '[unifrnd(RL.Env.x1_min,RL.Env.x1_max) , unifrnd(RL.Env.x2_min,RL.Env.x2_max)]';
        
        Xdim;
        Adim = 2;
        
        % render
        RenderObj;
        
        %Policy function:
        Wdim = 1;
        W; 

        % discritixation matrix:
        dX;
        dA;
        
    end
    
    methods
        
        function Env = RandomWalk()
            
            
            
        end
        
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
            
            Env.Xdim = [Env.x1_dim  Env.x2_dim];
            
            Env.dX(1) = diff([ Env.x1_min  Env.x1_max ])/ Env.x1_dim ;
            Env.dX(2) = diff([ Env.x2_min  Env.x2_max ])/ Env.x2_dim ;

                   
            Env.dA(1)  = diff([ Env.a1_min  Env.a1_max ])/ Env.a1_dim; 
            Env.dA(2)  = diff([ Env.a2_min  Env.a2_max ])/ Env.a2_dim; 
            
        end

        function [ r ] = GetReward(Env,x,a)
            
           r = -sse(x);
           
           if sse(x)<0.1
                r=5-sse(x);
            end
            if sse(x)<1e-5
                r=100;
            end
        end

        function [ xp ] = GetNextState(Env,x,a)
            
            x1 = x(1);
            x2 = x(2);
            
            a1 = a(1);
            a2 = a(2);
            
            drift1 = unifrnd(-2/10,0);
            drift2 = unifrnd(-0.3/10,0.6/10);
            
            x1p = x1+a1;%+drift1;
            x2p = x2+a2;%+drift2;
            
            x1p =max(  min( x1p , Env.x1_max )   , Env.x1_min );
            x2p =max(  min( x2p , Env.x2_max )   , Env.x2_min );
            
            xp = [x1p;x2p];
            
        end
        
        
        function [e] = IsTerminal(Env,x,a)
            
            e = 0;
            if sse(x)<1e-5
                e=1;
            end
            
        end
        
    end
    

end