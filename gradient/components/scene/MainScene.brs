sub init()
  m.gradientPoster = m.top.findNode("gradientPoster")
  m.gradientPoster.uri = GenerateGradient(1920, 1080, &h000000FF, &hFF0000FF, "vertical")
end sub

function GenerateGradient(width as integer, height as integer, startRgba as longinteger, endRgba as longinteger, lineDirection = "vertical")
  bitmap = CreateObject("roBitmap", { width: width, height: height, alphaEnable: true })

  'draw vertical lines from left to right
  if lineDirection = "vertical" then
    numSteps# = width
    'draw horizontal lines from top to bottom
  else
    numSteps# = height
  end if

  ' separate rgba values to compute the step between each gradient band
  red# = (startRgba and &hFF000000&) >> 24
  redEnd# = (endRgba and &hFF000000&) >> 24
  redStep# = (redEnd# - red#) / numSteps#

  blue# = (startRgba and &h00FF0000&) >> 16
  blueEnd# = (endRgba and &h00FF0000&) >> 16
  blueStep# = (blueEnd# - blue#) / numSteps#

  green# = (startRgba and &h0000FF00&) >> 8
  greenEnd# = (endRgba and &h0000FF00&) >> 8
  greenStep# = (greenEnd# - green#) / numSteps#

  alpha# = startRgba and &h000000FF&
  alphaEnd# = endRgba and &h000000FF&
  alphaStep# = (alphaEnd# - alpha#) / numSteps#

  for i = 0 to numSteps#
    red# += redStep#
    blue# += blueStep#
    green# += greenStep#
    alpha# += alphaStep#

    'merge rgb into single int
    color& = (Int(red#) << 24) + (Int(blue#) << 16) + (Int(green#) << 8) + (Int(alpha#))

    if lineDirection = "vertical" then
      'draw a line at (i, 0) for the full height of the image
      bitmap.DrawRect(i, 0, 1, height, color&)
    else
      'draw a line at (0, i) for the full width of the image
      bitmap.DrawRect(0, i, width, 1, color&)
    end if
  end for

  bitmap.Finish()

  png = bitmap.GetPng(0, 0, width, height)
  uri = "tmp:/linear-gradient-" + str(width) + "x" + str(height) + "-0x" + stri(startRgba, 16) + "-0x" + stri(endRgba, 16) + "-" + lineDirection + ".png"
  png.WriteFile(uri)
  return uri
end function