function SingleParticle_GUI(varargin)

if nargin == 0
    varargin = {'hybrid','V1'};
elseif nargin == 1
    varargin = {varargin{1},'V1'};
end

GUI_makeGUI(varargin);