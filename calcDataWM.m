function Result = calcDataWM(Video,infoWM)

backGround = infoWM.Props.backGround;
mask = infoWM.Props.mask;
threshMouse = infoWM.Props.threshMouse;
diag1 = infoWM.Props.diag1;
diag2 = infoWM.Props.diag2;
platform = infoWM.Props.platform;
ratioCmPerPxl = infoWM.Props.ratioCmPerPxl;

figure('units','normalized','outerposition',[0 0 1 1])
colormap gray
clear x y
targ = 0; adjR = 0; adjL = 0; opp = 0;
NumFrames = size(Video,3);

for i=1:NumFrames
    actual = squeeze(Video(:,:,i));
    actual2 = (uint8(255)-actual-backGround).*uint8(mask);
    actual2(actual2<255*threshMouse/100)=0;
    actual2(actual2>=255*threshMouse/100)=1;
    
    mousePerim = bwperim(actual2);
    [row,col] = find(mousePerim);
    pgon = polyshape(row,col);
    [y(i),x(i)] = centroid(pgon);
    if mod(i,10)==0
        imagesc(actual)
        daspect([1 1 1])
        hold on
        plot(x,y,'r*')
        pause(.1)
    end
    
    %%% Define quadrant
    pos1 = sign(polyval(diag1.coeffs,x(i)) - y(i));
    pos2 = sign(polyval(diag2.coeffs,x(i)) - y(i));
    if pos1<0
        if pos2<0
            targ = targ + 1;
        else
            adjL = adjL +1;
        end
    else
        if pos2<0
            adjR = adjR + 1;
        else
            opp = opp +1;
        end
    end
        
end

%%% Average dist to platform
xDist = x-platform.Center(1);
yDist = y-platform.Center(2);

AverageDistanceToPlatform = nanmean(sqrt(xDist.^2 + yDist.^2))*ratioCmPerPxl;
AdjacentLeft = adjL/NumFrames; Target = targ/NumFrames;
AdjacentRight = adjR/NumFrames; Opposite = opp/NumFrames;
Result = table(AdjacentLeft,Target,AdjacentRight,Opposite,AverageDistanceToPlatform);
