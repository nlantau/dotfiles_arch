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
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Spacing

-- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.ManageDocks

-- Utils
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

-- XF86
import Graphics.X11.ExtraTypes.XF86


myModMask :: KeyMask
myModMask = mod4Mask

altMask :: KeyMask
altMask = mod1Mask

myTerminal :: String
myTerminal = "alacritty"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth :: Dimension
myBorderWidth   = 2

myNormalBorderColor :: String
myNormalBorderColor  = "#4a4a4a"

myFocusedBorderColor :: String
myFocusedBorderColor = "#128a00"

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


------------------------------------------------------------------------
-- Key Bindings

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
    , ((altMask .|. shiftMask, xK_x     ), spawn "sudo systemctl suspend")

-- Scratchpads
    , ((altMask, xK_u     ), namedScratchpadAction myScratchPads "terminal")
    , ((altMask, xK_y     ), namedScratchpadAction myScratchPads "pyt")
    , ((altMask, xK_a     ), namedScratchpadAction myScratchPads "rang")

-- Workspaces
    , ((modm .|. shiftMask, xK_comma     ), nextScreen)
    , ((modm,               xK_q     ), kill)
    , ((modm,               xK_space ), sendMessage NextLayout)
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    , ((modm,               xK_n     ), refresh)
    , ((modm,               xK_Tab   ), windows W.focusDown)
    , ((modm,               xK_j     ), windows W.focusDown)
    , ((modm,               xK_k     ), windows W.focusUp  )
    , ((modm,               xK_m     ), windows W.focusMaster  )
    , ((modm .|. shiftMask, xK_Return), windows W.swapMaster)
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
    , ((modm,               xK_h     ), sendMessage Shrink)
    , ((modm,               xK_l     ), sendMessage Expand)
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

-- XF86
    , ((0, xF86XK_AudioRaiseVolume),  spawn "pactl set-sink-volume 0 +5%")
    , ((0, xF86XK_AudioLowerVolume),  spawn "pactl set-sink-volume 0 -5%")
    , ((0, xF86XK_AudioMute),         spawn "pactl set-sink-mute 0 toggle")
    , ((0, xF86XK_AudioMicMute),      spawn "pactl set-source-mute @DEFAULT_SOURCE@ toggle")
    , ((0, xF86XK_MonBrightnessUp),   spawn "sudo xbacklight -inc 10")
    , ((0, xF86XK_MonBrightnessDown), spawn "sudo xbacklight -dec 10")

-- Quit XMonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    , ((modm .|. shiftMask, xK_c     ), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++

    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

------------------------------------------------------------------------
-- Mouse Bindings
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    ]

------------------------------------------------------------------------
-- Layouts

--Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True


myLayout = avoidStruts ( tiled ||| Mirror tiled ||| Full)
  where
     tiled   = mySpacing 3 $ Tall nmaster delta ratio
     nmaster = 1
     ratio   = 1/2
     delta   = 3/100

------------------------------------------------------------------------
-- Window Rules
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
-- Main
main :: IO ()
main = do
    xmproc2 <- spawnPipe "xmobar -x 2 /home/nlantau/.config/xmobar/xmobarrc0"
    xmproc1 <- spawnPipe "xmobar -x 1 /home/nlantau/.config/xmobar/xmobarrc1"
    xmproc0 <- spawnPipe "xmobar -x 0 /home/nlantau/.config/xmobar/xmobarrc0"
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
            { ppOutput = \x -> hPutStrLn xmproc1 x
                            >> hPutStrLn xmproc0 x
                            >> hPutStrLn xmproc2 x
            , ppCurrent = xmobarColor "#98be65" "" . wrap "[" "]"           -- Current workspace
            , ppTitle = xmobarColor "#b3afc2" "" . shorten 60               -- Title of active window
            , ppSep =  "<fc=#666666> <fn=1>|</fn> </fc>"                    -- Separator character
            , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"            -- Urgent workspace
            , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]                    -- order of things in xmobar
            }
               , startupHook        = myStartupHook
    }





