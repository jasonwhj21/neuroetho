%% inputs: rawDatafiltEllipses (output of createEllipses), outputPath, otherOrg
% rawDatafiltEllipses
% exp 1 -> frame_nums(arr)   dal_vertices(cell arr) other_vertices(cell arr)

% outputPath and otherOrg
% outputPath is a string of output path of figures for interactions, and
% otherOrg is a string of the other organism's name, which is used to name
% the files for the figures
%
%% outputs: rawDatafiltCollisions
% rawDatafiltCollisions is a cell array with expnum/2 rows (bc accounting 
% for both top and mirror views for collisions in each experiment) with each cell
% being a table with the following format
%  frame_nums (arr)        final_collisions (arr)
% Saves one file per experiment for collisions

function rawDatafiltCollisions = findCollision2(rawDatafiltEllipses, otherOrg)


%     ogstrt = strt;
% 
%     strt = (strt * 2) - 1;
%     nd = nd  * 2;
%     numExps = (nd - strt) + 1;

    % if I want to manually strt and nd based on files struct
     %strt = 16;
     %nd = 19;
     %ogstrt = 8;

    expnum = size(rawDatafiltEllipses, 1);
    rawDatafiltCollisionsTemp = cell(expnum, 1); % temporary collision data
    rawDatafiltCollisions = cell(ceil(expnum / 2), 1); % what I want to return
    
    %extract header indices where Dal and other vertices are stored
    header = rawDatafiltEllipses{1,1}.Properties.VariableNames;
    Dal_VerticesIdx = find(contains(header, 'dal_vertices')); 
    Other_VerticesIdx = find(contains(header, 'other_vertices'));
   
    %loop through all expts
    for i = 1:expnum 
        data = rawDatafiltEllipses{i,1};
        rows = size(data, 1);
        
        All_Dal_Vertices = data{:, Dal_VerticesIdx};
        All_Other_Vertices = data{:, Other_VerticesIdx};
        
        %loop through all rows in each expt
        for k = 1:rows

            %Dal and other ellipse vertices in frame k, assuming NaNs give NaNs
            Dal_Vertices = All_Dal_Vertices(k, 1);
            Other_Vertices = All_Other_Vertices(k, 1);      
            
            colliding = true;

            % x = k;
            % disp(x)

            for j = 1:20
                % mod to wrap around to first vertex for last edge
                v1 = Dal_Vertices{1, 1}(j,:);
                ind = mod(j, 20) + 1;
                v2 = Dal_Vertices{1, 1}(ind,:); 
                
                % segment between two vertices
                edge = v2 - v1;

                % the slope perpendicular to edge
                axis = [edge(1,2) -edge(1,1)]; 
                
                dalMinMaxProjections = projectVertices2(Dal_Vertices, axis);
                otherMinMaxProjections = projectVertices2(Other_Vertices, axis);

                % treating NaNs as no collision
                if (    dalMinMaxProjections(1,1) == Inf ||...
                        dalMinMaxProjections(1, 2) == -Inf ||...
                        otherMinMaxProjections(1, 1) == Inf || ...
                        otherMinMaxProjections(1, 2) == -Inf)    
                    colliding = false;
                    break;
                end
                
                if (dalMinMaxProjections(1,1) >= otherMinMaxProjections(1,2) ||...
                        otherMinMaxProjections(1,1) >= dalMinMaxProjections(1, 2))
                    colliding = false;
                    break;
                end
                
            end
            colliding_col_dal(k, 1) = colliding;
        end
        

      % getting axes from edges of Other polygon (ellipse)
      for k = 1:rows

            % Dal and other ellipse vertices in frame k, assuming NaNs give NaNs
            Dal_Vertices = All_Dal_Vertices(k, 1);
            Other_Vertices = All_Other_Vertices(k, 1);     
            
            colliding = true;
            
            for j = 1:20
                % mod to wrap around to first vertex for last edge
                v1 = Other_Vertices{1, 1}(j,:);
                ind = mod(j, 20) + 1;
                v2 = Other_Vertices{1, 1}(ind,:); 
                
                edge = v2 - v1;

                % the slope perpendicular to edge
                axis = [edge(1,2) -edge(1,1)]; 
                
                dalMinMaxProjections = projectVertices2(Dal_Vertices, axis);
                otherMinMaxProjections = projectVertices2(Other_Vertices, axis);
                
                % treating NaNs as no collision
                if (    dalMinMaxProjections(1,1) == Inf ||...
                        dalMinMaxProjections(1, 2) == -Inf ||...
                        otherMinMaxProjections(1, 1) == Inf ||...
                        otherMinMaxProjections(1, 2) == -Inf)    
                    colliding = false;
                    break;
                end

                if (dalMinMaxProjections(1,1) >= otherMinMaxProjections(1,2) ||...
                        otherMinMaxProjections(1,1) >= dalMinMaxProjections(1, 2))
                    colliding = false;
                    break;
                end
                
            end
            colliding_col_other(k, 1) = colliding;
      end
        
        frame_nums = [1:rows]';
        rawDatafiltCollisionsTemp{i, 1} = table(frame_nums, colliding_col_dal, colliding_col_other);
        
        clear colliding_col_dal
        clear colliding_col_other
    end


    % Now rawDatafiltCollisionsTemp is a cell array of expnum rows and 1
    % column, in each cell there is a table with the frame numbers in one
    % column, logical collision operators w.r.t dal in col 2, and logical
    % collision operators w.r.t other in col 3. The following lines will do
    % da_collision_col(col2) = true && col 3 == true, which will give a column
    % with 1 wherever there is a collision.

    header = rawDatafiltCollisionsTemp{1,1}.Properties.VariableNames;
    collidingColDalIdx = find(contains(header, 'colliding_col_dal'));
    collidingColOtherIdx = find(contains(header, 'colliding_col_other'));
    
    for r = 1:expnum %( but doing first 5 exps for now, so rawDatafiltEllipses will have only 10 cells filled)
        collision_data = rawDatafiltCollisionsTemp{r,1};
        da_collisions_col = collision_data{:,collidingColDalIdx} & collision_data{:, collidingColOtherIdx};
        % creates a new column in each table of rawDataCollisionsTemp called colliding_col_actual
        rawDatafiltCollisionsTemp{r,1}.colliding_col_actual = da_collisions_col;  
    end

    % Now we do, if colliding in top view and colliding in side view, then
    % colliding is true
    counter = 1;
    for c = 1:2:expnum
        rows = size(rawDatafiltCollisionsTemp{c, 1}, 1);

        top_data = rawDatafiltCollisionsTemp{c, 1}.colliding_col_actual;
        mirror_data = rawDatafiltCollisionsTemp{(c+1), 1}.colliding_col_actual;
        final_collisions = top_data & mirror_data;

        frame_nums = [1:rows]';
        rawDatafiltCollisions{counter, 1} = table(frame_nums, final_collisions);
        counter = counter + 1;
    end
        
    clear rawDatafiltCollisionsTemp
end

%     % rawDatafiltCollisions     format
%     % A cell column array with expnum/2 rows, each cell is a table of
%     % following       format
%     
%     % frame_nums(arr)       final_collisions(arr)(logical arr with 1s as collisions)
%     
%     % creates figures
% 
% % totExp = numExps/2;
%     for y = 1:numExps/2   % should be 1:expnum/2    
% 
%         f = figure;
% 
%         % 2 -> final_collisions col is col 2, using parentheses because the col is an arr
%         collision_data = rawDatafiltCollisions{y, 1}{:,2};   
%         
%         frame_nums = rawDatafiltCollisions{y,1}{:, 1};
%         time_col = frame_nums / 3600;
%         
% %         subplot(totExp,1,y)
%         bar(time_col, logical(collision_data),...
%             'FaceColor',[0.6350 0.0780 0.1840],'EdgeColor',[0.2 .2 .2],'LineWidth',1.5);
%         
%         str_num = sprintf('%d', ogstrt);
%         da_str = strcat('Experiment ', str_num);
%         title(da_str);
%   
% 
%         %pretty figure settings
%         set(gca, ...
%             'LineWidth', 2,...
%             'XColor', 'k',...
%             'YColor', 'k',...
%             'FontName', 'Arial',...
%             'FontSize', 16,...
%             'Box', 'off');
%         set(gca, 'Color', 'w');
%         set(gcf, 'Color', 'w');
%         %set figure window size
%         set(gcf, 'Position',  [300, 300, 1200, 250]); 
%         offsetAxes(gca);
%         set(gca,'ytick',[])
%         set(gca,'TickDir','out');
%         ylim([0.01,1]);
% 
% 
% %         filename = [da_str,' ', otherOrg, ' Interactions'];
% %         saveas(f, fullfile(outputPath, filename),'fig');
% 
%         ogstrt = ogstrt + 1;
%     end
