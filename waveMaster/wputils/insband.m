function [wi,x1,y1,x2,y2]=insband(bnd,wx,basis,q,sizx,sizy)

%INSBAND    Inserts a wavelet band into a wavelet packet transform.
%
%           WI = INSBAND (BAND,W,BASIS,N) inserts the subband
%	    BAND into the Wavelet Packet transform W obtained with BASIS,
%	    at the location of the N-th subband.
%
%	    WI = INSBAND (BAND,W,BASIS,N,SIZX,SIZY) can be also used,
%	    providing the number of columns SIZX and rows SIZY of the
%	    original signal. This must be used if any of that sizes is
%	    not a power of two. By default, they are set to the size of W.
%
%           If the inserted band does not fit the band hole, then it
%           will be cut or padded with zeros. Giving a single constant
%	    value for BAND instead of a matrix will result in making the
%	    specified band to be filled with that value.
%
%           [WI,X1,Y1,X2,Y2] = INSBAND (...) will also return
%           the final coordinates of the resulting inserted band.
%
%	    This function works with two dimensional transforms but can
%	    be applied to one dimensional ones. The X or Y coordinates
%	    will be equal to 1 depending on SIZX, SIZY. 
%
%           See also: SITEBAND, EXTBAND, WPK2D, WPK.

%--------------------------------------------------------
% Copyright (C) 1994, 1995, 1996, by Universidad de Vigo 
%                                                      
%                                                      
% Uvi_Wave is free software; you can redistribute it and/or modify it      
% under the terms of the GNU General Public License as published by the    
% Free Software Foundation; either version 2, or (at your option) any      
% later version.                                                           
%                                                                          
% Uvi_Wave is distributed in the hope that it will be useful, but WITHOUT  
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or    
% FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License    
% for more details.                                                        
%                                                                          
% You should have received a copy of the GNU General Public License        
% along with Uvi_Wave; see the file COPYING.  If not, write to the Free    
% Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.             
%                                                                          
%       Author: Santiago Gonzalez Sanchez
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------


if nargin==4			% Original matrix size = transform matrix size.
	sizx=size(wx,2);	% This is always true when original sizes are
	sizy=size(wx,1);	% power of two.
end
	
[x1,y1,x2,y2]=siteband(sizx,sizy,basis,q);	% Calculate the correct 
if x1==-1					% place of the requested band.
	return					% On error (non existing band), 
end						% do nothing.

wdb=x2-x1+1;			% Correct size of the band
htb=y2-y1+1;
[hti,wdi]=size(bnd);		% Actual size of the given band

h=min(hti,htb);			% Compare and select the minimum
w=min(wdi,wdb);			% to fit it in the hole.

if [hti,wdi]==[1,1],		% if the given band is a single number
	tm=bnd*ones(htb,wdb);	% then fill it in the wavelet with the
else				% value, else pad the given band with
	tm=zeros(htb,wdb);	% zeros or cut it,... 
	tm(1:h,1:w)=bnd(1:h,1:w);
end

wi=wx;
wi(y1:y2,x1:x2)=tm;		% ... and insert.
