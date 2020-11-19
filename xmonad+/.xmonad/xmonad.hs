
    -- Base{{{
import XMonad
--import XMonad.Config.Desktop
import System.IO
import Text.Printf-- }}}

    -- Utilities (i.e. XMonad.Util.*){{{
import XMonad.Util.Paste
import XMonad.Util.EZConfig (additionalKeys, removeKeys)
import XMonad.Util.SpawnOnce
import XMonad.Util.Run (spawnPipe, unsafeSpawn, safeSpawn)-- }}}
import XMonad.Util.Scratchpad

    -- Hooks (i.e. XMonad.Hooks.*){{{
--import XMonad.ManageHook
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
--import XMonad.Hooks.SetWMName}}}

    -- Actions (i.e. XMonad.Actions.*)

    -- Layouts Modifier (i.e. XMonad.Layout.*){{{
import XMonad.Layout.Spacing-- }}}

    -- Layouts (i.e. XMonad.Layout.*)

    -- Prompts

    -- Etc{{{
import Graphics.X11.ExtraTypes.XF86-- }}}

{- Most common functions{{{
   { terminal           = myTerminal
   , focusFollowsMouse  = myFocusFollowsMouse
   , borderWidth        = myBorderWidth
   , modMask            = myModMask
   , workspaces         = myWorkspaces
   , normalBorderColor  = myNormalBorderColor
   , focusedBorderColor = myFocusedBorderColor

   -- key bindings
   , keys          = myKeys
   , mouseBindings = myMouseBindings

   -- hooks, layouts
   , layoutHook      = myLayoutHook
   , manageHook      = myManageHook
   , handleEventHook = myEventHook
   , logHook         = myLogHook
   , startupHook     = myStartupHook
   }
-}-- }}}

{-{{{
 modMask lets you specifiy which modkey you want to use. The default
 is mod1Mask ("left alt"). You may also consider using mod3Mask ("right alt"),
 which does not conflict with emacs keybindings. The "windows key" is
 typically mod4Mask.
-}-- }}}

myTerminal    = "urxvt"
myFileBrowser = "ranger"
myTextEditor  = "vim"
myMenu        = "dmenu"
myWebBrowser  = "google-chrome-stable"
myWallpaper   = "~/Images/wallpapers/anime/anime-wallpaper.jpg"
myModMask     = mod1Mask
myBorderWidth = 2
-- $ spacingRaw False (Border 20 20 20 20) True (Border 15 15 15 15) True
myLayoutHook  = avoidStruts $ layoutHook def

daemonWrapper name options =
    printf "[ -f /bin/%s ] && [ $(pgrep %s | wc -l) -eq 0 ] && %s %s &" name name name options

launchWrapper name = myTerminal ++ " -e " ++ name

myManageHook = composeAll
    [ className =? "Gimp" --> doFloat
    --, className =? "scratchpad" --> doShift "5"
    ]

myStartupHook = do
    unsafeSpawn $ "killall xcompmgr"
    unsafeSpawn $ "killall redshift"
    unsafeSpawn $ daemonWrapper "xcompmgr" "-c"
    unsafeSpawn $ daemonWrapper "redshift" ""

main = do
    unsafeSpawn $ printf "feh --bg-scale %s" myWallpaper
    unsafeSpawn $ "killall xmobar"
    xmproc <- spawnPipe $ daemonWrapper "xmobar" ""
    xmonad $ docks def
        { manageHook      = myManageHook <+> manageHook def
        , layoutHook      = myLayoutHook
        , startupHook     = myStartupHook <+> startupHook def
        , terminal        = launchWrapper "tmux"
        , modMask         = myModMask
        , borderWidth     = myBorderWidth
        --, normalBorderColor  = "#2p2d3e"
        --, focusedBorderColor = "#bbc5ff"
        , handleEventHook = handleEventHook def <+> docksEventHook
        , logHook         = dynamicLogWithPP xmobarPP
            { ppOutput          = hPutStrLn xmproc
            , ppTitle           = xmobarColor "darkgreen"  "" . shorten 20
            , ppHiddenNoWindows = xmobarColor "grey" ""
            }
        } `removeKeys`
      [ (myModMask, xK_Return)
      , (myModMask .|. shiftMask, xK_Return)
      ,(myModMask, xK_p)
      --, (myModMask, xK_Tab)
      --, (myModMask .|. shiftMask, xK_Tab)
      ] `additionalKeys`
      [ ((myModMask,               xK_r),           unsafeSpawn $ launchWrapper myFileBrowser)
      , ((myModMask,               xK_b),           unsafeSpawn myWebBrowser)
      , ((myModMask,               xF86XK_Launch1), unsafeSpawn "killall xcompmgr; xsetroot;")
      , ((myModMask,               xK_Return),      unsafeSpawn $ launchWrapper "tmux")
      , ((myModMask .|. shiftMask, xK_Return),      unsafeSpawn $ printf "ls /bin | %s" myMenu)
      , ((myModMask,               xK_grave),       scratchpadSpawnActionTerminal $ printf  "%s -name scratchpad -e tmux" myTerminal)
      ] --`additionalMouseBindings` []


{-
main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ defaultConfig
      { terminal    = myTerminal
      , borderWidth = myBorderWidth
      , modMask     = mod4Mask
      , manageHook  = manageDocks <+> manageHook defaultConfig
      , layoutHook  = avoidStruts  $ layoutHook defaultConfig
      -- this must be in this order, docksEventHook must be last
      , handleEventHook = handleEventHook defaultConfig <+> docksEventHook
      , logHook         = dynamicLogWithPP xmobarPP
          { ppOutput          = hPutStrLn xmproc
          , ppTitle           = xmobarColor "darkgreen"  "" . shorten 20
          , ppHiddenNoWindows = xmobarColor "grey" ""
          }
      , startupHook        = setWMName "LG3D"
      } `additionalKeys`
      [ ((mod4Mask, xK_b), sendMessage ToggleStruts) ]
-}
