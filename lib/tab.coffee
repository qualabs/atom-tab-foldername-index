div = (params = {}) ->
  item = document.createElement "div"
  for key in Object.keys(params)
    item[key] = params[key]

  return item


class Tab
  regExpIndexName: /^index\..+/
  className: "tab-foldername-index"

  constructor: (@pane, @$element) ->
    @handleChange = @pane.onDidChangePath () =>
      setTimeout(() => @checkTab())

  setEnabled: ->
    @disabled = false
    @checkTab()

  setDisabled: ->
    @disabled = true
    @clearTab()

  destroy: ->
    @handleChange.dispose()
    @handleChange = null

  generateTabTitle: (folder, file) ->
    $block = div({className: @className})
    $folderBlock = div({className: "#{@className}__folder", textContent: folder})
    $fileBlock = div({className: "#{@className}__file", textContent: file})
    $wrapper = div({className: "#{@className}__wrapper"})

    $wrapper.appendChild $folderBlock
    $wrapper.appendChild $fileBlock
    $block.appendChild $wrapper
    return $block

  checkTab: () ->
    name = @pane.getTitle()

    if !@regExpIndexName.test name || @disabled
      @clearTab()
      return

    folder = @pane.getPath().split "/"
    folder = folder[folder.length - 2]
    $tabWrapper = @generateTabTitle(folder, name)
    $oldTabWrapper = @$element.querySelector ".#{@className}"
    $oldTabWrapper.remove() if $oldTabWrapper

    $title = @$element.querySelector ".title"
    $title.parentNode.appendChild $tabWrapper

    $title.classList.add "#{@className}__original"

  clearTab: () ->
    $title = @$element.querySelector ".title"
    unless $title.classList.contains("#{@className}__original")
      return

    $title.classList.remove "#{@className}__original"
    $wrapper = @$element.querySelector ".#{@className}"
    $wrapper.remove() if $wrapper

module.exports = Tab
