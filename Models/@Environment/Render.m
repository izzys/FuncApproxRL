function [] = Render( Env ,varargin )

switch nargin
    
    case 1
        error('s and a unknown')
    case 2
        error('s or a unknown')
    case 3
        s = varargin{1};
        a = varargin{2};
        steps = [];
        h = axes;        
        disp('steps and axes handle not supplied, creating new figure')
    case 4
        disp('axes handle not supplied, creating new figure')
        s = varargin{1};
        a= varargin{2};
        steps = varargin{3};
        h = axes;
    case 5
        s = varargin{1};
        a= varargin{2};
        steps = varargin{3};
        h = varargin{4};
end



if isempty(Env.RenderObj)
    
    cla(h)
    axes(h)  
    hold on
    
    axis([0 1 0 1]) 
    axis normal
 
    drawnow
    
    Env.Render(s,a,steps,h);
    
      
else

    drawnow

end



end
  