function Props = getPropsWM(Video)

%%% Get properties for the Calculation of Variables in the Watermaze
%%% experiment
Props.templateIdx=50;
Props.threshMouse = 10; % 10% of the gray scale, i.e, round(255*0.1)
Props.realRadius = 73.37;
Props.backGround = uint8(255)-nanmedian(Video,3);
Props.template = squeeze(Video(:,:,Props.templateIdx));

figure('units','normalized','outerposition',[0 0 1 1])
imagesc(Props.template)
daspect([1 1 1])
colormap gray
roi = drawcircle;
wait(roi)
Props.pxlRadius = roi.Radius;
Props.ratioCmPerPxl = Props.realRadius/Props.pxlRadius;

Props.mask=createMask(roi);
line1 = drawline('SelectedColor','yellow');
wait(line1)
Props.diag1.Coords = line1.Position;
Props.diag1.coeffs = polyfit(Props.diag1.Coords(:,1),Props.diag1.Coords(:,2),1);
line2 = drawline('SelectedColor','yellow');
wait(line2)
Props.diag2.Coords = line2.Position;
Props.diag2.coeffs = polyfit(Props.diag2.Coords(:,1),Props.diag2.Coords(:,2),1);

platformLoc = drawcircle;
wait(platformLoc)
Props.platform.Center = platformLoc.Center;
Props.platform.Radius = platformLoc.Radius;
Props.platform.Vertices = platformLoc.Vertices;