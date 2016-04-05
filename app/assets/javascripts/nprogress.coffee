### NProgress, (c) 2013, 2014 Rico Sta. Cruz - http://ricostacruz.com/nprogress
# @license MIT
###

((root, factory) ->
  if typeof define == 'function' and define.amd
    define factory
  else if typeof exports == 'object'
    module.exports = factory()
  else
    root.NProgress = factory()
  return
) this, ->
  NProgress = {}

  ###*
  # Helpers
  ###

  clamp = (n, min, max) ->
    if n < min
      return min
    if n > max
      return max
    n

  ###*
  # (Internal) converts a percentage (`0..1`) to a bar translateX
  # percentage (`-100%..0%`).
  ###

  toBarPerc = (n) ->
    (-1 + n) * 100

  ###*
  # (Internal) returns the correct CSS for changing the bar's
  # position given an n percentage, and speed and ease from Settings
  ###

  barPositionCSS = (n, speed, ease) ->
    barCSS = undefined
    if Settings.positionUsing == 'translate3d'
      barCSS = transform: 'translate3d(' + toBarPerc(n) + '%,0,0)'
    else if Settings.positionUsing == 'translate'
      barCSS = transform: 'translate(' + toBarPerc(n) + '%,0)'
    else
      barCSS = 'margin-left': toBarPerc(n) + '%'
    barCSS.transition = 'all ' + speed + 'ms ' + ease
    barCSS

  ###*
  # (Internal) Determines if an element or space separated list of class names contains a class name.
  ###

  hasClass = (element, name) ->
    list = if typeof element == 'string' then element else classList(element)
    list.indexOf(' ' + name + ' ') >= 0

  ###*
  # (Internal) Adds a class to an element.
  ###

  addClass = (element, name) ->
    oldList = classList(element)
    newList = oldList + name
    if hasClass(oldList, name)
      return
    # Trim the opening space.
    element.className = newList.substring(1)
    return

  ###*
  # (Internal) Removes a class from an element.
  ###

  removeClass = (element, name) ->
    oldList = classList(element)
    newList = undefined
    if !hasClass(element, name)
      return
    # Replace the class name.
    newList = oldList.replace(' ' + name + ' ', ' ')
    # Trim the opening and closing spaces.
    element.className = newList.substring(1, newList.length - 1)
    return

  ###*
  # (Internal) Gets a space separated list of the class names on the element.
  # The list is wrapped with a single space on each end to facilitate finding
  # matches within the list.
  ###

  classList = (element) ->
    (' ' + (element.className or '') + ' ').replace /\s+/gi, ' '

  ###*
  # (Internal) Removes an element from the DOM.
  ###

  removeElement = (element) ->
    element and element.parentNode and element.parentNode.removeChild(element)
    return

  NProgress.version = '0.2.0'
  Settings = NProgress.settings =
    minimum: 0.08
    easing: 'ease-out'
    positionUsing: ''
    speed: 600
    trickle: true
    trickleRate: 0.02
    trickleSpeed: 600
    showSpinner: false
    barSelector: '[role="bar"]'
    spinnerSelector: '[role="spinner"]'
    parent: 'body'
    template: """
    <div class="bar" role="bar"></div>
    """

  ###*
  # Updates configuration.
  #
  #     NProgress.configure({
  #       minimum: 0.1
  #     });
  ###

  NProgress.configure = (options) ->
    key = undefined
    value = undefined
    for key of options
      `key = key`
      value = options[key]
      if value != undefined and options.hasOwnProperty(key)
        Settings[key] = value
    this

  ###*
  # Last number.
  ###

  NProgress.status = null

  ###*
  # Sets the progress bar status, where `n` is a number from `0.0` to `1.0`.
  #
  #     NProgress.set(0.4);
  #     NProgress.set(1.0);
  ###

  NProgress.set = (n) ->
    started = NProgress.isStarted()
    n = clamp(n, Settings.minimum, 1)
    NProgress.status = if n == 1 then null else n
    progress = NProgress.render(!started)
    bar = progress.querySelector(Settings.barSelector)
    speed = Settings.speed
    ease = Settings.easing
    progress.offsetWidth

    ### Repaint ###

    queue (next) ->
      # Set positionUsing if it hasn't already been set
      if Settings.positionUsing == ''
        Settings.positionUsing = NProgress.getPositioningCSS()
      # Add transition
      css bar, barPositionCSS(n, speed, ease)
      if n == 1
        # Fade out
        css progress,
          transition: 'none'
          opacity: 1
        progress.offsetWidth

        ### Repaint ###

        setTimeout (->
          css progress,
            transition: 'all ' + speed + 'ms linear'
            opacity: 0
          setTimeout (->
            NProgress.remove()
            next()
            return
          ), speed
          return
        ), speed
      else
        setTimeout next, speed
      return
    this

  NProgress.isStarted = ->
    typeof NProgress.status == 'number'

  ###*
  # Shows the progress bar.
  # This is the same as setting the status to 0%, except that it doesn't go backwards.
  #
  #     NProgress.start();
  #
  ###

  NProgress.start = ->
    if !NProgress.status
      NProgress.set 0

    work = ->
      setTimeout (->
        if !NProgress.status
          return
        NProgress.trickle()
        work()
        return
      ), Settings.trickleSpeed
      return

    if Settings.trickle
      work()
    this

  ###*
  # Hides the progress bar.
  # This is the *sort of* the same as setting the status to 100%, with the
  # difference being `done()` makes some placebo effect of some realistic motion.
  #
  #     NProgress.done();
  #
  # If `true` is passed, it will show the progress bar even if its hidden.
  #
  #     NProgress.done(true);
  ###

  NProgress.done = (force) ->
    if !force and !NProgress.status
      return this
    NProgress.inc(0.3 + 0.5 * Math.random()).set 1

  ###*
  # Increments by a random amount.
  ###

  NProgress.inc = (amount) ->
    n = NProgress.status
    if !n
      NProgress.start()
    else
      if typeof amount != 'number'
        amount = (1 - n) * clamp(Math.random() * n, 0.1, 0.95)
      n = clamp(n + amount, 0, 0.994)
      NProgress.set n

  NProgress.trickle = ->
    NProgress.inc Math.random() * Settings.trickleRate

  ###*
  # Waits for all supplied jQuery promises and
  # increases the progress as the promises resolve.
  #
  # @param $promise jQUery Promise
  ###

  do ->
    initial = 0
    current = 0

    NProgress.promise = ($promise) ->
      if !$promise or $promise.state() == 'resolved'
        return this
      if current == 0
        NProgress.start()
      initial++
      current++
      $promise.always ->
        current--
        if current == 0
          initial = 0
          NProgress.done()
        else
          NProgress.set (initial - current) / initial
        return
      this

    return

  ###*
  # (Internal) renders the progress bar markup based on the `template`
  # setting.
  ###

  NProgress.render = (fromStart) ->
    if NProgress.isRendered()
      return document.getElementById('nprogress')
    addClass document.documentElement, 'nprogress-busy'
    progress = document.createElement('div')
    progress.id = 'nprogress'
    progress.innerHTML = Settings.template
    bar = progress.querySelector(Settings.barSelector)
    perc = if fromStart then '-100' else toBarPerc(NProgress.status or 0)
    parent = document.querySelector(Settings.parent)
    spinner = undefined
    css bar,
      transition: 'all 0 linear'
      transform: 'translate3d(' + perc + '%,0,0)'
    if !Settings.showSpinner
      spinner = progress.querySelector(Settings.spinnerSelector)
      spinner and removeElement(spinner)
    if parent != document.body
      addClass parent, 'nprogress-custom-parent'
    parent.appendChild progress
    progress

  ###*
  # Removes the element. Opposite of render().
  ###

  NProgress.remove = ->
    removeClass document.documentElement, 'nprogress-busy'
    removeClass document.querySelector(Settings.parent), 'nprogress-custom-parent'
    progress = document.getElementById('nprogress')
    progress and removeElement(progress)
    return

  ###*
  # Checks if the progress bar is rendered.
  ###

  NProgress.isRendered = ->
    ! !document.getElementById('nprogress')

  ###*
  # Determine which positioning CSS rule to use.
  ###

  NProgress.getPositioningCSS = ->
    # Sniff on document.body.style
    bodyStyle = document.body.style
    # Sniff prefixes
    vendorPrefix = if 'WebkitTransform' of bodyStyle then 'Webkit' else if 'MozTransform' of bodyStyle then 'Moz' else if 'msTransform' of bodyStyle then 'ms' else if 'OTransform' of bodyStyle then 'O' else ''
    if vendorPrefix + 'Perspective' of bodyStyle
      # Modern browsers with 3D support, e.g. Webkit, IE10
      'translate3d'
    else if vendorPrefix + 'Transform' of bodyStyle
      # Browsers without 3D support, e.g. IE9
      'translate'
    else
      # Browsers without translate() support, e.g. IE7-8
      'margin'

  ###*
  # (Internal) Queues a function to be executed.
  ###

  queue = do ->
    pending = []

    next = ->
      fn = pending.shift()
      if fn
        fn next
      return

    (fn) ->
      pending.push fn
      if pending.length == 1
        next()
      return

  ###*
  # (Internal) Applies css properties to an element, similar to the jQuery
  # css method.
  #
  # While this helper does assist with vendor prefixed property names, it
  # does not perform any manipulation of values prior to setting styles.
  ###

  css = do ->
    cssPrefixes = [
      'Webkit'
      'O'
      'Moz'
      'ms'
    ]
    cssProps = {}

    camelCase = (string) ->
      string.replace(/^-ms-/, 'ms-').replace /-([\da-z])/gi, (match, letter) ->
        letter.toUpperCase()

    getVendorProp = (name) ->
      style = document.body.style
      if name of style
        return name
      i = cssPrefixes.length
      capName = name.charAt(0).toUpperCase() + name.slice(1)
      vendorName = undefined
      while i--
        vendorName = cssPrefixes[i] + capName
        if vendorName of style
          return vendorName
      name

    getStyleProp = (name) ->
      name = camelCase(name)
      cssProps[name] or (cssProps[name] = getVendorProp(name))

    applyCss = (element, prop, value) ->
      prop = getStyleProp(prop)
      element.style[prop] = value
      return

    (element, properties) ->
      args = arguments
      prop = undefined
      value = undefined
      if args.length == 2
        for prop of properties
          `prop = prop`
          value = properties[prop]
          if value != undefined and properties.hasOwnProperty(prop)
            applyCss element, prop, value
      else
        applyCss element, args[1], args[2]
      return
  NProgress
