function [ tiles ] = myGetTiles(nTilings,TilingOffSet,xs,Xdim,plot_tiling)

Ndim = length(xs);

% memory_size = [Xdim(1) , Xdim(2) , Xdim(3) , Xdim(4) , nTilings];

if plot_tiling
figure(121)
cla
hold on
axis( [ -1/Xdim(1) ,  1+1/Xdim(1) , -1/Xdim(2) ,  1+1/Xdim(2) ])      
xlabel 'coordinate i'
ylabel 'coordinate j'
end

%compute the tile numbers 
tiles = [];

for j = 1:nTilings
    
    % loop over each relevant dimension and quantize state to integers 
    for i =1:Ndim
        
       
        coordinates(i) =  floor( ( xs(i)- TilingOffSet(j,i) )* Xdim(i) ) + 1;

        if coordinates(i)>(Xdim(i))
            coordinates(i) = Xdim(i);
        end
        
        if coordinates(i)<1
            coordinates(i) = 1;
        end
 
    end
    
   % tile = sub2ind( memory_size , coordinates(1) , coordinates(2) ,coordinates(3),coordinates(4) ,  j)
    
    
    tile = coordinates(1);
    for i = 1:(Ndim-1)
        tile = tile + prod(Xdim(1:i))*( coordinates(i+1)-1);
    end
    tiles(j) = tile + (j-1)*prod(Xdim) ;
    
    
  %  tile =   coordinates(1)+ Xdim(1)*( coordinates(2)-1)+ Xdim(1)*Xdim(2)*( coordinates(3)-1) +(j-1)*prod(Xdim) 
    
    if plot_tiling
    PlotTilingLines(Xdim,TilingOffSet,coordinates,j)
    end
%     tiles = [tiles tile];
    
    
   
end


if plot_tiling
plot(xs(1),xs(2),'r*','MarkerSize',10)
end

function []=PlotTilingLines(Xdim,TilingOffSet,coordinates,jj)

if jj>1
Color = [rand rand rand];
LineStyle = '--';
LineWidth = 0.1;
else
Color = [0 0 0];
LineStyle = '-';  
LineWidth = 2;
end

for i = 1:(Xdim(1)+1)
    
    x = (i-1)*1/Xdim(1)+TilingOffSet(jj,1);
    
    y1 = TilingOffSet(jj,2);
    y2 = 1+TilingOffSet(jj,2);

    line([x x ],[y1 y2 ],'LineStyle',LineStyle,'LineWidth',LineWidth,'Color',Color)
    
    for j = 1:(Xdim(2)+1)
        
        y = (j-1)*1/Xdim(2)+TilingOffSet(jj,2);
        x1 = TilingOffSet(jj,1);
        x2 = 1+TilingOffSet(jj,1);
        line([x1 x2 ],[ y  y],'LineStyle',LineStyle,'LineWidth',LineWidth,'Color',Color);
          
    end
    

end



    xx1 =(coordinates(1)-1)/Xdim(1) + TilingOffSet(jj,1);
    xx2 = (coordinates(1))/Xdim(1) + TilingOffSet(jj,1);

    yy1 = (coordinates(2)-1)/Xdim(2) + TilingOffSet(jj,2);
    yy2 = (coordinates(2))/Xdim(2) + TilingOffSet(jj,2);

    patch([xx1 xx2 xx2 xx1],[ yy1  yy1 yy2 yy2],Color,'FaceAlpha',0.5);



