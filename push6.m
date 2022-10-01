




%% Preallocation

xid_new=evalin('base','xid_new');
xid_paper=[];
yid_newGUI=handles.yid_fim_baseline(handles.number_of_iteration);

handles.number_of_iteration=evalin('base','number_of_iteration');
yid_paper=evalin('base','yid_paper');
xid=evalin('base','xid');
yid=evalin('base','yid');
bias=evalin('base','bias');
func_type=evalin('base','func_type');
initial_setting=evalin('base','initial_setting');

xid_max=evalin('base','xid_max');
xid_min=evalin('base','xid_min');
number_of_iteration =evalin('base','number_of_iteration');
number_of_push=evalin('base','number_of_push');
nxeq0=evalin('base','nxeq0');
n=(nxeq0)+number_of_iteration;
test_p2=n
xval=evalin('base','xval');
size_val=evalin('base','size_val');
no_ini_samples_fim=evalin('base','no_ini_samples_fim');
sigma_y=evalin('base','sigma_y');
theta_true=evalin('base','theta_true');
FIM=evalin('base','FIM');
table_var=evalin('base','table_var');

pdpnts=evalin('base','pdpnts');
poldfit=evalin('base','poldfit');
pnewfit=evalin('base','pnewfit');
%pnewpoit=evalin('base','pnewpoit');

xidnm1=evalin('base','xidnm1');
yidnm1=evalin('base','yidnm1');
fmr=evalin('base','fmr');% threshold value for bad fit detection
sac=evalin('base','sac');% threshold value to detect whether estimation is saturated
plot_animation =1;
theta_est=evalin('base','theta_est');
yest_val=evalin('base','yest_val');

handles.yid_fim_baseline=evalin('base','yid_fim_baseline');
handles.xid_fim_baseline=evalin('base','xid_fim_baseline');


%%
handles.xidnm1=xid_fim_baseline;
handles.yidnm1=yid_fim_baseline;
xidnm1=xid_fim_baseline;
yidnm1=yid_fim_baseline;

           xid=[xid xid_new(end)];
           xid_paper=[xid_paper xid_new(end)];
           xid=sort(xid);
           handles.xid=xid;
           assignin('base','xid',handles.xid);
           i_xidnew=find(xid_fim_baseline==xid_new(end))
       
            logyid_new(n)=log(yid_newGUI);
            yid_new(n)=exp(logyid_new(n)); 
            yid_paper=[yid_paper yid_new(n)];
           
%            if isempty(i_xidnew)~= 1 && i_xidnew <= length(yid)
%                 if i_xidnew(1) == 1
%                     yid=[yid_new(end) yid];
%                
%                 elseif i_xidnew(1) == n
%                     yid=[yid yid_new(end)];
%                
%                 else
%                     y_var0=evalin('base','y_var0');
%                     yidtemp=y_var0;
%                     yid=[yidtemp(1:i_xidnew(1)-1) yid_new(end) yidtemp(i_xidnew(1):end)];
%                 end
%            else
%                y_var0=evalin('base','y_var0');
%                yidtemp=y_var0;
%                yid=yid;%[yidtemp(1:i_xidnew(1)-1) yid_new(end) yidtemp(i_xidnew(1):end)];
%                %WG=[WG(1:i_xidnew-1) WG_gain(end) WG(i_xidnew:end)];
%            end
           
         %leila 15-4-96
        
         handles.yid=yid;
         assignin('base','yid',handles.yid);
         
         %% estimate theta
                
                % using fit
               
                 handles.yid_fim_baseline=evalin('base','yid_fim_baseline');
                 handles.xid_fim_baseline=evalin('base','xid_fim_baseline');
                  
                 handles.xid_fim_baseline
                 
                 handles.yid_fim_baseline

         [handles.xData, handles.yData] = prepareCurveData( handles.xid_fim_baseline, log10(10^-6*handles.yid_fim_baseline) );
             assignin('base', 'xData',handles.xData);
             assignin('base', 'yData',handles.yData);

            
                ft = fittype( 'a+(b-a)/(1+10^((c-x)*d))', 'independent', 'x', 'dependent', 'y' );
           
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
             
            
             
            
                opts.StartPoint =paramLB+ (paramUB-paramLB).*rand(1,4);
           
                   
                    [fitresult, gof] = fit( handles.xData, handles.yData, ft, opts );
              
                 
          
                 theta_est(n,:)=[fitresult.a-bias fitresult.b-bias fitresult.c fitresult.d];
                 handles.theta_est(n,:)=[fitresult.a-bias fitresult.b-bias fitresult.c fitresult.d];
                 assignin('base','theta_est',handles.theta_est);

          
           %% avoid saturation
             
            
           
            if abs(theta_est(n,1) - paramLB(1))<sac || abs(theta_est(n,2)-paramLB(2))<sac || abs(theta_est(n,3) - paramLB(3))<0.1*sac || abs(theta_est(n,4)-paramLB(4))<sac || abs(theta_est(n,1)-paramUB(1))<sac || abs(theta_est(n,2)-paramUB(2))<sac  || abs(theta_est(n,3)-paramUB(3))<0.1*sac || abs(theta_est(n,4)-paramUB(4))<sac
                    %opts.StartPoint =xid_max*rand(1,2);%theta_est(n-1,:);
                    opts.StartPoint =paramLB+ (paramUB-paramLB).*rand(1,4);%theta_est(n-1,:);
                   
                        [fitresult, gof] = fit( handles.xData, handles.yData, ft, opts );
                   
                    %theta_est(n,:)=[fitresult.a-bias fitresult.b-bias ];
                     theta_est(n,:)=[fitresult.a-bias fitresult.b-bias fitresult.c fitresult.d];
                     handles.theta_est(n,:)=[fitresult.a-bias fitresult.b-bias fitresult.c fitresult.d];
                     assignin('base','theta_est',handles.theta_est);
                  
                         if abs(theta_est(n,1) - paramLB(1))<sac || abs(theta_est(n,2)-paramLB(2))<sac || abs(theta_est(n,3) - paramLB(3))<0.1*sac || abs(theta_est(n,4)-paramLB(4))<sac || abs(theta_est(n,1)-paramUB(1))<sac || abs(theta_est(n,2)-paramUB(2))<sac  || abs(theta_est(n,3)-paramUB(3))<0.1*sac || abs(theta_est(n,4)-paramUB(4))<sac
                        %opts.StartPoint =xid_max*rand(1,2);%theta_est(n-1,:);
                        opts.StartPoint =paramLB+ (paramUB-paramLB).*rand(1,4);
                       
                            [fitresult, gof] = fit( handles.xData, handles.yData, ft, opts );
                        
                        %theta_est(n,:)=[fitresult.a-bias fitresult.b-bias ];
                         
                        theta_est(n,:)=[fitresult.a-bias fitresult.b-bias fitresult.c fitresult.d];
                        handles.theta_est(n,:)=[fitresult.a-bias fitresult.b-bias fitresult.c fitresult.d];
                        assignin('base','theta_est',handles.theta_est);
                        
         
                         
                    end
             end
 
            if n>10%no_ini_samples_fim+3
                %theta_est_ave(n,:)=1/3.*(theta_est(n-1,:)+theta_est(n-2,:)+theta_est(n-3,:));
                theta_est_ave(n,:)=theta_est(n-1,:);
                er_a_abs_ave(n)=abs(abs(theta_est(n,1))-abs(theta_est_ave(n,1)));
                er_b_abs_ave(n)=abs(abs(theta_est(n,2))-abs(theta_est_ave(n,2)));
                er_c_abs_ave(n)=abs(abs(theta_est(n,3))-abs(theta_est_ave(n,3)));
                er_d_abs_ave(n)=abs(abs(theta_est(n,4))-abs(theta_est_ave(n,4)));
            
            
                if er_a_abs_ave(n) > fmr || er_b_abs_ave(n) > fmr || er_c_abs_ave(n) > 0.1*fmr || er_d_abs_ave(n) > fmr
                    %opts.StartPoint =xid_max*rand(1,2);%theta_est(n-1,:);
                    opts.StartPoint =paramLB+ (paramUB-paramLB).*rand(1,4);
                   
                        [fitresult, gof] = fit( handles.xData, handles.yData, ft, opts );
                    
                  %  theta_est(n,:)=[fitresult.a-bias fitresult.b-bias ];
                    theta_est(n,:)=[fitresult.a-bias fitresult.b-bias fitresult.c fitresult.d];
                    handles.theta_est(n,:)=[fitresult.a-bias fitresult.b-bias fitresult.c fitresult.d];
                    assignin('base','theta_est',handles.theta_est);
                    er_a_abs_ave2(n)=abs(abs(theta_est(n,1))-abs(theta_est_ave(n,1)));
                    er_b_abs_ave2(n)=abs(abs(theta_est(n,2))-abs(theta_est_ave(n,2)));
                    er_c_abs_ave2(n)=abs(abs(theta_est(n,3))-abs(theta_est_ave(n,3)));
                    er_d_abs_ave2(n)=abs(abs(theta_est(n,4))-abs(theta_est_ave(n,4)));
                    
                    if er_a_abs_ave2(n) > fmr || er_b_abs_ave2(n) > fmr || er_c_abs_ave2(n) > 0.1*fmr || er_d_abs_ave2(n) > fmr
                        %opts.StartPoint =xid_max*rand(1,2);%theta_est(n-1,:);
                        opts.StartPoint =paramLB+ (paramUB-paramLB).*rand(1,4);
                          [fitresult, gof] = fit( handles.xData, handles.yData, ft, opts );
                        
                        theta_est(n,:)=[fitresult.a-bias fitresult.b-bias fitresult.c fitresult.d];
                        handles.theta_est(n,:)=[fitresult.a-bias fitresult.b-bias fitresult.c fitresult.d];
                        assignin('base','theta_est',handles.theta_est);
                        er_a_abs_ave3(n)=abs(abs(theta_est(n,1))-abs(theta_est_ave(n,1)));
                        er_b_abs_ave3(n)=abs(abs(theta_est(n,2))-abs(theta_est_ave(n,2)));
                        er_c_abs_ave3(n)=abs(abs(theta_est(n,3))-abs(theta_est_ave(n,3)));
                        er_d_abs_ave3(n)=abs(abs(theta_est(n,4))-abs(theta_est_ave(n,4)));
                        
                        if er_a_abs_ave3(n) > fmr || er_b_abs_ave3(n) > fmr || er_c_abs_ave3(n) > 0.1*fmr || er_d_abs_ave3(n) > fmr
                            opts.StartPoint =paramLB+ (paramUB-paramLB).*rand(1,4);
                            [fitresult, gof] = fit( handles.xData, handles.yData, ft, opts );
                        
                           
                            theta_est(n,:)=[fitresult.a-bias fitresult.b-bias fitresult.c fitresult.d];
                             handles.theta_est(n,:)=[fitresult.a-bias fitresult.b-bias fitresult.c fitresult.d];
                             assignin('base','theta_est',handles.theta_est);
                        end
                        
                        
                    end
                    
            
                end
            end
            %%%%% <===== end fitting improvement 
 
            % added October 2016 for computations of error
           er_theta(n,:)=(theta_est(n,:)-theta_true')./theta_true';
           
            var_theta_est=evalin('base','var_theta_est');
            var_theta_est(n,1)=mean((theta_est((no_ini_samples_fim:n),1)-mean(theta_est((no_ini_samples_fim:n),1))).^2);
            var_theta_est(n,2)=mean((theta_est((no_ini_samples_fim:n),2)-mean(theta_est((no_ini_samples_fim:n),2))).^2);
            var_theta_est(n,3)=mean((theta_est((no_ini_samples_fim:n),3)-mean(theta_est((no_ini_samples_fim:n),3))).^2);
            var_theta_est(n,4)=mean((theta_est((no_ini_samples_fim:n),4)-mean(theta_est((no_ini_samples_fim:n),4))).^2);
            handles.var_theta_est=var_theta_est; % variance of estimations;for the computation of Cramer-Rao bound
            assignin('base', 'var_theta_est',handles.var_theta_est);
            
            


             number_of_push=evalin('base','number_of_push');


               m=n;
               
%              yest_xid(n,1:n)=theta_est(n,1) + ...
%                 (theta_est(n,2)-theta_est(n,1)) ./ (1 + 10.^((theta_est(n,3)-xid_fim_baseline)*theta_est(n,4)));
             yest_val(n,:)=theta_est(n,1) + ...
                (theta_est(n,2)-theta_est(n,1)) ./ (1 + 10.^((theta_est(n,3)-xval)*theta_est(n,4)));
%         handles.yest_xid=yest_xid;
%         assignin('base','yest_xid',handles.yest_xid); 
        

        handles.yest_val=yest_val;
        assignin('base','yest_val',handles.yest_val);
            
           %% plot
           if handles.number_of_iteration>5
               pnewpoint=evalin('base','pnewpoint');

               handles.pnewpoint=pnewpoint;
           end
           axesHandle= findobj(gcf,'Tag','axes1');
           axes(handles.axes1);
           hold on
           if plot_animation == 1

           ax1=gca;
           ax1.YScale='log';
           hold on
           %subplot(fig1_r,fig1_c,[1:1+fwdth,14:14+fwdth,27:27+fwdth,40:40+fwdth,53:53+fwdth,66:66+fwdth,79:79+fwdth]);
           delete(pdpnts)
           if n > no_ini_samples_fim+1
               pnewpoint=evalin('base','pnewpoint');
               delete(pnewpoint)
           end
           

         yid_fim_baseline=yid_fim_baseline*1000000;
%          Rewrite1
         pdpnts=plot(handles.xid_fim_baseline((handles.nxeq0)+1:end),handles.yid_fim_baseline((handles.nxeq0)+1:end),...
            'LineStyle','none',...
            'LineWidth',1,...
            'Marker','o',...
            'MarkerSize',8,...
            'MarkerEdgeColor','r',...
            'MarkerFaceColor','none');
        
        

        %pause(dtime);
           yid_new(end)=(yid_new(end))*1e6;
           pnewpoint=plot(handles.xid_fim_baseline(end),(handles.yid_fim_baseline(end)),...
            'LineStyle','none',...
            'LineWidth',1,...
            'Marker','o',...
            'MarkerSize',8,...
            'MarkerEdgeColor','r',...
            'MarkerFaceColor','r');
            
       % pause(dtime);
        delete(pnewfit);
        if n > no_ini_samples_fim+1
            delete(poldfit)
        end
       

         hold on
         
         axes(handles.axes1);
            pnewfit=plot(xval,1e6*10.^(yest_val(n,1:end)),...
            'LineStyle','-',...
            'LineWidth',1,...
            'Color','r');
        
        hold on
        axes(handles.axes1);
            poldfit=plot(xval,10^6*10.^(yest_val(n-1,1:end)),...
            'LineStyle','--',...
            'LineWidth',1,...
            'Color','b');
        
        AX=legend('Baseline sample','Previous TMS sample','New TMS sample','New estimate of IO curve','fit of IO cruve','location','northwest');
        
        
        handles.pdpnts=pdpnts;
        assignin('base','pdpnts',handles.pdpnts);
        handles.pnewpoint=pnewpoint;
        assignin('base','pnewpoint',handles.pnewpoint)
        handles.pnewfit=pnewfit;
        assignin('base','pnewfit',handles.pnewfit)
        handles.poldfit=poldfit;
        assignin('base','poldfit',handles.poldfit)
        
        handles.iter_ation=n-nxeq0;
        set(handles.edit18,'String',num2str(handles.number_of_iteration));
        assignin('base','number_of_iteration',handles.number_of_iteration);
        assignin('base','iter_ation',handles.iter_ation);
        
        % data table  
        test_d=[theta_est(n-1,:);
           theta_est(n,:)];
        % Create the column and row names in cell arrays 
          % cnames = {'Mean','Variance'};
        rnames = {'True Values','Previous estimate','Current estimate'};
      
%         % Create the uitable
%        table_t = uitable(f1,'Data',test_d,...
%             'ColumnName',cnames,... 
%             'ColumnWidth',{105 105 105 80},...
%             'RowName',rnames);
        if handles.number_of_push==1
        set(axesHandle,'Tag','axes1');
        
        axes(handles.axes2);
        hold on
        %lala1=plot(1:(m-handles.nxeq0),(theta_est(handles.nxeq0+1:end,1)),'r-','LineWidth',1);
        lala1=plot(3:handles.number_of_iteration,10.^(theta_est(handles.nxeq0+3:end,1))*1e6,'r-','LineWidth',1);
        ylab=ylabel('$y_l ~(\mu V_{pk-pk})$','FontSize',8);
        set(ylab,'interpreter','latex')
        %xlabel('n')
        %title('Estimation ','fontweight','normal')
        ax1=gca;
        ax1.FontName = 'Times New Roman';
        ax1.FontSize = 9;
        ax1.YScale='log';
        axes(handles.axes3);  
        %subplot(fig1_r,fig1_c,[48:52,61:65]);
        
       % plot([1 n],[log(theta_true(2)),log(theta_true(2))],'k-','LineWidth',1)
        hold on
        % lala2=plot(1:(m-handles.nxeq0),(theta_est(handles.nxeq0+1:end,2)),'r-','LineWidth',1);
        lala2=plot(3:handles.number_of_iteration,10.^(theta_est(handles.nxeq0+3:end,2))*1e6,'r-','LineWidth',1);
         ylab=ylabel('$y_h ~(\mu V_{pk-pk})$','FontSize',8);
        set(ylab,'interpreter','latex')
        %xlabel('n')
        %title({'True Value g--';'Estimation r-'},'fontweight','normal')
          ax1=gca;
        ax1.FontName = 'Times New Roman';
        ax1.FontSize = 9;
         ax1.YScale='log';
        axes(handles.axes4);  
         %subplot(fig1_r,fig1_c,[87:91,100:104]);
        
       % plot([1 n],[log(theta_true(3)),log(theta_true(3))],'k-','LineWidth',1)
        hold on
        %lala3=plot(1:(m-handles.nxeq0),(theta_est(handles.nxeq0+1:end,3)),'r-','LineWidth',1);
        lala3=plot(3:handles.number_of_iteration,(theta_est(handles.nxeq0+3:end,3))*100,'r-','LineWidth',1);
         ylab=ylabel('$m$ ~(\% max output)','FontSize',8);
        set(ylab,'interpreter','latex')
        %xlabel('n')
        %title({'True Value g--';'Estimation r-'},'fontweight','normal')
        ax1=gca;
        ax1.FontName = 'Times New Roman';
        ax1.FontSize =9;
        
       axes(handles.axes5);  
         %subplot(fig1_r,fig1_c,[126:130,139:143]);
        
       % plot([1 n],[log(theta_true(4)),log(theta_true(4))],'k-','LineWidth',1)
        hold on
               % lala4=plot(1:(m-handles.nxeq0),(theta_est(handles.nxeq0+1:end,4)),'r-','LineWidth',1);
               lala4=plot(3:handles.number_of_iteration,(theta_est(handles.nxeq0+3:end,4)),'r-','LineWidth',1);
         ylab=ylabel('$s$ $(\mu V_{pk-pk}$/\% max output)','FontSize',8);
        set(ylab,'interpreter','latex')
        xlab=xlabel('$n$');
        set(xlab,'interpreter','latex');
        %title({'True Value g--';'Estimation r-'},'fontweight','normal')
          ax1=gca;
        ax1.FontName = 'Times New Roman';
        ax1.FontSize = 9;
        
        
        else
            
             set(axesHandle,'Tag','axes1');
        
        axes(handles.axes2);
        %subplot(fig1_r,fig1_c,[9:13,22:26]);
        %delete(lala1);
        %cla(handles.axes2,'reset')
        cla(handles.axes2)
        %plot([1 n],[log(theta_true(1)),log(theta_true(1))],'k-','LineWidth',1);
        hold on
        lala1=plot(3:handles.number_of_iteration,10.^(theta_est(handles.nxeq0+3:end,1))*1e6,'r-','LineWidth',1);
        ylab=ylabel('$y_l~(\mu V_{pk-pk})$','FontSize',8);
        set(ylab,'interpreter','latex')
        %xlabel('n')
        %title({'True Value g--';'Estimation r-'},'fontweight','normal')
        %title(' Estimation ','fontweight','normal')
        
        ax1=gca;
        ax1.FontName = 'Times New Roman';
        ax1.FontSize = 9;
        ax1.YScale='log';
        
         axes(handles.axes3); 
         cla(handles.axes3);
        %subplot(fig1_r,fig1_c,[48:52,61:65]);
        %delete(lala2);
        %plot([1 n],[log(theta_true(2)),log(theta_true(2))],'k-','LineWidth',1)
        hold on
        lala2=plot(3:handles.number_of_iteration,10.^(theta_est(handles.nxeq0+3:end,2))*1e6,'r-','LineWidth',1);
         ylab=ylabel('$y_h~(\mu V_{pk-pk})$','FontSize',8);
        set(ylab,'interpreter','latex')
        %xlabel('n')
        %title({'True Value g--';'Estimation r-'},'fontweight','normal')
          ax1=gca;
        ax1.FontName = 'Times New Roman';
        ax1.FontSize = 9;
        ax1.YScale='log';
        axes(handles.axes4);
        cla(handles.axes4);
        %lala3=plot([1 n],[log(theta_true(3)),log(theta_true(3))],'k-','LineWidth',1);
        hold on
        lala3=plot(3:handles.number_of_iteration,(theta_est(handles.nxeq0+3:end,3))*100,'r-','LineWidth',1);
        ylab=ylabel('$m$ ~(\% max output)','FontSize',6);
        set(ylab,'interpreter','latex')
        %xlabel('n')
        ax1=gca;
        ax1.FontName = 'Times New Roman';
        ax1.FontSize = 9;
        
        axes(handles.axes5);
        cla(handles.axes5);
        %lala4=plot([1 n],[log(theta_true(4)),log(theta_true(4))],'k-','LineWidth',1);
        hold on
        lala4=plot(3:handles.number_of_iteration,(theta_est(handles.nxeq0+3:end,4)),'r-','LineWidth',1);
        ylab=ylabel('$s$ $(\mu V_{pk-pk}$/\% max output)','FontSize',6);
        set(ylab,'interpreter','latex')
        xlab=xlabel('$n$');
        set(xlab,'interpreter','latex');
        ax1=gca;
        ax1.FontName = 'Times New Roman';
        ax1.FontSize = 9;
        end
        

           
 % frop eteration 4
  %% next iterations
  

     set(handles.uitable1,'Data',theta_est(end-1:end,:));

            theta1_F(n)=theta_est(n,1);
            theta2_F(n)=theta_est(n,2);
            theta3_F(n)=theta_est(n,3);
            theta4_F(n)=theta_est(n,4);
    
            er_theta1_F(n)=er_theta(n,1);
            er_theta2_F(n)=er_theta(n,2);
            er_theta3_F(n)=er_theta(n,3);
            er_theta4_F(n)=er_theta(n,4);
            tol_rtheta=.001*ones(1,4); % epsilon in the termination algorithm
            SS_stopping_rtheta; 
            
            iter_rtheta_conv=iter_rtheta_converged;

           
       end % end iterations    

           
           
        