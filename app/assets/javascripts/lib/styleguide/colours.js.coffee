require ['jquery'], ($) ->
  $(".js-select").on "change", (e) ->
    sortBy window[@value]
    $(@parentNode).find(".js-select-overlay").textContent = @selectedOptions[0].textContent

  $(".styleguide-proximity__input").on "keyup", (e) ->
    e.keyCode is 13 and matchProximity()

  $(".clearbutton").on "click", (e) ->
    resetProximity()

  sortBy = (comparator) ->
    sections = document.querySelectorAll(".styleguide-block")
    i = 0

    while i < sections.length
      section = sections[i]
      cards = Array::slice.call(section.querySelectorAll(".card--double"))
      newCards = ""
      cards = cards.sort(comparator)
      cards.forEach (card) ->
        newCards += card.outerHTML

      section.querySelector(".js-card-container").innerHTML = newCards
      i++
  lightToDark = (a, b) ->
    lumA = Number(a.getAttribute("data-luminance"))
    lumB = Number(b.getAttribute("data-luminance"))
    lumA < lumB
  darkToLight = (a, b) ->
    lumA = Number(a.getAttribute("data-luminance"))
    lumB = Number(b.getAttribute("data-luminance"))
    lumA > lumB
  resetProximity = ->
    document.getElementById("proximityMatch").value = ""
    document.querySelectorAll(".card--double").forEach (card) ->
      card.removeAttribute "style"
      card.className = card.className.replace(" isnt-approximate", "").replace(" is-approximate", "")

  matchProximity = ->
    colour = document.getElementById("proximityMatch").value
    colourBlocks = document.querySelectorAll(".styleguide-block__item--colour")
    colourBlocks.forEach (colourBlock) ->
      proximity = colourProximity(colour, colourBlock.innerHTML)
      
      # Remove previous classes
      colourBlock.parentNode.removeAttribute "style"
      colourBlock.parentNode.className = colourBlock.parentNode.className.replace(" is-approximate", "").replace(" isnt-approximate", "")
      if proximity < 20
        colourBlock.parentNode.style["background-color"] = (if /^#/.test(colour) then colour else "#" + colour)
        colourBlock.parentNode.className += " is-approximate"
        colourBlock.parentNode.className += " is-exact"  if proximity is 0
      else
        colourBlock.parentNode.className += " isnt-approximate"


  # Mostly ripped from here: http://stackoverflow.com/questions/13586999/color-difference-similarity-between-two-values-with-js 
  colourProximity = (v1, v2) ->
    i = undefined
    d = 0
    v1 = hexToRGB(v1)
    v2 = hexToRGB(v2)
    i = 0
    while i < v1.length
      d += (v1[i] - v2[i]) * (v1[i] - v2[i])
      i++
    Math.sqrt d
  hexToRGB = (colour) ->
    colour = colour.replace(/^#/, "").match(/[0-9a-z]{2}/g)
    [parseInt(colour[0], 16), parseInt(colour[1], 16), parseInt(colour[2], 16)]