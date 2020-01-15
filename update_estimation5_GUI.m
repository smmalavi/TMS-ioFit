            %%%%%%%%$$$$ after sending send xid_new(end) this value to GUI
          
            if handles.xid_new(handles.number_of_iteration) < handles.WG_th
                    WG_gain(handles.number_of_iteration)=handles.Weight_gain1;
            else
                    WG_gain(handles.number_of_iteration)=handles.Weight_gain2;
            end
            
            
            %pause
           handles.xid=[handles.xid handles.xid_new(end)];
           assignin('base','xid',handles.xid);
           handles.xid_paper=[handles.xid_paper handles.xid_new(end)];
           handles.xid=sort(handles.xid);
           i_xidnew=find(handles.xid==handles.xid_new(end));
           %yid_new(n)= virtstimulate(xid_new(n), SubjParameters);
           
            %%%%%$$read actual mep
            %%%%%$$  logyid_new(n)=log (actual mep)

            %logyid_new(handles.number_of_iteration)= log(yidguiupdate);%noise will be added in the fitting routine
            %leila
            
            logyid_new(handles.number_of_iteration)=log(handles.yid_newGUI);
            yid_new(handles.number_of_iteration)=exp(logyid_new(handles.number_of_iteration)); 
            yid_paper=[yid_paper yid_new(handles.number_of_iteration)];

           if i_xidnew == 1
               yid=[yid_new(end) yid];
               WG=[WG_gain(handles.number_of_iteration) WG];
           elseif i_xidnew == handles.number_of_iteration
               yid=[yid yid_new(end)];
               WG=[WG WG_gain(handles.number_of_iteration)];
           else
               handles.yidtemp=handles.yid;
               handles.yid=[yidtemp(1:handles.i_xidnew-1) yid_new(end) yidtemp(handles.i_xidnew:end)];
               handles.WG=[handles.WG(1:handles.i_xidnew-1) handles.WG_gain(end) handles.WG(handles.i_xidnew:end)];
           end
         
       
           % estimate theta
              
                % using fit
           [xData, yData] = prepareCurveData( handles.xid, handles.yid+bias );

                % Set up fittype and options.
           
            if func_type == 0
                    ft = fittype( 'a+(b-a)/(1+10^((c-x)*d))', 'independent', 'x', 'dependent', 'y' );
                else
                    ft = fittype( 'log(a+(b-a)/(1+10^((c-x)*d)))', 'independent', 'x', 'dependent', 'y' );
            end
           
           opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Display = 'Off';
            opts.Algorithm = 'Trust-Region';
            opts.Lower = paramLB;%[1e-07+bias 0.0001+bias xid_min 0.05];
            opts.Upper = paramUB;%[0.00001+bias 0.01+bias xid_max Inf];
            opts.Robust ='LAR';% 'Bisquare';
            if initial_setting == 0
                %opts.StartPoint =xid_max*rand(1,2);
                opts.StartPoint =rand(1,4);%theta_est(n-1,:);
            else
                opts.StartPoint =theta_est(n-1,:);
            end
            opts.Weights=WG;
%%
                % Fit model to data.
            if func_type == 0
                    %[fitresult, gof] = fit( xData, yData, ft, opts );
                    [fitresult, gof] = fit( xData, yData, ft, opts );
            else
                    [fitresult, gof] = fit( xData, log(yData), ft, opts );
            end
        
            %theta_est(n,:)=[fitresult.a-bias fitresult.b-bias ];
            
            theta_est(handles.number_of_iteration,:)=[fitresult.a-bias fitresult.b-bias fitresult.c fitresult.d];
            %%%%% =====>fitting improvement 
            % --> avoid saturation
            
             if abs(theta_est(handles.number_of_iteration,1) - paramLB(1))<sac || abs(theta_est(handles.number_of_iteration,2)-paramLB(2))<sac || abs(theta_est(handles.number_of_iteration,3) - paramLB(3))<sac || abs(theta_est(handles.number_of_iteration,4)-paramLB(4))<sac || abs(theta_est(handles.number_of_iteration,1)-paramUB(1))<sac || abs(theta_est(handles.number_of_iteration,2)-paramUB(2))<sac  || abs(theta_est(handles.number_of_iteration,3)-paramUB(3))<sac || abs(theta_est(handles.number_of_iteration,4)-paramUB(4))<sac
                    %opts.StartPoint =xid_max*rand(1,2);%theta_est(n-1,:);
                    opts.StartPoint =rand(1,4);%theta_est(n-1,:);
                    if func_type == 0
                         %[fitresult, gof] = fit( xData, yData, ft, opts );
                        [fitresult, gof] = fit( xData, yData, ft, opts );
                    else
                        [fitresult, gof] = fit( xData, log(yData), ft, opts );
                    end
                    %theta_est(n,:)=[fitresult.a-bias fitresult.b-bias ];
                     theta_est(handles.number_of_iteration,:)=[fitresult.a-bias fitresult.b-bias fitresult.c fitresult.d];
                    
                    if abs(theta_est(handles.number_of_iteration,1) - paramLB(1))<sac || abs(theta_est(handles.number_of_iteration,2)-paramLB(2))<sac || abs(theta_est(handles.number_of_iteration,3) - paramLB(3))<sac || abs(theta_est(handles.number_of_iteration,4)-paramLB(4))<sac || abs(theta_est(handles.number_of_iteration,1)-paramUB(1))<sac || abs(theta_est(handles.number_of_iteration,2)-paramUB(2))<sac  || abs(theta_est(handles.number_of_iteration,3)-paramUB(3))<sac || abs(theta_est(handles.number_of_iteration,4)-paramUB(4))<sac
                        %opts.StartPoint =xid_max*rand(1,2);%theta_est(n-1,:);
                        opts.StartPoint =rand(1,4);%theta_est(n-1,:);
                        if func_type == 0
                         %[fitresult, gof] = fit( xData, yData, ft, opts );
                            [fitresult, gof] = fit( xData, yData, ft, opts );
                        else
                            [fitresult, gof] = fit( xData, log(yData), ft, opts );
                        end
                        %theta_est(n,:)=[fitresult.a-bias fitresult.b-bias ];
                         theta_est(handles.number_of_iteration,:)=[fitresult.a-bias fitresult.b-bias fitresult.c fitresult.d];
                    end
             end
 
            if handles.number_of_iteration>10%no_ini_samples_fim+3
                %theta_est_ave(n,:)=1/3.*(theta_est(n-1,:)+theta_est(n-2,:)+theta_est(n-3,:));
                theta_est_ave(handles.number_of_iteration,:)=theta_est(handles.number_of_iteration-1,:);
                er_a_abs_ave(handles.number_of_iteration)=abs(abs(theta_est(handles.number_of_iteration,1))-abs(theta_est_ave(handles.number_of_iteration,1)));
                er_b_abs_ave(handles.number_of_iteration)=abs(abs(theta_est(handles.number_of_iteration,2))-abs(theta_est_ave(handles.number_of_iteration,2)));
                er_c_abs_ave(handles.number_of_iteration)=abs(abs(theta_est(handles.number_of_iteration,3))-abs(theta_est_ave(handles.number_of_iteration,3)));
                er_d_abs_ave(handles.number_of_iteration)=abs(abs(theta_est(handles.number_of_iteration,4))-abs(theta_est_ave(handles.number_of_iteration,4)));
            
            
                if er_a_abs_ave(handles.number_of_iteration) > fmr || er_b_abs_ave(handles.number_of_iteration) > fmr || er_c_abs_ave(handles.number_of_iteration) > fmr || er_d_abs_ave(handles.number_of_iteration) > fmr
                    %opts.StartPoint =xid_max*rand(1,2);%theta_est(n-1,:);
                    opts.StartPoint =rand(1,4);
                    if func_type == 0
                         %[fitresult, gof] = fit( xData, yData, ft, opts );
                        [fitresult, gof] = fit( xData, yData, ft, opts );
                    else
                        [fitresult, gof] = fit( xData, log(yData), ft, opts );
                    end
                  %  theta_est(n,:)=[fitresult.a-bias fitresult.b-bias ];
                    theta_est(handles.number_of_iteration,:)=[fitresult.a-bias fitresult.b-bias fitresult.c fitresult.d];
                    er_a_abs_ave2(handles.number_of_iteration)=abs(abs(theta_est(handles.number_of_iteration,1))-abs(theta_est_ave(handles.number_of_iteration,1)));
                    er_b_abs_ave2(handles.number_of_iteration)=abs(abs(theta_est(handles.number_of_iteration,2))-abs(theta_est_ave(handles.number_of_iteration,2)));
                    er_c_abs_ave2(handles.number_of_iteration)=abs(abs(theta_est(handles.number_of_iteration,3))-abs(theta_est_ave(handles.number_of_iteration,3)));
                    er_d_abs_ave2(handles.number_of_iteration)=abs(abs(theta_est(handles.number_of_iteration,4))-abs(theta_est_ave(handles.number_of_iteration,4)));
                    
                    if er_a_abs_ave(handles.number_of_iteration) > fmr || er_b_abs_ave(handles.number_of_iteration) > fmr || er_c_abs_ave(handles.number_of_iteration) > fmr || er_d_abs_ave(handles.number_of_iteration) > fmr
                        %opts.StartPoint =xid_max*rand(1,2);%theta_est(n-1,:);
                        opts.StartPoint =rand(1,4);
                        if func_type == 0
                         %[fitresult, gof] = fit( xData, yData, ft, opts );
                            [fitresult, gof] = fit( xData, yData, ft, opts );
                        else
                            [fitresult, gof] = fit( xData, log(yData), ft, opts );
                        end
                        theta_est(handles.number_of_iteration,:)=[fitresult.a-bias fitresult.b-bias fitresult.c fitresult.d];
                        er_a_abs_ave3(handles.number_of_iteration)=abs(abs(theta_est(handles.number_of_iteration,1))-abs(theta_est_ave(handles.number_of_iteration,1)));
                        er_b_abs_ave3(handles.number_of_iteration)=abs(abs(theta_est(handles.number_of_iteration,2))-abs(theta_est_ave(handles.number_of_iteration,2)));
                        er_c_abs_ave3(handles.number_of_iteration)=abs(abs(theta_est(handles.number_of_iteration,3))-abs(theta_est_ave(handles.number_of_iteration,3)));
                        er_d_abs_ave3(handles.number_of_iteration)=abs(abs(theta_est(handles.number_of_iteration,4))-abs(theta_est_ave(handles.number_of_iteration,4)));
                    end
                    
            
                end
            end
            
            %%
            %%%%% <===== end fitting improvement 
 
            % added October 2016 for computations of error
           er_theta(handles.number_of_iteration,:)=(theta_est(handles.number_of_iteration,:)-theta_true')./theta_true';

            var_theta_est(handles.number_of_iteration,1)=mean((theta_est((no_ini_samples_fim:handles.number_of_iteration),1)-mean(theta_est((no_ini_samples_fim:n),1))).^2);
            var_theta_est(handles.number_of_iteration,2)=mean((theta_est((no_ini_samples_fim:handles.number_of_iteration),2)-mean(theta_est((no_ini_samples_fim:handles.number_of_iteration),2))).^2);
            var_theta_est(handles.number_of_iteration,3)=mean((theta_est((no_ini_samples_fim:handles.number_of_iteration),3)-mean(theta_est((no_ini_samples_fim:handles.number_of_iteration),3))).^2);
            var_theta_est(handles.number_of_iteration,4)=mean((theta_est((no_ini_samples_fim:handles.number_of_iteration),4)-mean(theta_est((no_ini_samples_fim:handles.number_of_iteration),4))).^2);
           
            if length(find(diag(FIM)) ~= 0);
               FIM_neg_element=find(diag(FIM)<0);
            end
 
             
            [y,FIM]=SSfim_cost_modified(no_ini_samples_fim,handles.number_of_iteration,0,xid,theta_est(handles.number_of_iteration,:),[],sigma_y,0);
            CRB(handles.number_of_iteration,:)=diag(inv(FIM));
            
            [y,FIM_true]=SSfim_cost_modified(no_ini_samples_fim,handles.number_of_iteration,0,xid,theta_true,[],sigma_y,0);
            CRB_true(handles.number_of_iteration,:)=diag(inv(FIM_true));

            var_CRB(handles.number_of_iteration,1)=mean((CRB_true((no_ini_samples_fim:handles.number_of_iteration),1)-mean(CRB_true((no_ini_samples_fim:handles.number_of_iteration),1))).^2);
            var_CRB(handles.number_of_iteration,2)=mean((CRB_true((no_ini_samples_fim:handles.number_of_iteration),2)-mean(CRB_true((no_ini_samples_fim:handles.number_of_iteration),2))).^2);
            var_CRB(handles.number_of_iteration,3)=mean((CRB_true((no_ini_samples_fim:handles.number_of_iteration),3)-mean(CRB_true((no_ini_samples_fim:handles.number_of_iteration),3))).^2);
            var_CRB(handles.number_of_iteration,4)=mean((CRB_true((no_ini_samples_fim:handles.number_of_iteration),4)-mean(CRB_true((no_ini_samples_fim:handles.number_of_iteration),4))).^2);
%leila
             yest_xid(handles.number_of_iteration,1:handles.number_of_iteration)=theta_est(handles.number_of_iteration,1) + ...
                (theta_est(handles.number_of_iteration,2)-theta_est(handles.number_of_iteration,1)) ./ (1 + 10.^((theta_est(handles.number_of_iteration,3)-xid)*theta_est(handles.number_of_iteration,4)));
             yest_val(handles.number_of_iteration,1:size_val)=theta_est(handles.number_of_iteration,1) + ...
                (theta_est(handles.number_of_iteration,2)-theta_est(handles.number_of_iteration,1)) ./ (1 + 10.^((theta_est(handles.number_of_iteration,3)-xval)*theta_est(handles.number_of_iteration,4)));
       
            
           %% plot
           
           if plot_animation == 1
           figure(1)
           hold on
           subplot(fig1_r,fig1_c,[1:1+fwdth,14:14+fwdth,27:27+fwdth,40:40+fwdth,53:53+fwdth,66:66+fwdth,79:79+fwdth]);
           delete(pdpnts)
           if handles.number_of_iteration > no_ini_samples_fim+1
                delete(pnewpoint)
           end
           pdpnts=plot(xidnm1,log(yidnm1),...
            'LineStyle','none',...
            'LineWidth',1,...
            'Marker','o',...
            'MarkerSize',6,...
            'MarkerEdgeColor','r',...
            'MarkerFaceColor','none');
           
        %pause(dtime);
           pnewpoint=plot(xid_new(end),log(yid_new(end)),...
            'LineStyle','none',...
            'LineWidth',1,...
            'Marker','o',...
            'MarkerSize',8,...
            'MarkerEdgeColor','r',...
            'MarkerFaceColor','r');
            
       % pause(dtime);
        delete(pnewfit);
        if handles.number_of_iteration > no_ini_samples_fim+1
            delete(poldfit)
        end
           
            poldfit=plot(xval,log(yest_val(handles.number_of_iteration-1,1:end)),...
            'LineStyle','--',...
            'LineWidth',1,...
            'Color','r');
        
            pnewfit=plot(xval,log(yest_val(handles.number_of_iteration,1:end)),...
            'LineStyle','-',...
            'LineWidth',1,...
            'Color','r');
        
        AX=legend('data','true model','previous samples','new sample','previous fit','new fit','Location','southeast');%''southeast');

        % data table  
        test_d=[theta_true';theta_est(handles.number_of_iteration-1,:);
           theta_est(handles.number_of_iteration,:)];
        % Create the column and row names in cell arrays 
          % cnames = {'Mean','Variance'};
        rnames = {'True Values','Previous estimate','Current estimate'};
      
        % Create the uitable
       table_t = uitable(f1,'Data',test_d,...
            'ColumnName',cnames,... 
            'ColumnWidth',{105 105 105 80},...
            'RowName',rnames);
        table_t.FontName='Times New Roman';
        table_t.FontSize=16;
        table_t.Position(1) = table_x;
        table_t.Position(2) = table_y;
        table_t.Position(3) = table_t.Extent(3);
        table_t.Position(4) = table_t.Extent(4);
        
        % parameters 
      subplot(fig1_r,fig1_c,[9:13,22:26]);
        plot([1 handles.number_of_iteration],[log(theta_true(1)),log(theta_true(1))],'k-','LineWidth',1)
        hold on
        plot(1:handles.number_of_iteration,log(theta_est(:,1)),'r--','LineWidth',1);
        ylab=ylabel('$y_l$');
        set(ylab,'interpreter','latex')
        xlabel('Sample')
        %title({'True Value g--';'Estimation r-'},'fontweight','normal')
        title('True Value k-  Estimation r--','fontweight','normal')
        
        ax1=gca;
        ax1.FontName = 'Times New Roman';
        ax1.FontSize = 14;
        
        subplot(fig1_r,fig1_c,[48:52,61:65]);
        plot([1 handles.number_of_iteration],[log(theta_true(2)),log(theta_true(2))],'k-','LineWidth',1)
        hold on
        plot(1:handles.number_of_iteration,log(theta_est(:,2)),'r--','LineWidth',1)
         ylab=ylabel('$y_h$');
        set(ylab,'interpreter','latex')
        xlabel('Sample')
        %title({'True Value g--';'Estimation r-'},'fontweight','normal')
          ax1=gca;
        ax1.FontName = 'Times New Roman';
        ax1.FontSize = 14;
        
         subplot(fig1_r,fig1_c,[87:91,100:104]);
        plot([1 handles.number_of_iteration],[log(theta_true(3)),log(theta_true(3))],'k-','LineWidth',1)
        hold on
        plot(1:handles.number_of_iteration,log(theta_est(:,3)),'r--','LineWidth',1)
         ylab=ylabel('$m$');
        set(ylab,'interpreter','latex')
        xlabel('Sample')
        %title({'True Value g--';'Estimation r-'},'fontweight','normal')
          ax1=gca;
        ax1.FontName = 'Times New Roman';
        ax1.FontSize = 14;
        
         subplot(fig1_r,fig1_c,[126:130,139:143]);
        plot([1 handles.number_of_iteration],[log(theta_true(4)),log(theta_true(4))],'k-','LineWidth',1)
        hold on
        plot(1:handles.number_of_iteration,log(theta_est(:,4)),'r--','LineWidth',1);
         ylab=ylabel('$s$');
        set(ylab,'interpreter','latex')
        xlabel('Sample')
        %title({'True Value g--';'Estimation r-'},'fontweight','normal')
          ax1=gca;
        ax1.FontName = 'Times New Roman';
        ax1.FontSize = 14;
        
        %%%%%%%%save gif
        frame = getframe(gcf);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        if handles.number_of_iteration-no_ini_samples_fim == 1
            imwrite(imind,cm,'FigFIM.gif','gif','WriteMode','append', 'DelayTime',next_est_plot_delay1);
        elseif handles.number_of_iteration-no_ini_samples_fim < 3 && n-no_ini_samples_fim >1
            imwrite(imind,cm,'FigFIM.gif','gif','WriteMode','append', 'DelayTime',next_est_plot_delay2);
        else
            imwrite(imind,cm,'FigFIM.gif','gif','WriteMode','append', 'DelayTime',next_est_plot_delay3);
        end
   
        %%%%%%%%save gif
        frame = getframe(gcf);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        if handles.number_of_iteration-no_ini_samples_fim == 1
            imwrite(imind,cm,'FigFIMv2.gif','gif','WriteMode','append', 'DelayTime',next_est_plot_delay1);
        elseif handles.number_of_iteration-no_ini_samples_fim < 3 && handles.number_of_iteration-no_ini_samples_fim >1
            imwrite(imind,cm,'FigFIMv2.gif','gif','WriteMode','append', 'DelayTime',next_est_plot_delay2);
        else
            imwrite(imind,cm,'FigFIMv2.gif','gif','WriteMode','append', 'DelayTime',next_est_plot_delay3);
        end
        

           end
           
           
           
           
 % frop eteration 4
  %% next iterations
     
        %for n=no_ini_samples_fim+1:no_ini_samples_fim+no_next_iter
      % if pb_on_off (0/1)
           
            % FIM Method
            % SS_nextiter_FIM_ModifiedCost;
            theta1_F(handles.number_of_iteration)=theta_est(handles.number_of_iteration,1);
            theta2_F(handles.number_of_iteration)=theta_est(handles.number_of_iteration,2);
            theta3_F(handles.number_of_iteration)=theta_est(handles.number_of_iteration,3);
            theta4_F(handles.number_of_iteration)=theta_est(handles.number_of_iteration,4);
            
            er_theta1_F(handles.number_of_iteration)=er_theta(handles.number_of_iteration,1);
            er_theta2_F(handles.number_of_iteration)=er_theta(handles.number_of_iteration,2);
            er_theta3_F(handles.number_of_iteration)=er_theta(handles.number_of_iteration,3);
            er_theta4_F(handles.number_of_iteration)=er_theta(handles.number_of_iteration,4);
            tol_rtheta=.005*ones(1,4); % epsilon in the termination algorithm
            SS_stopping_rtheta; 
            iter_rtheta_conv=iter_rtheta_converged;
         
    %%%%%% Optional to continue
    %%%%%% GUI masssage
         
            if length(iter_rtheta_converged)~=0
                    save([ 'gfx/mat/test' num2str(1) '.mat' ]);
                    success_stop=1;
                    break;
                
            end
           
       % end % end iterations    
