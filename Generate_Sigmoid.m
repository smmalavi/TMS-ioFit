  %========> Sigmoid function           
  function [yid]=Generate_Sigmoid(xid)
  % Number of yid
  %global sigma_y yl_true yh_true m_true s_true theta_true 
  
  %sigma_y=evalin('base','sigma_y');
  sigma_y=evalin('base','sigma_y');
  yl_true=evalin('base','yl_true');
  yh_true=evalin('base','yh_true');
  m_true=evalin('base','m_true');
  s_true=evalin('base','s_true');
  %theta_true=evalin('base','theta_true');
   n=1;
   yid=[];
   % 0.05+(0.5-0.05).*rand
   % export from GUI Initialization by Stsrt 
   % xid=exportfromgui;
        % prealocating in initialization
        %xid_min=0;
        %xid_max=1;
       % xid=(xid_min + (xid_max-xid_min)*rand(1,4));
       % x_dg=linspace(xid_min,xid_max,10000);
        
        %% Generate true model
%         yl_true=1e-6 + (1e-5 - 1e-6).*rand;
%         yh_true=1e-4 + (1e-2 - 1e-4).*rand;
%         m_true=.1 + (0.9-.1)*xid_max*rand;
%       
% 
%         if m_true <.2 || m_true >= 0.8
%             s_true=30 + (50-30)*rand;
%         elseif m_true >= .2 && m_true < 0.3
%             s_true=20 + (40-20)*rand;
%         elseif m_true >= .7 && m_true < 0.8
%             s_true=20 + (40-20)*rand;
%         elseif m_true >= .3 && m_true < 0.45
%             s_true=10 + (30-10)*rand;
%         elseif m_true >= .55 && m_true < 0.7
%             s_true=10 + (30-10)*rand;
%         else
%             s_true=5 + (20-5)*rand;
%         end
%        

       %% sigmoid function
       
        theta_true=[yl_true;yh_true;m_true;s_true];
        yid(1:n)=SSsigmoidFunc(xid,theta_true,0)*exp(sigma_y*randn(1,1)); 
        % y_var=sigma_y*randn;
        % yid(1:n)= yid(1:n)+y_var;
        % yid=(yid)*sigma_y*randn(1);
       
       %% plot sigmid funtion
          %y_var=sigma_y*randn(1,length(x_dg));
          %yt_true=SSsigmoidFunc(x_dg,theta_true,0);
          %yid(1:n)=SSsigmoidFunc(xid,theta_true,y_var);
          
%         yt_noise=SSsigmoidFunc(x_dg,theta_true,0);
%         logyt_m=log(yt_noise)+y_var;
%         
%         figure
%         plot(x_dg,logyt_m,'x','Color', [0.5 0.5 0.5]);
%         hold on
%         plot(x_dg,log(yt_true),'k','LineWidth',1);

  end         