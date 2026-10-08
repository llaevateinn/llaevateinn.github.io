Task 3: 3D Plotting, Finding Isocontours and Critical Points (MATLAB)


Description: 
This MATLAB function 'plot3d' reads 3-dimensional data from a CSV file, generates
3D surface plots and iso-contours, and finds critical points (local minimum, local
maximum, saddle points, resp.) of the data within a specified tolerance. 


Requirements: 
- MATLAB (any recent version)
- CSV file of 3 columns


How to Run:
The function is designed to be called from the MATLAB console.
1. Basic usage with default parameters: 
   plot3d('filename.csv')
   This generates: 
   - A 3D plot of the CSV data.
   - The 2D projection of the iso-contours of the data. 
2. Advanced usage with optional parameters:
   plot3d('filename.csv','isocontour',[0 1 2],'isovalue',[0 1 2],...
   'tolerance',0.1,'criticalpoints',true)
   This generates:
   - A 3D plot of the CSV data together with isocontours and critical points.
   - The 2D projection of the iso-contour of given values. 


Optional Parameters: 
- 'isocontour'     :Array of isocontours to plot in 2D projection.
                    (default: 15 evenly spaced contours of Z)
- 'isovalue'       :Array of isovalues to plot in the 3D surface plot. 
                    Warning will occur when value exceeds the minimum or maximum of Z.
                    (default: none)
- 'criticalpoints' :true/false, whether to compute and display the critical points on
                    the 3D plot 
                    (default: false).
- 'tolerance'      :Tolerance for computing critical points.
                    (default: 0.007)


Example Output:
For the CSV file '2d_scalar_field.csv', running
    plot3d('2d_scalar_field.csv','isovalue',[0 1 2],'criticalpoints',true)
produces:
- A 3D surface plot with iso-contours at 0,1,2 and critical points
- A 2D projection showing the evenly spaced iso-contours
- A warning if any specified isovalue exceeds the data range:
  "Warning: The isovalue 2 exceeds the range of the function."
See 'example_output_2d.png' and 'example_output_3d.png' for the resulting plots. 