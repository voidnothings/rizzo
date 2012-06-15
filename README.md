## Beaker

# Creating a new project
- Create a new directory for your project with an empty sass file.
- Import _base-project (includes all of utils and core)
- Create a subfolder for any project partials

# _utils
- Any Sass you write in _utils should be contained within mixins or declared using the placeholder (%). This will ensure that this code does not bleed unnecessarily into stylesheets and create bloated code.
- Utils is included by default in _base-project but mixins (eg. the grid) will need to be instantiated by @include

### utils/_debug.sass
Only @include this in development. Toggle .debug class on the body to activate debugging

# _common-ui
- None of these files are included by default
- If you want to use elements of common ui - @import them


## Writing Sass
- Nest with care ;)
- Any globally useful UI elements should be abstracted from your project into the common-ui folder
- Any globally useful css patterns should be included in _utils. Try to make the next developer's life easier.
- Comment as much as possible. Always comment using // rather than /* */

### TODO: Introduce the living styleguide. https://github.com/kneath/kss