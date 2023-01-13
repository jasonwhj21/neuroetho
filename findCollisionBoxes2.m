%% inputs: rawDatafiltBoxes
% Two cell arrays, each with expnum number of rows. For the first cell
% array, each element is a table with at least one column called
% dal_Vertices. For the second cell array, each element is a table with at
% least one column called other_Vertices
%
%% outputs: rawDatafiltCollisions
% rawDatafiltCollisions is a cell array with expnum/2 rows (bc accounting 
% for both top and mirror views for collisions in each experiment) with each cell
% being a table with the following format
%  frame_nums (arr)        final_collisions (arr)
% Saves one file per experiment for collisions
%% Explanation
% Instead of comparing two polygons, the function must now loop through
% every combination of polygons from both organisms to check for overlap.
% Otherwise, it follows the same principle as before.

function rawDatafiltCollisions = findCollisionBoxes2(rawDatafiltBoxes, otherEllipses)

%     ogstrt = strt;
% 
%     strt = (strt * 2) - 1;
%     nd = nd  * 2;
%     numExps = (nd - strt) + 1;

    % if I want to manually strt and nd based on files struct
     %strt = 16;
     %nd = 19;
     %ogstrt = 8;

    expnum = size(rawDatafiltBoxes, 1);
    rawDatafiltCollisionsTemp = cell(expnum, 1); % temporary collision data
    rawDatafiltCollisions = cell(ceil(expnum / 2), 1); % what I want to return

    
   
    %loop through all expts
    for i = 1:expnum 
        dal = rawDatafiltBoxes{i,1};
        other = otherEllipses{i,1};
        rows = size(dal, 1);
        
        All_Dal_Vertices = dal.dal_Vertices;
        All_Other_Vertices = other.other_vertices;
        dal_poly = size(All_Dal_Vertices,2); %Is this the right dimension?
        other_poly = size(All_Other_Vertices, 2); %These two variables are the number of polygons reprsenting each insect, inferred by the dims of data
        
        collide_or_not = zeros(rows,1);
        
        %loop through all rows in each expt
        for k = 1:rows
            
            %Dal and other ellipse Vertices in frame k, assuming NaNs give NaNs
            %This is slightly difference than before, now that the Vertices
            %column can itself have multiple columns representing multiple
            %polygons 
            Dal_Vertices = All_Dal_Vertices(k, :); 
            Other_Vertices = All_Other_Vertices(k, :);      
            dal_how_many_Vertices = size(Dal_Vertices{1,1}, 1); %These two are the number of Vertices per polygon, again inferred from dims of data
            other_how_many_Vertices = size(Other_Vertices{1,1}, 1);
            collidings = [];

            % x = k;
            % disp(x)
            
            for l = 1:dal_poly
                for m = 1:other_poly
                    colliding = true;
                    for n = 1:dal_how_many_Vertices
                        v1 = Dal_Vertices{1, l}(n, :);
                        ind = mod(n,dal_how_many_Vertices) + 1;
                        v2 = Dal_Vertices{1, l}(ind, :);
                        
                        edge = v2 - v1;

                        axis = [edge(1,2) -edge(1,1)]; 

                        dalMinMaxProjections = projectVertices2(Dal_Vertices(1, l), axis);
                        otherMinMaxProjections = projectVertices2(Other_Vertices(1, m), axis);

                        if (    dalMinMaxProjections(1,1) == Inf ||...
                            dalMinMaxProjections(1, 2) == -Inf ||...
                            otherMinMaxProjections(1, 1) == Inf || ...
                            otherMinMaxProjections(1, 2) == -Inf)    
                            colliding = false;           
                        end

                        if (dalMinMaxProjections(1,1) >= otherMinMaxProjections(1,2) ||...
                            otherMinMaxProjections(1,1) >= dalMinMaxProjections(1, 2))
                            colliding = false;
                            
                        end
                    end

                    for g = 1:other_how_many_Vertices
                        v1 = Other_Vertices{1, m}(g, :);
                        ind = mod(g,other_how_many_Vertices) + 1;
                        v2 = Other_Vertices{1, m}(ind, :);
                        
                        edge = v2 - v1;

                        axis = [edge(1,2) -edge(1,1)]; 

                        dalMinMaxProjections = projectVertices2(Dal_Vertices(1, l), axis);
                        otherMinMaxProjections = projectVertices2(Other_Vertices(1, m), axis);

                        if (    dalMinMaxProjections(1,1) == Inf ||...
                            dalMinMaxProjections(1, 2) == -Inf ||...
                            otherMinMaxProjections(1, 1) == Inf || ...
                            otherMinMaxProjections(1, 2) == -Inf)    
                            colliding = false;           
                        end

                        if (dalMinMaxProjections(1,1) >= otherMinMaxProjections(1,2) ||...
                            otherMinMaxProjections(1,1) >= dalMinMaxProjections(1, 2))
                            colliding = false;
                            
                        end
                    end
                    collidings(end+1) = colliding;
                end
            end
            collide_or_not(k,1) = any(collidings);
        end
       

        
        frame_nums = [1:rows]';
        rawDatafiltCollisionsTemp{i, 1} = table(frame_nums, collide_or_not);
        
        
    end

    % Now we do, if colliding in top view and colliding in side view, then
    % colliding is true
    counter = 1;
    for c = 1:2:expnum
        rows = size(rawDatafiltCollisionsTemp{c, 1}, 1);

        top_data = rawDatafiltCollisionsTemp{c, 1}.collide_or_not;
        mirror_data = rawDatafiltCollisionsTemp{(c+1), 1}.collide_or_not;
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
