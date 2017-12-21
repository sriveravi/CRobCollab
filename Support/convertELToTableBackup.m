function convertELToTable( trials, file, writePermissions)

    if nargin < 2 || isempty( file)
        file = 'Python/dataTable.txt';
        if ~exist( 'Python', 'dir'); mkdir( 'Python'); end
    end

    if nargin< 3 || isempty(writePermissions)
        writePermissions =  'w'; % overwrite file
        % 'a': would append
    end


    % if nargin < 4
    %     ageGroups = { [5:7], [8:12], [16:24], [13:15]};  % group 4 so nothing missing
    % end

    if ~isempty( trials)

        % split up the x-y coordinates
        [trials, fixSac] = splitXY(trials );

        % get the table names
        parNames = fieldnames( trials);
        % we remove these since we will handle this differently
        parNames(strcmp( parNames, 'msg')) = [];
        parNames(strcmp( parNames, 'msgTime')) = [];


        % open file and write header line
        fID = fopen( file, writePermissions);
        if ~strcmp( writePermissions, 'a') % if appending, do not write header
            tableLine = num2cell( nan( 1, length(parNames)+17));   
            for i1 = 1:length( parNames)
                    tableLine{1,i1} = parNames{i1};
            end
            tableLine{i1+1} = 'fixX';
            tableLine{i1+2} = 'fixY';
            tableLine{i1+3} = 'pupil';
            tableLine{i1+4} = 'fixDuration';
            tableLine{i1+5} = 'fixStart';
            tableLine{i1+6} = 'fixEnd';
            tableLine{i1+7} = 'sacEndPosX';
            tableLine{i1+8} = 'sacEndPosY';
            tableLine{i1+9} = 'sacStartPosX';
            tableLine{i1+10} = 'sacStartPosY';
            tableLine{i1+11} = 'sacStartTime';
            tableLine{i1+12} = 'sacEndTime';
            tableLine{i1+13} = 'sacVel';
            tableLine{i1+14} = 'sacDuration';
            tableLine{i1+15} = 'sacAmp';        
            tableLine{i1+16} = 'fixAois';        
            tableLine{i1+17} = 'sacAois';        
            tableLine{i1+18} = 'lastMessage';  
            writeLine(fID,tableLine) % write it
        end

        %loop through all trials
        for triIdx = 1:length( trials )

            % reset table line (general info) 
            tableLine = num2cell( nan( 1, length(parNames)+18)); % chnged 17->18 for msg  
            for i1 = 1:length( parNames)
                tableLine{1,i1} = trials(triIdx).( parNames{i1});
            end

            % add all fixations to file
            numF = length( fixSac(triIdx).fixX );
            for fixIdx = 1:numF
                tableLine{i1+1} = fixSac(triIdx).fixX(fixIdx);
                tableLine{i1+2} = fixSac(triIdx).fixY(fixIdx);
                tableLine{i1+3} = fixSac(triIdx).pupil(fixIdx);
                tableLine{i1+4} = fixSac(triIdx).fixDuration(fixIdx);
                tableLine{i1+5} = fixSac(triIdx).fixStart(fixIdx);
                tableLine{i1+6} = fixSac(triIdx).fixEnd(fixIdx);   
                if isfield( fixSac,'fixAois')
                    tableLine{i1+16} = fixSac(triIdx).fixAois(fixIdx);
                end
                % last message
                tableLine{i1+18} = getLastMsg( trials(triIdx).msg, trials(triIdx).msgTime, fixSac(triIdx).fixStart(fixIdx) );
                % write trial info
                writeLine(fID,tableLine)
            end

            % reset table line (general info) 
            tableLine = num2cell( nan( 1, length(parNames)+18));   
            for i1 = 1:length( parNames)
                tableLine{1,i1} = trials(triIdx).( parNames{i1});
            end

            % add all saccades
            numS = length( fixSac(triIdx).sacEndPosX );
            for sacIdx = 1:numS
                tableLine{i1+7} = fixSac(triIdx).sacEndPosX(sacIdx);
                tableLine{i1+8} = fixSac(triIdx).sacEndPosY(sacIdx);        
                tableLine{i1+9} = fixSac(triIdx).sacStartPosX(sacIdx);
                tableLine{i1+10} = fixSac(triIdx).sacStartPosY(sacIdx);        
                tableLine{i1+11} = fixSac(triIdx).sacStartTime(sacIdx);
                tableLine{i1+12} = fixSac(triIdx).sacEndTime(sacIdx);                
                tableLine{i1+13} = fixSac(triIdx).sacVel(sacIdx);
                tableLine{i1+14} = fixSac(triIdx).sacDuration(sacIdx);
                tableLine{i1+15} = fixSac(triIdx).sacAmp(sacIdx);              
                if isfield( fixSac,'sacAois')
                    tableLine{i1+17} = fixSac(triIdx).sacAois(sacIdx);
                end
                % last message
                tableLine{i1+18} = getLastMsg( trials(triIdx).msg, trials(triIdx).msgTime, fixSac(triIdx).sacStartTime(sacIdx) );

                % write trial info
                writeLine(fID,tableLine)
            end

            % write trial info if no fixations/saccades
            if numF < 1 && numS < 1  
                writeLine(fID,tableLine)
            end    

        end % end trials  




        %----------



        % 
        % % write header line
        % fID = fopen( file, 'w');
        % headerLine = 'subject\tage\tage_group\ttrial\tblock\tfixTime\tfixAOI\tsacTime\tsacAOI\tzeroOffset\tleft\n'; % acc\tlat\tprop\tleft\n';
        % fprintf( fID, headerLine );
        % fclose(fID);
        % % dlmwrite( file, mixModelTable,'delimiter', '\t', '-append');
        % 
        % % loop through all subjects
        % for subIdx = 1:length( responseSum )
        %     thisSub = responseSum{subIdx};
        %     age = thisSub.age;
        %     
        %     % get age group
        %     I = cellfun(@(x) find(x==age), ageGroups, 'UniformOutput', false);
        %     ageGrp = find( ~cellfun('isempty', I));
        %     
        %     %loop through all trials
        %     for triIdx = 1:length( thisSub.latFix )
        %             
        %         block = ceil( triIdx/8);        
        %         
        %         offset = zeroOffset{subIdx}(1,triIdx);
        %         left = responseSum{subIdx}.outLeft(triIdx);
        %         
        %         % loop through all fixations
        %         sacT = NaN;
        %         sacAOI = NaN;                    
        %         for fixIdx = 1:length( thisSub.aoISeqAllFix{triIdx}) 
        %             fixT = thisSub.allFixTime{triIdx}(fixIdx);
        %             fixAOI = thisSub.aoISeqAllFix{triIdx}(fixIdx);
        %             
        %             % write to file
        %             tableLine = [ subIdx, age, ageGrp, triIdx, block, fixT, fixAOI, sacT, sacAOI, offset, left];
        %             dlmwrite( file, tableLine,'delimiter', '\t', '-append');
        %         end
        %         
        %         %loop through all saccades
        %         fixT = NaN;
        %         fixAOI = NaN;        
        %         for sacIdx = 1:length( thisSub.aoiSeqAllSac{triIdx})
        %             sacT = thisSub.allSacTime{triIdx}(sacIdx);
        %             sacAOI = thisSub.aoiSeqAllSac{triIdx}(sacIdx);
        %             
        %             %write to file
        %             tableLine = [ subIdx, age, ageGrp, triIdx, block, fixT, fixAOI, sacT, sacAOI, offset, left];
        %             dlmwrite( file, tableLine,'delimiter', '\t', '-append');
        %         end
        %         
        %     end % end trials             
        % end % end subjects
        % 
        %     

    end
end
    
% get last message send before start of fixation/saccade
% return NaN if no message before
function m = getLastMsg( msg, msgTime, evtTime )
    idx = find( cell2mat(msgTime) < evtTime, 1, 'last');
    if ~isempty( idx ); m = msg{idx};else m = NaN; end

end


% output a table line to a file, checking data type
function writeLine(fID,tableLine)

    for i1 =1:length( tableLine)
        if isa( tableLine{i1}, 'numeric') % print number
            fprintf(fID,'%f',tableLine{i1});
        else % else print string
            fprintf(fID,'%s',tableLine{i1});
        end
        if i1 ~= length( tableLine)
            fprintf(fID,'\t'); % tab
        end
    end
    fprintf(fID,'\n'); % newline               
end


% this splits the XY coordinates of things for convenience
function [trials, fixSac ] = splitXY(trials )

    % split 2d variables into x-y
    for i1 = 1:length(trials)
        fixSac(i1).fixDuration = trials(i1).fixDuration;
        fixSac(i1).fixStart = trials(i1).fixStart;
        fixSac(i1).fixEnd = trials(i1).fixEnd;
        fixSac(i1).pupil = trials(i1).pupil;
        fixSac(i1).sacDuration = trials(i1).sacDuration;
        fixSac(i1).sacStartTime = trials(i1).sacStartTime;
        fixSac(i1).sacEndTime = trials(i1).sacEndTime;
        fixSac(i1).sacAmp = trials(i1).sacAmp;
        fixSac(i1).sacVel = trials(i1).sacVel;
        
        %--------
        % if no fixations, just put empty thing, dont index
        if ~isempty(trials(i1).fixDuration)
            fixSac(i1).fixX = trials(i1).fixPos(1,:);  
            fixSac(i1).fixY = trials(i1).fixPos(2,:);              
        else  
            fixSac(i1).fixX = trials(i1).fixPos;  
            fixSac(i1).fixY = trials(i1).fixPos;              
        end
        if ~isempty( trials(i1).sacVel)
            fixSac(i1).sacStartPosX = trials(i1).sacStartPos(1,:);  
            fixSac(i1).sacStartPosY = trials(i1).sacStartPos(2,:);          
            fixSac(i1).sacEndPosX = trials(i1).sacEndPos(1,:);  
            fixSac(i1).sacEndPosY = trials(i1).sacEndPos(2,:);
        else
            fixSac(i1).sacStartPosX = trials(i1).sacStartPos;  
            fixSac(i1).sacStartPosY = trials(i1).sacStartPos;          
            fixSac(i1).sacEndPosX = trials(i1).sacEndPos;  
            fixSac(i1).sacEndPosY = trials(i1).sacEndPos;
        end
        %--------
        
        if isfield( trials,'fixAois')
            fixSac(i1).fixAois = trials(i1).fixAois;
            fixSac(i1).sacAois = trials(i1).sacAois;
        end
    end

    %remove unwanted fields for table
    trials = rmfield(trials,'fixPos');
    trials = rmfield(trials,'sacStartPos');
    trials = rmfield(trials,'sacEndPos');
% %     trials = rmfield(trials,'msg');
% %     trials = rmfield(trials,'msgTime');
    
    trials = rmfield(trials,'fixDuration');
    trials = rmfield(trials,'fixStart');
    trials = rmfield(trials,'fixEnd');
    trials = rmfield(trials,'pupil');
    trials = rmfield(trials,'sacDuration');
    trials = rmfield(trials,'sacStartTime');
    trials = rmfield(trials,'sacEndTime');
    trials = rmfield(trials,'sacAmp');
    trials = rmfield(trials,'sacVel');
    
    if isfield( trials,'fixAois')
        trials = rmfield(trials,'fixAois');
        trials = rmfield(trials,'sacAois');
    end    
end
                