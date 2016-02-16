function [] = Render( Env , varargin)
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



arrowfactor_x=sign(a)*2.5;
if (sign(arrowfactor_x)>0)
 text_arrow = strcat('==>> ',num2str(a));
else if (sign(arrowfactor_x)<0)
     text_arrow = strcat(num2str(a),' <<==');
 else
     text_arrow='=0=';
     arrowfactor_x=0.25;
 end
end

pause_time = 0.00;

x_car = s(1);
y_car = sin(3*x_car);

LineWidth = 2;
PathColor = [0.3,0.2,0.7];

CarSize = 55;
CartColor =[0.7 0 0];

res = 1:0.01:10;
x_path = Env.x1_min:0.01:Env.x1_max;
y_path = sin(3*x_path);

arrow_height = 0.5;
arrow_pos = -0.6;

 if isempty(Env.RenderObj)
     
    cla(axes_handle)
    
    axes(axes_handle)  
       
    hold on

    set(axes_handle,'YDir','normal',...
          'XGrid','off',... 
          'YGrid','off',...
          'XTick',[],...
          'YTick',[],... 
          'XTickLabel',[],... 
          'YTickLabel',[]);
      
    axis normal
    axis([Env.x1_min Env.x1_max -1 1])

    %Draw path:
    Env.RenderObj.Path = plot(x_path,y_path,'Color',PathColor,'LineWidth',LineWidth);  
    
    
    %Car:
    Env.RenderObj.Car = plot(x_car,y_car,'Marker','.','Color',CartColor,'MarkerSize',CarSize);  

    %Steps count:
    Env.RenderObj.Text =  text(Env.x1_min,-0.95,'steps: ' );
            

    %Command arrow:
    Env.RenderObj.Arrow = text(arrow_pos ,arrow_height,2,text_arrow);


    drawnow
    
    %Call fucntion again:
    Env.Render(s,a,steps,axes_handle);
    
 else
     
     set(Env.RenderObj.Car,'Xdata', x_car, 'Ydata', y_car )
     set(Env.RenderObj.Text,'String',['steps: ' num2str(steps)])

     set(Env.RenderObj.Arrow, 'String' , text_arrow )
   
     
     drawnow
     pause(pause_time)
     
     
 end
 
 

end

