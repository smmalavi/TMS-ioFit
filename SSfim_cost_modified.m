%==========================================================================
% In this file: computation of Fisher Information Matrix (FIM)  
%==========================================================================
%
% Optimal Estimation of Neural Recruitment Curves Using Fisher Information: 
%         Application to Transcranial Magnetic Stimulation 
%
% Seyed Mohammad Mahdi Alavi, Stefan M. Goetz, Angel V. Peterchev
%
%
% S.M.M. Alavi is with the
% Department of Electrical Engineering, and the
% Institute of Medical Science and Technology,
% Shahid Beheshti University, Iran. 
% He was with the
% Department of Psychiatry and Behavioral Sciences,
% Duke University, Durham, NC 27710, USA.
% e-mail: mahdi.alavi.work@gmail.com
%
% S.M. Goetz is with the Departments of
% Psychiatry and Behavioral Sciences,
% Electrical and Computer Engineering, and
% Neurosurgery,
% Duke University,
% Durham, NC 27710, USA,
% e-mail: stefan.goetz@duke.edu
%
% A.V. Peterchev is with the Departments of
% Psychiatry and Behavioral Sciences,
% Biomedical Engineering,
% Electrical and Computer Engineering, and
% Neurosurgery,
% Duke University,
% Durham, NC 27710, USA.
% e-mail: angel.peterchev@duke.edu
%
% This work was supported by
% the National Institutes of Health (NIH) under grant nos.
%           R01MH091083, R01NS088674, and RF1MH114268, and
% the Brain Behavior Research Foundation under NARSAD award no. 3837144.
%
% Copyright statement: The IEEE Ocean code copyright statement is applied.  
%                     Visit https://codeocean.com for more information. 
%
% Published on CodeOcean in 2018
%==========================================================================





function [y,FIM] = SSfim_cost_modified(n0,n,x,xid,theta,sigma_y,z)
    if n>1 
    % partial derivatives
    Si2nm1=1./(1+10.^((theta(3)-xid)*theta(4)));
    Si3nm1=-(theta(2)-theta(1))*theta(4)*10.^((theta(3)-xid)*theta(4)).*Si2nm1.^2*log(10);
    Si4nm1=-(theta(2)-theta(1))*(theta(3)-xid).*10.^((theta(3)-xid)*theta(4)).*Si2nm1.^2*log(10);
       
    % F_n(x_{1:n})
    FIMnm1=[
              dot(Si2nm1,Si2nm1) dot(Si2nm1,Si3nm1) dot(Si2nm1,Si4nm1);
              dot(Si3nm1,Si2nm1) dot(Si3nm1,Si3nm1) dot(Si3nm1,Si4nm1);
              dot(Si4nm1,Si2nm1) dot(Si4nm1,Si3nm1) dot(Si4nm1,Si4nm1)];
    else 
        FIMnm1=zeros(3,3);
    end
        
   %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
   
  
    Sn2=1./(1+10^((theta(3)-x)*theta(4)));
    Sn3=-(theta(2)-theta(1))*theta(4)*10^((theta(3)-x)*theta(4))*Sn2^2*log(10);
    Sn4=-(theta(2)-theta(1))*(theta(3)-x)*10^((theta(3)-x)*theta(4))*Sn2^2*log(10);
    
    % deltaF_{n+1}(x_{n+1})
        FIMn=[
              dot(Sn2,Sn2) dot(Sn2,Sn3) dot(Sn2,Sn4);
              dot(Sn3,Sn2) dot(Sn3,Sn3) dot(Sn3,Sn4);
              dot(Sn4,Sn2) dot(Sn4,Sn3) dot(Sn4,Sn4)];  
    
    % sum them up     
        FIM=(FIMnm1+FIMn);
       
%         if n>n0+1
%             y=-det(FIM);
%         else
%             y=-det(FIM);
%         end
         
       y=-det(FIM);
    
        
   

