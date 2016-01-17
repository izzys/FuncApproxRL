classdef  CartPole < handle

    properties 

        S; % States 
        A = -1:0.1:1; % Available actions
      
        Adim;
        Sdim;
        
        const_IC = [0 0 0.1 0] ;
        random_IC = '0.1*[rand()-0.5 rand()-0.5 rand()-0.5 rand()-0.5 ]';
        
        % discritization params:
        x1_min = -1;
        x1_max =  1;
        x1_dim = 3;
        
        x2_min = -1;
        x2_max = 1;
        x2_dim = 3;
        
        x3_min = deg2rad(-12);
        x3_max = deg2rad(12);
        x3_dim = 13;
        
        x4_min = -1;
        x4_max = 1;
        x4_dim = 3;
        
        % render
        RenderObj;
        
        
    end
    
    methods
        
        % class cunstructor:
        function [Env] = CartPole()
            
        end
        
        
        %%%    ~  Abstract fucntions ~  %%%
        
        function [] = Init(Env)
                       
            Env.BuildStateList();           
            Env.Sdim = size(Env.S,1);
            Env.Adim = length(Env.A);
            
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
            
        end

        function [r] = GetReward(Env,s,a)
            
            
            s_next = Env.GetNextState(s,a);
            
            x         = s_next(1);
            x_dot     = s_next(2);
            theta     = s_next(3);
            theta_dot = s_next(4);

            r = 10 - 10*abs(10*theta)^2 - 5*abs(x) - 10*theta_dot;

            fourtyfive_degrees = deg2rad(45); 
           
            if (x < -4 || x > 4  || theta < -fourtyfive_degrees || theta > fourtyfive_degrees)          
                r = -10000 - 50*abs(x) - 100*abs(theta);     
            end
     
        end

        function [s] = GetNextState(Env,s,a)
            
            % Parameters for simulation
            x          = s(1);
            x_dot      = s(2);
            theta      = s(3);
            theta_dot  = s(4);

            g               = 9.8;      %Gravity
            Mass_Cart       = 1.0;      %Mass of the cart is assumed to be 1Kg
            Mass_Pole       = 0.1;      %Mass of the pole is assumed to be 0.1Kg
            Total_Mass      = Mass_Cart + Mass_Pole;
            Length          = 0.5;      %Half of the length of the pole 
            PoleMass_Length = Mass_Pole * Length;
            Force_Mag       = 10.0;
            Tau             = 0.02;     %Time interval for updating the values
            Fourthirds      = 4.0/3.0;

            force = Force_Mag*Env.A(a);

            temp     = (force + PoleMass_Length * theta_dot * theta_dot * sin(theta)) / Total_Mass;
            thetaacc = (g * sin(theta) - cos(theta) * temp) / (Length * (Fourthirds - Mass_Pole * cos(theta) * cos(theta) / Total_Mass));
            xacc     = temp - PoleMass_Length * thetaacc * cos(theta) / Total_Mass;

            % Update the four state variables, using Euler's method.
            x         = x + Tau * x_dot;
            x_dot     = x_dot + Tau * xacc;
            theta     = theta + Tau * theta_dot;
            theta_dot = theta_dot+Tau*thetaacc;

            s = [x x_dot theta theta_dot];      
            
        end
        
        function e = IsTerminal(Env,s,a)
            
            s_next = Env.GetNextState(s,a);
            
            x         = s_next(1);
            x_dot     = s_next(2);
            theta     = s_next(3);
            theta_dot = s_next(4);
            
            e = false;
            fourtyfive_degrees = deg2rad(45);
            
            if (x < -4 || x > 4  || theta < -fourtyfive_degrees || theta > fourtyfive_degrees)          
    
                e = true;
            
            end
        end
            
        
        %%%    ~  Added fucntions ~  %%%
        
        
        function [ s ] = DiscretizeState( Env , x  )
          
            %DiscretizeState check which entry in the state list is more close to x and
            %return the index of that entry.

            statelist = Env.S;

            x(1) = sign(x(1));
            x(2) = sign(x(2));
            x(4) = sign(x(4));

            x = repmat(x,Env.Sdim,1);

            [~ , s] = min(Env.edist(statelist,x));

        end
        
        function [ d ] = edist( Env, x , y )
            %edist euclidean distance between two vectors
            d = sqrt( sum( (x-y).^2,2 ) );
        end
                
        
        function [ind] = subsindex(Env)
            ind = 0;
        end


        function [] = BuildStateList(Env)

            % state discretization for the mountain car problem

            x1 = linspace(Env.x1_min,Env.x1_max,Env.x1_dim);
            x2 = linspace(Env.x2_min,Env.x2_max,Env.x2_dim);
            x3 = linspace(Env.x3_min,Env.x3_max,Env.x3_dim);
            x4 = linspace(Env.x4_min,Env.x4_max,Env.x4_dim);
           
            index=1;
            for i=1:Env.x1_dim    
                for j=1:Env.x2_dim  
                    for k=1:Env.x3_dim 
                        for l=1:Env.x4_dim
                            Env.S(index,1)=x1(i);
                            Env.S(index,2)=x2(j);
                            Env.S(index,3)=x3(k);
                            Env.S(index,4)=x4(l);
                            index=index+1;
                        end
                    end
                end
            end
            
        end
              


    end
        
end