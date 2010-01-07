{-# OPTIONS_GHC -fglasgow-exts #-}
--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--
 
import XMonad
import System.Exit
 
import XMonad.Actions.CopyWindow
import XMonad.Actions.DwmPromote
import XMonad.Actions.WindowBringer
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Layout.Tabbed
import XMonad.Layout.Magnifier
import XMonad.Layout.Maximize
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.PerWorkspace
import XMonad.Layout.IM
import XMonad.Util.WindowProperties

import XMonad.Prompt
import XMonad.Prompt.Shell

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import qualified Data.Set        as S
import qualified Data.List as L (deleteBy,find,splitAt,filter,nub)
import Control.Monad (when, unless)
import Data.Ratio ((%))
 
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "Terminal"
 
-- Width of the window border in pixels.
--
myBorderWidth   = 1
 
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod1Mask
 
-- The mask for the numlock key. Numlock status is "masked" from the
-- current modifier status, so the keybindings will work with numlock on or
-- off. You may need to change this on some systems.
--
-- You can find the numlock modifier by running "xmodmap" and looking for a
-- modifier with Num_Lock bound to it:
--
-- > $ xmodmap | grep Num
-- > mod2        Num_Lock (0x4d)
--
-- Set numlockMask = 0 if you don't have a numlock key, or want to treat
-- numlock status separately.
--
myNumlockMask   = mod2Mask
 
-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]
 
-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#222233"
myFocusedBorderColor = "#ff0000"
 
-- Default offset of drawable screen boundaries from each physical
-- screen. Anything non-zero here will leave a gap of that many pixels
-- on the given edge, on the that screen. A useful gap at top of screen
-- for a menu bar (e.g. 15)
--
-- An example, to set a top gap on monitor 1, and a gap on the bottom of
-- monitor 2, you'd use a list of geometries like so:
--
-- > defaultGaps = [(18,0,0,0),(0,18,0,0)] -- 2 gaps on 2 monitors
--
-- Fields are: top, bottom, left, right.
--
--myDefaultGaps   = [(18,0,0,0)]
myDefaultGaps   = [(0,0,0,0),(0,0,0,0)]
 
------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
 
    -- launch a terminal
    [ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
 
    -- launch dmenu
    , ((modMask,               xK_p     ), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")
    , ((modMask,               xK_o     ), spawn "/usr/lib/wicd/gui.py")

    -- mod-shift-g goto window menu
    -- mod-shift-g bring me window menu
    , ((modMask, xK_g     ), gotoMenu)
    , ((modMask .|. shiftMask, xK_b     ), bringMenu)

    -- mod-shift-d (re)launch dzen
    , ((modMask .|. shiftMask, xK_d     ), spawn "killall dzonky dzen2 inotail inotifywatch watchfile ;  sleep 1; exec /home/mstearn/bin/dzonky")
    , ((modMask .|. shiftMask .|. controlMask, xK_d     ), spawn "dzonky")

    , ((modMask .|. controlMask, xK_Escape     ), spawn "xkill")

    -- mod-\ toggle maximizedness
    , ((modMask, xK_backslash), withFocused (sendMessage . maximizeRestore))
    , ((modMask, xK_x), shellPrompt $ defaultXPConfig  )
 
    -- launch gmrun
    , ((modMask .|. shiftMask, xK_p     ), spawn "gmrun")
 
    -- amarok
    --, ((0, 0x1008ff14    ), spawn "xeyes")
    --, ((shiftMask, 0x1008ff1d    ), spawn "xeyes")
    --, ((0, 0x1008ff1d    ), spawn "xeyes")

    -- reset modifiers if i hit Web/Home
    , ((0, 0x1008ff18   ), spawn "xmodmap ~/.xmodmap")

    -- close focused window 
    -- , ((modMask .|. shiftMask, xK_c     ), kill)
    , ((modMask .|. shiftMask, xK_c     ),  focusedHasProperty (ClassName "Roxterm") 
                                                >>= flip unless kill1)

     -- Rotate through the available layout algorithms
    , ((modMask,               xK_space ), sendMessage NextLayout)
 
    --  Reset the layouts on the current workspace to default
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
 
    -- Resize viewed windows to the correct size
    , ((modMask,               xK_n     ), refresh)
 
    -- Move focus to the next window
    , ((modMask,               xK_j     ), windows W.focusDown)
    , ((modMask,               xK_Tab   ), windows W.focusDown)
 
    -- Move focus to the previous window
    , ((modMask,               xK_k     ), windows W.focusUp)
    , ((modMask .|. shiftMask, xK_Tab   ), windows W.focusUp)
 
    -- Move focus to the master window
    , ((modMask,               xK_m     ), windows W.focusMaster  )
    
    ,((modMask,                xK_f     ),sendMessage ToggleLayout >> toggleGaps)
 
    -- Swap the focused window and the master window
    , ((modMask,               xK_Return), dwmpromote)
 
    -- Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  )
 
    -- Swap the focused window with the previous window
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    )
 
    -- Shrink the master area
    , ((modMask,               xK_h     ), sendMessage Shrink)
 
    -- Expand the master area
    , ((modMask,               xK_l     ), sendMessage Expand)
 
    -- Push window back into tiling
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink)
 
    -- Increment the number of windows in the master area
    , ((modMask              , xK_comma ), sendMessage (IncMasterN 1))
 
    -- Deincrement the number of windows in the master area
    , ((modMask              , xK_period), sendMessage (IncMasterN (-1)))
 
    -- toggle the status bar gap
    , ((modMask              , xK_b     ), toggleGaps)
 
    -- Quit xmonad
    , ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
 
    -- Restart xmonad
    , ((modMask              , xK_q     ),
          broadcastMessage ReleaseResources >> restart "xmonad" True)

    -- Copy everywhere
    , ((modMask, xK_a     ), sequence_ $ [windows $ copy i | i <- workspaces conf])
    , ((modMask .|. shiftMask, xK_a     ), windows $ kill8 )
    ]
    ++
    -- mod-[1..9] @@ Switch to workspace N
    -- mod-shift-[1..9] @@ Move client to workspace N
    -- mod-control-shift-[1..9] @@ Copy client to workspace N
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(ungreedyView, 0), (W.shift, shiftMask), (copy, controlMask .|. shiftMask)]] 
 
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    ++
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <-  take 2 $ zip [xK_e, xK_w] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask), (W.greedyView, controlMask)]]
 
-- like view, but do nothing if is visible
ungreedyView i s  =
    if i `elem` (map (W.tag . W.workspace) $ W.visible s)
         then s
         else W.view i s

kill8 ss | Just w <- W.peek ss = (W.insertUp w) $ W.delete w ss
         | otherwise = ss

toggleGaps = sendMessage ToggleStruts
--toggleGaps = modifyGap (\i n -> let x = (myDefaultGaps ++ repeat (0,0,0,0)) !! i
--                             in if n == x then (0,0,0,0) else x)

{-
kill8 ss | Just w <- W.peek ss = W.mapWorkspace $ f w
         | otherwise = ss
            where f w ws = if ws == (W.workspace $ W.current ss)
                         then ws
                         else W.modify Nothing (W.filter (/=w)) ws
                             -}

                             
------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
 
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))

 
    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2), (\w -> focus w >> windows W.shiftMaster))
 
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))
 
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    -- resize the windows in tiled mode
    , ((modMask, button4), (\w -> focus w >> sendMessage MirrorExpand))
    , ((modMask, button5), (\w -> focus w >> sendMessage MirrorShrink))
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
myLayout = avoidStruts $ onWorkspace "9" (IM (1%7) (Title "Buddy List")) $ toggleLayouts (noBorders Full) $ maximize (tiled ||| Mirror tiled ||| noBorders (tabbed shrinkText defaultTheme) )
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = ResizableTall nmaster delta ratio []
 
     -- The default number of windows in the master pane
     nmaster = 1
 
     -- Default proportion of screen occupied by master pane
     ratio   = 2/3
 
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
myManageHook = manageDocks <+> composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "DebugSource"    --> doFloat
    , resource  =? "pidgin"         --> doF (W.shift "9")
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , resource  =? "kicker"         --> doIgnore 
    , resource  =? "stalonetray"    --> doIgnore 
    , title     =? "panel"          --> doIgnore 
    ]


 
 
------------------------------------------------------------------------
-- Status bars and logging
 
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
-- 
redbeardPP = defaultPP { ppHiddenNoWindows = dzenColor "#33FF00"  ""
                      , ppHidden  = dzenColor "white"  ""
                      , ppCurrent = dzenColor "yellow" ""
                      , ppVisible = dzenColor "#FF2222" ""
                      , ppUrgent  = dzenColor "red"    "yellow"
                      , ppSep     = " | "
                      , ppWsSep   = "\n"
                      , ppTitle   = id
                      , ppLayout  = \s -> " "
                      , ppOutput  = writeFile "/home/mstearn/.xmonad-status" 
                                        . ("^cs()\n"++)
                      } 

myLogHook = do setWMName "LG3D"
               --dynamicLogWithPP redbeardPP
               return ()
 

myUrgencyHook = withUrgencyHook dzenUrgencyHook 
        { args = ["-bg", "yellow", "-fg", "black" ,"-p", "3", "-xs", "1"] }

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.
 
-- Run xmonad with the settings you specify. No need to modify this.
--
main = xmonad $ ewmh $ myUrgencyHook defaults
 
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will 
-- use the defaults defined in xmonad/XMonad/Config.hs
-- 
-- No need to modify this.
--
defaults = defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        numlockMask        = myNumlockMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
        --defaultGaps        = myDefaultGaps,
 
      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,
 
      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        logHook            = myLogHook
    }


-- vim:nospell:
