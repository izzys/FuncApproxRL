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

 
    
    
    x     = s(1);
    theta = s(3);

    action = Env.A(a);
    
    l = 2; %length of pole
    w = 0.6; %half width of cart
    h = 0.7; %half height of cart
    d = 0.1; %distance of cart from earth
    CircRes = 12; %resolution of the wheel circle
    WheelColor = [0.5 0.5 0.5];
    R = 0.2; % radius of cart weels (in points)
    LinkRes = 12; %resolution of link plot
    link_width = 0.1; %width of link plot
    link_color = [0.3,0.2,0.7];
    LineWidth = 1;
    CartColor = [0.6 0.6 0.5];
    arrow_height = 0.8;
    pause_time = 0.01;
    
    
    px_cart = [x+w x-w x-w x+w x+w];
    py_cart = [d d d+h d+h d];

    px_pole=[x x+l*sin(theta)];
    py_pole=[d+h d+h+l*cos(theta)];

    arrowfactor_x=sign(action)*2.5;
    if (sign(arrowfactor_x)>0)
        text_arrow = strcat('==>> ',num2str(action));
    else if (sign(arrowfactor_x)<0)
            text_arrow = strcat(num2str(action),' <<==');
        else
            text_arrow='=0=';
            arrowfactor_x=0.25;
        end
    end
    
    

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

    axis equal
    axis([-6 6 0 4])
    
    %Cart
    Env.RenderObj.Cart = fill(px_cart,py_cart,CartColor,'LineWidth',LineWidth);  

    %Steps count:
    Env.RenderObj.Text =  text(4.8,5.1,'steps: ' );

    %Car Wheels:
    Env.RenderObj.Wheel1 = DrawCircle( x-w+R, R, 1, R, WheelColor,[]);
    Env.RenderObj.Wheel2 = DrawCircle( x+w-R, R, 1, R, WheelColor,[]);                

    %Pendulum:
    Env.RenderObj.L = DrawLink( px_pole(1), py_pole(1), px_pole(2), py_pole(2), 0, []);

    %Command arrow:
    Env.RenderObj.Arrow = text(x + arrowfactor_x - 0.5 ,arrow_height,2,text_arrow);


    drawnow
    
    %Call fucntion again:
    Env.Render(s,a,steps,axes_handle);
    
 else
     
     set(Env.RenderObj.Cart,'Xdata', px_cart )
     set(Env.RenderObj.Text,'String',['steps: ' num2str(steps)])

     set(Env.RenderObj.Arrow,'Position', [x + arrowfactor_x - 0.5  ,arrow_height, 2] , 'String' , text_arrow )
   
     DrawLink( px_pole(1), py_pole(1), px_pole(2), py_pole(2),0,Env.RenderObj.L);
     DrawCircle( x-w+R, R, 1, R, WheelColor,Env.RenderObj.Wheel1);
     DrawCircle( x+w-R, R, 1, R, WheelColor,Env.RenderObj.Wheel2); 
     
     drawnow
     pause(pause_time)
     
     
 end
 
 
    % Draw the pendulum
    function [ res ] = DrawLink( x0, y0, x1, y1, z, Obj)

        if isempty(Obj)

            Length=sqrt((x1-x0)^2+(y1-y0)^2);
            Center=[(x0+x1)/2;
                    (y0+y1)/2];
            Orientation=atan2(y1-y0,x1-x0);

            res.Trans=hgtransform('Parent',axes_handle);
            Txy=makehgtform('translate',[Center(1) Center(2) z]);
            Rz=makehgtform('zrotate',Orientation-pi/2);

            coordX=zeros(1,2*LinkRes+1);
            coordY=zeros(1,2*LinkRes+1);
            coordZ=zeros(1,2*LinkRes+1);

            xx=0;
            yy = Length/2-link_width/2;

            for r=1:LinkRes
                coordX(1,r)=xx+link_width/2*cos(r/LinkRes*pi);
                coordY(1,r)=yy+link_width/2*sin(r/LinkRes*pi);
                coordZ(1,r)=0;
            end

            yy = -Length/2+link_width/2;

            for r=LinkRes:2*LinkRes
                coordX(1,r+1)=xx+link_width/2*cos(r/LinkRes*pi);
                coordY(1,r+1)=yy+link_width/2*sin(r/LinkRes*pi);
                coordZ(1,r+1)=0;
            end

            res.Geom=patch(coordX,coordY,coordZ,link_color);
            set(res.Geom,'EdgeColor',[0 0 0]);
            set(res.Geom,'LineWidth',2*LineWidth);

            set(res.Geom,'Parent',res.Trans);
            set(res.Trans,'Matrix',Txy*Rz);
        else
            Center=[(x0+x1)/2;
                    (y0+y1)/2];
            Orientation=atan2(y1-y0,x1-x0);
            Length=sqrt((x1-x0)^2+(y1-y0)^2);

            Txy=makehgtform('translate',[Center(1) Center(2) z]);
            Rz=makehgtform('zrotate',Orientation-pi/2);
            Sx=makehgtform('scale',[Length/l,1,1]);
            set(Obj.Trans,'Matrix',Txy*Rz*Sx);
            res=1;
        end
    end

    % Draw Circle:
    function [ res ] = DrawCircle( x, y, z, R, color,Obj)
        
        if isempty(Obj)
            
            coordX=zeros(1,CircRes);
            coordY=zeros(1,CircRes);
            coordZ=zeros(1,CircRes);

            for r=1:CircRes
                coordX(1,r)=R*cos(r/CircRes*2*pi);
                coordY(1,r)=R*sin(r/CircRes*2*pi);
                coordZ(1,r)=0;
            end

            res.Geom=patch(coordX,coordY,coordZ,color);
            set(res.Geom,'EdgeColor',color.^4);
            set(res.Geom,'LineWidth',2*LineWidth);
            
            res.Trans=hgtransform('Parent',axes_handle);
            Txy=makehgtform('translate',[x y z]);
            
            set(res.Geom,'Parent',res.Trans);
            set(res.Trans,'Matrix',Txy);
            
        else
            
            Txy=makehgtform('translate',[x y z]);
            set(Obj.Trans,'Matrix',Txy); 
            
            res=1;          
        end
    end

end

