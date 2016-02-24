function varargout = ValueFcn(RL,varargin)


if nargin && ischar(varargin{1})
    ValueFcn_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = ValueFcn_Callback(RL, varargin{2:end});
else
    ValueFcn_Callback(RL, varargin{2:end});
end

function [] = Init(RL,varargin)

if nargin>=2

end

function [Q , tiles] = GetValue(RL,varargin)

x = varargin{1};
a = varargin{2};

% scale our state so that it is within unit intervals:
for i = 1:length(x)
xs(i)   = x(i)/( RL.Env.Xdim(i) * RL.Env.dX(i) )+0.5;
end

% scale our action so that it is within unit intervals:
%as   = 0;%a/RL.Env.dA; 

[ tiles ] = myGetTiles(RL.VnTilings,RL.TilingOffSet,xs,RL.Env.Xdim,0);

%tiles  = GetTiles_Mex(RL.VnTilings,xs,RL.V_memory_size,as);
Q = sum( RL.V(tiles) ); 



function [] = Plot(RL,varargin)

    nS = 100; 
    x = linspace(RL.Env.x1_min,RL.Env.x1_max,nS);
    y = linspace(RL.Env.x2_min,RL.Env.x2_max,nS);
    [X,Y] = meshgrid(x,y);
    F_approx = zeros(nS,1);
    
    for xi=1:nS
      for yi = 1:nS
          
          st = [X(xi,yi), Y(xi,yi)];
          
          [F_approx(xi,yi),~] = GetValue(RL,st,1);
          
      end
    end
    
    cla
    hold on
    meshc( X, Y,F_approx );
    view(3) 

