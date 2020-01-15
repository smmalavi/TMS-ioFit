handles.handles.number_of_iteration=5;
%leila
xid= evalin('base','xid');
yid= evalin('base','yid');
                xidnm1=xid;% to use for plot
                yidnm1=yid;% to use for plot
                %leila 15-4-96
                [y,FIM] = SSfim_cost_modified(n0,n,x,xid,theta,theta_var,sigma_y,z);
                handles.FIM=FIM;
                assignin('base','FIM',handles.FIM);
    
                ObjFunc_FIM = @(x) SSfim_cost_modified(no_ini_samples_fim,handles.number_of_iteration,x,xid,theta_est(handles.number_of_iteration-1,:),var_theta_est(handles.number_of_iteration-1,:),sigma_y,1);% 
                optsFIM = optimoptions(@fmincon,'Algorithm','interior-point');
                problem = createOptimProblem('fmincon','x0',xid_max*rand,...
                    'objective',ObjFunc_FIM,'lb',xid_min,'ub',xid_max,'options',optsFIM);
                
                         
                if handles.opt_method == 0 % ga was chosen
                    [xid_ga(handles.number_of_iteration),fval_ga(handles.number_of_iteration)] = ga(ObjFunc_FIM,1,[],[],[],[],xid_min,xid_max);
                    xid_new(handles.number_of_iteration)  = xid_ga(handles.number_of_iteration);
                    fval_x(handles.number_of_iteration)   =fval_ga(handles.number_of_iteration);
                elseif handles.opt_method == 1 % Global search was chosen
                    [xid_gs(handles.number_of_iteration),fval_gs(handles.number_of_iteration),flagm_gs,outptm_gs,manyminsm_gs] = run(GlobalSearch,problem);
                    xid_new(handles.number_of_iteration)  = xid_gs(handles.number_of_iteration);
                    fval_x(handles.number_of_iteration)   =fval_gs(handles.number_of_iteration);
                else   % MultiStartPoint was chosen
                    pts = xid_min + (xid_max-xid_min).*rand(200,1);
                    tpoints = CustomStartPointSet(pts);
                    allpts = {tpoints};
                
                    [xid_ms(handles.number_of_iteration),fval_ms(handles.number_of_iteration),flagm_ms,outptm_ms,manyminsm_ms] = run(MultiStart,problem,allpts);
                    xid_new(handles.number_of_iteration)  = xid_ms(handles.number_of_iteration);
                    fval_x(handles.number_of_iteration)   =fval_ms(handles.number_of_iteration);
                end
                handles.xid_new(handles.number_of_iteration)=xid_new(handles.number_of_iteration);
                handles.xid_byFIM(handles.number_of_iteration)=handles.xid_new(handles.number_of_iteration);
                % I eliminate it
            %xid_byFIM(n)=xid_new(n);
        
           %%%%%%%%$$$$ send xid_new(end) this value to GUI
          
           %%%%%$$$$ read actual mep
            %%%%%$$  logyid_new(n)=log (actual mep)
        
           
       