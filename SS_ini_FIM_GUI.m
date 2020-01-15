 
 

xid_min=0;
xid_max=1;
Total_runs=1;
plot_animation = 1; %  To run saving animation, set this to 1
save_er_plot_after_each_run=1; %save 
total_theta_true=[];
total_sigma_y=[];
fmr=evalin('base','fmr');% threshold value for bad fit detection
sac=evalin('base','sac');% threshold value to detect whether estimation is saturated
%% variables for evaluations
theta1_F=[];
theta2_F=[];
theta3_F=[];
theta4_F=[];

er_theta1_F=[];
er_theta1_F_conv=[];
er_theta1_F_final_iter=[];

er_theta2_F=[];
er_theta2_F_conv=[];
er_theta2_F_final_iter=[];

er_theta3_F=[];
er_theta3_F_conv=[];
er_theta3_F_final_iter=[];

er_theta4_F=[];
er_theta4_F_conv=[];
er_theta4_F_final_iter=[];

no_of_runs_F_conv=0;
theta_F_conv=[];
iter_F_conv=[];

outSim=0; %record saturated runs; if it is empty --> runs are OK
%%
% this variable my be usless and removable!
xid_ga=[];% input computed by genetic algorithm 
xid_ms=[];% input computed by multiple start
xid_gs=[];% input computed by global search
fval_gs=[];
fval_ga=[];% cost function genetic algorithm ; cost_func=det(FIM)
fval_ms=[];

yid_new=[]; % output vector asscoiated xid_new,
yid_paper=[];% used for plot

theta_est=[0 0 0 0];
var_theta_est=[]; % variance of estimations;for the computation of Cramer-Rao bound
yest_xid=[]; % output of model by using FIM-SPE estimation results and xid 

CRB_true=[]; % Cramer-Rao bounds computed using theta_est
var_CRB=[];  % ????
rtheta_converge_flag=[]; % Memory of how many consequative convergence happend
                         % It is used in SS_stopping_rtheta.m
er_theta=[];% Absolute Relative Error (ARE) using FIM-SPE
 eyL_th=100;% for fit modification
        em_th=150;
        Weight_gain1=1;%1e2;
        Weight_gain2=1;
        WG_th=.5;
        bias=0;%1e-3;
        no_ini_samples_fim=handles.nxeq0;
        no_next_iter=136;
        total_no_iterations=no_ini_samples_fim+no_next_iter;
        Nmax=total_no_iterations;
%         paramLB=[-7 -4 .01 .01];% lower limit of estimation, applies when trust-region method is used
%         paramUB=[-3 -1 1 100];% upper limit of estimation
        paramLB=evalin('base','paramLB');
             paramUB=evalin('base','paramUB');
        %paramUB=[7+bias 5+bias];  
        xval=linspace(0,handles.xid_max,100);% for validation of estimated models
        size_val=length(xval);
        success_stop=0;
        sucess_flag=0;
        % FIM case
        %xid=[];
        yid=[];
        yest_val=[]; % output of model by using FIM-SPE estimation results and xid_val
        fit_modification_flag=[];
        WG=[];% Weightings for curve fittinG
        WG_gain=[];
         
        CRB=[];
        var_theta_est(no_ini_samples_fim,:)=[0 0 0 0];
        % variance of estimations; for the computation of Cramer-Rao bound
     
            func_type=1;      % choose 0 to estimate the actual function, and 1 to estimate the logarithm of the function  
            initial_setting=0;% curve fitting initilaization method: choose 0 for random initialization and 1 for using the most recent estimate  
            opt_method=1;     % Choose the optimization algorithm of FIM (0 Genetic Algorithm | 1 GlobalSearch-default | 2 MultiStart)
            same_xid_ini=1;
 
        rtheta_converge_flag(1:4)=[0 0 0 0];
        iter_rtheta_converged=[];% iterations where FIM-SPE converges

            %$$$$$$$$
            xid_ini=evalin('base', 'xeq0');
            xid=xid_ini;
            assignin('base', 'xid',xid)
            xid_paper=xid;
            xid_new=xid_ini;
            
            %$$$$$$$$$
            no_ini_samples_fim=evalin('base', 'nxeq0');
            
            
            %4
            n=handles.nxeq0;
           
           initial=handles.initial;
           exportfromgui=evalin('base','initial');
           logyid_new(1:n)= log(exportfromgui(2,1:handles.nxeq0));
           
           
            yid_new(1:n)=exp(logyid_new(1:n));
            assignin('base', 'yid_new',yid_new);
            yid_paper=yid_new;
            handles.yid_paper=yid_paper;
            assignin('base','yid_paper',handles.yid_paper);
            
            xid=sort(xid);
             assignin('base', 'xid',xid);
             assignin('base', 'xid_new',xid_new);
            
            % fit
            
             assignin('base', 'xid',xid);
             assignin('base', 'yid',yid);
             xid=evalin('base','xid');
             yid=handles.yid_paper;
             
            
            %% 22-7-98
            %[xData, yData] = prepareCurveData( initial(1,:), log10(initial(2,:)) );
            1
            handles.xid_fim_baseline
            handles.yid_fim_baseline
            
            [handles.xData,handles.yData] = prepareCurveData(handles.xid_fim_baseline,log10(10^-6*handles.yid_fim_baseline));
            %% Seeing
            handles.xid_fim_baseline
             assignin('base', 'xData',handles.xData);
             assignin('base', 'yData',handles.yData);
            
            ZZZZZ=handles.yData
                ft = fittype( 'a+(b-a)/(1+10^((c-x)*d))', 'independent', 'x', 'dependent', 'y' );
           
            assignin('base', 'ft',ft);

            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Display = 'Off';
            opts.Algorithm = 'Trust-Region';
            opts.Lower = paramLB;%[1e-07+bias 0.0001+bias xid_min .01];
            opts.Upper = paramUB;%[0.00001+bias 0.01+bias xid_max Inf];
            opts.Robust = 'LAR';%'Bisquare';
             assignin('base', 'opts',opts);
             
           
                opts.StartPoint =paramLB+ (paramUB-paramLB).*rand(1,4);
           
            
              
                    [fitresult, gof] = fit( handles.xData, handles.yData, ft, opts );
                
                
 
          % Leila Aug17-2018
           n=handles.nxeq0;
            m=n+3;
            
           
           
           theta_est(m,:)=[fitresult.a-bias fitresult.b-bias fitresult.c fitresult.d];
           test_p1=theta_est;
           handles.theta_est(m,:)=[fitresult.a-bias fitresult.b-bias fitresult.c fitresult.d];
           assignin('base','theta_est',handles.theta_est);
           set(handles.uitable1,'Data',theta_est(end-1:end,:));
            % added October 2016 for computations of error
            er_theta(m,:)=(theta_est(m,:)-handles.theta_true')./handles.theta_true';
            assignin('base','er_theta',er_theta);
            
%              xid_max=evalin('');
             handles.xval=linspace(0,handles.xid_max,100);% for validation of estimated models
             assignin('base', 'xval',handles.xval); 
 
            
%             yest_xid(n,1:n)=theta_est(m,1)+(theta_est(m,2)-theta_est(m,1)) ./ (1 + 10.^((theta_est(m,3)-xid)*theta_est(m,4)));
            yest_val(m,1:size_val)=theta_est(m,1) + ...
            (theta_est(m,2)-theta_est(m,1)) ./ (1 + 10.^((theta_est(m,3)-xval)*theta_est(m,4)));
             handles.yest_val=yest_val;
             
        
             assignin('base', 'yest_val',handles.yest_val); 
%              handles.yest_xid=yest_xid;
%              assignin('base','yest_xid',handles.yest_xid);
            
            
            % --> initial FIM
            sigma_y=evalin('base','sigma_y');
%             [y,FIM]=SSfim_cost_modified(no_ini_samples_fim,n,0,xid,theta_est(m,:),zeros(1,4),sigma_y,0);% zero means initial stage
%             minusdetFIM(n)=y;
            %leila
          
%             var_theta_est=evalin('base','var_theta_est');      
%             var_theta_est(m,1)=mean((theta_est((no_ini_samples_fim:m),1)-mean(theta_est(:,1))).^2);
%             var_theta_est(m,2)=mean((theta_est((no_ini_samples_fim:m),2)-mean(theta_est(:,2))).^2);
%             var_theta_est(m,3)=mean((theta_est((no_ini_samples_fim:m),3)-mean(theta_est(:,3))).^2);
%             var_theta_est(m,4)=mean((theta_est((no_ini_samples_fim:m),4)-mean(theta_est(:,4))).^2);
           
%             handles.var_theta_est=var_theta_est; % variance of estimations;for the computation of Cramer-Rao bound
%             assignin('base', 'var_theta_est',handles.var_theta_est);


            