function varargout = TMS_ioFit(varargin)
% TMS_IOFIT MATLAB code for TMS_ioFit.fig
%      TMS_IOFIT, by itself, creates a new TMS_IOFIT or raises the existing
%      singleton*.
%
%      H = TMS_IOFIT returns the handle to a new TMS_IOFIT or the handle to
%      the existing singleton*.
%
%      TMS_IOFIT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TMS_IOFIT.M with the given input arguments.
%
%      TMS_IOFIT('Property','Value',...) creates a new TMS_IOFIT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TMS_ioFit_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TMS_ioFit_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TMS_ioFit

% Last Modified by GUIDE v2.5 20-Dec-2019 15:13:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TMS_ioFit_OpeningFcn, ...
                   'gui_OutputFcn',  @TMS_ioFit_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before TMS_ioFit is made visible.
function TMS_ioFit_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TMS_ioFit (see VARARGIN)

% Choose default command line output for TMS_ioFit
handles.output = hObject;

%% prealication

handles.Total_runs=1;
assignin('base', 'Total_runs',handles.Total_runs);

handles.plot_animation = 1; %  To run saving animation, set this to 1
assignin('base', 'plot_animation',handles.plot_animation);

handles.save_er_plot_after_each_run=1; %save 
assignin('base', 'save_er_plot_after_each_run',handles.save_er_plot_after_each_run);

handles.total_theta_true=[];
assignin('base', 'total_theta_true',handles.total_theta_true);

handles.total_sigma_y=[];
assignin('base', 'total_sigma_y',handles.total_sigma_y);

handles.fmr=0.1;% threshold value for bad fit detection
assignin('base', 'fmr',handles.fmr);

handles.sac=0.1;% threshold value to detect whether estimation is saturated
assignin('base', 'sac',handles.sac);

%% Prealocation of the variables for evaluations

handles.theta1_F=[];
assignin('base', 'theta1_F',handles.theta1_F);

handles.theta2_F=[];
assignin('base', 'theta2_F',handles.theta2_F);

handles.theta3_F=[];
assignin('base', 'theta3_F',handles.theta3_F);

handles.theta4_F=[];
assignin('base', 'theta4_F',handles.theta4_F);

handles.er_theta1_F=[];
assignin('base', 'er_theta1_F',handles.er_theta1_F);

handles.er_theta1_F_conv=[];
assignin('base', 'er_theta1_F_conv',handles.er_theta1_F_conv);

handles.er_theta1_F_final_iter=[];
assignin('base', 'er_theta1_F_final_iter',handles.er_theta1_F_final_iter);

handles.er_theta2_F=[];
assignin('base', 'er_theta2_F',handles.er_theta2_F);

handles.er_theta2_F_conv=[];
assignin('base', 'er_theta2_F_conv',handles.er_theta2_F_conv);

handles.er_theta2_F_final_iter=[];
assignin('base', 'er_theta2_F_final_iter',handles.er_theta2_F_final_iter);

handles.er_theta3_F=[];
assignin('base', 'er_theta3_F',handles.er_theta3_F);

handles.er_theta3_F_conv=[];
assignin('base', 'er_theta3_F_conv',handles.er_theta3_F_conv);

handles.er_theta3_F_final_iter=[];
assignin('base', 'er_theta3_F_final_iter',handles.er_theta3_F_final_iter);


handles.er_theta4_F=[];
assignin('base', 'er_theta4_F',handles.er_theta4_F);

handles.er_theta4_F_conv=[];
assignin('base', 'er_theta4_F_conv',handles.er_theta4_F_conv);

handles.er_theta4_F_final_iter=[];
assignin('base', 'er_theta4_F_final_iter',handles.er_theta4_F_final_iter);

handles.no_of_runs_F_conv=0;
assignin('base', 'no_of_runs_F_conv',handles.no_of_runs_F_conv);

handles.theta_F_conv=[];
assignin('base', 'theta_F_conv',handles.theta_F_conv);

handles.iter_F_conv=[];
assignin('base', 'iter_F_conv',handles.iter_F_conv);

handles.outSim=0; %record saturated runs; if it is empty --> runs are OK
assignin('base', 'outSim',handles.outSim);

handles.xid_new=[];
assignin('base', 'xid_new',handles.xid_new);

handles.xid_byFIM=[];% this variable my be usless and removable!
assignin('base', 'xid_byFIM',handles.xid_byFIM);

handles.xid_ga=[];% input computed by genetic algorithm 
assignin('base', 'xid_ga',handles.xid_ga);

handles.xid_ms=[];% input computed by multiple start
assignin('base', 'xid_ms',handles.xid_ms);

handles.xid_gs=[];% input computed by global search
assignin('base', 'xid_gs',handles.xid_gs);

handles.fval_gs=[];
assignin('base', 'fval_gs',handles.fval_gs);

handles.fval_ga=[];% cost function genetic algorithm ; cost_func=det(FIM)
assignin('base', 'fval_ga',handles.fval_ga);

handles.fval_ms=[];
assignin('base', 'fval_ms',handles.fval_ms);

handles.yid_new=[]; % output vector asscoiated xid_new,
assignin('base', 'yid_new',handles.yid_new);

handles.yid_paper=[];% used for plot
assignin('base', 'yid_paper',handles.yid_paper);

handles.theta_est=[0 0 0 0;0 0 0 0];
assignin('base', 'theta_est',handles.theta_est);

handles.var_theta_est=[]; % variance of estimations;for the computation of Cramer-Rao bound
assignin('base', 'var_theta_est',handles.var_theta_est);

handles.yest_xid=[]; % output of model by using FIM-SPE estimation results and xid 
assignin('base', 'yest_xid',handles.yest_xid);

handles.CRB_true=[]; % Cramer-Rao bounds computed using theta_est
assignin('base', 'CRB_true',handles.CRB_true);

handles.var_CRB=[]; 
assignin('base', 'var_CRB',handles.var_CRB);

handles.rtheta_converge_flag=[]; % Memory of how many consequative convergence happend
assignin('base', 'rtheta_converge_flag',handles.rtheta_converge_flag);   % It is used in SS_stopping_rtheta.m

handles.er_theta=[];% Absolute Relative Error (ARE) using FIM-SPE
assignin('base', 'er_theta',handles.er_theta);
%% Prealocation added 16Aug-2018

handles.nxeq0=20;
assignin('base','nxeq0',handles.nxeq0);

handles.xeq0=zeros(1,handles.nxeq0);
assignin('base','xeq0',handles.xeq0);

handles.sigma_y=0.0001;
assignin('base', 'sigma_y',handles.sigma_y);

handles.y_var0=0;
assignin('base','y_var0',handles.y_var0);

%% Prealocation from getparameter

handles.xid_min=0;
assignin('base', 'xid_min',handles.xid_min);
%handles.xid_min=evalin('base', 'xid_min');

handles.xid_max=1;
assignin('base', 'xid_max',handles.xid_max);
%handles.xid_max=evalin('base', 'xid_max');

handles.yl_true=1e-6 + (1e-5 - 1e-6).*rand;
assignin('base', 'yl_true',handles.yl_true);
%handles.yl_true=evalin('base', 'yl_true');

handles.yh_true=1e-4 + (1e-2 - 1e-4).*rand;
assignin('base', 'yh_true',handles.yh_true);
%handles.yh_true=evalin('base', 'yh_true');


handles.m_true=.1 + (0.9-.1)*handles.xid_max*rand;
assignin('base', 'm_true',handles.m_true);
%handles.m_true=evalin('base', 'm_true');

  if handles.m_true <.2 || handles.m_true >= 0.8
            handles.s_true=30 + (50-30)*rand;
        elseif handles.m_true >= .2 && handles.m_true < 0.3
            handles.s_true=20 + (40-20)*rand;
        elseif handles.m_true >= .7 && handles.m_true < 0.8
            handles.s_true=20 + (40-20)*rand;
        elseif handles.m_true >= .3 && handles.m_true < 0.45
            handles.s_true=10 + (30-10)*rand;
        elseif handles.m_true >= .55 && handles.m_true < 0.7
            handles.s_true=10 + (30-10)*rand;
        else
            handles.s_true=5 + (20-5)*rand;
  end
             assignin('base', 's_true',handles.s_true);


handles.theta_true=[handles.yl_true handles.yh_true handles.m_true handles.s_true];
assignin('base', 'theta_true',handles.theta_true);


%% plot true model 2
 %Plot Data that is geenrated using Update GUI
       % rng('shuffle');%seeds the random number generator based on the current time.
                       %Thus, rand, randi, and randn produce a different sequence of

         handles.x_dg=linspace(handles.xid_min,handles.xid_max,10000); 
         assignin('base', 'x_dg',handles.x_dg);

         handles.theta_true=[handles.yl_true;handles.yh_true;handles.m_true;handles.s_true];
         assignin('base', 'theta_true',handles.theta_true);
         
         handles.y_var=handles.sigma_y*randn(1,length(handles.x_dg));
         assignin('base', 'y_var',handles.y_var);
         
         handles.yt_true=SSsigmoidFunc(handles.x_dg,handles.theta_true,0);
         assignin('base', 'yt_true',handles.yt_true);
         
         handles.yt_noise=SSsigmoidFunc(handles.x_dg,handles.theta_true,0);
         assignin('base', 'yt_noise',handles.yt_noise);
         
         handles.logyt_m=log(handles.yt_noise)+handles.y_var;
         assignin('base', 'logyt_m',handles.logyt_m);
         
%% basic curve fitting 3

 handles.eyL_th=100;% for fit modification
 assignin('base', 'eyL_th',handles.eyL_th);
 
 handles.em_th=150;
 assignin('base', 'eyL_th',handles.eyL_th);
 
 handles.Weight_gain1=1;%1e2;
 assignin('base', 'Weight_gain1',handles.Weight_gain1);      
  
 handles.Weight_gain2=1;
 assignin('base', 'Weight_gain2',handles.Weight_gain2);
        
 handles.WG_th=.5;
 assignin('base', 'WG_th',handles.WG_th);
 
 handles.bias=0;%1e-3;
 assignin('base', 'bias',handles.bias);
        
 handles.no_ini_samples_fim=4;
 assignin('base', 'no_ini_samples_fim',handles.no_ini_samples_fim);
        
 handles.no_next_iter=150;
 assignin('base', 'no_next_iter',handles.no_next_iter);
        
 handles.total_no_iterations=handles.no_ini_samples_fim+handles.no_next_iter;
 assignin('base', 'total_no_iterations',handles.total_no_iterations);
 
 handles.Nmax=handles.total_no_iterations;
 assignin('base', 'Nmax',handles.Nmax);
 
 handles.paramLB=[-7 -4 .01 .01];% lower limit of estimation, applies when trust-region method is used
 assignin('base', 'paramLB',handles.paramLB);
   
 handles.paramUB=[-3 -1 1 100];% upper limit of estimation
 assignin('base', 'paramUB',handles.paramUB);
   
 handles.xval=linspace(0,handles.xid_max,100);% for validation of estimated models
 assignin('base', 'xval',handles.xval); 
 
 handles.size_val=length(handles.xval);
 assignin('base', 'size_val',handles.size_val);
 
        handles.success_stop=0;
         assignin('base', 'success_stop',handles.success_stop); 
         
        handles.sucess_flag=0;
         assignin('base', 'sucess_flag',handles.sucess_flag); 
         
        handles.xid=[];
         assignin('base', 'xid',handles.xid); 
         
        handles.yid=[];
         assignin('base', 'yid',handles.yid); 
         
        handles.yest_val=[]; % output of model by using FIM-SPE estimation results and xid_val
         assignin('base', 'yest_val',handles.yest_val); 
        
        handles.fit_modification_flag=[];
         assignin('base', 'fit_modification_flag',handles.fit_modification_flag); 
         
        handles.WG=[];% Weightings for curve fittinG
         assignin('base', 'WG',handles.WG); 
         
        handles.WG_gain=[];
         assignin('base', 'WG_gain',handles.WG_gain); 
         
        handles.CRB=[];
         assignin('base', 'CRB',handles.CRB); 
         
         handles.FIM=[];
         assignin('base', 'FIM',handles.FIM); 
         
         handles.var_theta_est(handles.no_ini_samples_fim,:)=[0 0 0 0];
         assignin('base', 'var_theta_est',handles.var_theta_est); 
         
         handles.func_type=1;      % choose 0 to estimate the actual function, and 1 to estimate the logarithm of the function  
         assignin('base', 'func_type',handles.func_type); 
         
         handles.initial_setting=0;% curve fitting initilaization method: choose 0 for random initialization and 1 for using the most recent estimate  
         assignin('base', 'initial_setting',handles.initial_setting); 
  
         handles.opt_method=1;     % Choose the optimization algorithm of FIM (0 Genetic Algorithm | 1 GlobalSearch-default | 2 MultiStart)
          assignin('base', 'opt_method',handles.opt_method);   
         
         handles.same_xid_ini=1;
          assignin('base', 'same_xid_ini',handles.same_xid_ini); 
 
         %handles.rtheta_converge_flag(1:4)=[0 0 0 0];
         handles.rtheta_converge_flag=[];%[0 0 0 0];
          assignin('base', 'rtheta_converge_flag',handles.rtheta_converge_flag); 
        
         handles.iter_rtheta_converged=[];
          assignin('base', 'iter_rtheta_converged',handles.iter_rtheta_converged); 
          
         handles.iter_rtheta_conv=[];
          assignin('base', 'iter_rtheta_conv',handles.iter_rtheta_conv); 
          
         handles.xid_ini=[];
           assignin('base', 'xid_ini',handles.xid_ini);   
           
         handles.n=[];
            %assignin('base', 'n',handles.n);   
            
         handles.Session_Data=[];
         assignin('base','Session_Data',handles.Session_Data);
         
         handles.Stopping_rule_satisfied='No';
         assignin('base','Stopping_rule_satisfied', handles.Stopping_rule_satisfied);
         
         handles.Subject_Information=[];
         assignin('base','Subject_Information',handles.Subject_Information);
         
         handles.Session_Number=[];
         assignin('base','Session_Number',handles.Session_Number);
         
         handles.Session_Date=[];
         assignin('base','Session_Date',handles.Session_Date);

        %% FIM_estimation4
        handles.number_of_iteration=4;  %Changed from 5 to 4 by MA, 3 Oct 2019
        assignin('base','number_of_iteration',handles.number_of_iteration);
%% Update_estimation5
handles.yid_newGUI=[];
handles.i_xidnew=[];
handles.number_of_push=0;
assignin('base','number_of_push',handles.number_of_push);
handles.xid_paper=[];
handles.logyid_new=[];
handles.xData=[];
handles.pdpnts=[];
handles.yData=[];
handles.yidtemp=[];
handles.pdpnts=[];
handles.pnewfit=[];
handles.xidnm1=[];
handles.yidnm1=[];
handles.yest_xid=[];
handles.yest_val=[];

handles.pdpnts=[];
assignin('base','pdpnts',handles.pdpnts);
handles.poldfit=[];
assignin('base','poldfit',handles.poldfit);
handles.pnewpoint=[];
assignin('base','pnewpoint',handles.pnewpoint);
handles.pnewfit=[];
assignin('base','pnewfit',handles.pnewfit);
handles.thereshold_value=[];
assignin('base','thereshold_value',handles.thereshold_value);
%%
handles.table_var=[0 0 0 0;0 0 0 0];
assignin('base','table_var',handles.table_var);
%% Preallocation of Recording Data from Baseline 17Aug-2018

handles.initial=0;
assignin('base','initial',handles.initial);

handles.BaselineDate=[];
assignin('base','BaselineDate',handles.BaselineDate);

handles.xfim_gs=[];
assignin('base','xfim_gs',handles.xfim_gs);

handles.xid_fim_baseline=[];
assignin('base','xid_fim_baseline',handles.xid_fim_baseline);

handles.yid_fim_baseline=[];
assignin('base','yid_fim_baseline',handles.yid_fim_baseline);

handles.initialization=zeros(2,3);
handles.initialization(1,1)=0.50;
handles.initialization(1,2)=0.75;
handles.initialization(1,3)=1.00;
assignin('base','initialization',handles.initialization);

handles.iter_ation=0;
assignin('base','iter_ation',handles.iter_ation);

handles.adjustment_of_stopping(1)=2;
assignin('base','adjustment_of_stopping',handles.adjustment_of_stopping);

% slider (number of stopping rule) 
set(handles.slider1,'Min',1);
set(handles.slider1,'Max',5);
set(handles.slider1,'Value',2);
set(handles.slider1,'SliderStep',[0.25,0.25]);
set(handles.slider1,'Position',[4.2 10.7 24.5 1.5]);
handles.output=hObject;

% tollerance of parameters
handles.tol_rtheta=[0.01 0.01 0.01 0.01];
assignin('base','tol_rtheta',handles.tol_rtheta);

%Preallocation of Saving

handles.Name1=[];
assignin('base','Name1',handles.Name1)

handles.Name2=[];
assignin('base','Name2',handles.Name2)

handles.Name3=[];
assignin('base','Name3',handles.Name3)

handles.Name4=[];
assignin('base','Name4',handles.Name4)

handles.Name5=[];
assignin('base','Name5',handles.Name5)

handles.Name6=[];
assignin('base','Name6',handles.Name6)

handles.Name7=[];
assignin('base','Name7',handles.Name7)

handles.Name8=[];
assignin('base','Name8',handles.Name8)

handles.Name9=[];
assignin('base','Name9',handles.Name9)

handles.Name10=[];
assignin('base','Name10',handles.Name10)

handles.Name11=[];
assignin('base','Name11',handles.Name11)

handles.Name12=[];
assignin('base','Name12',handles.Name12)

handles.Name13=[];
assignin('base','Name13',handles.Name13)

handles.number_of_baselines=20;
assignin('base','number_of_baselines',handles.number_of_baselines);

handles.mean_baseline=[];
assignin('base','mean_baseline',handles.mean_baseline);

handles.breakGUI=0;
assignin('base','breakGUI',handles.breakGUI);

handles.Stopbreak=0;
assignin('base','Stopbreak',handles.Stopbreak);

handles.numberofpushpause=0;
assignin('base','numberofpushpause',handles.numberofpushpause);

%% Reading MEP from EMG 

handles.MEP_Baseline=0;
assignin('base','MEP_Baseline',handles.MEP_Baseline);

handles.MEP_Baseline2=0;
assignin('base','MEP_Baseline2',handles.MEP_Baseline2);

handles.MEP_Baseline3=0;
assignin('base','MEP_Baseline3',handles.MEP_Baseline3);

handles.MEP_TMSi=0;
assignin('base','MEP_TMSi',handles.MEP_TMSi);

handles.MEP_TMSi2=0;
assignin('base','MEP_TMSi2',handles.MEP_TMSi2);

handles.MEP_TMSi3=0;
assignin('base','MEP_TMSi3',handles.MEP_TMSi3);


handles.Trig_TMSi=0;
assignin('base','Trig_TMSi',handles.Trig_TMSi);

handles.x_art=0;
assignin('base','x_art',handles.x_art);

handles.TMSi_nloops=100;
assignin('base','TMSi_nloops',handles.TMSi_nloops);

handles.TMSi_TrigON=25;
assignin('base','TMSi_TrigON',handles.TMSi_TrigON);

handles.TMSi_TrigOFF=100;
assignin('base','TMSi_TrigOFF',handles.TMSi_TrigOFF);

handles.TMSi_sampling_rate=1024;
assignin('base','TMSi_sampling_rate',handles.TMSi_sampling_rate);

handles.TMS_latency=10;%mili seconds
assignin('base','TMS_latency',handles.TMS_latency);

handles.TMS_latency_sample_no=0;%mili seconds
assignin('base','TMS_latency_sample_no',handles.TMS_latency_sample_no);

handles.hpfilt_freq=30;%Hz
assignin('base','hpfilt_freq',handles.hpfilt_freq);

handles.uniform_samp_selected=0;
assignin('base','uniform_samp_selected',handles.uniform_samp_selected);

handles.uniform_samp_selected=0;% optimal sampling is default 
assignin('base','uniform_samp_selected',handles.uniform_samp_selected);


handles.uniform_pulses=[];
assignin('base','uniform_pulses',handles.uniform_pulses);

handles.uniform_pulses_with_repeat=[];
assignin('base','uniform_pulses_with_repeat',handles.uniform_pulses_with_repeat);


handles.random_indexes=[];
assignin('base','random_indexes',handles.random_indexes);

handles.random_uniform_pulses=[];
assignin('base','random_uniform_pulses',handles.random_uniform_pulses);

handles.uniform_mt=50;
assignin('base','uniform_mt',handles.uniform_mt);

handles.uniform_a1=0.9;
assignin('base','uniform_a1',handles.uniform_a1);

handles.uniform_a2=1.4;
assignin('base','uniform_a2',handles.uniform_a2);


handles.uniform_a3=0;
assignin('base','uniform_a3',handles.uniform_a3);

handles.uniform_no_of_samples_area2=15;
assignin('base','uniform_no_of_samples_area2',handles.uniform_no_of_samples_area2);

handles.uniform_no_of_samples_area3=5;
assignin('base','uniform_no_of_samples_area3',handles.uniform_no_of_samples_area3);

handles.uniform_no_of_samples_repeat=5;
assignin('base','uniform_no_of_samples_repeat',handles.uniform_no_of_samples_repeat);

handles.deltaM_area1=0;%Hz
assignin('base','deltaM_area1',handles.deltaM_area1);

handles.deltaM_area2=0;%Hz
assignin('base','deltaM_area2',handles.deltaM_area2);

handles.deltaM_area3=0;%Hz
assignin('base','deltaM_area3',handles.deltaM_area3);

handles.facil_per=200;%Hz
assignin('base','facil_per',handles.facil_per);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TMS_ioFit wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TMS_ioFit_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject,'String');
handles.yid_newGUI=str2double(str);
handles.yid_newGUI=handles.yid_newGUI*0.000001;
yid_fim_baseline=evalin('base','yid_fim_baseline');
handles.yid_fim_baseline=[yid_fim_baseline handles.yid_newGUI];
assignin('base','yid_fim_baseline',handles.yid_fim_baseline);
assignin('base', 'yid_newGUI',handles.yid_newGUI);
% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double
guidata(hObject,handles);




% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%$1
% if handles.number_of_push==0
   
    % exporting value from start bottom to workspace- Recording Baseline
    %% Automation Baseline Mep 
    % 23Oct_2019 .LN
%     
% handles.y_var0=evalin('base','y_var0');
% for j=1:handles.number_of_baselines
%     handles.y_var0(j)=10e6*10.^mep_gen(0);
% end

handles.number_of_baselines=evalin('base','number_of_baselines');

%========= Set-up Mobi Mini
handles.MEP_Baseline=evalin('base','MEP_Baseline');

samples=[];
library = TMSi.Library('bluetooth');

% Step 2: Find device to connect to. Keep on trying every second.
while numel(library.devices) == 0
    library.refreshDevices()
    pause(1);
end

device = library.getFirstDevice();

sampler = device.createSampler();
      
sampler.setSampleRate(handles.TMSi_sampling_rate);
sampler.setReferenceCalculation(true);
      
%sampler.connect();
% sampler.start();
  
handles.y_var0=evalin('base','y_var0');
      
      for i=1:handles.number_of_baselines
          i
          
            sampler.connect();
            sampler.start();
            samples=[];
            
            for kk=1:handles.TMSi_nloops
              samples = [samples sampler.sample()];
            end
         handles.MEP_Baseline=evalin('base','MEP_Baseline');   
         handles.MEP_Baseline(i,1:length(samples(1,:)))=samples(1,:);
         assignin('base', 'MEP_Baseline',handles.MEP_Baseline);
         
         length(samples(1,:))
         x1_mb=round(1*length(samples(1,:))/5)
         x2_mb=round(4*length(samples(1,:))/5)
         handles.MEP_Baseline3=evalin('base','MEP_Baseline3');   
         handles.MEP_Baseline3(i,1:length(samples(1,:)))=samples(1,1:length(samples(1,:)))-mean(samples(1,1:length(samples(1,:))));
         assignin('base', 'MEP_Baseline3',handles.MEP_Baseline3);
         

    filt1 = fdesign.highpass('n,f3db',4,2*handles.hpfilt_freq*(1/handles.TMSi_sampling_rate)); 
    hpFilt = design(filt1,'butter');
         
         handles.MEP_Baseline2(i,1:length(samples(1,:)))=filter(hpFilt,handles.MEP_Baseline3(i,1:length(samples(1,:)))); 
         assignin('base', 'MEP_Baseline2',handles.MEP_Baseline2);
         
%          if peak2peak(handles.MEP_Baseline2(i,x1_mb:x2_mb)) > 40
%              handles.y_var0(i)=40;%peak2peak(handles.MEP_Baseline2(i,1:length(samples)));  
%          elseif peak2peak(handles.MEP_Baseline2(i,x1_mb:x2_mb)) < 5
%              handles.y_var0(i)=5;%peak2peak(handles.MEP_Baseline2(i,1:length(samples)));  
%          else
             handles.y_var0(i)=peak2peak(handles.MEP_Baseline2(i,x1_mb:x2_mb));
%         end
          assignin('base', 'y_var0',handles.y_var0);
          
         sampler.stop();
         sampler.disconnect(); 
      end
      


% Stop Mbi Mini
% sampler.stop();

handles.nxeq0=length(handles.y_var0);
assignin('base','nxeq0',handles.nxeq0);
handles.mean_baseline=evalin('base','mean_baseline');
handles.mean_baseline=mean(handles.y_var0);
assignin('base','mean_baseline',handles.mean_baseline);
set(handles.edit15,'String',num2str(handles.mean_baseline));
   
    
%% Insert Initialization MEP automatically

% handles.initialization(2,1)=10e6*10.^mep_gen(handles.initialization(1,1));
% % handles.initialization(2,1)=handles.initialization(2,1)*0.000001;
% assignin('base','initialization',handles.initialization);
% set(handles.edit20,'String',num2str(handles.initialization(2,1)));

%% compute xid_fim_baseline when uniform sampling is chosen uniform_samp_selected ==1 

if handles.uniform_samp_selected == 1
    
    handles.uniform_a3=handles.xid_max/(handles.uniform_mt*.01);
    assignin('base','uniform_a3',handles.uniform_a3);
     set(handles.edit33,'String',num2str(handles.uniform_a3));
   
 
    handles.no_next_iter=(handles.uniform_no_of_samples_area2+...
                          handles.uniform_no_of_samples_area3)*handles.uniform_no_of_samples_repeat;
    assignin('base','no_next_iter',handles.no_next_iter);
    
    set(handles.edit4,'String',num2str(handles.no_next_iter));
    
    
    handles.deltaM_area2=(handles.uniform_a2-handles.uniform_a1)*handles.uniform_mt*.01/(handles.uniform_no_of_samples_area2-1);
    assignin('base','deltaM_area2',handles.deltaM_area2);
    
    handles.deltaM_area3=(handles.xid_max*100-handles.uniform_a2*handles.uniform_mt)*.01/(handles.uniform_no_of_samples_area3);
    assignin('base','deltaM_area3',handles.deltaM_area3);
    
    
    
 handles.uniform_pulses=handles.uniform_a1*handles.uniform_mt*.01:handles.deltaM_area2:handles.uniform_a2*handles.uniform_mt*.01;
 assignin('base','uniform_pulses',handles.uniform_pulses);
  
  
   if handles.uniform_no_of_samples_area3 == 1
      handles.uniform_pulses=[handles.uniform_pulses handles.xid_max];
   elseif handles.uniform_no_of_samples_area3 > 1
      handles.uniform_pulses=[handles.uniform_pulses...
          handles.uniform_a2*handles.uniform_mt*.01+handles.deltaM_area3:handles.deltaM_area3:handles.xid_max]; 
   end
    assignin('base','uniform_pulses',handles.uniform_pulses);
    
    
    
    handles.uniform_pulses_with_repeat=repelem(handles.uniform_pulses,handles.uniform_no_of_samples_repeat);
    assignin('base','uniform_pulses_with_repeat',handles.uniform_pulses_with_repeat);
    
    handles.random_indexes=randperm(length(handles.uniform_pulses_with_repeat),length(handles.uniform_pulses_with_repeat));
    assignin('base','random_indexes',handles.random_indexes);
    
    for kk=1:length(handles.uniform_pulses_with_repeat)
        handles.random_uniform_pulses(kk)=handles.uniform_pulses_with_repeat(handles.random_indexes(kk));
        assignin('base','random_uniform_pulses',handles.random_uniform_pulses);
    end

    %handles.xid_fim_baseline =[zeros(1,handles.nxeq0) handles.random_uniform_pulses];
    %assignin('base','xid_fim_baseline',handles.xid_fim_baseline);
    
    handles.initialization(1,1:3)=handles.random_uniform_pulses(1:3);
    assignin('base','initialization',handles.initialization);
    
    
    
    %===> write the first three pulses in the box
    set(handles.edit11,'String',num2str(round(handles.random_uniform_pulses(1)*100)));
    set(handles.edit12,'String',num2str(round(handles.random_uniform_pulses(2)*100)));
    set(handles.edit13,'String',num2str(round(handles.random_uniform_pulses(3)*100)));
end



%% 23Oct_2019 .LN 
% apply tms and then read the corresponding mep


s=daq.createSession('ni');
addDigitalChannel(s,'myDAQ1','Port0/Line0','OutputOnly');
outputSingleScan(s,[0]);

%=========  Set-up TMS device
% Set the serial port of the computer that is connected to COM2 of the TMS Device
myMV = magventure('COM4');  
% Connect to TMS device
myMV.connect();
% Enable TMS device
myMV.arm();
% Set TMS pulse amplitude

myMV.setAmplitude(round(100*handles.initialization(1,1)));


%========= Set-up Mobi Mini
samples=[];
library = TMSi.Library('bluetooth');

% Step 2: Find device to connect to. Keep on trying every second.
while numel(library.devices) == 0
    library.refreshDevices()
    pause(1);
end

device = library.getFirstDevice();

sampler = device.createSampler();
      
sampler.setSampleRate(handles.TMSi_sampling_rate);
sampler.setReferenceCalculation(true);
      
sampler.connect();
sampler.start();
  
      
      for i=1:handles.TMSi_nloops
          samples = [samples sampler.sample()];
          
          if i==handles.TMSi_TrigON
              % Trigger TMSi 
              outputSingleScan(s,[1]);
              % Trigger TMS Device
              myMV.fire();
          end
      
      end
      outputSingleScan(s,[0]);
      
      
% Disable TMS device
myMV.disarm();
% Disconnect TMS device 
myMV.disconnect(); 

% Stop Mbi Mini
sampler.stop();
sampler.disconnect();


%%% ====> Check MEP==0. If yes, re-apply the same pulse
trig_on=min(find(samples(3,:)==8));
trig_off=max(find(samples(3,:)==8));
if trig_off-trig_on < 24 % three time frame of TMSi loop
        %========= Set-up Mobi Mini
    pause(10);%puase 6 sec for the same pulse to apply
    PPP=1
    % Set the serial port of the computer that is connected to COM2 of the TMS Device
    myMV = magventure('COM4');  
    % Connect to TMS device
    myMV.connect();
    % Enable TMS device
    myMV.arm();
    % Set TMS pulse amplitude
    
   
        myMV.setAmplitude(round(100*handles.initialization(1,1)));
    
    samples=[];
    library = TMSi.Library('bluetooth');

    % Step 2: Find device to connect to. Keep on trying every second.
    while numel(library.devices) == 0
        library.refreshDevices()
        pause(1);
    end

    device = library.getFirstDevice();
    sampler = device.createSampler();
      
    sampler.setSampleRate(handles.TMSi_sampling_rate);
    sampler.setReferenceCalculation(true);
      
    sampler.connect();
    sampler.start();
  
      
    for i=1:handles.TMSi_nloops
          samples = [samples sampler.sample()];
          
          if i==handles.TMSi_TrigON
              % Trigger TMSi 
              outputSingleScan(s,[1]);
              % Trigger TMS Device
              myMV.fire();
          end
      
    end
      outputSingleScan(s,[0]);
      
      
    % Disable TMS device
    myMV.disarm();
    % Disconnect TMS device 
    myMV.disconnect(); 

    % Stop Mbi Mini
    sampler.stop();
    sampler.disconnect();

end
%%% <=== End of Check MEP==0



% get MEP

handles.MEP_TMSi=evalin('base','MEP_TMSi');
handles.MEP_TMSi(1,1:length(samples(1,:)))=samples(1,:);
assignin('base','MEP_TMSi',handles.MEP_TMSi);

handles.MEP_TMSi3=evalin('base','MEP_TMSi3');   
handles.MEP_TMSi3(1,1:length(samples))=samples(1,:)-mean(samples(1,:));
assignin('base', 'MEP_TMSi3',handles.MEP_TMSi3);
         

handles.Trig_TMSi=evalin('base','Trig_TMSi');
handles.Trig_TMSi(1,1:length(samples(3,:)))=samples(3,:);
assignin('base','Trig_TMSi',handles.Trig_TMSi);


handles.TMS_latency_sample_no=round(handles.TMSi_sampling_rate*handles.TMS_latency*10^-3);
assignin('base','TMS_latency_sample_no',handles.TMS_latency_sample_no);

trig_on=min(find(samples(3,:)==8));
trig_off=max(find(samples(3,:)==8));
handles.x_art=evalin('base','x_art');
handles.x_art(1,1)=trig_on;
handles.x_art(1,2)=trig_off;
assignin('base','x_art',handles.x_art);


if handles.initialization(1,1) > .50
    filt1 = fdesign.highpass('n,f3db',4,2*handles.hpfilt_freq*(1/handles.TMSi_sampling_rate)); %high-pass filter, cut off frequency at 10Hz, sampling frequency of 1kHz
else
    filt1 = fdesign.highpass('n,f3db',4,2*handles.hpfilt_freq*(1/handles.TMSi_sampling_rate)); 
end

hpFilt = design(filt1,'butter');
         
         %handles.MEP_TMSi2(1,1:handles.x_art(1,2)-handles.x_art(1,1)+1)=filter(hpFilt,handles.MEP_TMSi3(1,handles.x_art(1,1):handles.x_art(1,2))); 
         handles.MEP_TMSi2(1,1:length(samples(1,:)))=filter(hpFilt,handles.MEP_TMSi3(1,1:length(samples(1,:)))); 
         assignin('base', 'MEP_TMSi2',handles.MEP_TMSi2);


handles.initialization(2,1)=peak2peak(handles.MEP_TMSi2(1,handles.x_art(1,1)+handles.TMS_latency_sample_no:handles.x_art(1,2)));   
assignin('base','initialization',handles.initialization);
set(handles.edit20,'String',num2str(handles.initialization(2,1)));



%%
% 
% handles.initialization(2,2)=10e6*10.^mep_gen(handles.initialization(1,2));
% % handles.initialization(2,1)=handles.initialization(2,1)*0.000001;
% assignin('base','initialization',handles.initialization);
% set(handles.edit21,'String',num2str(handles.initialization(2,2)));

%% 23Oct_2019 .LN 

% apply tms and then read the corresponding mep

%=========  Set-up TMS device
% Set the serial port of the computer that is connected to COM2 of the TMS Device
myMV = magventure('COM4');  
% Connect to TMS device
myMV.connect();
% Enable TMS device
myMV.arm();
% Set TMS pulse amplitude


    myMV.setAmplitude(round(100*handles.initialization(1,2)));


%========= Set-up Mobi Mini
samples=[];
library = TMSi.Library('bluetooth');

% Step 2: Find device to connect to. Keep on trying every second.
while numel(library.devices) == 0
    library.refreshDevices()
    pause(1);
end

device = library.getFirstDevice();

sampler = device.createSampler();
      
sampler.setSampleRate(handles.TMSi_sampling_rate);
sampler.setReferenceCalculation(true);
      
sampler.connect();
sampler.start();
  
      
      for i=1:handles.TMSi_nloops
          samples = [samples sampler.sample()];
          
          if i==handles.TMSi_TrigON
              % Trigger TMSi 
              outputSingleScan(s,[1]);
              % Trigger TMS Device
              myMV.fire();
          end
      
      end
      outputSingleScan(s,[0]);
    
% Disable TMS device
myMV.disarm();
% Disconnect TMS device 
myMV.disconnect(); 

% Stop Mbi Mini
sampler.stop();
sampler.disconnect();


%%% ====> Check MEP==0. If yes, re-apply the same pulse
trig_on=min(find(samples(3,:)==8));
trig_off=max(find(samples(3,:)==8));
if trig_off-trig_on < 24 % three time frame of TMSi loop
        %========= Set-up Mobi Mini
    pause(10);%puase 6 sec for the same pulse to apply
    PPP=1
    % Set the serial port of the computer that is connected to COM2 of the TMS Device
    myMV = magventure('COM4');  
    % Connect to TMS device
    myMV.connect();
    % Enable TMS device
    myMV.arm();
    % Set TMS pulse amplitude
    
        myMV.setAmplitude(round(100*handles.initialization(1,2)));
   
    
    samples=[];
    library = TMSi.Library('bluetooth');

    % Step 2: Find device to connect to. Keep on trying every second.
    while numel(library.devices) == 0
        library.refreshDevices()
        pause(1);
    end

    device = library.getFirstDevice();
    sampler = device.createSampler();
      
    sampler.setSampleRate(handles.TMSi_sampling_rate);
    sampler.setReferenceCalculation(true);
      
    sampler.connect();
    sampler.start();
  
      
    for i=1:handles.TMSi_nloops
          samples = [samples sampler.sample()];
          
          if i==handles.TMSi_TrigON
              % Trigger TMSi 
              outputSingleScan(s,[1]);
              % Trigger TMS Device
              myMV.fire();
          end
      
    end
      outputSingleScan(s,[0]);
      
      
    % Disable TMS device
    myMV.disarm();
    % Disconnect TMS device 
    myMV.disconnect(); 

    % Stop Mbi Mini
    sampler.stop();
    sampler.disconnect();

end
%%% <=== End of Check MEP==0




% get MEP
handles.MEP_TMSi=evalin('base','MEP_TMSi');
handles.MEP_TMSi(2,1:length(samples(1,:)))=(samples(1,:));
assignin('base','MEP_TMSi',handles.MEP_TMSi);

handles.MEP_TMSi3=evalin('base','MEP_TMSi3');   
handles.MEP_TMSi3(2,1:length(samples))=samples(1,:)-mean(samples(1,:));
assignin('base', 'MEP_TMSi3',handles.MEP_TMSi3);


handles.Trig_TMSi=evalin('base','Trig_TMSi');
handles.Trig_TMSi(2,1:length(samples(3,:)))=samples(3,:);
assignin('base','Trig_TMSi',handles.Trig_TMSi);

trig_on=min(find(samples(3,:)==8));
trig_off=max(find(samples(3,:)==8));
handles.x_art=evalin('base','x_art');
handles.x_art(2,1)=trig_on;
handles.x_art(2,2)=trig_off;
assignin('base','x_art',handles.x_art);


if handles.initialization(1,2) > .50
    filt1 = fdesign.highpass('n,f3db',4,2*handles.hpfilt_freq*(1/handles.TMSi_sampling_rate)); %high-pass filter, cut off frequency at 10Hz, sampling frequency of 1kHz
else
    filt1 = fdesign.highpass('n,f3db',4,2*handles.hpfilt_freq*(1/handles.TMSi_sampling_rate)); 
end

hpFilt = design(filt1,'butter');


         %handles.MEP_TMSi2(2,1:handles.x_art(2,2)-handles.x_art(2,1)+1)=filter(hpFilt,handles.MEP_TMSi3(2,handles.x_art(2,1):handles.x_art(2,2))); 
         handles.MEP_TMSi2(2,1:length(samples(1,:)))=filter(hpFilt,handles.MEP_TMSi3(2,1:length(samples(1,:)))); 
         assignin('base', 'MEP_TMSi2',handles.MEP_TMSi2);


handles.initialization(2,2)=peak2peak(handles.MEP_TMSi2(2,handles.x_art(2,1)+handles.TMS_latency_sample_no:handles.x_art(2,2)));  
assignin('base','initialization',handles.initialization);
set(handles.edit21,'String',num2str(handles.initialization(2,2)));




 %%
    
% handles.initialization(2,3)=10e6*10.^mep_gen(handles.initialization(1,3));
% % handles.initialization(2,1)=handles.initialization(2,1)*0.000001;
% assignin('base','initialization',handles.initialization);
% set(handles.edit22,'String',num2str(handles.initialization(2,3)));

%% 23Oct_2019 .LN 
% apply tms and then read the corresponding mep

%=========  Set-up TMS device
% Set the serial port of the computer that is connected to COM2 of the TMS Device
myMV = magventure('COM4');  
% Connect to TMS device
myMV.connect();
% Enable TMS device
myMV.arm();
% Set TMS pulse amplitude


    myMV.setAmplitude(round(100*handles.initialization(1,3)));


%========= Set-up Mobi Mini
samples=[];
library = TMSi.Library('bluetooth');

% Step 2: Find device to connect to. Keep on trying every second.
while numel(library.devices) == 0
    library.refreshDevices()
    pause(1);
end

device = library.getFirstDevice();

sampler = device.createSampler();
      
sampler.setSampleRate(handles.TMSi_sampling_rate);
sampler.setReferenceCalculation(true);
      
sampler.connect();
sampler.start();
  
      
      for i=1:handles.TMSi_nloops
          samples = [samples sampler.sample()];
          
          if i==handles.TMSi_TrigON
              % Trigger TMSi 
              outputSingleScan(s,[1]);
              % Trigger TMS Device
              myMV.fire();
          end
      
      end
      outputSingleScan(s,[0]);
    
% Disable TMS device
myMV.disarm();
% Disconnect TMS device 
myMV.disconnect(); 

% Stop Mbi Mini
sampler.stop();
sampler.disconnect();


%%% ====> Check MEP==0. If yes, re-apply the same pulse
trig_on=min(find(samples(3,:)==8));
trig_off=max(find(samples(3,:)==8));
if trig_off-trig_on < 24 % three time frame of TMSi loop
        %========= Set-up Mobi Mini
    pause(10);%puase 6 sec for the same pulse to apply
    PPP=1
    % Set the serial port of the computer that is connected to COM2 of the TMS Device
    myMV = magventure('COM4');  
    % Connect to TMS device
    myMV.connect();
    % Enable TMS device
    myMV.arm();
    % Set TMS pulse amplitude
    
  
        myMV.setAmplitude(round(100*handles.initialization(1,3)));
  
    
    samples=[];
    library = TMSi.Library('bluetooth');

    % Step 2: Find device to connect to. Keep on trying every second.
    while numel(library.devices) == 0
        library.refreshDevices()
        pause(1);
    end

    device = library.getFirstDevice();
    sampler = device.createSampler();
      
    sampler.setSampleRate(handles.TMSi_sampling_rate);
    sampler.setReferenceCalculation(true);
      
    sampler.connect();
    sampler.start();
  
      
    for i=1:handles.TMSi_nloops
          samples = [samples sampler.sample()];
          
          if i==handles.TMSi_TrigON
              % Trigger TMSi 
              outputSingleScan(s,[1]);
              % Trigger TMS Device
              myMV.fire();
          end
      
    end
      outputSingleScan(s,[0]);
      
      
    % Disable TMS device
    myMV.disarm();
    % Disconnect TMS device 
    myMV.disconnect(); 

    % Stop Mbi Mini
    sampler.stop();
    sampler.disconnect();

end
%%% <=== End of Check MEP==0



% get MEP
handles.MEP_TMSi=evalin('base','MEP_TMSi');
handles.MEP_TMSi(3,1:length(samples(1,:)))=(samples(1,:));
assignin('base','MEP_TMSi',handles.MEP_TMSi);

handles.MEP_TMSi3=evalin('base','MEP_TMSi3');   
handles.MEP_TMSi3(3,1:length(samples))=samples(1,:)-mean(samples(1,:));
assignin('base', 'MEP_TMSi3',handles.MEP_TMSi3);

handles.Trig_TMSi=evalin('base','Trig_TMSi');
handles.Trig_TMSi(3,1:length(samples(3,:)))=samples(3,:);
assignin('base','Trig_TMSi',handles.Trig_TMSi);

trig_on=min(find(samples(3,:)==8));
trig_off=max(find(samples(3,:)==8));
handles.x_art=evalin('base','x_art');
handles.x_art(3,1)=trig_on;
handles.x_art(3,2)=trig_off;
assignin('base','x_art',handles.x_art);

if handles.initialization(1,3) > .50
    filt1 = fdesign.highpass('n,f3db',4,2*handles.hpfilt_freq*(1/handles.TMSi_sampling_rate)); %high-pass filter, cut off frequency at 10Hz, sampling frequency of 1kHz
else
    filt1 = fdesign.highpass('n,f3db',4,2*handles.hpfilt_freq*(1/handles.TMSi_sampling_rate)); 
end

hpFilt = design(filt1,'butter');


         %handles.MEP_TMSi2(3,1:handles.x_art(3,2)-handles.x_art(3,1)+1)=filter(hpFilt,handles.MEP_TMSi3(3,handles.x_art(3,1):handles.x_art(3,2))); 
         handles.MEP_TMSi2(3,1:length(samples(1,:)))=filter(hpFilt,handles.MEP_TMSi3(3,1:length(samples(1,:)))); 
         assignin('base', 'MEP_TMSi2',handles.MEP_TMSi2);


handles.initialization(2,3)=peak2peak(handles.MEP_TMSi2(3,handles.x_art(3,1)+handles.TMS_latency_sample_no:handles.x_art(3,2)));   
assignin('base','initialization',handles.initialization);
set(handles.edit22,'String',num2str(handles.initialization(2,3)));


    
    %%
handles.iter_ation=3;
set(handles.edit18,'String',num2str(handles.iter_ation));
assignin('base','iter_ation',handles.iter_ation);
        
handles.nxeq0=evalin('base','nxeq0');

handles.xeq0=zeros(1,handles.nxeq0);
assignin('base','xeq0',handles.xeq0);

handles.sigma_y=0.1 + (1-.1).*rand;
assignin('base', 'sigma_y',handles.sigma_y);

handles.y_var0=evalin('base','y_var0');


handles.initial(1,1:(handles.nxeq0+3))=[handles.xeq0(1,1:handles.nxeq0) handles.initialization(1,:)];
handles.initial(2,1:(handles.nxeq0+3))=[handles.y_var0(1,1:handles.nxeq0) handles.initialization(2,:)];
assignin('base', 'initial',handles.initial);
initial=evalin('base','initial');
handles.yid_fim_baseline=initial(2,:);
assignin('base','yid_fim_baseline',handles.yid_fim_baseline);

handles.xid_fim_baseline=initial(1,:);
assignin('base','xid_fim_baseline',handles.xid_fim_baseline)

initial=handles.initial;

%% plot true model
%  Leila: Delete ploting true model  17Aug-2018
         axes(handles.axes1);   
      if handles.plot_animation == 1 
          hold on
          xlabel('Pulse amplitude (% max output)');
          ylabel('MEP amplitude $(\mu V_{pk-pk})$','interpreter','latex');
          %title('FIM SPE')
          ax1=gca;
          ax1.FontName = 'Times New Roman';
          ax1.FontSize = 10;
          ax1.XLim=[0 1];
          ax1.YScale='log';
          %AX=legend('previous samples','new sample','previous fit','new fit');
          handles.test_d=[handles.theta_true';zeros(1,4);
          zeros(1,4)];
       end

%% plot curve fitting
  handles.n=handles.nxeq0;
  handles.number_of_iteration=evalin('base','number_of_iteration');
  
  SS_ini_FIM_GUI; 
            %%
      if plot_animation == 1 
      
        hold on
        % pdpnt plot data points
       % axes(handles.axes1);
        yest_val=evalin('base', 'yest_val');
        xid_fim_baseline=evalin('base','xid_fim_baseline');
        yid_fim_baseline=evalin('base','yid_fim_baseline');
        %% 24-7-98
        %yid_fim_baseline=1000000*(yid_fim_baseline);
        %hold on
        %axes(handles.axes1);
        pdpnts=plot(xid_fim_baseline(1:end-3),yid_fim_baseline(1:end-3),...
            'LineStyle','none',...
            'LineWidth',1,...
            'Marker','d',...
            'MarkerSize',8,...
            'MarkerEdgeColor','m',...
            'MarkerFaceColor','none');
         handles.y_var0=evalin('base','y_var0');
%          Rewrite2
%          hold on
%          axes(handles.axes1);
         pdpnts=plot(xid_fim_baseline((length(handles.y_var0)+1):end),yid_fim_baseline((length(handles.y_var0)+1):end),...
            'LineStyle','none',...
            'LineWidth',1,...
            'Marker','o',...
            'MarkerSize',8,...
            'MarkerEdgeColor','r',...
            'MarkerFaceColor','none');
%          hold on
%          axes(handles.axes1);
           pnewfit=plot(handles.xval,1e6*10.^(yest_val(m,1:end)),...
            'LineStyle','-',...
            'LineWidth',1,...
            'Color','r');
        AX=legend('Baseline sample','IO Curve Estimation','location','northwest');
        handles.yest_val=yest_val;
        assignin('base','yest_val',handles.yest_val);
        handles.pdpnts=pdpnts;
        assignin('base','pdpnts',handles.pdpnts);
        handles.pnewfit=pnewfit;
        assignin('base','pnewfit',handles.pnewfit);
          
        %% parameters
        
            evalin('base','theta_est(4,1)');
            handles.theta1_F(n)=theta_est(4,1);
            assignin('base','theta1_F',handles.theta1_F);
            
            evalin('base','theta_est(4,2)');
            handles.theta2_F(n)=theta_est(4,2);
            assignin('base','theta2_F',handles.theta2_F);
            
            evalin('base','theta_est(4,3)');
            handles.theta3_F(n)=theta_est(4,3);
            assignin('base','theta3_F',handles.theta3_F);
            
            evalin('base','theta_est(4,4)');
            handles.theta4_F(n)=theta_est(4,4);
            assignin('base','theta4_F',handles.theta4_F);
          

      end
     
% %% FIM_estimation4

xid= evalin('base','xid');
yid= evalin('base','y_var0');
handles.yid=yid;
                handles.xidnm1=xid;% to use for plot
                handles.yidnm1=yid;% to use for plot
                FIM=evalin('base','FIM');
                handles.FIM=FIM;
                assignin('base','FIM',handles.FIM);
                
                assignin('base','xidnm1',handles.xidnm1);
                assignin('base','yidnm1',handles.yidnm1);
    
    
                nxeq0=evalin('base','nxeq0');
                handles.nxeq0=evalin('base','nxeq0');
                 %% 22-7-98
                theta_est(end,:);
                handles.initialization=evalin('base','initialization');
                ObjFunc_FIM = @(x) SSfim_cost_modified(0,3,x,handles.initialization(1:3),theta_est(end,:),[],1);% 
                optsFIM = optimoptions(@fmincon,'Algorithm','interior-point');
                problem = createOptimProblem('fmincon','x0',handles.xid_max*rand,...
                    'objective',ObjFunc_FIM,'lb',0.1,'ub',handles.xid_max,'options',optsFIM);
%                 
%                 ObjFunc_FIM = @(x) SSfim_cost_modified(0,n-handles.nxeq0,x,handles.xid_fim_baseline(handles.nxeq0+1:end),theta_est(end,:),[],1);
%                  optsFIM = optimoptions(@fmincon,'Algorithm','interior-point');
%                 problem = createOptimProblem('fmincon','x0',handles.xid_max*rand,...
%                      'objective',ObjFunc_FIM,'lb',0.1,'ub',handles.xid_max,'options',optsFIM);
%                 
                 handles.FIM=FIM;
                 assignin('base','FIM',handles.FIM);
                
                         
                if handles.opt_method == 0 % ga was chosen
                    [xid_ga(handles.number_of_iteration),fval_ga(handles.number_of_iteration)] = ga(ObjFunc_FIM,1,[],[],[],[],xid_min,xid_max);
                    xid_new(handles.number_of_iteration)  = xid_ga(handles.number_of_iteration);
                    fval_x(handles.number_of_iteration)   =fval_ga(handles.number_of_iteration);
                elseif handles.opt_method == 1 % Global search was chosen
                    [xid_gs(handles.number_of_iteration),fval_gs(handles.number_of_iteration),flagm_gs,outptm_gs,manyminsm_gs] = run(GlobalSearch,problem);
                    xid_new(handles.number_of_iteration)  = xid_gs(handles.number_of_iteration);
                    handles.xfim_gs=xid_new(handles.number_of_iteration);
                    assignin('base','xfim_gs',handles.xfim_gs);
                   
                    fval_x(handles.number_of_iteration)   =fval_gs(handles.number_of_iteration);
                else   % MultiStartPoint was chosen
                    pts = xid_min + (xid_max-xid_min).*rand(200,1);
                    tpoints = CustomStartPointSet(pts);
                    allpts = {tpoints};
                
                    [xid_ms(handles.number_of_iteration),fval_ms(handles.number_of_iteration),flagm_ms,outptm_ms,manyminsm_ms] = run(MultiStart,problem,allpts);
                    xid_new(handles.number_of_iteration)  = xid_ms(handles.number_of_iteration);
                    fval_x(handles.number_of_iteration)   =fval_ms(handles.number_of_iteration);
                end
                
               
               % handles.xid_fim_baseline=[initial(1,:) handles.xfim_gs];
                
               if handles.uniform_samp_selected == 0
                   handles.xid_fim_baseline(handles.nxeq0+4)=handles.xfim_gs;
               elseif handles.uniform_samp_selected == 1
                   handles.xid_fim_baseline(handles.nxeq0+4)=handles.random_uniform_pulses(4);
               end
               assignin('base','xid_fim_baseline',handles.xid_fim_baseline);
              
                handles.xid_new=round(xid_new,2);
                
                handles.xid_byFIM(handles.number_of_iteration)=handles.xid_new(handles.number_of_iteration);
                assignin('base', 'xid_new',handles.xid_new);
                handles.xid_new(handles.number_of_iteration)=100*(handles.xid_new(handles.number_of_iteration));
                
                
                if handles.uniform_samp_selected == 0
                    set(handles.edit16,'String',num2str(handles.xid_new(handles.number_of_iteration)));
                elseif handles.uniform_samp_selected == 1
                    set(handles.edit16,'String',num2str(round(handles.random_uniform_pulses(4)*100)));
                end
                
                
                assignin('base', 'number_of_iteration',handles.number_of_iteration);
                %assignin('base','xid',handles.xid);
               handles.number_of_push=handles.number_of_push+1;
     
%$3
%elseif handles.number_of_push~=0

               handles.number_of_push=handles.number_of_push+1;
               assignin('base','number_of_push',handles.number_of_push);
%$4
% if  (handles.number_of_push)/2+2 < handles.no_next_iter
%  
%  if mod(handles.number_of_push,2)==0
%     bgClr = get(handles.pushbutton6,'BackgroundColor');
%     set(handles.pushbutton6,'BackgroundColor',[1 0 0]);
     %% Automation MEP
             % handles.yid_fim_baseline(handles.number_of_iteration+handles.nxeq0)=10e6*10.^mep_gen(handles.xid_fim_baseline(handles.number_of_iteration+handles.nxeq0));
             
     %% 23Oct_2019 .LN
     
     % apply tms and then read the corresponding mep

%=========  Set-up TMS device
% Set the serial port of the computer that is connected to COM2 of the TMS Device
myMV = magventure('COM4');  
% Connect to TMS device
myMV.connect();
% Enable TMS device
myMV.arm();
% Set TMS pulse amplitude
myMV.setAmplitude(round(100*handles.xid_fim_baseline(handles.number_of_iteration+handles.nxeq0)));
 

%========= Set-up Mobi Mini
samples=[];
library = TMSi.Library('bluetooth');

% Step 2: Find device to connect to. Keep on trying every second.
while numel(library.devices) == 0
    library.refreshDevices()
    pause(1);
end

device = library.getFirstDevice();

sampler = device.createSampler();
      
sampler.setSampleRate(handles.TMSi_sampling_rate);
sampler.setReferenceCalculation(true);
      
sampler.connect();
sampler.start();
  
      
      for i=1:handles.TMSi_nloops
          samples = [samples sampler.sample()];
          
          if i==handles.TMSi_TrigON
              % Trigger TMSi 
              outputSingleScan(s,[1]);
              % Trigger TMS Device
              myMV.fire();
          end
      
      end
      outputSingleScan(s,[0]);
    
% Disable TMS device
myMV.disarm();
% Disconnect TMS device 
myMV.disconnect(); 

% Stop Mbi Mini
sampler.stop();
sampler.disconnect();


%%% ====> Check MEP==0. If yes, re-apply the same pulse
trig_on=min(find(samples(3,:)==8));
trig_off=max(find(samples(3,:)==8));
if trig_off-trig_on < 24 % three time frame of TMSi loop
        %========= Set-up Mobi Mini
    pause(10);%puase 6 sec for the same pulse to apply
    
    % Set the serial port of the computer that is connected to COM2 of the TMS Device
    myMV = magventure('COM4');  
    % Connect to TMS device
    myMV.connect();
    % Enable TMS device
    myMV.arm();
    % Set TMS pulse amplitude
    myMV.setAmplitude(round(100*handles.xid_fim_baseline(handles.number_of_iteration+handles.nxeq0)));
 
    samples=[];
    library = TMSi.Library('bluetooth');

    % Step 2: Find device to connect to. Keep on trying every second.
    while numel(library.devices) == 0
        library.refreshDevices()
        pause(1);
    end

    device = library.getFirstDevice();
    sampler = device.createSampler();
      
    sampler.setSampleRate(handles.TMSi_sampling_rate);
    sampler.setReferenceCalculation(true);
      
    sampler.connect();
    sampler.start();
  
      
    for i=1:handles.TMSi_nloops
          samples = [samples sampler.sample()];
          
          if i==handles.TMSi_TrigON
              % Trigger TMSi 
              outputSingleScan(s,[1]);
              % Trigger TMS Device
              myMV.fire();
          end
      
    end
      outputSingleScan(s,[0]);
      
      
    % Disable TMS device
    myMV.disarm();
    % Disconnect TMS device 
    myMV.disconnect(); 

    % Stop Mbi Mini
    sampler.stop();
    sampler.disconnect();

end
%%% <=== End of Check MEP==0




% get MEP

handles.MEP_TMSi=evalin('base','MEP_TMSi');
handles.MEP_TMSi(4,1:length(samples(1,:)))=(samples(1,:));
assignin('base','MEP_TMSi',handles.MEP_TMSi);

handles.MEP_TMSi3=evalin('base','MEP_TMSi3');   
handles.MEP_TMSi3(4,1:length(samples))=samples(1,:)-mean(samples(1,:));
assignin('base', 'MEP_TMSi3',handles.MEP_TMSi3);


handles.Trig_TMSi=evalin('base','Trig_TMSi');
handles.Trig_TMSi(4,1:length(samples(3,:)))=samples(3,:);
assignin('base','Trig_TMSi',handles.Trig_TMSi);

trig_on=min(find(samples(3,:)==8));
trig_off=max(find(samples(3,:)==8));
handles.x_art=evalin('base','x_art');
handles.x_art(4,1)=trig_on;
handles.x_art(4,2)=trig_off;
assignin('base','x_art',handles.x_art);


if handles.xid_fim_baseline(handles.number_of_iteration+handles.nxeq0) > .50
    filt1 = fdesign.highpass('n,f3db',4,2*handles.hpfilt_freq*(1/handles.TMSi_sampling_rate)); %high-pass filter, cut off frequency at 10Hz, sampling frequency of 1kHz
else
    filt1 = fdesign.highpass('n,f3db',4,2*handles.hpfilt_freq*(1/handles.TMSi_sampling_rate)); 
end

hpFilt = design(filt1,'butter');



        % handles.MEP_TMSi2(4,1:handles.x_art(4,2)-handles.x_art(4,1)+1)=filter(hpFilt,handles.MEP_TMSi3(4,handles.x_art(4,1):handles.x_art(4,2))); 
        handles.MEP_TMSi2(4,1:length(samples(1,:)))=filter(hpFilt,handles.MEP_TMSi3(4,1:length(samples(1,:)))); 
        assignin('base', 'MEP_TMSi2',handles.MEP_TMSi2);


 handles.yid_fim_baseline(handles.number_of_iteration+handles.nxeq0)=peak2peak(handles.MEP_TMSi2(4,handles.x_art(4,1)+handles.TMS_latency_sample_no:handles.x_art(4,2)));   
                  
  handles.yid_fim_baseline(handles.number_of_iteration+handles.nxeq0)
  assignin('base', 'yid_fim_baseline',handles.yid_fim_baseline);
  set(handles.edit17,'String',num2str(handles.yid_fim_baseline(end)));
      
  
  
  
              %pause(4)
               push6;
 handles.no_next_iter=evalin('base','no_next_iter');       
               
 for i=5:handles.no_next_iter
  handles.number_of_iteration=i;   
 
 evalin('base','no_next_iter');

 
 assignin('base','number_of_iteration',handles.number_of_iteration);
 set(handles.edit18,'String',num2str(handles.number_of_iteration));
      
   
 %set(handles.uitable1,'Data',table_var);
 %%
     %set(handles.pushbutton6,'BackgroundColor',bgClr);


 %else
    
%      bgClr = get(handles.pushbutton6,'BackgroundColor');
%      set(handles.pushbutton6,'BackgroundColor',[0.16 0.27 0.16]);
%     
%      handles.number_of_iteration=5+(handles.number_of_push-1)/2;
%      assignin('base','number_of_iteration',handles.number_of_iteration);
      n=handles.number_of_iteration;

            theta_est=evalin('base','theta_est');
            
          
            evalin('base','theta_est(4,1)');
            handles.theta1_F(n)=theta_est(4,1);
            assignin('base','theta1_F',handles.theta1_F);
            
            evalin('base','theta_est(4,2)');
            handles.theta2_F(n)=theta_est(4,2);
            assignin('base','theta2_F',handles.theta2_F);
            
            evalin('base','theta_est(4,3)');
            handles.theta3_F(n)=theta_est(4,3);
            assignin('base','theta3_F',handles.theta3_F);
            
            evalin('base','theta_est(4,4)');
            handles.theta4_F(n)=theta_est(4,4);
            assignin('base','theta4_F',handles.theta4_F);
              %%%% FIM_estimation4

              xid_fim_baseline=evalin('base','xid_fim_baseline');
              yid_fim_baseline=evalin('base','yid_fim_baseline');
              %% Seeing
              xid_fim_baseline
              yid_fim_baseline
                handles.xidnm1=xid_fim_baseline;% to use for plot
                handles.yidnm1=yid_fim_baseline;% to use for plot

                
                assignin('base','xidnm1',handles.xidnm1);
                assignin('base','yidnm1',handles.yidnm1);
    
                var_theta_est=evalin('base','var_theta_est');
                FIM=evalin('base','FIM');
                no_ini_samples_fim=evalin('base','no_ini_samples_fim');  
                sigma_y=evalin('base','sigma_y');
                
               
                theta_est(end,:);
                ObjFunc_FIM = @(x) SSfim_cost_modified(0,handles.number_of_iteration,x,xid_fim_baseline(handles.nxeq0+1:end),theta_est(end,:),[],1);
                optsFIM = optimoptions(@fmincon,'Algorithm','interior-point');
                problem = createOptimProblem('fmincon','x0',handles.xid_max*rand,...
                    'objective',ObjFunc_FIM,'lb',0.1,'ub',handles.xid_max,'options',optsFIM);
                handles.FIM=FIM;
                assignin('base','FIM',handles.FIM);
                
                      
                if handles.opt_method == 0 % ga was chosen
                    [xid_ga(handles.number_of_iteration),fval_ga(handles.number_of_iteration)] = ga(ObjFunc_FIM,1,[],[],[],[],xid_min,xid_max);
                    xid_new(handles.number_of_iteration)  = xid_ga(handles.number_of_iteration);
                    fval_x(handles.number_of_iteration)   =fval_ga(handles.number_of_iteration);
                elseif handles.opt_method == 1 % Global search was chosen
                    [xid_gs(handles.number_of_iteration),fval_gs(handles.number_of_iteration),flagm_gs,outptm_gs,manyminsm_gs] = run(GlobalSearch,problem);
                    xid_new(handles.number_of_iteration)  = xid_gs(handles.number_of_iteration);
                    handles.xfim_gs=xid_new(handles.number_of_iteration);
                    assignin('base','xfim_gs',handles.xfim_gs);
                    fval_x(handles.number_of_iteration)   =fval_gs(handles.number_of_iteration);
                else   % MultiStartPoint was chosen
                    pts = xid_min + (xid_max-xid_min).*rand(200,1);
                    tpoints = CustomStartPointSet(pts);
                    allpts = {tpoints};
                
                    [xid_ms(handles.number_of_iteration),fval_ms(handles.number_of_iteration),flagm_ms,outptm_ms,manyminsm_ms] = run(MultiStart,problem,allpts);
                    xid_new(handles.number_of_iteration)  = xid_ms(handles.number_of_iteration);
                    fval_x(handles.number_of_iteration)   =fval_ms(handles.number_of_iteration);
                end
                %%
                
               handles.xid_new(handles.number_of_iteration)=round(xid_new(handles.number_of_iteration),2);
             
                handles.xid_new(handles.number_of_iteration)
               
                handles.xid_byFIM(handles.number_of_iteration)=handles.xid_new(handles.number_of_iteration);
                assignin('base', 'xid_new',handles.xid_new);
                handles.xid_new(handles.number_of_iteration)=(100).*(handles.xid_new(handles.number_of_iteration));
                
                if handles.uniform_samp_selected == 0
                    set(handles.edit16,'String',num2str(handles.xid_new(handles.number_of_iteration)));
                    xid_fim_baseline=evalin('base','xid_fim_baseline');
                    handles.xid_fim_baseline=[xid_fim_baseline handles.xfim_gs];
                elseif handles.uniform_samp_selected == 1
                    set(handles.edit16,'String',num2str(round(handles.random_uniform_pulses(handles.number_of_iteration)*100)));
                    xid_fim_baseline=evalin('base','xid_fim_baseline');
                    handles.xid_fim_baseline=[xid_fim_baseline handles.random_uniform_pulses(handles.number_of_iteration)];
                end
                
                assignin('base','xid_fim_baseline',handles.xid_fim_baseline);
                handles.xid_fim_baseline
              
                handles.xid_new=round(xid_new,2);
              
                %assignin('base','xid',handles.xid);

     %% Automation MEP
              %handles.yid_fim_baseline(handles.number_of_iteration+handles.nxeq0)=10e6*10.^mep_gen(handles.xid_fim_baseline(handles.number_of_iteration+handles.nxeq0));
              
              % apply tms and then read the corresponding mep

%=========  Set-up TMS device
% Set the serial port of the computer that is connected to COM2 of the TMS Device
myMV = magventure('COM4');  
% Connect to TMS device
myMV.connect();
% Enable TMS device
myMV.arm();
% Set TMS pulse amplitude
myMV.setAmplitude(round(100*handles.xid_fim_baseline(handles.number_of_iteration+handles.nxeq0)));
 

%========= Set-up Mobi Mini
samples=[];
library = TMSi.Library('bluetooth');

% Step 2: Find device to connect to. Keep on trying every second.
while numel(library.devices) == 0
    library.refreshDevices()
    pause(1);
end

device = library.getFirstDevice();

sampler = device.createSampler();
      
sampler.setSampleRate(handles.TMSi_sampling_rate);
sampler.setReferenceCalculation(true);
      
sampler.connect();
sampler.start();
  
      
     for i=1:handles.TMSi_nloops
          samples = [samples sampler.sample()];
          
          if i==handles.TMSi_TrigON
              % Trigger TMSi 
              outputSingleScan(s,[1]);
              % Trigger TMS Device
              myMV.fire();
          end
      
      end
      outputSingleScan(s,[0]);
    
% Disable TMS device
myMV.disarm();
% Disconnect TMS device 
myMV.disconnect(); 

% Stop Mbi Mini
sampler.stop();
sampler.disconnect();


%%% ====> Check MEP==0. If yes, re-apply the same pulse
trig_on=min(find(samples(3,:)==8));
trig_off=max(find(samples(3,:)==8));
if trig_off-trig_on < 24 % three time frame of TMSi loop
        %========= Set-up Mobi Mini
    pause(10);%puase 6 sec for the same pulse to apply
    
    % Set the serial port of the computer that is connected to COM2 of the TMS Device
    myMV = magventure('COM4');  
    % Connect to TMS device
    myMV.connect();
    % Enable TMS device
    myMV.arm();
    % Set TMS pulse amplitude
    myMV.setAmplitude(round(100*handles.xid_fim_baseline(handles.number_of_iteration+handles.nxeq0)));

    samples=[];
    library = TMSi.Library('bluetooth');

    % Step 2: Find device to connect to. Keep on trying every second.
    while numel(library.devices) == 0
        library.refreshDevices()
        pause(1);
    end

    device = library.getFirstDevice();
    sampler = device.createSampler();
      
    sampler.setSampleRate(handles.TMSi_sampling_rate);
    sampler.setReferenceCalculation(true);
      
    sampler.connect();
    sampler.start();
  
      
    for i=1:handles.TMSi_nloops
          samples = [samples sampler.sample()];
          
          if i==handles.TMSi_TrigON
              % Trigger TMSi 
              outputSingleScan(s,[1]);
              % Trigger TMS Device
              myMV.fire();
          end
      
    end
      outputSingleScan(s,[0]);
      
      
    % Disable TMS device
    myMV.disarm();
    % Disconnect TMS device 
    myMV.disconnect(); 

    % Stop Mbi Mini
    sampler.stop();
    sampler.disconnect();

end
%%% <=== End of Check MEP==0


% get MEP

handles.MEP_TMSi=evalin('base','MEP_TMSi');
handles.MEP_TMSi(handles.number_of_iteration,1:length(samples(1,:)))=(samples(1,:));
assignin('base','MEP_TMSi',handles.MEP_TMSi);

handles.MEP_TMSi3=evalin('base','MEP_TMSi3');
handles.MEP_TMSi3(handles.number_of_iteration,1:length(samples(1,:)))=samples(1,:)-mean(samples(1,:));
assignin('base','MEP_TMSi3',handles.MEP_TMSi3);

handles.Trig_TMSi=evalin('base','Trig_TMSi');
handles.Trig_TMSi(handles.number_of_iteration,1:length(samples(3,:)))=samples(3,:);
assignin('base','Trig_TMSi',handles.Trig_TMSi);

trig_on=min(find(samples(3,:)==8));
trig_off=max(find(samples(3,:)==8));
handles.x_art=evalin('base','x_art');
handles.x_art(handles.number_of_iteration,1)=trig_on;
handles.x_art(handles.number_of_iteration,2)=trig_off;
assignin('base','x_art',handles.x_art);


if handles.xid_fim_baseline(handles.number_of_iteration+handles.nxeq0) > .50
    filt1 = fdesign.highpass('n,f3db',4,2*handles.hpfilt_freq*(1/handles.TMSi_sampling_rate)); %high-pass filter, cut off frequency at 10Hz, sampling frequency of 1kHz
else
    filt1 = fdesign.highpass('n,f3db',4,2*handles.hpfilt_freq*(1/handles.TMSi_sampling_rate)); 
end

hpFilt = design(filt1,'butter');
         
%handles.MEP_TMSi2(handles.number_of_iteration,1:handles.x_art(handles.number_of_iteration,2)-handles.x_art(handles.number_of_iteration,1)+1)=...
%  filter(hpFilt,handles.MEP_TMSi3(handles.number_of_iteration,handles.x_art(handles.number_of_iteration,1):handles.x_art(handles.number_of_iteration,2))); 
handles.MEP_TMSi2(handles.number_of_iteration,1:length(samples(1,:)))=filter(hpFilt,handles.MEP_TMSi3(handles.number_of_iteration,1:length(samples(1,:)))); 

assignin('base', 'MEP_TMSi2',handles.MEP_TMSi2);

handles.yid_fim_baseline(handles.number_of_iteration+handles.nxeq0)=...
    peak2peak(handles.MEP_TMSi2(handles.number_of_iteration,handles.x_art(handles.number_of_iteration,1)+handles.TMS_latency_sample_no:handles.x_art(handles.number_of_iteration,2)));   
         
 handles.yid_fim_baseline(handles.number_of_iteration+handles.nxeq0)
 assignin('base', 'yid_fim_baseline',handles.yid_fim_baseline);
 set(handles.edit17,'String',num2str(handles.yid_fim_baseline(end))); 
 
 
%%
  push6;
  handles.number_of_iteration=handles.number_of_iteration+1;
%%
handles.breakGUI=evalin('base','breakGUI');
handles.Stopbreak=evalin('base','Stopbreak');

if handles.breakGUI==1 || handles.Stopbreak==1
    break
end
 end 
 
if handles.breakGUI==0 && handles.Stopbreak==0
 warndlg('Maximum number of pulses was taken, and the session is terminated!','Maximum Number Of Pulses');
end
%lend
%GUI_Copy_of_SS_Main_MahdiV4T5
guidata(hObject,handles);                                                                                                        



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.numberofpushpause=evalin('base','numberofpushpause');
handles.numberofpushpause=handles.numberofpushpause+1;
assignin('base','numberofpushpause',handles.numberofpushpause);

 pause
%  if mod(handles.numberofpushpause,2)==1
%       pause('on');
%      
%  else 
%      pause('off');
%         
%  end
guidata(hObject, handles);



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double

handles.xid_max=str2double(get(hObject,'String'));
handles.xid_max=(0.01)*(handles.xid_max);
assignin('base','xid_max',handles.xid_max);
handles.paramUB(3)=handles.xid_max;
assignin('base','paramUB',handles.paramUB);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
handles.no_next_iter= str2double(get(hObject,'String'));
 assignin('base', 'no_next_iter',handles.no_next_iter);
 guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double
str = get(hObject,'String');
handles.initialization(1,1)=str2double(str);
handles.initialization(1,1)=handles.initialization(1,1)*(0.01);
assignin('base','initialization',handles.initialization);
% %% Insert Initialization MEP automatically
% handles.initialization(2,1)=10e6*10.^mep_gen(handles.initialization(1,1));
% % handles.initialization(2,1)=handles.initialization(2,1)*0.000001;
% assignin('base','initialization',handles.initialization);
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
tolVal_yl=str2double(get(hObject,'String'));
handles.tol_rtheta(1,1)=tolVal_yl;
assignin('base','tol_rtheta',handles.tol_rtheta);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
tolVal_yh=str2double(get(hObject,'String'));
handles.tol_rtheta(1,2)=tolVal_yh;
assignin('base','tol_rtheta',handles.tol_rtheta);

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
tolVal_m=str2double(get(hObject,'String'));
handles.tol_rtheta(1,3)=tolVal_m;
assignin('base','tol_rtheta',handles.tol_rtheta);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double
tolVal_s=str2double(get(hObject,'String'));
handles.tol_rtheta(1,4)=tolVal_s;
assignin('base','tol_rtheta',handles.tol_rtheta);

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double
str = get(hObject,'String');
handles.initialization(1,2)=str2double(str);
handles.initialization(1,2)=handles.initialization(1,2)*(0.01);
assignin('base','initialization',handles.initialization);
%% Insert Initialization MEP automatically
str = get(hObject,'String');
handles.initialization(2,2)=10e6*10.^mep_gen(handles.initialization(1,2));
% handles.initialization(2,2)=handles.initialization(2,2)*0.000001;
assignin('base','initialization',handles.initialization);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double
str = get(hObject,'String');
handles.initialization(1,3)=str2double(str);
handles.initialization(1,3)=handles.initialization(1,3)*(0.01);
assignin('base','initialization',handles.initialization);
%% Insert Initialization MEP automatically
str = get(hObject,'String');
handles.initialization(2,3)=10e6*10.^mep_gen(handles.initialization(1,3));
%handles.initialization(2,3)=handles.initialization(2,3)*0.000001;
assignin('base','initialization',handles.initialization);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double
% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
% str = get(hObject,'String');
% handles.nxeq1=str2double(str);
% assignin('base', 'nxeq0',handles.nxeq0);
handles.number_of_baselines= str2double(get(hObject,'String'));
assignin('base', 'number_of_baselines',handles.number_of_baselines);
 
% %% Automation Baseline Mep 
% handles.y_var0=evalin('base','y_var0');
% for j=1:handles.number_of_baselines
%     handles.y_var0(j)=10e6*10.^mep_gen(0);
% end
% assignin('base', 'y_var0',handles.y_var0);
% handles.nxeq0=length(handles.y_var0);
% assignin('base','nxeq0',handles.nxeq0);
% handles.mean_baseline=evalin('base','mean_baseline');
% handles.mean_baseline=mean(handles.y_var0);
% assignin('base','mean_baseline',handles.mean_baseline);
% set(handles.edit15,'String',num2str(handles.mean_baseline));
guidata(hObject,handles);
 
 
 




% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double
%% Insert Baseline MEP automatically
str = get(hObject,'String');
handles.y_var0=str2num(str);
handles.y_var0=handles.y_var0*0.000001;
handles.y_var0;
assignin('base', 'y_var0',handles.y_var0);
handles.nxeq0=length(handles.y_var0);
assignin('base','nxeq0',handles.nxeq0);
set(handles.edit2,'String',num2str(handles.nxeq0));
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles=guidata(hObject);
newVal=get(handles.slider1,'Value');
newVal=round(newVal(1));
h0bject.Value=newVal;
set(handles.slider1,'value',newVal);
handles.adjustment_of_stopping=get(handles.slider1,'value');
assignin('base','adjustment_of_stopping',handles.adjustment_of_stopping);
set(handles.edit10,'String',num2str(newVal));
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
str = get(hObject,'String');
handles.Session_Number=(str);
assignin('base','Session_Number',handles.Session_Number);
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
str = get(hObject,'String');
handles.Session_Date=(str);
assignin('base','Session_Date',handles.Session_Date);
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
str = get(hObject,'String');
handles.Subject_Information=(str);
assignin('base','Subject_Information',handles.Subject_Information);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% % --- Executes on slider movement.
% function slider2_Callback(hObject, eventdata, handles)
% % hObject    handle to slider1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'Value') returns position of slider
% %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% 
% 
% % --- Executes during object creation, after setting all properties.
% function slider2_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to slider1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: slider controls usually have a light gray background.
% if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor',[.9 .9 .9]);
% end


% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Data',handles.theta_est(end-1:end,:));
disp(tables);
guidata(hObject,handles);

% --- Executes on key press with focus on uitable1 and none of its controls.
function uitable1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over figure background.
function figure1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


%% Later For Menu
% --------------------------------------------------------------------
% function Untitled_1_Callback(hObject, eventdata, handles)
% % hObject    handle to Untitled_1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% 
% % --------------------------------------------------------------------
% function Untitled_2_Callback(hObject, eventdata, handles)
% % hObject    handle to Untitled_2 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% 
% % --------------------------------------------------------------------
% function Untitled_3_Callback(hObject, eventdata, handles)
% % New Subject
% % hObject    handle to Untitled_3 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% close(handles.figure1)
% TMS_LAB
% 
% 
% % --------------------------------------------------------------------
% function Untitled_4_Callback(hObject, eventdata, handles)
% % Save
% % hObject    handle to Untitled_4 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% 
% % --------------------------------------------------------------------
% function Untitled_5_Callback(hObject, eventdata, handles)
% % Exit
% % hObject    handle to Untitled_5 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% close(handles.figure1)
% 
% 
% % --------------------------------------------------------------------
% function Untitled_6_Callback(hObject, eventdata, handles)
% % hObject    handle to Untitled_6 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% 
% % --------------------------------------------------------------------
% function Untitled_7_Callback(hObject, eventdata, handles)
% % hObject    handle to Untitled_7 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% 
% %Add name to arrays
% %1
% handles.Subject_Information=evalin('base','Subject_Information');
% handles.Subject_Information={handles.Subject_Information};
% assignin('base','Subject_Information',handles.Subject_Information);
% handles.Name1={'Subject_Name'};
% assignin('base','Name1',handles.Name1);
% 
% %2
% handles.Session_Date=evalin('base','Session_Date');
% handles.Session_Date={handles.Session_Date};
% assignin('base','Session_Date',handles.Session_Date);
% handles.Name2={'Session_Date'};
% assignin('base','Name2',handles.Name2);
% 
% %3
% handles.Session_Number=evalin('base','Session_Number');
% handles.Session_Number={handles.Session_Number};
% assignin('base','Session_Number',handles.Session_Number);
% handles.Name3={'Session_Number'};
% assignin('base','Name3',handles.Name3);
% 
% %4
% handles.no_next_iter=evalin('base','no_next_iter');
% handles.no_next_iter={handles.no_next_iter};
% assignin('base','no_next_iter',handles.no_next_iter);
% handles.Name4={'Maximum_number_of_pulses'};
% assignin('base','Name4',handles.Name4);
% 
% %5
% handles.nxeq0=evalin('base','nxeq0');
% handles.nxeq0={handles.nxeq0};
% assignin('base','nxeq0',handles.nxeq0);
% handles.Name5={'Number_Of_Baselinedata'};
% assignin('base','Name5',handles.Name5);
% 
% %6
% handles.y_var0=evalin('base','y_var0');
% handles.y_var0=handles.y_var0';
% assignin('base','y_var0',handles.y_var0);
% handles.Name6={'Baselinedata'};
% assignin('base','Name6',handles.Name6)
% 
% %7
% handles.xid_max=evalin('base','xid_max');
% handles.xid_max=handles.xid_max;
% assignin('base','xid_max',handles.xid_max);
% handles.Name7={'Maximum_TMS_Amplitude'};
% assignin('base','Name7',handles.Name7);
% 
% %8
% handles.xid_fim_baseline=evalin('base','xid_fim_baseline');
% handles.xid_fim_baseline=(handles.xid_fim_baseline)';
% assignin('base','xid_fim_baseline',handles.xid_fim_baseline);
% handles.Name8={'TMS_Pulses'};
% assignin('base','Name8',handles.Name8);
% 
% %9
% handles.yid_fim_baseline=evalin('base','yid_fim_baseline');
% handles.yid_fim_baseline=(handles.yid_fim_baseline)';
% assignin('base','yid_fim_baseline',handles.yid_fim_baseline);
% handles.Name9={'MEP_Amplitudes'};
% assignin('base','Name9',handles.Name9);
% 
% %10
% handles.theta_est=evalin('base','theta_est');
% handles.Name10={'Parameters';'yl,yh,m,s'};
% assignin('base','Name10',handles.Name10);
% 
% %11
% handles.tol_rtheta=evalin('base','tol_rtheta');
% handles.tol_rtheta=(handles.tol_rtheta)';
% assignin('base','tol_rtheta',handles.tol_rtheta);
% handles.Name11={'Convergence_Tolerancees';'yl,yh,m,s'};
% assignin('base','Name11',handles.Name11);
% 
% %12
% handles.iter_ation=evalin('base','iter_ation');
% handles.Name12={'Number_of_sampling'};
% assignin('base','Name12',handles.Name12);
% 
% %13
% handles.Stopping_rule_satisfied=evalin('base','Stopping_rule_satisfied');
% handles.Stopping_rule_satisfied={handles.Stopping_rule_satisfied};
% assignin('base','Stopping_rule_satisfied',handles.Stopping_rule_satisfied);
% handles.Name13={'Stopping_rule_satisfied'};
% assignin('base','Name13',handles.Name13);
% 
% %Creat structure consisting of workspace arrays
% handles.Session_Data=struct('Subject_Name',handles.Subject_Information,'Session_Number',handles.Session_Number,'Session_Date',handles.Session_Date,'Maximum_number_of_Pulses',handles.no_next_iter,'Number_Of_Baselinedata',handles.nxeq0,'Recorded_Baselinedata',handles.y_var0,'Maximum_TMS_Amplitude',handles.xid_max,'TMS_Amplitude',handles.xid_fim_baseline,'MEP_Amplitude',handles.yid_fim_baseline,'theta_estimation',handles.theta_est,'Convergence_Tolerances',handles.tol_rtheta,'Number_of_sampling',handles.iter_ation,'Stopping_rule_satisfied',handles.Stopping_rule_satisfied);
% assignin('base','Session_Data',handles.Session_Data);
% 
% %Get path
% [F P]=uiputfile('*.xlsx','Session_Data','Save Data as...');
% filename=fullfile(P,F);
% 
% %Save each of arrays 
% %1
% xlswrite(filename,handles.Name1,1,'A1');
% xlswrite(filename,handles.Subject_Information,1,'B1');
% %2
% xlswrite(filename,handles.Name2,2,'A1');
% xlswrite(filename,handles.Session_Date,2,'B1');
% %3
% xlswrite(filename,handles.Name3,3,'A1');
% xlswrite(filename,handles.Session_Number,3,'B1');
% %4
% xlswrite(filename,handles.Name4,4,'A1');
% xlswrite(filename,handles.no_next_iter,4,'B1');
% %5
% xlswrite(filename,handles.Name5,5,'A1');
% xlswrite(filename,handles.nxeq0,5,'B1');
% %6
% xlswrite(filename,handles.Name6,6,'A1');
% xlswrite(filename,handles.y_var0,6,'B1');
% %7
% xlswrite(filename,handles.Name7,7,'A1');
% xlswrite(filename,handles.xid_max,7,'B1');
% %8
% xlswrite(filename,handles.Name8,8,'A1');
% xlswrite(filename,handles.xid_fim_baseline,8,'B1');
% %9
% xlswrite(filename,handles.Name9,9,'A1');
% xlswrite(filename,handles.yid_fim_baseline,9,'B1');
% %10
% xlswrite(filename,handles.Name10,10,'A1');
% xlswrite(filename,handles.theta_est,10,'B1');
% %11
% xlswrite(filename,handles.Name11,11,'A1');
% xlswrite(filename,handles.tol_rtheta,11,'B1');
% %12
% xlswrite(filename,handles.Name12,12,'A1');
% xlswrite(filename,handles.iter_ation,12,'B1');
% xlswrite(filename,handles.Name13,12,'C1');
% xlswrite(filename,handles.Stopping_rule_satisfied,12,'D1');
% 
% clc
% 
% 
% 
% 
% 
% 
% % --------------------------------------------------------------------
% function Untitled_8_Callback(hObject, eventdata, handles)
% % hObject    handle to Untitled_8 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% [F P]=uiputfile('Input-Output Curve.fig','Save Figure as...');
% NewFig1=figure;
% NewAx1=copyobj(handles.axes1,NewFig1);
% set(NewAx1,'Units','normalized','Position',[0.08 0.1 0.85 0.75]);
% hgsave(NewFig1,[P F]);
% close(NewFig1);
% 
% 
% % --------------------------------------------------------------------
% function Untitled_9_Callback(hObject, eventdata, handles)
% % hObject    handle to Untitled_9 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% [F P]=uiputfile('Lower Plateaus Curve.fig','Save Figure as...');
% NewFig2=figure;
% NewAx2=copyobj(handles.axes2,NewFig2);
% set(NewAx2,'Units','normalized','Position',[0.08 0.1 0.85 0.75]);
% hgsave(NewFig2,[P F]);
% close(NewFig2);
% 
% 
% % --------------------------------------------------------------------
% function Untitled_10_Callback(hObject, eventdata, handles)
% % hObject    handle to Untitled_10 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% [F P]=uiputfile('Higher Plateaus Curve.fig','Save Figure as...');
% NewFig3=figure;
% NewAx3=copyobj(handles.axes3,NewFig3);
% set(NewAx3,'Units','normalized','Position',[0.08 0.1 0.85 0.75]);
% hgsave(NewFig3,[P F]);
% close(NewFig3);
% 
% 
% 
% % --------------------------------------------------------------------
% function Untitled_11_Callback(hObject, eventdata, handles)
% % hObject    handle to Untitled_11 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% [F P]=uiputfile('Mid point Curve.fig','Save Figure as...');
% NewFig4=figure;
% NewAx4=copyobj(handles.axes4,NewFig4);
% set(NewAx4,'Units','normalized','Position',[0.08 0.1 0.85 0.75]);
% hgsave(NewFig4,[P F]);
% close(NewFig4);
% 
% 
% % --------------------------------------------------------------------
% function Untitled_12_Callback(hObject, eventdata, handles)
% % hObject    handle to Untitled_12 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% [F P]=uiputfile('Slope Curve.fig','Save Figure as...');
% NewFig5=figure;
% NewAx5=copyobj(handles.axes5,NewFig5);
% set(NewAx5,'Units','normalized','Position',[0.08 0.1 0.85 0.75]);
% hgsave(NewFig5,[P F]);
% close(NewFig5);



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Stopbreak=1;
assignin('base','Stopbreak',handles.Stopbreak);



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double
str = get(hObject,'String');
handles.TMS_latency=str2double(str);
assignin('base','TMS_latency',handles.TMS_latency);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double
str = get(hObject,'String');
handles.TMSi_sampling_rate=str2double(str);
assignin('base','TMSi_sampling_rate',handles.TMSi_sampling_rate);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double
str = get(hObject,'String');
handles.hpfilt_freq=str2double(str);
assignin('base','hpfilt_freq',handles.hpfilt_freq);
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function uibuttongroup1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% c=get(hObject.uibuttongroup1,'SelectedObject') 
% if get(c,'String') == 'Uniform'
%     handles.uniform_samp_selected=1;
% else
%     handles.uniform_samp_selected=0;
% end
% assignin('base','uniform_samp_selected',handles.uniform_samp_selected);
% guidata(hObject, handles);


% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'String') == 'Uniform'
    handles.uniform_samp_selected=1;
elseif get(hObject,'String') == 'Optimal'
    handles.uniform_samp_selected=0;
end
assignin('base','uniform_samp_selected',handles.uniform_samp_selected);
guidata(hObject, handles);



function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double
handles.uniform_mt= str2double(get(hObject,'String'));
 assignin('base', 'uniform_mt',handles.uniform_mt);
 guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit27_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double

handles.uniform_a1= str2double(get(hObject,'String'));
 assignin('base', 'uniform_a1',handles.uniform_a1);
 guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit28_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit28 as text
%        str2double(get(hObject,'String')) returns contents of edit28 as a double


% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit29_Callback(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit29 as text
%        str2double(get(hObject,'String')) returns contents of edit29 as a double

handles.uniform_a2= str2double(get(hObject,'String'));
assignin('base','uniform_a2',handles.uniform_a2);
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function edit30_Callback(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit30 as text
%        str2double(get(hObject,'String')) returns contents of edit30 as a double

handles.uniform_no_of_samples_area2= str2double(get(hObject,'String'));
assignin('base','uniform_no_of_samples_area2',handles.uniform_no_of_samples_area2);
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit31_Callback(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit31 as text
%        str2double(get(hObject,'String')) returns contents of edit31 as a double

handles.uniform_no_of_samples_area3= str2double(get(hObject,'String'));
assignin('base','uniform_no_of_samples_area3',handles.uniform_no_of_samples_area3);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double

handles.uniform_no_of_samples_repeat= str2double(get(hObject,'String'));
assignin('base','uniform_no_of_samples_repeat',handles.uniform_no_of_samples_repeat);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit33_Callback(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit33 as text
%        str2double(get(hObject,'String')) returns contents of edit33 as a double
% handles.uniform_a3= str2double(get(hObject,'String'));
% assignin('base','uniform_a3',handles.uniform_a3);

 
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit34_Callback(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit34 as text
%        str2double(get(hObject,'String')) returns contents of edit34 as a double

handles.facil_per= str2double(get(hObject,'String'));
assignin('base','facil_per',handles.facil_per);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
