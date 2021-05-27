-- XMonad, Arch
-- nlantau, 2021-05-26

-- Base
import XMonad
import System.Exit
import qualified XMonad.StackSet as W

-- Actions
import XMonad.Actions.CycleWS (nextScreen)

-- Data
import Data.Monoid
import qualified Data.Map        as M

-- Layouts
import XMonad.Layout.IndependentScreens

-- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.ManageDocks

-- Utils
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

-- XF86
import Graphics.X11.ExtraTypes.XF86

myTerminal :: String
myTerminal = "alacritty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
myBorderWidth :: Dimension
myBorderWidth   = 1


myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "pyt" spawnPython findPy manageTerm
                , NS "rang" spawnRanger findRanger manageTerm
                ]
    where
        spawnTerm   = myTerminal ++ " -t scratchpad"
        findTerm    = title =? "scratchpad"
        manageTerm  = customFloating $ W.RationalRect l t w h
            where
                h = 0.5
                w = 0.5
                t = 0.75 -h
                l = 0.75 -w
        spawnPython = myTerminal ++ " -t pyt -e ipython --no-banner"
        findPy      = title =? "pyt"
        spawnRanger = myTerminal ++ " -t rang -e ranger"
        findRanger  = title =? "rang"



-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"

myModMask       = mod4Mask
altMask         = mod1Mask

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

-- Launch a Terminal
    [ ((modm,               xK_Return), spawn $ XMonad.terminal conf)

-- Launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run")

-- Monitors
    , ((altMask .|. shiftMask, xK_d     ), spawn "monitors dual")
    , ((altMask .|. shiftMask, xK_s     ), spawn "monitors laptop")
    , ((altMask .|. shiftMask, xK_t     ), spawn "monitors triple")
    , ((altMask .|. shiftMask, xK_p     ), spawn "flameshot gui")
    , ((altMask .|. shiftMask, xK_j     ), spawn "/home/nlantau/IntelliJ/idea-IU-211.6693.111/bin/idea.sh")

-- Lock & Suspend
    , ((altMask .|. shiftMask, xK_x     ), spawn "power")

-- Scratchpads
    , ((altMask, xK_u     ), namedScratchpadAction myScratchPads "terminal")
    , ((altMask, xK_y     ), namedScratchpadAction myScratchPads "pyt")
    , ((altMask, xK_a     ), namedScratchpadAction myScratchPads "rang")

-- Workspaces
    , ((modm .|. shiftMask, xK_comma     ), nextScreen)

    -- close focused window
    , ((modm,               xK_q     ), kill)
     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)
    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)
    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)
    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)
    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )
    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )
    -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_Return), windows W.swapMaster)
    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)
    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)
    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

-- XF86
    , ((0, xF86XK_AudioRaiseVolume),  spawn "pactl set-sink-volume 0 +5%")
    , ((0, xF86XK_AudioLowerVolume),  spawn "pactl set-sink-volume 0 -5%")
    , ((0, xF86XK_AudioMute),         spawn "pactl set-sink-mute 0 toggle")
    , ((0, xF86XK_AudioMicMute),      spawn "pactl set-source-mute @DEFAULT_SOURCE@ toggle")
    , ((0, xF86XK_MonBrightnessUp),   spawn "sudo xbacklight -inc 10")
    , ((0, xF86XK_MonBrightnessDown), spawn "sudo xbacklight -dec 10")
    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    , ((modm .|. shiftMask, xK_c     ), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts (tiled ||| Mirror tiled ||| Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore 
    ] <+> namedScratchpadManageHook myScratchPads

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main :: IO ()
main = do
    xmproc0 <- spawnPipe "xmobar -x 0 /home/nlantau/.config/xmobar/xmobarrc0"
    xmproc1 <- spawnPipe "xmobar -x 1 /home/nlantau/.config/xmobar/xmobarrc1"
    xmproc2 <- spawnPipe "xmobar -x 2 /home/nlantau/.config/xmobar/xmobarrc2"
    xmonad $ docks def
        { terminal           = myTerminal
        , focusFollowsMouse  = myFocusFollowsMouse
        , clickJustFocuses   = myClickJustFocuses
        , borderWidth        = myBorderWidth
        , modMask            = myModMask
        , workspaces         = myWorkspaces
        , normalBorderColor  = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor
        , keys               = myKeys
        , mouseBindings      = myMouseBindings
        , layoutHook         = myLayout
        , manageHook         = myManageHook
        , handleEventHook    = myEventHook
        , logHook = dynamicLogWithPP $ xmobarPP
            { ppOutput = \x -> hPutStrLn xmproc0 x
                            >> hPutStrLn xmproc1 x
                            >> hPutStrLn xmproc2 x
            , ppCurrent = xmobarColor "#98be65" "" . wrap "[" "]"           -- Current workspace
            --, ppVisible = xmobarColor "#98be65" "" . clickable              -- Visible but not current workspace
            --, ppHidden = xmobarColor "#82AAFF" "" . wrap "*" "" . clickable -- Hidden workspaces
            --, ppHiddenNoWindows = xmobarColor "#c792ea" ""  . clickable     -- Hidden workspaces (no windows)
            , ppTitle = xmobarColor "#b3afc2" "" . shorten 60               -- Title of active window
            , ppSep =  "<fc=#666666> <fn=1>|</fn> </fc>"                    -- Separator character
            , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"            -- Urgent workspace
            --, ppExtras  = [windowCount]                                     -- # of windows current workspace
            , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]                    -- order of things in xmobar
            }
               , startupHook        = myStartupHook
    }

























