function SingleParticle_GUI(varargin)

if nargin == 0
    varargin = {'Ayca','V1'};
elseif nargin == 1
    varargin = {varargin{1},'V1'};
end

GUI_makeGUI(varargin);