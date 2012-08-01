define ->

  class errorMessages  

    systemError : ->
      error = '<div class="system-error">' +
                '<div class="error-inner">' +
                  '<h3 class="error-title">Whoopsie&hellip; an error has occurred</h3>' +
                  '<p class="error-copy">We have our best guys working on it. In the meantime, please try again</p>' +
                '</div>' +
              '</div>'
