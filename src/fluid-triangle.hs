{-# LANGUAGE OverloadedStrings, PatternSynonyms #-}
module Main where
import qualified Graphics.UI.FLTK.LowLevel.FL as FL
import qualified Graphics.UI.FLTK.LowLevel.GlWindow as FL
import qualified Graphics.UI.FLTK.LowLevel.Gl as FL
import qualified Graphics.UI.FLTK.LowLevel.Fl_Enumerations as FL
import Graphics.UI.FLTK.LowLevel.Fl_Types
import Graphics.UI.FLTK.LowLevel.FLTKHS
import Graphics.GL.Functions as GL
import Graphics.GL as GL
import Foreign.Marshal.Array (newArray)
import Foreign.Ptr (Ptr)
import Data.IORef
import Data.Bits
import Data.Text as T
import System.Environment
import Triangle

drawTriangle :: Ref ValueSlider -> Ref GlWindow -> IO ()
drawTriangle rotation glWindow = do
  valid <- getValid glWindow
  rot <- getValue rotation
  w' <- pixelW glWindow
  h' <- pixelH glWindow
  let ratio = (fromIntegral w') / (fromIntegral h')
  if (not valid)
    then do
       glLoadIdentity
       glViewport 0 0 (fromIntegral w') (fromIntegral h')
    else return ()
  glClear GL_COLOR_BUFFER_BIT
  glMatrixMode GL_PROJECTION
  glLoadIdentity
  glOrtho (-ratio) ratio (-1.0) 1.0 1.0 (-1.0)
  glMatrixMode GL_MODELVIEW
  glLoadIdentity
  glRotatef (-(realToFrac rot)) 0.0 0.0 1.0
  glBegin GL_TRIANGLES
  glColor3f 1.0 0.0 0.0
  glVertex3f (-0.6) (-0.4) 0.0
  glColor3f 0.0 1.0 0.0
  glVertex3f 0.6 (-0.4) 0.0
  glColor3f 0.0 0.0 1.0
  glVertex3f 0.0 0.6 0.0
  glEnd

ui :: IO ()
ui = do
  FL.setUseHighResGL True
  (window, rotation, glContainer) <- makeWindow
  Rectangle glPosition glSize <- getRectangle glContainer
  begin glContainer
  glWindow <- FL.glWindowCustom
                glSize
                (Just glPosition)
                Nothing
                (Just (drawTriangle rotation))
                defaultCustomWidgetFuncs
                defaultCustomWindowFuncs
  end glContainer
  setCallback rotation (\_ -> redraw glWindow)
  showWidget glWindow
  showWidget window
  _ <- FL.run
  return ()

main :: IO ()
main = ui >> FL.flush

replMain :: IO ()
replMain = ui >> FL.replRun
