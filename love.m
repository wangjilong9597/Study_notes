clear
clc


[X,Y,Z] = meshgrid(linspace(-3,3,101));

F = -X.^2.*Z.^3-(9/80).*Y.^2.*Z.^3+(X.^2+(9/4).*Y.^2+Z.^2-1).^3;

hFigure=figure;

set(hFigure, 'Position', [300 300 1200 600]);
set(hFigure,'color','w', 'menu','none')
hAxes = axes('Parent',hFigure,...?
'DataAspectRatio',[1 1 1],...? ??
'XLim',[30 120], 'YLim',[35 65], 'ZLim',[30 75]);
view([-39 30]);   
axis off           


p = patch(isosurface(F,0)); 
set(p,'FaceColor','none','EdgeColor','none');   
alpha(0);                                
text(45,50,60,'WJL','fontweight','bold','fontsize',25,'color','m');
pause(2)
hold on 


for iX = 35:1:67
    plane = reshape(F(:,iX,:),101,101);
    cData = contourc(plane,[0 0]);
    xData = iX.*ones(1,cData(2,1));
    plot3(hAxes,xData,cData(2,2:end),cData(1,2:end),'r');
    pause(0.05), drawnow
end

for iY = 41:2:61
     plane = reshape(F(iY,:,:),101,101);
     cData = contourc(plane,[0 0]);
     yData = iY.*ones(1,cData(2,1));
     plot3(hAxes,cData(2,2:end),yData,cData(1,2:end),'r');
     pause(0.05), drawnow 
end

for iZ = 36:1:71
    plane = F(:,:,iZ);
    cData = contourc(plane,[0 0]);
    startIndex = 1;
    if size(cData,2) > (cData(2,1)+1)
       startIndex = cData(2,1)+2;
       zData = iZ.*ones(1,cData(2,1));
       plot3(hAxes,cData(1,2:(startIndex-1)),...? ????
       cData(2,2:(startIndex-1)),zData,'r');
    end
   zData = iZ.*ones(1,cData(2,startIndex));
   plot3(hAxes,cData(1,(startIndex+1):end),...??????
   cData(2,(startIndex+1):end),zData,'r');
   pause(0.05), drawnow
end


alpha(1)              
set(p,'facecolor','m','edgecolor','none');
camlight               
lighting gouraud
pause(0.2)


line([20 80],[50 50],[52.5 2.5], 'color','r')
line([50 50],[20 80],[52.5 52.5], 'color','r')
line([50 50],[50 50],[30 80], 'color','r')
pause(0.5)


text(0,50,107,'\heartsuitLOVE\heartsuit','fontweight','bold','fontsize',25,'color','r');
pause(2)
text(7,100,70,['WJL\heartsuit'], 'fontWeight','bold','FontAngle','italic','FontName','Trebuchet?MS','fontsize',35,'Color','c');
pause(.5)
text(80,50,43,'YOU', 'fontWeight','bold','FontAngle','italic','FontName','Trebuchet?MS','fontsize',60,'Color','k');
pause(.2)
text(77,5,40,'\heartsuitForever\heartsuit', 'fontWeight','bold','FontAngle','italic','FontName','Trebuchet?MS','fontsize',25,'Color','g');
pause(.2)
text(120,0,20,'\heartsuitGXY', 'fontWeight','bold','FontAngle','italic','FontName','Trebuchet?MS','fontsize',35,'Color','c');
pause(.2)
uicontrol(hFigure,'Style','Edit','Units','normalized','Position',[0,0.8,1,0.12],...
    'Backgroundcolor','[0,1,1]','String','HAPPY 100 DAY!','Fontsize',40,'Foregroundcolor','[1,0,1]');
pause(.5)
uicontrol(hFigure,'Style','Edit','Units','normalized','Position',[0,0.8,1,0.12],...
    'Backgroundcolor','[0.3,0.75,0.93]','String','HAPPY 100 DAY!','Fontsize',40,'Foregroundcolor','[1,0,1]');
pause(.5)
uicontrol(hFigure,'Style','Edit','Units','normalized','Position',[0,0.8,1,0.12],...
    'Backgroundcolor','[1,0.5,0]','String','HAPPY 100 DAY!','Fontsize',40,'Foregroundcolor','[1,0,1]');
pause(.5)
uicontrol(hFigure,'Style','Edit','Units','normalized','Position',[0,0.8,1,0.12],...
    'Backgroundcolor','[1,1,1]','String','HAPPY 100 DAY!','Fontsize',40,'Foregroundcolor','[1,1,1]');
pause(.5)
uicontrol(hFigure,'Style','Edit','Units','normalized','Position',[0,0.8,1,0.12],...
    'Backgroundcolor','[1,1,1]','String','HAPPY 100 DAY!','Fontsize',40,'Foregroundcolor','[0,0,0]');
