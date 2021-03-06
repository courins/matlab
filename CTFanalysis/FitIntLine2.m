function cf_ = FitIntLine2(xx,y,upperLimit,lowerLimit)
%CREATEFIT Create plot of data sets and fits
%   CREATEFIT(XX,Y)
%   Creates a plot, similar to the plot in the main Curve Fitting Tool,
%   using the data that you provide as input.  You can
%   use this function with the same data you used with CFTOOL
%   or with different data.  You may want to edit the function to
%   customize the code and this help message.
%
%   Number of data sets:  1
%   Number of fits:  1

% Data from data set "y vs. xx":
%     X = xx:
%     Y = y:
%     Unweighted

% Auto-generated by MATLAB on 16-Jun-2011 15:04:15

% Default arguments.
if nargin < 4
    lowerLimit = -10;
end

% Set up figure to receive data sets and fits
f_ = clf;
figure(f_);
set(f_,'Units','Pixels','Position',[78 339 674 474]);
% Line handles and text for the legend.
legh_ = [];
legt_ = {};
% Limits of the x-axis.
xlim_ = [Inf -Inf];
% Axes for the plot.
ax_ = axes;
set(ax_,'Units','normalized','OuterPosition',[0 0 1 1]);
set(ax_,'Box','on');
axes(ax_);
hold on;

% --- Plot data that was originally in data set "y vs. xx"
xx = xx(:);
y = y(:);
h_ = line(xx,y,'Parent',ax_,'Color',[0.333333 0 0.666667],...
    'LineStyle','none', 'LineWidth',1,...
    'Marker','.', 'MarkerSize',12);
xlim_(1) = min(xlim_(1),min(xx));
xlim_(2) = max(xlim_(2),max(xx));
legh_(end+1) = h_;
legt_{end+1} = 'y vs. xx';

% Nudge axis limits beyond data limits
if all(isfinite(xlim_))
    xlim_ = xlim_ + [-1 1] * 0.01 * diff(xlim_);
    set(ax_,'XLim',xlim_)
else
    set(ax_, 'XLim',[22.75, 252.25]);
end

% --- Create fit "fit 1"
%fo_ = fitoptions('method','NonlinearLeastSquares','Lower',[0 0 0 lowerLimit lowerLimit lowerLimit lowerLimit lowerLimit lowerLimit 0.00015200000000000000837],'Upper',[upperLimit upperLimit upperLimit upperLimit upperLimit upperLimit upperLimit upperLimit upperLimit 0.00015449999999999998782]);
fo_ = fitoptions('method','NonlinearLeastSquares','Lower',[0 0 0 lowerLimit lowerLimit lowerLimit lowerLimit  0.000152],'Upper',[upperLimit upperLimit upperLimit upperLimit upperLimit upperLimit upperLimit 0.000154]);
ok_ = isfinite(xx) & isfinite(y);
if ~all( ok_ )
    warning( 'GenerateMFile:IgnoringNansAndInfs',...
        'Ignoring NaNs and Infs in data.' );
end
%st_ = [0.85723149109189666905 0.80710848995778283754 0.61563356375509603602 0.65472953790691790221 0.29221618960297668366 0.37122021385674686123 0.79708000477068841061 0.79933879736335800015 0.52786670096744892078 0.00015349999999999999062 ];
st_ = [0.85723149109189666905 0.80710848995778283754 0.61563356375509603602 0.65472953790691790221 0.29221618960297668366 0.37122021385674686123 0.79708000477068841061 0.00015349999999999999062 ];
set(fo_,'Startpoint',st_);
%ft_ = fittype('a*exp(-b2*pf*x^2-b1*sqrt(pf*x^2))*abs(sin(pf*x^2))+c+d*sqrt(pf*x^2)+ee*pf*x^2+f*sqrt(pf*x^2)^3+g*sqrt(pf*x^2)^4+h*sqrt(pf*x^2)^5',...
%    'dependent',{'y'},'independent',{'x'},...
%    'coefficients',{'a', 'b1', 'b2', 'c', 'd', 'ee', 'f', 'g', 'h', 'pf'});
ft_ = fittype('a*exp(-b2*pf*x^2-b1*sqrt(pf*x^2))*abs(sin(pf*x^2))+c+d*sqrt(pf*x^2)+ee*pf*x^2+f*sqrt(pf*x^2)^3',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'a', 'b1', 'b2', 'c', 'd', 'ee', 'f', 'pf'});

% Fit this model using new data
cf_ = fit(xx(ok_),y(ok_),ft_,fo_);
% Alternatively uncomment the following lines to use coefficients from the
% original fit. You can use this choice to plot the original fit against new
% data.
%    cv_ = { 67.35247061236819377, 1.1689309520566053546, 7.8824124452660304446e-06, 12.416756312056888234, -9.9998081546681518716, 2.222078356133120991, -1.6463001466666293826, 1.1727805205226842222, -0.21654439310043227529, 0.00015429370267833054215};
%    cf_ = cfit(ft_,cv_{:});

% Plot this fit
h_ = plot(cf_,'fit',0.95);
set(h_(1),'Color',[1 0 0],...
    'LineStyle','-', 'LineWidth',2,...
    'Marker','none', 'MarkerSize',6);
% Turn off legend created by plot method.
legend off;
% Store line handle and fit name for legend.
legh_(end+1) = h_(1);
legt_{end+1} = 'fit 1';

% --- Finished fitting and plotting data. Clean up.
hold off;
% Display legend
leginfo_ = {'Orientation', 'vertical', 'Location', 'NorthEast'};
h_ = legend(ax_,legh_,legt_,leginfo_{:});
set(h_,'Interpreter','none');
% Remove labels from x- and y-axes.
xlabel(ax_,'');
ylabel(ax_,'');
