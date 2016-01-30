classdef  AcroBot < handle

    properties 
        
        const_IC = [ -0.2 0.1 0  0] ;
        random_IC = '0.1*[rand()-0.5 rand()-0.5  rand()-0.5 rand()-0.5]';
        
        % System parameters:
        m1 = 1;        % mass of link 1
        m2 = 1;        % mass of link 2
        l1 = 1;        % length of link 1
        l2 = 1;        % length of link 2
        lc1 = 0.5;     % center of mass of link 1
        lc2 = 0.5;     % center of mass of link 2
        I1 = 1/12;     % moment of inertia of link 1
        I2 = 1/12;     % moment of inertia of link 2
        g = 9.81;      % gravity
        
        % Control:
        GoalHeight = 1;
        StepSize = 0.025;
        
        %  state params:
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

        % control params:
        a_min = -1;
        a_max = 1;
        a_dim = 21;
          
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
        function [Env] = AcroBot()
            
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
            
            
            Env.Xdim = [Env.x1_dim Env.x2_dim Env.x3_dim Env.x4_dim];
            
            
            Env.dX(1) = diff([ Env.x1_min  Env.x1_max ])/ Env.x1_dim ;
            Env.dX(2) = diff([ Env.x2_min  Env.x2_max ])/ Env.x2_dim ;
            Env.dX(3) = diff([ Env.x3_min  Env.x3_max ])/ Env.x3_dim ;
            Env.dX(4) = diff([ Env.x4_min  Env.x4_max ])/ Env.x4_dim ;
                   
            Env.dA  = diff([ Env.a_min  Env.a_max ])/ Env.a_dim; 
        end
        
        %  Get position:
        function [ x, y ] = GetPos(Env, q, which)
                       
            theta1 = q(1);
            theta2 = q(3);
            
            if strcmp(which,'end1')
                x = Env.l1*sin(theta1);
                y = -Env.l1*cos(theta1);
                return;
            end           
            
            if strcmp(which,'center1')
                x = Env.lc1*sin(theta1);
                y = -Env.lc1*cos(theta1);
                return;
            end
            
            if strcmp(which,'end2')
                
                [x1,y1] = Env.GetPos(q, 'end1');
                
                x = x1+Env.l2*sin(theta1+theta2);
                y = y1-Env.l2*cos(theta1+theta2);
                return;
            end
            
            if strcmp(which,'center2')
                
                [x1,y1] = Env.GetPos(q, 'end1');
                
                x = x1+Env.lc2*sin(theta1+theta2);
                y = y1-Env.lc2*cos(theta1+theta2);
                return;
            end
            
            if strcmp(which,'COM')
               
                [xc1,yc1] = Env.GetPos(q, 'center1');
                [xc2,yc2] = Env.GetPos(q, 'center2');
                
                x = (Env.m1*xc1+Env.m2*xc2)/(Env.m1+Env.m2);
                y = (Env.m1*yc1+Env.m2*yc2)/(Env.m1+Env.m2);
                
            end
        end
        
        % Get energy:
        function [ E ] = GetNrg(Env, q, which)
            
            q1 =  q(1);
            q2  = q(3);
            dq1 = q(2);
            dq2 = q(4);
                
            m1 = Env.m1;
            m2 = Env.m2;
            l1 = Env.l1;
            l2 = Env.l2;
            lc1 = Env.lc1;
            lc2 = Env.lc2;
            I1 = Env.I1;
            I2 = Env.I2;
            g = Env.g;
                
            if strcmp(which,'kinetic')
                
                d11 = m2*lc1^2+m2*(l1^2+lc2^2+2*l1*lc2*cos(q2)+I1+I2);
                d22 = m2*lc2^2+I2;
                d12 = m2*(lc2^2+l1*lc2*cos(q2))+I2;
                
                E = 0.5*d11*dq1^2+d12*dq1*dq2+0.5*d22*dq2^2;
            end
            
            if strcmp(which,'potential')              

                [~,yc1] = Env.GetPos(q,'center1');
                [~,yc2] = Env.GetPos(q,'center2');
                
              
                E = m1*g*yc1+m2*g*yc2;
            end
            
            
            if strcmp(which,'total')
                
                Ek = Env.GetNrg(q, 'kinetic');
                Ep = Env.GetNrg(q, 'potential');
                
                E = Ek+Ep;
                
            end
                        
        end

        function [r] = GetReward(Env,q,a)
            
            
            [~,y] = Env.GetPos(q,'end2');
            
            r=-1;
            if (y-Env.GoalHeight)>=0
                r =10;
            end
     
        end
        
        % Derivative:
        function [qdot] = Derivative(Env, q ,a)

            m1 = Env.m1;
            m2 = Env.m2;
            l1 = Env.l1;
            l2 = Env.l2;
            lc1 = Env.lc1;
            lc2 = Env.lc2;
            I1 = Env.I1;
            I2 = Env.I2;
            g = Env.g;
            
            theta1 = q(1); 
            dtheta1 = q(2);
            theta2 = q(3);
            dtheta2 = q(4);
            
            d1 = m1*lc1^2+m2*(l1^2+lc2^2+2*l1*lc2*cos(theta2))+I1+I2;
            d2 = m2*(lc2^2+l1*lc2*cos(theta2))+I2;
            f2 = m2*lc2*g*cos(theta1+theta2-pi/2);
            f1 = -m2*l1*lc2*dtheta2^2*sin(theta2)-2*m2*l1*lc2*dtheta2*dtheta1*sin(theta2)...
                +(m1*lc1+m2*l1)*g*cos(theta1-pi/2)+f2;
            
            tau = a;
            
            ddtheta2 = (m2*lc2^2+I2-d2^2/d1)^(-1)*(tau+d2/d1*f1-m2*l1*lc2*dtheta1^2*sin(theta2)-f2);
            ddtheta1 = -d1^(-1)*(d2*ddtheta2+f1);
            
            qdot(1) =  q(2);
            qdot(2) =  ddtheta1;
            qdot(3) =  q(4);
            qdot(4) =  ddtheta2;
            
            qdot = qdot';
        end
        
        

        function [qNext] = GetNextState(Env,q,a)
                        
            
            [qdot] = Derivative(Env, q , a);
            
             qNext =  q+Env.StepSize*qdot;
        end
        
        function e = IsTerminal(Env,q,a)
            
            [~,y] = Env.GetPos(q,'end2');
            
            e = 0;
            if (y-Env.GoalHeight)>=0
                e =1;
            end
            
        end
            
        
        %%%    ~  Added fucntions ~  %%%
        function [ind] = subsindex(Env)
            ind = 0;
        end


              


    end
        
end