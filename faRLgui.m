function varargout = faRLgui(varargin)
% RLGUI MATLAB code for RLgui.fig
%      RLGUI, by itself, creates a new RLGUI or raises the existing
%      singleton*.
%
%      H = RLGUI returns the handle to a new RLGUI or the handle to
%      the existing singleton*.
%
%      RLGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RLGUI.M with the given input arguments.
%
%      RLGUI('Property','Value',...) creates a new RLGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RLgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RLgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RLgui

% Last Modified by GUIDE v2.5 17-Jan-2016 17:26:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @faRLgui_OpeningFcn, ...
                   'gui_OutputFcn',  @faRLgui_OutputFcn, ...
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

% --- Executes just before RLgui is made visible.
function faRLgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RLgui (see VARARGIN)

% Choose default command line output for RLgui
handles.output = hObject;


% UIWAIT makes RLgui wait for user response (see UIRESUME)
 %uiwait(handles.figure1);
 
 
 % set here model names:
 model_handle = handles.popupmenu1;
 set(model_handle, 'String',{ 'Select model...',...
                              'Cart pole',...           % Model #1
                              'Mountain car',...        % Model #2
                              'Acrobot',...             % Model #3
                              'Random walk',...         % Model #4
                              [] } );


 % set here method names:
method_handle = handles.popupmenu2;
set(method_handle, 'String',{ 'Select method...',...  
                              'REINFORCE',...               % Method #1
                              'TD actor-critic',...         % Method #2
                              'Q actor-critic',...          % Method #3
                              'Natural actor-critic',...    % Method #4
                              [] } );

 % create RL agent:
handles.RL = faRL();

% Update handles structure
guidata(hObject, handles)

% get init values;
gamma_handle = handles.edit1;
lambda_handle = handles.edit12;
alpha_handle = handles.edit2;
alpha_decrease_handle = handles.checkbox2;
alpha_decrease_val_handle = handles.edit5;
beta_handle = handles.edit6;
beta_decrease_handle = handles.checkbox4;
beta_decrease_val_handle = handles.edit7;
max_steps_handle = handles.edit11;
plot_learning_handle = handles.axes2;
plot_Q_handle = handles.axes3;
plot_model_handle = handles.axes1;
enable_rand_IC_handle = handles.checkbox3;
model_graphics_handle = handles.radiobutton1;
rep_trc_handle = handles.checkbox6;

gamma = get(gamma_handle,'String');                          % Param #2
lambda = get(lambda_handle,'String');                        % Param #3 
alpha = get(alpha_handle,'String');                          % Param #4
alpha_decreass = get(alpha_decrease_handle,'Value');         % Param #5
alpha_decrease_val = get(alpha_decrease_val_handle,'String');% Param #6
beta = get(beta_handle,'String');                            % Param #7
beta_decreass = get(beta_decrease_handle,'Value');           % Param #8
beta_decrease_val = get(beta_decrease_val_handle,'String');  % Param #9
max_steps = get(max_steps_handle,'String');                  % Param #10
replacing_traces = get(rep_trc_handle,'Value');              % Param #11
enable_rand_IC = get(enable_rand_IC_handle,'Value');         % Param #12
enable_model_graphics = get(model_graphics_handle,'Value');  % Param #13

% Init RL values:
Facade(handles.RL,'Init',gamma,...
                        lambda,...
                        alpha,...
                        alpha_decreass,...
                        alpha_decrease_val,...
                        beta,...
                        beta_decreass,...
                        beta_decrease_val,...
                        max_steps,...
                        replacing_traces,...
                        enable_rand_IC,...
                        enable_model_graphics,...
                        plot_learning_handle,...
                        plot_Q_handle,...
                        plot_model_handle,...
                        [],...
                        []);
                        
% --- Outputs from this function are returned to the command line.
function varargout = faRLgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
handles.RL.figure_handle = handles.output;
varargout{1} = handles.RL;

% --- Executes on slider movement.
function slider_gamma_Callback(hObject, eventdata, handles)
% hObject    handle to slider gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

gamma = get(hObject,'Value');
gamma_handle = handles.edit1;
set(gamma_handle,'String',gamma)

Facade(handles.RL,'HandleGammaCB',gamma);

% --- Executes during object creation, after setting all properties.
function slider_gamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function edit_gamma_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

gamma = get(hObject,'String');
gamma = str2double(gamma);
gamma_handle = handles.slider3;
max_val  = get(gamma_handle,'Max');
min_val  = get(gamma_handle,'Min');
gamma = min(max_val,max(min_val,gamma));
set(hObject,'String',gamma)
set(gamma_handle,'Value',gamma)

Facade(handles.RL,'HandleGammaCB',gamma);

% --- Executes during object creation, after setting all properties.
function edit_gamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function slider_alpha_Callback(hObject, eventdata, handles)
% hObject    handle to slider alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


alpha = get(hObject,'Value');
alpha_handle = handles.edit2;
set(alpha_handle,'String',alpha)

Facade(handles.RL,'HandleAlphaCB',alpha);

% --- Executes during object creation, after setting all properties.
function slider_alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function edit_alpha_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


alpha = get(hObject,'String');
alpha = str2double(alpha);
alpha_handle = handles.slider4;
max_val  = get(alpha_handle,'Max');
min_val  = get(alpha_handle,'Min');
alpha = min(max_val,max(min_val,alpha));
set(hObject,'String',alpha)
set(alpha_handle,'Value',alpha)

Facade(handles.RL,'HandleAlphaCB',alpha);

% --- Executes during object creation, after setting all properties.
function edit_alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function slider_beta_Callback(hObject, eventdata, handles)

% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

beta = get(hObject,'Value');
beta_handle = handles.edit6;
set(beta_handle,'String',beta)

Facade(handles.RL,'HandleBetaCB',beta);

% --- Executes during object creation, after setting all properties.
function slider_beta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function edit_beta_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double

beta = get(hObject,'String');
beta = str2double(beta);
beta_handle = handles.slider6;
max_val  = get(beta_handle,'Max');
min_val  = get(beta_handle,'Min');
beta = min(max_val,max(min_val,beta));
set(hObject,'String',beta)
set(beta_handle,'Value',beta)

Facade(handles.RL,'HandleBetaCB',beta);

% --- Executes during object creation, after setting all properties.
function edit_beta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu1.
function popupmenu_model_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
contents = cellstr(get(hObject,'String')) ;
selected_model = contents{get(hObject,'Value')};
text_handle = handles.text9;
text2_handle = handles.text17;
push_handle = handles.pushbutton3;
method_handle = handles.popupmenu2;
setIC_handle = handles.pushbutton8;


string = get(hObject,'String');
void_string = string{1};

if ~strcmp(selected_model,void_string)
   set(text_handle,'Visible','off')
   set(text2_handle,'Visible','off')
   set(push_handle,'Enable','on')
   set(setIC_handle,'Enable','on')
   
   popupmenu_method_Callback(method_handle, [], handles)
   
   
else
   set(text_handle,'Visible','on')
   set(text2_handle,'Visible','on')
   set(push_handle,'Enable','off')
   set(setIC_handle,'Enable','off')
   set( push_handle , 'String' , 'Run one episode')
   popupmenu_method_Callback(method_handle, [], handles)
end

selected_model_ind = find(strcmp(selected_model,string),1,'first');
Facade(handles.RL,'HandleSelectModelCB',selected_model_ind-1,hObject);

% --- Executes during object creation, after setting all properties.
function popupmenu_model_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu2.
function popupmenu_method_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2

contents = cellstr(get(hObject,'String')) ;
selected_method = contents{get(hObject,'Value')};
text_handle = handles.text10;
push_handle = handles.pushbutton2;
model_handle = handles.popupmenu1;
models = cellstr(get(model_handle,'String')) ;
selected_model = models{get(model_handle,'Value')};

method_string = get(hObject,'String');
method_void_string = method_string{1};

model_string = get(model_handle,'String');
model_void_string = model_string{1};

if ~strcmp(selected_method,method_void_string)
   set(text_handle,'Visible','off')
   
   if ~strcmp(selected_model,model_void_string)
      set(push_handle,'Enable','on')
   else
      set(push_handle,'Enable','inactive') 
   end
       
else

   set(text_handle,'Visible','on')
   set(push_handle,'Enable','off')
end

selected_method_ind = find(strcmp(selected_method,method_string),1,'first');
Facade(handles.RL,'HandleSelectMethodCB',selected_method_ind-1);

% --- Executes during object creation, after setting all properties.
function popupmenu_method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

run_episode_handle = handles.pushbutton3;
%graphics_handle = handles.radiobutton1;
model_handle = handles.popupmenu1;
method_handle = handles.popupmenu2;

plot_learning_handle = handles.axes2;
plot_Q_handle = handles.axes3;
plot_model_handle = handles.axes1;
clear_handle = handles.pushbutton10;

stop_learning = get(hObject,'UserData');
if ~stop_learning %start learning:
    
    set(hObject,'String','Stop learning')
    set(hObject,'BackgroundColor',[1 0.6 0.6])
    set(run_episode_handle,'Enable','off')
    set(clear_handle,'Enable','off')
    set(model_handle,'Enable','off')
    set(method_handle,'Enable','off')
    set( run_episode_handle , 'String' , 'Run one episode')
    
    stop_learning = 1;
    set(hObject,'UserData',stop_learning);
    
    Facade(handles.RL,'HandleStartLearningCB',plot_learning_handle,plot_Q_handle,plot_model_handle);
    
    
    set(hObject,'String','Start learning')
    set(hObject,'BackgroundColor',[0.6 0.8 0.5])
    set(run_episode_handle,'Enable','on')
    set(model_handle,'Enable','on')
    set(method_handle,'Enable','on')
    set(clear_handle,'Enable','on')
    set(hObject,'Value',0)
    stop_learning = 0;
    set(hObject,'UserData',stop_learning);
    
    
    
    
    
else %stop learning:
    
    set(hObject,'String','Start learning')
    set(hObject,'BackgroundColor',[0.6 0.8 0.5])
    set(run_episode_handle,'Enable','on')
    set(model_handle,'Enable','on')
    set(method_handle,'Enable','on')
    set(clear_handle,'Enable','on')
    set(hObject,'Value',0)
    
    Facade(handles.RL,'HandleStopLearningCB');
    
    stop_learning = 0;
    set(hObject,'UserData',stop_learning);
end

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2

val = get(hObject,'Value');
edit_handle = handles.edit5; 
decrease_val = get(edit_handle,'String');
decrease_val = str2double(decrease_val);

if val 
  set(edit_handle,'Enable','on')  
  Facade(handles.RL,'HandleAlphaDecreaseValCB',decrease_val)
else
  set(edit_handle,'Enable','off')      
end

Facade(handles.RL,'HandleAlphaDecreaseCB',val)

function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double

val = get(hObject,'String');
val = str2double(val);
max_val  = get(hObject,'Max');
min_val  = get(hObject,'Min');
val = min(max_val,max(min_val,val));
set(hObject,'String',val)

Facade(handles.RL,'HandleAlphaDecreaseValCB',val)

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

% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkbox3
enable = get(hObject,'Value');
Facade(handles.RL,'HandleEnableRandomIcCB',enable)

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stop_episode = get(hObject,'UserData');
start_learning_handle = handles.pushbutton2;

method_handle = handles.popupmenu2;
graphics_handle = handles.radiobutton1;



if ~stop_episode
    
   % change string to 'stop':
   set( hObject , 'String' , 'stop')
   
   % make sure learning cannot statrt during this episode:
   set(start_learning_handle,'Enable','off')
   
   % change flag so pressing the button again stops the episode:
   stop_episode = 1;
   set(hObject,'UserData',stop_episode)
   
   % make sure graphics is enabled:
   graphics_val = get(graphics_handle,'Value'); %get the current value
   set(graphics_handle,'UserData',graphics_val); % save it as user data
   set(graphics_handle,'Value',1);
   radiobutton1_Callback(graphics_handle, eventdata, handles)
   
   % run episode:
   Facade(handles.RL,'HandleRunEpisodeCB')
   
%    set(start_learning_handle,'Enable','on')
   popupmenu_method_Callback(method_handle, [], handles)
   set( hObject , 'String' , 'Run one episode')
   
   % change flag so pressing the button again starts the episode:
   stop_episode = 0;
   set(hObject,'UserData',stop_episode)
   
else
   set( hObject , 'String' , 'Run one episode')
   
   popupmenu_method_Callback(method_handle, [], handles)
   

   Facade(handles.RL,'HandleStopEpisodeCB')
   stop_episode = 0;
   set(hObject,'UserData',stop_episode)
   
   
   % reset graphics to previous value:
   graphics_val = get(graphics_handle,'UserData'); %get the stored value 
   set(graphics_handle,'Value',graphics_val);
   radiobutton1_Callback(graphics_handle, eventdata, handles)
end

function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


val = get(hObject,'String');
val = str2double(val);
max_val  = get(hObject,'Max');
min_val  = get(hObject,'Min');
val = min(max_val,max(min_val,val));
set(hObject,'String',val)

Facade(handles.RL,'HandleBetaDecreaseValCB',val)

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

% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkbox4

val = get(hObject,'Value');

edit_handle = handles.edit7; 
beta_decrease_val = get(edit_handle,'String');
beta_decrease_val = str2double(beta_decrease_val);

if val 
  set(edit_handle,'Enable','on')  
  Facade(handles.RL,'HandleBetaDecreaseValCB',beta_decrease_val)
else
  set(edit_handle,'Enable','off')      
end

Facade(handles.RL,'HandleBetaDecreaseCB',val)

% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate axes2

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton2.
function pushbutton2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
val = get(hObject,'Value');
Facade(handles.RL,'HandleModelGraphicsCB',val);

% --------------------------------------------------------------------
function about_Callback(hObject, eventdata, handles)
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

about_handle = handles.uipanel10; 
close_handle = handles.pushbutton7;
text_handle = handles.text13;
set(about_handle,'Visible','on')
set(close_handle,'Visible','on')
set(text_handle,'Visible','on')

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

about_handle = handles.uipanel10; 
close_handle = handles.pushbutton7;
text_handle = handles.text13; 
set(about_handle,'Visible','off')
set(close_handle,'Visible','on')
set(text_handle,'Visible','off')

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton7.
function pushbutton7_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5
val = get(hObject,'Value');
help_handle = handles.uipanel11; 
text_handle = handles.text11;
if val
set(help_handle,'Visible','on')
set(text_handle,'Visible','on')
else
set(help_handle,'Visible','off')
set(text_handle,'Visible','off')
end
% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over checkbox5.
function checkbox5_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
rl_handle = handles.RL;
delete(rl_handle);
delete(hObject);

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%opens uipanel12
setIC_handle = handles.uipanel12;
set(setIC_handle,'Visible','on')

function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double
val = get(hObject,'String');
val = str2num(val);
if isempty(val)
    error('Insert a numeric value!')
end

Facade(handles.RL,'HandleSetConstIcCB',val)

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
val = get(hObject,'String');

Facade(handles.RL,'HandleSetRandomIcCB',val)

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

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%closes uipanel12
setIC_handle = handles.uipanel12;
set(setIC_handle,'Visible','off')


function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double
val = get(hObject,'String');
val = str2double(val);
max_val  = get(hObject,'Max');
min_val  = get(hObject,'Min');
val = min(max_val,max(min_val,val));
set(hObject,'String',val)

Facade(handles.RL,'HandleNofMaxStepsCB',val)

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

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Enable','off')
Facade(handles.RL,'HandleClearLastLearningCB')


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val = get(hObject,'Value');
lambda_handle = handles.edit12;
set(lambda_handle,'String',val)

Facade(handles.RL,'HandleLambdaCB',val);

% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double

val = get(hObject,'String');
val = str2double(val);
lambda_handle = handles.slider7;
max_val  = get(lambda_handle,'Max');
min_val  = get(lambda_handle,'Min');
val = min(max_val,max(min_val,val));
set(hObject,'String',val)
set(lambda_handle,'Value',val)

Facade(handles.RL,'HandleLambdaCB',val);

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


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6
val = get(hObject,'Value');
Facade(handles.RL,'HandleReplacingTracesCB',val)


