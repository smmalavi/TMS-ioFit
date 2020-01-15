           %%%%%%%%$$$$ after sending send xid_new(end) this value to GUI
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
xid_new=evalin('base','xid_new');
xid_paper=[];
yid_newGUI=evalin('base','yid_newGUI');
WG_th=evalin('base','WG_th');
Weight_gain1=evalin('base','Weight_gain1');
Weight_gain2=evalin('base','Weight_gain2');
yid_paper=evalin('base','yid_paper');



            if xid_new(n) < WG_th
                    WG_gain(n)=Weight_gain1;
            else
                    WG_gain(n)=Weight_gain2;
            end
            
            
            %pause
           xid=[xid xid_new(end)];
           xid_paper=[xid_paper xid_new(end)];
           xid=sort(xid);
           handles.xid=xid;
           assignin('base','xid',handles.xid);
           i_xidnew=find(xid==xid_new(end));
           %yid_new(n)= virtstimulate(xid_new(n), SubjParameters);
           
           %%%%%$$$$ read actual mep
            %%%%%$$  logyid_new(n)=log (actual mep)
         
          %must be deleted in trial
            %logyid_new(n)= log(yidguiupdate);%noise will be added in the fitting routine
            logyid_new(n)=log(yid_newGUI);
            yid_new(n)=exp(logyid_new(n)); 
            yid_paper=[yid_paper yid_new(n)];
           
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
           
         %leila 15-4-96
         handles.WG=WG;
         assignin('base','WG',handles.WG);
         handles.yid=yid;
         assignin('base','yid',handles.yid);
       
           % --> estimate theta