classdef  Environment < handle


    properties 
                
        S; % States 
        A; % Available actions
        
        Sdim;
        Adim;
        
        const_IC;
        random_IC;
    end
    
    methods
        
        function Env = Environment()
        end
        
        function [] = Init(Env)
        end

        function [ r ] = GetReward(Env,s,a)
        end

        function [ s ] = GetNextState(Env,s,a)
        end
        
        function [ s ] = DiscretizeState( Env , x  )
        end
        
        function [e] = IsTerminal(Env,s,a)
        end
        
    end
    

end