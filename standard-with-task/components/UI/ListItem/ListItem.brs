sub init()
  m.imagePoster = m.top.findNode("imagePoster")
  m.itemCursor = m.top.findNode("itemCursor")
  m.labelGroup = m.top.findNode("labelGroup")
  m.titleLabel = m.top.findNode("titleLabel")
  m.titleLabel.font.fallbackGlyph="u0020"
  m.descriptionLabel = m.top.findNode("descriptionLabel")
  m.maxWidth = 1880
  m.top.maxLabelWidth = m.maxWidth
end sub

sub onItemContentChange()
  m.itemContent = m.top.itemContent
  m.titleLabel.text = DecodeHtmlEntities(m.itemContent.title.Unescape())
  m.descriptionLabel.text = DecodeHtmlEntities(m.itemContent.description.Unescape())

  image = DecodeHtmlEntities(m.top.itemContent.SDPosterUrl.Unescape())
  if image = "" then
    m.imagePoster.visible = false
    m.labelGroup.translation = [0, 0]
    m.maxLabelWidth = m.maxLabelWidth
  else
    m.imagePoster.uri = image ' + "?width=" + m.imagePoster.width.toStr() + "&crop=smart&auto=webp"
    m.imagePoster.visible = true
    m.labelGroup.translation = [m.imagePoster.width + 20, 0]
    m.top.maxLabelWidth = m.maxWidth - (m.imagePoster.width + 20 + 40)
  end if
end sub

sub onFocusPercentChange()
  m.itemCursor.opacity = m.top.focusPercent
end sub

Function DecodeHtmlEntities(encodedString As String) As String
    decodedString = encodedString
    decodedString = decodedString.Replace("&amp;", "&")
    decodedString = decodedString.Replace("&lt;", "<")
    decodedString = decodedString.Replace("&gt;", ">")
    decodedString = decodedString.Replace("&quot;", Chr(34)) ' Double quote
    decodedString = decodedString.Replace("&#39;", Chr(39))  ' Single quote/apostrophe
    decodedString = decodedString.Replace("&nbsp;", " ")   ' Non-breaking space

    ' Add more replacements for other common entities as needed
    
    Return decodedString
End Function
