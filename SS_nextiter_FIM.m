            xidnm1=xid;% to use for plot
            yidnm1=yid;% to use for plot
      
            
            %                 pts = .1*rand(20,1) + (xid(end)-theta_est(n-1,3));
%                 tpoints = CustomStartPointSet(pts);
%                 rpts = RandomStartPointSet('NumStartPoints',40);
%                 allpts = {tpoints,rpts};
                
%                 pts = xid_min + (xid_max-xid_min).*rand(100,1);
%                 tpoints = CustomStartPointSet(pts);
%                 allpts = {tpoints};

            
            if fim_logsigm == 0
           
                ObjFunc_FIM = @(x) SSfim_cost(x,xid,theta_est(n-1,:),sigma_y,1);% 
                optsFIM = optimoptions(@fmincon,'Algorithm','interior-point');
                problem = createOptimProblem('fmincon','x0',rand,...
                    'objective',ObjFunc_FIM,'lb',xid_min,'ub',xid_max,'options',optsFIM);
                
                
                         
                if opt_method == 0 % ga was chosen
                    [xid_ga(n),fval_ga(n)] = ga(ObjFunc_FIM,1,[],[],[],[],xid_min,xid_max);
                    xid_new(n)  = xid_ga(n);
                    fval_x(n)   =fval_ga(n);
                elseif opt_method == 1 % Global search was chosen
                    [xid_gs(n),fval_gs(n),flagm_gs,outptm_gs,manyminsm_gs] = run(GlobalSearch,problem);
                    xid_new(n)  = xid_gs(n);
                    fval_x(n)   =fval_gs(n);
                else   % MultiStartPoint was chosen
                    pts = xid_min + (xid_max-xid_min).*rand(50,1);
                    tpoints = CustomStartPointSet(pts);
                    allpts = {tpoints};
                
                    [xid_ms(n),fval_ms(n),flagm_ms,outptm_ms,manyminsm_ms] = run(MultiStart,problem,allpts);
                    xid_new(n)  = xid_ms(n);
                    fval_x(n)   =fval_ms(n);
                 end
            xid_byFIM(n)=xid_new(n);
            %end of comparison of ga, gs and ms
            else % fim_logsigm==1
            
            
                ObjFunc_FIM2 = @(x) SMAfim_cost2(x,xid,theta_est(n-1,:),sigma_y,1);% 
                optsFIM = optimoptions(@fmincon,'Algorithm','interior-point');
                problem = createOptimProblem('fmincon','x0',rand,...
                    'objective',ObjFunc_FIM2,'lb',xid_min,'ub',xid_max,'options',optsFIM);
                
      
                if opt_method == 0 % ga was chosen
                    [xid_ga2(n),fval_ga2(n)] = ga(ObjFunc_FIM2,1,[],[],[],[],xid_min,xid_max);
                    xid_new2(n)  = xid_ga2(n);
                    fval_x2(n)   =fval_ga2(n);
                elseif opt_method == 1 % Global search was chosen
                    [xid_gs2(n),fval_gs2(n),flagm_gs,outptm_gs,manyminsm_gs] = run(GlobalSearch,problem);
                    xid_new2(n)  = xid_gs2(n);
                    fval_x2(n)   =fval_gs2(n);
                else   % MultiStartPoint was chosen
                    pts = xid_min + (xid_max-xid_min).*rand(200,1);
                    tpoints = CustomStartPointSet(pts);
                    allpts = {tpoints};
                    [xid_ms2(n),fval_ms2(n),flagm_ms,outptm_ms,manyminsm_ms] = run(MultiStart,problem,allpts);
                    xid_new2(n)  = xid_ms2(n);
                    fval_x2(n)   =fval_ms2(n);
                end
                xid_byFIM2(n)=xid_new2(n);
                yid_new2(n)= virtstimulate(xid_new2(n), SubjParameters);
                xid_new(n)=xid_new2(n);
                fval_x(n)=fval_x2(n);
            % end of modification
            end %logsigmoid
            
            
            
            if xid_new(n) < WG_th
                    WG_gain(n)=Weight_gain1;
            else
                    WG_gain(n)=Weight_gain2;
            end
            
            
            %pause
           xid=[xid xid_new(end)];
           xid=sort(xid);
           i_xidnew=find(xid==xid_new(end));
           %yid_new(n)= virtstimulate(xid_new(n), SubjParameters);
           yid_new(n)= SSsigmoidFunc(xid_new(n),theta_true,sigma_y);
           
           if i_xidnew == 1
               yid=[yid_new(end) yid];
               WG=[WG_gain(n) WG];
           elseif i_xidnew == n
               yid=[yid yid_new(end)];
               WG=[WG WG_gain(n)];
           else
               yidtemp=yid;
               yid=[yidtemp(1:i_xidnew-1) yid_new(end) yidtemp(i_xidnew:end)];
               WG=[WG(1:i_xidnew-1) WG_gain(end) WG(i_xidnew:end)];
           end
           
           % --> estimate theta
                
                % using fit
           [xData, yData] = prepareCurveData( xid, yid+bias );

                % Set up fittype and options.
            if func_type == 0
                    ft = fittype( 'a+(b-a)/(1+c*x^(-d))', 'independent', 'x', 'dependent', 'y' );
                else
                    ft = fittype( 'log(a+(b-a)/(1+c*x^(-d)))', 'independent', 'x', 'dependent', 'y' );
            end
            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Display = 'Off';
            opts.Algorithm = 'Trust-Region';
            opts.Lower = paramLB;%[1e-07+bias 0.0001+bias xid_min 0.05];
            opts.Upper = paramUB;%[0.00001+bias 0.01+bias xid_max Inf];
            opts.Robust ='LAR';% 'Bisquare';
            if initial_setting == 0
                opts.StartPoint =rand(1,4);
            else
                opts.StartPoint =theta_est(n-1,:);
            end
            opts.Weights=WG;

                % Fit model to data.
            if func_type == 0
                    [fitresult, gof] = fit( xData, yData, ft, opts );
                else
                    [fitresult, gof] = fit( xData, log(yData), ft, opts );
            end
        
            
            %%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%fitting improvement
            %%%%%%%%%%%%%%%%%%%%%%%%%%
%             if ((fitresult.a - paramLB(1))<1e-10 || abs(fitresult.a - paramUB(1))<1e-10 || abs((fitresult.a-theta_est(n-1,1))/theta_est(n-1,1))*100>eyL_th || abs((fitresult.c-theta_est(n-1,3))/theta_est(n-1,3))*100>em_th) % repeat bad fitting
%                 
%                 fit_modification_flag=[n, fitresult.a, abs(fitresult.c-theta_est(n-1,3))];
%                 kkkkkk=1;
%                 if initial_setting == 1 % intial point is exchanged
%                     opts.StartPoint =rand(1,4);
%                 else
%                     opts.StartPoint =theta_est(n-1,:);
%                 end
%                 
%                 if func_type == 0
%                     [fitresult, gof] = fit( xData, yData, ft, opts );
%                 else
%                     [fitresult, gof] = fit( xData, log(yData), ft, opts );
%                 end
%                 
%             end
%             
%                 % reapeat fitting improvment if necessary
%             
%             if ((fitresult.a - paramLB(1))<1e-10 || abs(fitresult.a - paramUB(1))<1e-10 || abs((fitresult.a-theta_est(n-1,1))/theta_est(n-1,1))*100>eyL_th || abs((fitresult.c-theta_est(n-1,3))/theta_est(n-1,3))*100>em_th) % repeat bad fitting
%                 
%                 fit_modification_flag=[n, fitresult.a, abs(fitresult.c-theta_est(n-1,3))];
%                 kkkkkk=1;
%                 if initial_setting == 1 % intial point is exchanged
%                     opts.StartPoint =rand(1,4);
%                 else
%                     opts.StartPoint =theta_est(n-1,:);
%                 end
%                 
%                 if func_type == 0
%                     [fitresult, gof] = fit( xData, yData, ft, opts );
%                 else
%                     [fitresult, gof] = fit( xData, log(yData), ft, opts );
%                 end
%                 
%             end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%end of fitting improvement
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
            theta_est(n,:)=[fitresult.a-bias fitresult.b-bias fitresult.c fitresult.d];
        
            % estimated
            %xval=0:.05:xid_max;
            %size_val=length(xval);
            yest_xid(n,1:n)=theta_est(n,1) + ...
                (theta_est(n,2)-theta_est(n,1)) ./ (1 + theta_est(n,3)*xid.^-theta_est(n,4));
            yest_val(n,1:size_val)=theta_est(n,1) + ...
                (theta_est(n,2)-theta_est(n,1)) ./ (1 + theta_est(n,3)*xval.^-theta_est(n,4));
            

              % get det FIM
              if fim_logsigm == 0
                [y,FIM]=SSfim_cost(0,xid,theta_est(n,:),sigma_y,0);% zero means initial stage
                
                FIM11=[FIM11 FIM(1,1)];
                FIM22=[FIM22 FIM(2,2)];
                FIM33=[FIM33 FIM(3,3)];
                FIM44=[FIM44 FIM(4,4)];
                
                rate_FIM11(n)=abs(FIM11(end)-FIM11(end-1));
                rate_FIM22(n)=abs(FIM22(end)-FIM22(end-1));
                rate_FIM33(n)=abs(FIM33(end)-FIM33(end-1));
                rate_FIM44(n)=abs(FIM44(end)-FIM44(end-1));
                   
                                
                invFIM11=[invFIM11 inv(FIM(1,1))];
                invFIM22=[invFIM22 inv(FIM(2,2))];
                invFIM33=[invFIM33 inv(FIM(3,3))];
                invFIM44=[invFIM44 inv(FIM(4,4))];
                
                
                var_theta_est(n,1)=mean((theta_est((no_ini_samples_fim:n),1)-mean(theta_est((no_ini_samples_fim:n),1))).^2);
                var_theta_est(n,2)=mean((theta_est((no_ini_samples_fim:n),2)-mean(theta_est((no_ini_samples_fim:n),2))).^2);
                var_theta_est(n,3)=mean((theta_est((no_ini_samples_fim:n),3)-mean(theta_est((no_ini_samples_fim:n),3))).^2);
                var_theta_est(n,4)=mean((theta_est((no_ini_samples_fim:n),4)-mean(theta_est((no_ini_samples_fim:n),4))).^2);
                %var_theta_est(n,:)=(theta_est(n,:)-theta_true').^2;
                %est_eff(n,:)=[invFIM(1,1) invFIM(2,2) invFIM(3,3) invFIM(4,4)]./var_theta_est(n,:);
                est_eff(n,:)=diag(FIM)'.*var_theta_est(n,:);
                est_eff(:,1)';
                est_eff(:,2)';
                est_eff(:,3)';
                est_eff(:,4)';
%                 est_eff_last1=est_eff(n,1)
%                  est_eff_last2=est_eff(n,2)
%                   est_eff_last3=est_eff(n,3)
%                    est_eff_last4=est_eff(n,3)
              else
                [y,FIM]=SMAfim_cost2(0,xid,theta_est(n,:),sigma_y,0);% zero means initial stage
                minusdetFIM(n)=y;
                invFIM=inv(FIM);
                sqrtminvFIM=sqrtm(inv(FIM));
                Cramer_Rao_bnd(n,:)=abs([sqrtminvFIM(1,1) sqrtminvFIM(2,2) sqrtminvFIM(3,3) sqrtminvFIM(4,4)]);
                var_theta_est(n,:)=(theta_est(n,:)-mean(theta_est((no_ini_samples_fim:n),:),1)).^2;
                est_eff(n,:)=[invFIM(1,1) invFIM(2,2) invFIM(3,3) invFIM(4,4)]./var_theta_est(n,:);
                est_eff_last=est_eff(n,:);
              end
              
           %% plot   
           plot(xidnm1,yidnm1,'ob');
           hold on
           for p=n-1:n-1
                hold on
                %plot(xidnm1,yest_ga(p,1:n-1),'--b');
                hold on
                plot(xval,yest_val(p,1:end),'--b');
            end
            hold on
            plot(xid_new(end),yid_new(end),'or');
            hold on
%             plot(xid_new2(end),yid_new2(end),'og');
            hold on
            %plot(xid,yest_ga(n,1:n),'r');
            hold on
            plot(xval,yest_val(n,1:end),'r');