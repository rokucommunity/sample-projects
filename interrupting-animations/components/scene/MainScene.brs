sub init()
  m.rect0 = m.top.findNode("rect0")
  m.rect1 = m.top.findNode("rect1")
  m.rect2 = m.top.findNode("rect2")
  m.rect3 = m.top.findNode("rect3")
  m.rect4 = m.top.findNode("rect4")
  m.animation = m.top.findNode("animation")
  m.interpolator0 = m.top.findNode("interpolator0")
  m.interpolator1 = m.top.findNode("interpolator1")
  m.interpolator2 = m.top.findNode("interpolator2")
  m.interpolator3 = m.top.findNode("interpolator3")
  m.interpolator4 = m.top.findNode("interpolator4")
  m.index = 0
  m.top.setFocus(true)
end sub

function move(side as string)
  'clamp to boundaries
  if side = "left"
    x = 0
  else
    x = 1920 - m.rect0.width
  end if
  m.interpolator0.keyvalue = [m.rect0.translation, [x, m.rect0.translation[1]]]
  m.interpolator1.keyvalue = [m.rect1.translation, [x, m.rect1.translation[1]]]
  m.interpolator2.keyvalue = [m.rect2.translation, [x, m.rect2.translation[1]]]
  m.interpolator3.keyvalue = [m.rect3.translation, [x, m.rect3.translation[1]]]
  m.interpolator4.keyvalue = [m.rect4.translation, [x, m.rect4.translation[1]]]
  m.animation.control = "start"
end function

sub onKeyEvent(key as string, press as boolean) as boolean
  if press then
    if key = "left" or key = "right" then
      move(key)
    end if
  end if
  return true
end sub
