function plot3d(filename, varargin)

    data = readmatrix(filename);
    crit_points = false;
    tol = 0.007;
    isovalue = [];
    isocontour = [];
    
    if size(data,2) ~= 3
        warning('Data should have 3 columns: x, y, z. ')
    end
    
    x = data(:,1);
    y = data(:,2);
    z = data(:,3);

    for i = 1:2:length(varargin)
        varname = char(varargin(i));
        varvalue = varargin(i+1);
        switch lower(varname)
            case 'isocontour'
                isocontour = double(varvalue{1});
            case 'isovalue'
                isovalue = double(varvalue{1});
            case 'criticalpoints'
                crit_points = logical(varvalue{1});
            case 'tolerance'
                tol = double(varvalue{1});
            otherwise
                warning('Unknown parameter name: %s', varname)
        end
    end

    [X, Y] = meshgrid(unique(x), unique(y));
    Z = griddata(x, y, z, X, Y);

    z_min = min(z);
    z_max = max(z);

    if isempty(isocontour)
        figure
        contour(X, Y, Z, 15);
    else
        figure
        hold on;
        for i = 1:length(isocontour)
            if isocontour(i) > z_max || isocontour(i) < z_min
                warning('The isovalue %d exceeds the range of the function. ', isocontour(i))
            end
            contour(X,Y,Z,[isocontour(i),isocontour(i)],'ShowText','on');
        end

    end

    figure
    h = surf(X, Y, Z);
    axis equal
    h.FaceAlpha = 1;
    h.EdgeColor = 'none';
    xlabel('X'); ylabel('Y'); zlabel('Z');
    colorbar east;
    hold on;

    color_isocontour = ['r' 'g' 'b' 'flat'];

    if ~isempty(isovalue)
        for i = 1:length(isovalue)
            if isovalue(i) > z_max || isovalue(i) < z_min
                warning('The isovalue %d exceeds the range of the function. ', isovalue(i))
            end
            contour3(X,Y,Z,[isovalue(i) isovalue(i)],color_isocontour(mod(i,4)), ...
                'LineWidth',3,...
                'ShowText','on');
        end
    end

    if crit_points == 1
        [fx, fy] = gradient(Z);
        crit_pt = find(abs(fx)<tol & abs(fy)<tol);

        [fxx, fxy] = gradient(fx, X(1,:), Y(:,1));  % ∂²Z/∂X², ∂²Z/∂X∂Y
        [fyx, fyy] = gradient(fy, X(1,:), Y(:,1));
        D = fxx .* fyy - fxy.^2;

        cl = cell(size(crit_pt));

        for i = 1:length(crit_pt)
            if D(crit_pt(i)) < 0
                cl{i} = 'saddle';
            elseif fxx(crit_pt(i)) > 0
                cl{i} = 'min';
            else
                cl{i} = 'max';
            end
        end
    

        classes = {'inconclusive','saddle','min','max'};
        colors = {'k','y','magenta','flat'};

        for i=1:length(classes)
            idx = strcmp(cl,classes{i});
            if all(idx==0)==false
                %idx_pt = [double(xcrit(idx)),double(ycrit(idx)),cell2mat(crit_val(idx))];
                idx_pt = [X(crit_pt(idx)),Y(crit_pt(idx)),Z(crit_pt(idx))];
                scatter3(idx_pt(:,1),idx_pt(:,2),idx_pt(:,3),'ko','MarkerFaceColor',colors{i}, ...
                    'LineWidth',1)
                hold on;
            end
        end
        legend({'','saddle point','minimum','maximum'})
    end
end