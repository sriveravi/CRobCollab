%------------------------
% initialization of basic common things (screen size, aois, etc )
%------------------------


imSize = [ 1024, 768]; %x,y
[width ] = imSize(1);
[height ] = imSize(2);
% imFolder = '../ExpBasic/';
imFolder = '/media/New_Volume/CRSameDiffProj/ChrisData/EyeTracking/Stimuli/CenteredImg/';
aoiFolder = '/media/New_Volume/CRSameDiffProj/ChrisData/EyeTracking/Stimuli/CenteredImg/Annotations/';
maxDist = 70;

% datFldr = '/media/New_Volume/CRSameDiffProj/ChrisData/EyeTracking/CrossmodalData/AllASC/';
% cond = 'Mix';

% datFldr = '/media/New_Volume/CRSameDiffProj/ChrisData/EyeTracking/UnimodalAuditoryData/AllASC/';
% cond = 'Aud';

datFldr = '/media/New_Volume/CRSameDiffProj/ChrisData/EyeTracking/UnimodalVisualData/AllASC/';
cond = 'Vis';

% % 
% % 
% % %  get stimulus size and position, initialize black img
% % stimSz = size( imread( [imFolder 'Trees/cat1_33336.png'  ] ));
% % stimSz(1:2) = stimSz(1:2)*1.75;
% % stimRect = CenterRectOnPoint([0 0 stimSz(2) stimSz(1)], width/2, height/2);
% % % %newRect=[left,top,right,bottom];
% % img = uint8( zeros(height, width,3));
% % 
% % 
% % %load aois
% % load( '../ExpBasic/treeAois.mat'); % aois, AOIMatrix

% % % scale and shift aois
% % aois = aois*1.75;
% % aois(1,:) = aois(1,:) + stimRect(1);
% % aois(2,:) = aois(2,:) + stimRect(2);
% % 
% % % show AOIs
% % stimImg = imresize( imread([imFolder 'Trees/cat1_33336.png' ]), stimSz(1:2));
% % img( stimRect(2):stimRect(4)-1, stimRect(1):stimRect(3)-1,:) = stimImg;
% % showFigure = 1;
% % AOIimage = viewAOILandscape( aois, maxDist, img, showFigure );

%--------------------------
%--------------------------
% subList = dir( '../ExpBasic/Results/00*.asc');
subList = dir( [ datFldr '*.asc'] );
% allSubs = {'0011', '0012', '0013','0014','0015','0016','0017','0018','0019','0020'};
for i1 =1:length(subList)
    allSubs{i1} = subList(i1).name(1:end-4);
end

emptySubjects = [];
for subIdx = 1:length(allSubs)
    sub = allSubs{subIdx}; % '0011';

    % table file
    if ~exist( ['Python/Data' cond ], 'dir'); mkdir( ['Python/Data' cond ]); end
    file = ['Python/Data' cond '/dataTable' sub '.txt'];
    if ~exist( file, 'file')

        % load exp data (11 works)
        trials = loadELfile( [datFldr sub '.asc']);
%         if isempty(find(strcmp( 'BLANK_SCREEN', trials(end).msg), 1)) 
%             trials(end) = []; 
%         end


        % extract trial info from stim presentation
        startMsg = 'target'; 
        endMsg = 'responseMade';
        offsets = []; % [0, 0];
        [ stimSegment, times ] = cropTrialsByMsg( trials, startMsg, endMsg, offsets );
% %         stimSegment = trials;


        % add trial start time and AOIs to struct
        for i1 = 1:length( times)
            % trial start time
            stimSegment(i1).trialTime = times(i1); 
            
            %---- load AOI position, 
            imgStim = stimSegment(i1).test(1:end-4);  %test_visual(1:end-4); % get test stim name
%             imgStim = stimSegment(i1).test_visual(1:end-4); % get test stim name
% %             idx = find(imgStim == 'V'); % eliminate Auditory name
% %             imgStim( 1:(idx-1) ) = [];
            load( [ aoiFolder imgStim '.mat'],  'coordinates2D');
                                       
            % get aois sequence
            [ stimSegment(i1).fixAois ] =calcMMFixSequence( stimSegment(i1).fixPos, coordinates2D', maxDist, imSize );
            [ stimSegment(i1).sacAois ] =calcMMFixSequence( stimSegment(i1).sacEndPos, coordinates2D', maxDist, imSize );
            
            % subid
            stimSegment(i1).subid = sub;            
            
            % show it
            if ~exist( ['GazePattern' cond ], 'dir'); mkdir( ['GazePattern' cond ]); end
            hold off
            imshow( imread( [aoiFolder '../' imgStim '.bmp']));
            hold on
            plot( stimSegment(i1).fixPos(1,:), stimSegment(i1).fixPos(2,:), 'ko', 'markersize', 7, 'markerfacecolor','w');
            saveas(1, ['GazePattern' cond  '/' sub '_tr' num2str(i1) '.jpg'])                                    
            
        end

        % put in a cell array
        allSubData{subIdx} = stimSegment;

        % check if empty, else export to table
        if isempty( stimSegment)
                emptySubjects = [emptySubjects; subIdx];
        else   

            % %     file = ['Python/dataTableFull.txt'];
            % %     if subIdx == 1
            % %         writePerm = 'w';
            % %     else
            % %         writePerm = 'a';
            % %     end

            % %     % export to table

            writePerm = 'w';
            convertELToTable( stimSegment, file, writePerm)
        end
        
    end
end
allSubData( emptySubjects ) = [];


%----------
% % % show AOIs
% % stimImg = imresize( imread([imFolder stimSegment(50).CENTER ]), stimSz(1:2));
% % img( stimRect(2):stimRect(4)-1, stimRect(1):stimRect(3)-1,:) = stimImg;
% % showFigure = 1;
% % AOIimage = viewAOILandscape( aois, maxDist, img, showFigure );
%----------





% %-----------------------------------
% % show the fixations on the trials
% % 
% % %scale down images for speed
% % scaleSize = .4;
% % img = imresize(img, scaleSize);
% % stimRect = round(scaleSize.*stimRect);
% % stimSz(1:2) = round(scaleSize.*stimSz(1:2));
% % 
% % sigma = 10;
% % 
% % 
% % %loop through and show stimulus
% % for i2 = 1:length(stimSegment )
% %     
% %     stimImg = imresize( imread([imFolder stimSegment(i2).CENTER ]), stimSz(1:2));
% %     img( stimRect(2):stimRect(4)-1, stimRect(1):stimRect(3)-1,:) = stimImg;
% %     
% %     
% %     % show fixations
% %     [mixedImage] = showFixations( img, scaleSize.*stimSegment(i2).fixPos, stimSegment(i2).fixDuration, sigma  );
% %     
% % %     imshow(img);
% %     pause
% % end
% %     


