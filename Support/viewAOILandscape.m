function AOIimage = viewAOILandscape( aoiPos, outSideDist, A, showFigure )


%  A: image
%  aoiPos: [ x x x; y y y]

%----------------------------------
% show AOI landscape ( voranoid type )

if nargin < 4
    showFigure = 1;
end


    clf( gcf)
    % learning part
    numAOI =size(aoiPos,2);
    [numYsamples numXsamples] = size( A(:,:,1));
    x = 1:numXsamples;
    y = 1:numYsamples;
    [X,Y] = meshgrid(x,y);
    distMatrixLearn = zeros( numYsamples*numXsamples, numAOI);

    for i1 = 1:numAOI
        distVecLearn = calc2Dist( aoiPos(:,i1), [X(:)' ; Y(:)' ]); % 2-norm 
        distMatrixLearn(:,i1) =  distVecLearn;
    end
    [C AOIimage ]=min( distMatrixLearn,[],2);
    AOIimage( C > outSideDist) = numAOI+1; % for outside region    
    AOIimage = reshape(AOIimage,  [numYsamples, numXsamples ] );
    AOIimage = edge(AOIimage);
    
    
    if showFigure
        %  imagesc(  AOIimage ), colormap gray;
        imshow( mixRGBAndGray( A, AOIimage )); %, colormap gray;
        axis equal off
        hold on
        plot( aoiPos(1,:), aoiPos(2,:), 'b*' );
        for i1 = 1:numAOI
            text( aoiPos(1,i1)+4,  aoiPos(2,i1)+4, int2str(i1), 'fontsize', 20,'color', 'blue' )
        end
        hold off
        pause(.1);
    end
    
    

end