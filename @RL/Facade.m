function varargout = Facade(RL,varargin)


if nargin && ischar(varargin{1})
    facade_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = facade_Callback(RL, varargin{:});
else
    facade_Callback(RL, varargin{:});
end

function [] = Init(RL,varargin)

if nargin>=2
HandleGammaCB(RL,[],varargin{2})
if nargin>=3
HandleLambdaCB(RL,[],varargin{3})
if nargin>=4
HandleAlphaCB(RL,[],varargin{4})
if nargin>=5
HandleAlphaDecreaseCB(RL,[],varargin{5})
if nargin>=6
HandleAlphaDecreaseValCB(RL,[],varargin{6})
if nargin>=7
HandleEpsCB(RL,[],varargin{7})
if nargin>=8
HandleEpsDecreaseCB(RL,[],varargin{8})
if nargin>=9
HandleEpsDecreaseValCB(RL,[],varargin{9})
if nargin>=10
HandleNofMaxStepsCB(RL,[],varargin{10})
if nargin>=11
HandleReplacingTracesCB(RL,[],varargin{11})
if nargin>=12
HandleEnableRandomIcCB(RL,[],varargin{12})
if nargin>=13
HandleModelGraphicsCB(RL,[],varargin{13})
if nargin>=14
Set(RL,'plot_learning_handle',varargin{14})
if nargin>=15
Set(RL,'plot_Q_handle',varargin{15})
if nargin>=16
Set(RL,'plot_model_handle',varargin{16})
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end

% ---- Incoming data to pass to RL:

function [] = HandleEpsCB(RL,varargin)

    eps =  varargin{2};
    if ischar(eps) ; eps = str2double(eps) ; end
    Set(RL,'eps',eps);

function [] = HandleEpsDecreaseValCB(RL,varargin)

    val =  varargin{2};
    if ischar(val) ; val = str2double(val) ; end
    Set(RL,'eps_decrease_val',val);

function [] = HandleEpsDecreaseCB(RL,varargin)

    eps_decrease =  varargin{2};
    Set(RL,'eps_decrease',eps_decrease);

function [] = HandleAlphaCB(RL,varargin)

    alpha =  varargin{2};
    if ischar(alpha) ; alpha = str2double(alpha) ; end
    Set(RL,'alpha',alpha);
        
function [] = HandleAlphaDecreaseValCB(RL,varargin)

    val =  varargin{2};
    if ischar(val) ; val = str2double(val) ; end
    Set(RL,'alpha_decrease_val',val);

function [] = HandleAlphaDecreaseCB(RL,varargin)

    alpha_decrease =  varargin{2};
    Set(RL,'alpha_decrease',alpha_decrease);

function [] = HandleGammaCB(RL,varargin)

    val =  varargin{2};
    if ischar(val) ; val = str2double(val) ; end
    Set(RL,'gamma',val);
    
function [] = HandleLambdaCB(RL,varargin)

    val =  varargin{2};
    if ischar(val) ; val = str2double(val) ; end
    Set(RL,'lambda',val);
    
function [] = HandleReplacingTracesCB(RL,varargin)

    val =  varargin{2};
    if ischar(val) ; val = str2double(val) ; end
    Set(RL,'replacing_traces',val);    

function [] = HandleNofMaxStepsCB(RL,varargin)
    val =  varargin{2};
    if ischar(val) ; val = str2double(val) ; end
    Set(RL,'max_steps',val);

function [] = HandleStartLearningCB(RL,varargin)


RL.StartLearning(varargin{2},varargin{3},varargin{4});

function [] = HandleStopLearningCB(RL,varargin)

RL.StopLearning();

function [] = HandleModelGraphicsCB(RL,varargin)
graphics = varargin{2};
Set(RL,'graphics',graphics);

function [] = HandleSelectModelCB(RL,varargin)

if nargin>=3
selected_model = varargin{2};
if nargin >=4
h = varargin{3};
end
end

if selected_model>0
    
    Env = eval( RL.ModelList{selected_model} );
    Set(RL,'Env',Env)

    RL.InitDone = 0;
    RL.ClearLearningCurve();
    
    constIC = num2str(RL.Env.const_IC);
    randIC  = RL.Env.random_IC;

    if ishandle(h)
        handles = guidata(h);

        h_const = handles.edit9;
        set(h_const,'String',constIC);


        h_rand = handles.edit10;
        set(h_rand,'String',randIC);
    end



else
    
    if ishandle(h)
        handles = guidata(h);

        h_const = handles.edit9;
        set(h_const,'String','[]');

        h_rand = handles.edit10;
        set(h_rand,'String','[]');  
    end
    
    
end
            
function [] = HandleSelectMethodCB(RL,varargin)
selected_method = varargin{2};

if selected_method>0
Method = RL.MethodList{selected_method};
MethodFcn = str2func(Method);
Set(RL,'MethodFcn',MethodFcn )
end

function [] = HandleRunEpisodeCB(RL,varargin)

RL.Episode();

function [] = HandleStopEpisodeCB(RL,varargin)

RL.StopEpisode();

function [] = HandleSetConstIcCB(RL,varargin)

    IC =  varargin{2};
    if ischar(IC) ; alpha = str2num(IC) ; end
    RL.Env.const_IC=IC;
    
function [] = HandleSetRandomIcCB(RL,varargin)

    IC =  varargin{2};
    RL.Env.random_IC=IC;

function [] = HandleEnableRandomIcCB(RL,varargin)
enable = varargin{2};
Set(RL,'enable_random_IC',enable)

function [] = HandleClearLastLearningCB(RL,varargin)

RL.ClearLearningCurve()

% ------------ Outgoing data to pass to GUI:

function [] = PassEpsUpdated(RL,varargin)
handles = guidata(RL.figure_handle);
edit_eps_handle = handles.edit6;
slider_eps_handle = handles.slider6;
set(edit_eps_handle,'String',num2str(RL.eps))
set(slider_eps_handle,'value',RL.eps)

function [] = PassAlphaUpdated(RL,varargin)
handles = guidata(RL.figure_handle);
edit_alpha_handle = handles.edit2;
slider_alpha_handle = handles.slider4;
set(edit_alpha_handle,'String',num2str(RL.alpha))
set(slider_alpha_handle,'value',RL.alpha)

function [] = PassDoneEpisode(RL,varargin)

function [] = PassDoneLearning(RL,varargin)