function [] = Render( Env ,varargin )

switch nargin
    
    case 1
        error('s and a unknown')
    case 2
        error('s or a unknown')
    case 3
        s = varargin{1};
        a= varargin{2};
        steps = [];
        axes_handle = axes;        
        disp('steps and axes handle not supplied, creating new figure')
    case 4
        disp('axes handle not supplied, creating new figure')
        s = varargin{1};
        a= varargin{2};
        steps = varargin{3};
        axes_handle = axes;
    case 5
        s = varargin{1};
        a= varargin{2};
        steps = varargin{3};
        axes_handle = varargin{4};
end



if isempty(Env.RenderObj)
    
    cla(axes_handle)
    axes(axes_handle)  
    
    hold on
    
      
    axis([Env.x1_min Env.x1_max Env.x2_min Env.x2_max]) 

    
    
    line([Env.x1_min Env.x1_max],[Env.x2_min Env.x2_min],'Color','k')
    line([Env.x1_max Env.x1_max],[Env.x2_min Env.x2_max],'Color','k')
    line([Env.x1_min Env.x1_max],[Env.x2_max Env.x2_max],'Color','k')
    line([Env.x1_min Env.x1_min],[Env.x2_min Env.x2_max],'Color','k')
    
    plot(axes_handle,0,0,'r+');
    Env.RenderObj.Pos = plot(s(1),s(2),'Marker','o','MarkerSize',10);
    
    %Steps count:
    Env.RenderObj.Text =  text(-0.9,-0.9,'steps: ' );
    
    drawnow
    
    Env.Render(s,a,steps,axes_handle);
    
      
else
    
    set(Env.RenderObj.Text,'String',['steps: ' num2str(steps)])
    set(Env.RenderObj.Pos,'Xdata',s(1),'Ydata',s(2));
    
    drawnow

end



end
  