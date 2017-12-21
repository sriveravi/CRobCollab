function inside = IsInRectSR(x,y,rect)
% inside = IsInRectSR(x,y,rect)
%
% Is location x,y inside the rect?
%
% Also see PsychRects.

% 3/5/97  dhb  Wrote it (psychtoolbox).
% 3/27/2014  SR modified

% if 
   inside = (x >= rect(RectLeft) & x <= rect(RectRight) & ...
		y >= rect(RectTop) & y <= rect(RectBottom) );
% 	inside = 1;
% else
% 	inside = 0;
% end
