% show AOIs

imageFolder = './';
markingsFolder= 'Annotations/';

outSideDist = 80;  % specifies radius of circle for AOIs
    % chris liked 60

% creat output folder    
outFolder = 'AOIView/';
if ~exist( outFolder, 'dir')
    mkdir( outFolder);
end
    
showFigure = 1;
imList = dir( [ imageFolder '*.bmp']);
for i1 = 1:length(imList)

    %load image
    A = imread( [ imageFolder imList(i1).name ]);
    %load markings
    load( [markingsFolder imList(i1).name(1:end-3) 'mat'], 'coordinates2D')
    
    % aois supposed to be like [ x x x;
    %                            y y y]
    aoiPos = coordinates2D';    
    AOIimage = viewAOILandscapeNoText( aoiPos, outSideDist, A, showFigure );
        
%     saveas(1, [outFolder imList(i1).name(1:end-3) '.png' ]);
    
    pause(.1);
end