{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
import Protolude

import XMonad hiding (keys)
import qualified XMonad
import XMonad.Prompt
import XMonad.Hooks.ManageDocks
import XMonad.Operations (restart)
import XMonad.Config.Desktop
import XMonad.Layout.Decoration
import XMonad.Layout.Groups.Wmii
import XMonad.Layout.Groups.Helpers
import XMonad.Actions.Commands

import qualified Data.Map as Map
import System.Environment (getExecutablePath, getEnv)

xmonadCommands = runCommand 
  [ ("tabbed", groupToTabbedLayout)
  , ("vertical", groupToVerticalLayout)
  , ("theme", sendMessage (SetTheme theme))
  ]

theme :: Theme
theme = def 
  { decoHeight = 25
  , fontName = "xft:Ubuntu"
  }

main = do
  executablePath <- getExecutablePath
  let baseConfig = desktopConfig
  launch $ desktopConfig 
    { terminal = "urxvt"
    , layoutHook = desktopLayoutModifiers $ wmii shrinkText theme
    , XMonad.keys = \config@(XMonad.XConfig {modMask}) ->
        Map.fromList 
          [ ((modMask, xK_q), restart executablePath True)
          , ((modMask .|. shiftMask, xK_p), xmonadCommands)
          -- Groups
          , ((modMask, xK_h), focusGroupUp)
          , ((modMask, xK_l), focusGroupDown)
          , ((modMask, xK_k), focusUp)
          , ((modMask, xK_j), focusDown)
          , ((modMask .|. shiftMask, xK_k), swapUp)
          , ((modMask .|. shiftMask, xK_j), swapDown)
          , ((modMask .|. shiftMask, xK_h), moveToGroupUp False)
          , ((modMask .|. shiftMask, xK_l), moveToGroupDown False)
          , ((modMask .|. shiftMask, xK_space), groupToNextLayout)
          ]
        <> (XMonad.keys baseConfig config)
    }
