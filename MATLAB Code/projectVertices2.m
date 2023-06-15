%% inputs: vertices (has the form {x y; x  y; x y;...}, axis ([x y] form)
%% ouputs: minmax (has the form [min max])
% minmax has the minimum and maximum projections of the vertices onto the axis

function minmax = projectVertices2(vertices, axis)
    min = Inf;
    max = -Inf;
    num_vertices = size(vertices{1,1});
    for i = 1:num_vertices
        vertex = vertices{1, 1}(i,:);
        projection = vertex(1, 1) * axis(1, 1) + vertex(1, 2) * axis(1, 2);
        
        if projection < min
            min = projection;
        end
        if projection > max
            max = projection;
        end
    end
    minmax = [min max];
end
