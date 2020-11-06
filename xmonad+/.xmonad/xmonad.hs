import XMonad
--import XMonad.Config.Desktop
import XMonad.Util.Paste
--import XMonad.Hooks.SetWMName
--import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Spacing
import XMonad.Util.Run(spawnPipe)

{-
baseConfig = desktopConfig

main = xmonad baseConfig {
    focusedBorderColor = "#ff2037" -- not a hook
   ,startupHook = startupHook baseConfig <+> spawnOnce "urxvt"
}
-}

{-
main = xmonad def
    { terminal    = "urxvt"
    , modMask     = mod4Mask
    , borderWidth = 3
    }
-}


{- Most common functions one might want to define in their main do block
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
-}

{-
 modMask lets you specifiy which modkey you want to use. The default
 is mod1Mask ("left alt"). You may also consider using mod3Mask ("right alt"),
 which does not conflict with emacs keybindings. The "windows key" is
 typically mod4Mask.
-}

myTerminal    = "urxvt"
myModMask     = mod1Mask
myBorderWidth = 4
myLayoutHook  = avoidStruts $ spacingRaw False (Border 20 20 20 20) True (Border 15 15 15 15) True
                            $ layoutHook def
myManageHook = composeAll
    [ className =? "Gimp" --> doFloat
    ]

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ docks def
        { manageHook  = myManageHook <+> manageHook def
        , layoutHook  = myLayoutHook
        , terminal    = myTerminal
        , modMask     = myModMask
        , borderWidth = myBorderWidth
        }

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
