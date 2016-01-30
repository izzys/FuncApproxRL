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

 
    arrowfactor_x=sign(a)*0.8;
    if (sign(arrowfactor_x)>0)
        text_arrow = strcat('==>> ',num2str(a));
    else if (sign(arrowfactor_x)<0)
            text_arrow = strcat(num2str(a),' <<==');
        else
            text_arrow='=0=';
            arrowfactor_x=0.25;
        end
    end
    
    [x1,y1] = Env.GetPos(s,'end1');
    [x2,y2] = Env.GetPos(s,'end2');
    
    CircRes = 12; %resolution of the joint circle
    joint_color = [0.2,0.6,0.8];
    joint_radius = 0.08; % radius of joint (in points)
    LinkRes = 12; %resolution of link plot
    link_width = 0.025; %width of link plot
    link_color = [0.1, 0.3, 0.8];
    LineWidth = 1;
    x0 = 0;
    y0 = 0;
    
    
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
    axis([-3 3 -2 2])
    
    % Render joints as circle
    Env.RenderObj.j1 = DrawCircle(Env, x0, y0, 1, joint_radius, joint_color, []);
    Env.RenderObj.j2 = DrawCircle(Env, x1, y1, 1, joint_radius, joint_color, []);

    % Render links
    Env.RenderObj.L1 = DrawLink(Env, x0, y0, x1, y1, 0, []);
    Env.RenderObj.L2 = DrawLink(Env, x1, y1, x2, y2, 0, []);

    % Draw goal line:
    Env.RenderObj.Goal = line( [-1, 1], [Env.l1, Env.l1], [0  0],'Color','k','LineStyle','--');
   
    %Steps count:
    Env.RenderObj.Text =  text(-3,-1.9,'steps: ' );

    %Command arrow:
    Env.RenderObj.Arrow = text(x1 + arrowfactor_x  ,y1,2,text_arrow);


    drawnow
    
    %Call fucntion again:
    Env.Render(s,a,steps,axes_handle);
    
 else
     
    % Envel was already rendered - Re-draw links
    DrawCircle(Env, x1, y1, 1, joint_radius, joint_color,Env.RenderObj.j2);
    DrawLink(Env, x0, y0, x1, y1,0,Env.RenderObj.L1);
    DrawLink(Env, x1, y1, x2, y2,0,Env.RenderObj.L2);
    
    set(Env.RenderObj.Text,'String',['steps: ' num2str(steps)])
    set(Env.RenderObj.Arrow,'Position', [x1 + arrowfactor_x   ,y1, 2] , 'String' , text_arrow )
    
    drawnow
    pause(0.01)
     
     
 end
 
 
    %         ~   Auxiliary nested functions ~      
    
    % Draw Circle:
    function [ res ] = DrawCircle(Env, x, y, z, R, color,Obj)
        
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
            
            res.Trans=hgtransform('Parent',gca);
            Txy=makehgtform('translate',[x y z]);
            
            set(res.Geom,'Parent',res.Trans);
            set(res.Trans,'Matrix',Txy);
            
        else
            
            Txy=makehgtform('translate',[x y z]);
            set(Obj.Trans,'Matrix',Txy); 
            
            res=1;          
        end
    end

    % Draw Link:
    % Draws a link of from (x0,y0) to (x1,y1)
    function [ res ] = DrawLink(Env, x0, y0, x1, y1, z, Obj)
       
        if isempty(Obj)
            
            Length=sqrt((x1-x0)^2+(y1-y0)^2);
            Center=[(x0+x1)/2;
                    (y0+y1)/2];
            Orientation=atan2(y1-y0,x1-x0);

            res.Trans=hgtransform('Parent',gca);
            Txy=makehgtform('translate',[Center(1) Center(2) z]);
            Rz=makehgtform('zrotate',Orientation-pi/2);

            coordX=zeros(1,2*LinkRes+1);
            coordY=zeros(1,2*LinkRes+1);
            coordZ=zeros(1,2*LinkRes+1);

            x=0;
            y = Length/2-link_width/2;
            
            for r=1:LinkRes
                coordX(1,r)=x+link_width/2*cos(r/LinkRes*pi);
                coordY(1,r)=y+link_width/2*sin(r/LinkRes*pi);
                coordZ(1,r)=0;
            end

            y = -Length/2+link_width/2;
            
            for r=LinkRes:2*LinkRes
                coordX(1,r+1)=x+link_width/2*cos(r/LinkRes*pi);
                coordY(1,r+1)=y+link_width/2*sin(r/LinkRes*pi);
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
            Sx=makehgtform('scale',[Length/Env.l1,1,1]);
            set(Obj.Trans,'Matrix',Txy*Rz*Sx);
            res=1;
        end
    end

end

