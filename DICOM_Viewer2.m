function varargout = DICOM_Viewer2(varargin)
% DICOM_VIEWER MATLAB code for DICOM_Viewer.fig
%      DICOM_VIEWER, by itself, creates a new DICOM_VIEWER or raises the existing
%      singleton*.
%
%      H = DICOM_VIEWER returns the handle to a new DICOM_VIEWER or the handle to
%      the existing singleton*.
%
%      DICOM_VIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DICOM_VIEWER.M with the given input arguments.
%
%      DICOM_VIEWER('Property','Value',...) creates a new DICOM_VIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DICOM_Viewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DICOM_Viewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DICOM_Viewer

% Last Modified by GUIDE v2.5 24-Feb-2015 10:31:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DICOM_Viewer_OpeningFcn, ...
                   'gui_OutputFcn',  @DICOM_Viewer_OutputFcn, ...
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


% --- Executes just before DICOM_Viewer is made visible.
function DICOM_Viewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DICOM_Viewer (see VARARGIN)

% Choose default command line output for DICOM_Viewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DICOM_Viewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DICOM_Viewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Display DICOM when slider is moved
traceNum = int32(get(handles.slider1, 'Value'));
% image = dicomread(fullfile(handles.path, handles.fileNames{traceNum}));
images = hangles.images;
% axes(handles.img_display);
% imshow(images{traceNum},[]);
imshow(images{traceNum},'Parent',handles.img_display);
title(['Image Number' ' ' num2str(traceNum)]);
set(handles.img_display,'Visible','off');


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function file_path_Callback(hObject, eventdata, handles)
% hObject    handle to file_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file_path as text
%        str2double(get(hObject,'String')) returns contents of file_path as a double


% --- Executes during object creation, after setting all properties.
function file_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_imgs.
function load_imgs_Callback(hObject, eventdata, handles)
% hObject    handle to load_imgs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

path = uigetdir('Choose Directory');

% Set edit1 to directory path
set(handles.file_path, 'String', path);

files = dir(fullfile(path, '*.dcm'));
fileNames = {files.name};

% Files are not set to .dcm
if isempty(fileNames)
    % Construct a questdlg with three options
        choice = questdlg('No .dcm files found, assume filetype?', ...
            'Warning', ...
            'Yes','Change folder','Exit','Exit');
        % Handle response
        switch choice
            case 'Yes'
                files = dir(fullfile(path));
                temp = {files.name}; 
                if strcmp(temp{1},'.') && strcmp(temp{2},'..')
                    fileNames = {temp{3:end}};
                else
                    fileNames = {files.name};
                end
                
            case 'Change folder'
                path = uigetdir('Choose Directory');
                files = dir(fullfile(path, '*.dcm'));
                fileNames = {files.name}; 

            case 'Exit'
                error('User exited program');
        end
end

if isempty(fileNames)
    error('fileNames still empty after user input');
end

numImages = length(fileNames);

% Set values for slider
set(handles.slider1, 'Min', 1);
set(handles.slider1, 'Max', numImages);
set(handles.slider1, 'Value', 1);
images = zeros(numImages);

for i = 1:numImages
    images{i} = dicomread(fullfile(path, fileNames{i}));
end

% Display first image
axes(handles.img_display);
imshow(images{1},[]);
title(['Image Number' ' ' num2str(1)]);
set(handles.img_display,'Visible','off');

% Update gui variables so that other callbacks can access them
handles.images = images;
handles.path = path;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function img_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to img_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function img_display_CreateFcn(hObject, eventdata, handles)
% hObject    handle to img_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate img_display
