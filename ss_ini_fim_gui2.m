       
%%
xid=evalin('base','xid');
yid=evalin('base','yid');
bias=evalin('base','bias');
func_type=evalin('base','func_type');
initial_setting=evalin('base','initial_setting');
WG=evalin('base','WG');
xid_max=evalin('base','xid_max');
xid_min=evalin('base','xid_min');
number_of_iteration =evalin('base','number_of_iteration');
n=number_of_iteration;
xval=evalin('base','xval');
size_val=evalin('base','size_val');
no_ini_samples_fim=evalin('base','no_ini_samples_fim');

[xData, yData] = prepareCurveData( xid, yid+bias );
             assignin('base', 'xData',xData);
             assignin('base', 'yData',yData);

            if func_type == 0
                ft = fittype( 'a+(b-a)/(1+10^((c-x)*d))', 'independent', 'x', 'dependent', 'y' );
            else
                ft = fittype( 'log(a+(b-a)/(1+10^((c-x)*d)))', 'independent', 'x', 'dependent', 'y' );
            end
            assignin('base', 'ft',ft);
            
             paramLB=evalin('base','paramLB');
             paramUB=evalin('base','paramUB');
            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Display = 'Off';
            opts.Algorithm = 'Trust-Region';
            opts.Lower = paramLB;%[1e-07+bias 0.0001+bias xid_min .01];
            opts.Upper = paramUB;%[0.00001+bias 0.01+bias xid_max Inf];
            opts.Robust = 'LAR';%'Bisquare';
             assignin('base', 'opts',opts);
             
            
             
            if initial_setting == 0
                opts.StartPoint =xid_max*rand(1,4);
            else
                opts.StartPoint =theta_est(n-1,:);
            end
            opts.Weights=WG;
                % Fit model to data.
                if func_type == 0
                    %[fitresult, gof] = fit( xData, yData, ft, opts );
                    [fitresult, gof] = fit( xData, yData, ft, opts );
                else
                    [fitresult, gof] = fit( xData, log(yData), ft, opts );
                end
                
           % theta_est(n,:)=[fitresult.a-bias fitresult.b-bias ];
           
           theta_est(n,:)=[fitresult.a-bias fitresult.b-bias fitresult.c fitresult.d];
           assignin('base','theta_est',theta_est);
            % added October 2016 for computations of error
            er_theta(n,:)=(theta_est(n,:)-handles.theta_true')./handles.theta_true';
            assignin('base','er_theta',er_theta);
   
            yest_xid(n,1:n)=theta_est(n,1) + ...
            (theta_est(n,2)-theta_est(n,1)) ./ (1 + 10.^((theta_est(n,3)-xid)*theta_est(n,4)));
            yest_val(n,1:size_val)=theta_est(n,1) + ...
            (theta_est(n,2)-theta_est(n,1)) ./ (1 + 10.^((theta_est(n,3)-xval)*theta_est(n,4)));
            
            
            % --> initial FIM
            sigma_y=evalin('base','sigma_y');
            [y,FIM]=SSfim_cost_modified(no_ini_samples_fim,n,0,xid,theta_est(n,:),zeros(1,4),sigma_y,0);% zero means initial stage
            minusdetFIM(n)=y;
            
                      
            var_theta_est(n,1)=mean((theta_est((no_ini_samples_fim:n),1)-mean(theta_est(:,1))).^2);
            var_theta_est(n,2)=mean((theta_est((no_ini_samples_fim:n),2)-mean(theta_est(:,2))).^2);
            var_theta_est(n,3)=mean((theta_est((no_ini_samples_fim:n),3)-mean(theta_est(:,3))).^2);
            var_theta_est(n,4)=mean((theta_est((no_ini_samples_fim:n),4)-mean(theta_est(:,4))).^2);
            