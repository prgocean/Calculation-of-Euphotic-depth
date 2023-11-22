function eu_dep=function_euphoticdepth(PAR,Z)
% Function to calculate Euphotic depth
% the depth at which net photosynthesis 
%(i.e. carbon dioxide uptake by photosynthesis minus carbon dioxide release by respiration) 
% occurs in a light intensity about 1 percent of that at the surface. 

%==========================================================
% AUTHOR :
% Prasanth Rajendran
% INCOIS, Hydrabad
% prasanth.rajendran6@gmail.com
%==========================================================
% USAGE: 
% eu_dep = function_euphoticdepth(PAR,Z)
% eu_dep - Euphotic depth (m)
% PAR    - Photosynthetically Active Radiation (vertical profiles)
% Z      - depth values
% This function determines euphotic depth from profile data sets
%===========================================================

% Check inputs
if (nargin ~= 2)
   error('function_euphoticdepth.m: should have two parameters')
end

% Dimension Check
[lz, lt, lx]=size(PAR) ;

if (lz ~= length(Z))
    error('function_euphoticdepth.m: Z - level must be same as PAR')
end

%%
data=reshape(PAR, lz, lt*lx);
oce=~isnan(data(1, :)); % Not land portion since land portion is NAN
land=isnan(data(1, :)); % Land portion location
data(:, land)=[];
[~, n5]=size(data);

%%
% Calculate 1% of surface PAR
par0 = data(1,:)      ; % surface PAR
par_1per = par0.*0.01 ; % 1% of surface PAR

zeu=NaN(n5, 1);

%%
% Calculate euphotic depth
for ii=1:n5
 t=data(:, ii) ;
 pos1=find( t < par_1per(ii));

    if ((numel(pos1) > 0) && (pos1(1) > 1))
        p2=pos1(1);
        p1=p2-1;
        zeu(ii)=interp1(t([p1, p2]), Z([p1, p2]), par_1per(ii));
    else
        zeu(ii)=NaN;
    end
end

 %%   
eu_dep=NaN(1, lt*lx);
eu_dep(oce)=zeu;
eu_dep=reshape(eu_dep, lt, lx);

%============== END OF FUNCTION =====================================
