%% -*- mode: erlang; erlang-indent-level: 2 -*-
%%% Created : 17 Aug 2015 by masse <masse@klarna.com>

%% @doc
%% @end

-module('gen_wx').
-author('masse').
-export([go/0,start/0]).

-include_lib("wx/include/wx.hrl").

start() ->
    Wx = wx:new(),
    Frame = wx:batch(fun() -> create_window(Wx) end),
    wxWindow:show(Frame),
    loop(Frame),
    wx:destroy(),
    ok.

create_window(Wx) ->
    Frame = wxFrame:new(Wx,
                        -1, % window id
                        "Hello World", % window title
                        [{size, {600,400}}]),


    wxFrame:createStatusBar(Frame,[]),

    %% if we don't handle this ourselves, wxwidgets will close the window
    %% when the user clicks the frame's close button, but the event loop still runs
    wxFrame:connect(Frame, close_window),

    ok = wxFrame:setStatusText(Frame, "Hello World!",[]),
    Frame.

loop(Frame) ->
    receive
        #wx{event=#wxClose{}} ->
            io:format("~p Closing window ~n",[self()]),
            ok = wxFrame:setStatusText(Frame, "Closing...",[]),
            wxWindow:destroy(Frame),
            ok;
        Msg ->
            io:format("Got ~p ~n", [Msg]),
            loop(Frame)
    end.

go() ->
  WX = wx:new(),
  XRC = wxXmlResource:get(),
  wxXmlResource:initAllHandlers(XRC),
  wxXmlResource:load(XRC,"/Users/masse/Documents/mongo.xrc"),
  FRAME = wxFrame:new(),
  wxXmlResource:loadFrame(XRC,FRAME,WX,"MyFrame1"),
  wxFrame:connect(FRAME,
                  command_button_clicked,
                  [{id,wxXmlResource:getXRCID("m_button1")}]),
  ok = wxFrame:connect(FRAME, close_window),
  wxFrame:show(FRAME),
  loop(),
  wxFrame:hide(FRAME),
  %% wxFrame:destroy(FRAME),
  %% wxXmlResource:destroy(XRC),
  wx:destroy().

loop() ->
  receive
    X ->
      erlang:display(X),
      case X of
        #wx{event=#wxClose{}} -> ok;
        _ -> loop()
      end
  end.

%% 17> flush().
%% Shell got {wx,-2009,
%%               {wx_ref,36,wxFrame,[]},
%%               [],
%%               {wxCommand,command_button_clicked,[],0,0}}



%% 4> WX = wx:new().
%% {wx_ref,0,wx,[]}
%% 5> XRC = wxXmlResource:get().
%% {wx_ref,35,wxXmlResource,[]}
%% 6> wxXmlResource:initAllHandlers(XRC).
%% ok
%% 7> wxXmlResource:load(XRC,"/Users/masse/Documents/mongo.xrc").
%% true
%% 8> FRAME = wxFrame:new().
%% {wx_ref,36,wxFrame,[]}
%% 11> XRC2 = wxXmlResource:get().
%% {wx_ref,35,wxXmlResource,[]}
%% 12> wxXmlResource:loadFrame(XRC2,FRAME,WX,"MyFrame1").
%% true
%% 13> wxFrame:show(FRAME).
%% true
%% 15> wxFrame:connect(FRAME,
%%                     command_button_clicked,
%%                     [{id,wxXmlResource:getXRCID("m_button1")}]).
%% ok
%% 17> flush().
%% Shell got {wx,-2009,
%%               {wx_ref,36,wxFrame,[]},
%%               [],
%%               {wxCommand,command_button_clicked,[],0,0}}
%% ok
%% 21> FRAME.
%% #wx_ref{ref = 36,type = wxFrame,state = []}
%% 24> wxXmlResource:getXRCID("m_button").
%% -2010
