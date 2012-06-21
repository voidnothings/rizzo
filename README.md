# Principles of writing Lonely Planet Sass

These are guidelines put in place to provide structure and clarity to our Sass library. It is not here to restrict how we write Sass and to that end it should evolve as our practices evolve. However, these guidelines do strongly
encourage the use of existing, common, sensible patterns.


## Table of contents

1. [General principles](#general-principles)
2. [Indentation](#sass)
3. [Comments](#comments)
4. [Format](#format)
5. [Abstractions](#abstractions)
6. [Naming](#naming)
7. [Organization](#organization)
8. [Base Project](#base_project)
9. [Utils](#utils)
10. [Common-ui](#common-ui)
11. [Styleguide](#styleguide)


<a name="general-principles"></a>
## 1. General principles

> "Leave code in a better state than you found it."

* All code in any code-base should look like a single person typed it, no matter how many people contributed.
* Strictly enforce the agreed upon style.
* If in doubt use existing, common patterns.


<a name="sass"></a>
## 2. Indentation
We use the Sass indented format which means:

* 2 spaces (or a soft tab) are used for indentation
* Curly braces are omitted

Tip: configure your editor to "show invisibles". This will allow you to eliminate end of line whitespace, eliminate unintended blank line whitespace, and avoid polluting commits.


<a name="comments"></a>
## 3. Comments

Don't leave others in the team guessing as to the purpose of uncommon or non-obvious code.

Comments should follow the below pattern:

```css
//----------------------------------------------------------
// UI Object Title
//
// Description, modifier classes, styleguide reference 
//----------------------------------------------------------
```

* Always use // rather than /* as the latter will persist after compilation.
* Be overly verbose. All comments will be stripped out on build, they are there for our understanding and to help the team develop faster.
* Place comments on a new line above their subject.
* Make liberal use of comments to break CSS code into discrete sections.


<a name="format"></a>
## 4. Format

* Nest with care!
* Limit nesting to 1 level deep. Reassess any nesting more than 2 levels deep. This prevents overly specific CSS selectors.
* Avoid large numbers of nested rules. Break them up when readability starts to be affected. Avoid nesting that spreads over more than 20 lines.
* Group `@include` and `@extend` statements at the top of a declaration block.

<a name="abstractions"></a>
## 5. Abstractions
* Reusable blocks of code should be abstracted from your project Sass and placed within beaker if you believe it is globally useful. They should be placed into the common-ui or utils folder (see below for clarfication on where)
* Variables should be abstracted into Beaker unless you want them to remain local. Variables are local when declared inside mixins.
* Code should be abstracted from your style declarations where possible. Check in _utils/extends and _utils/objects to see if there are code patterns already available for you to use.

```css
// Example of refactorable code

// Before
.example
  position: absolute
  top: 0
  left: 0
  right: 30px
  .heading
    font-size: 22px
    width: 100%
    color: #007c
    margin-bottom: 20px
    border-bottom: 1px solid #cecece

// After
.example
  @extend %absolute-top-left
  right: 30px
  .heading
    @extend .module-title
    color: $blue-link

```

Using @extend to link to abstracted classes makes for more readable code as we can specify much more verbose placeholder names and reduce the amount of declarations.


<a name="naming"></a>
## 6. Naming

Balance the necessity for semantic classnames with terseness when naming classes: short but readable.

We use two types of prefix:
 * Prefix states with is- Eg. is-hidden
 * Prefix hooks with js- Eg. js-toggle
 
Prefixing with js: 
 * This ensures that we maintain a distinction between content and functionality
 * If there is no id to the element you can place your js-hook as the id.
 * If there is an id and you need to style the element with a class it is ok to duplicate the class, eg:
 ```
 <a id="#someContent" class="toggle js-toggle">View content</a>
 ```
 * Do NOT style js-classes in your CSS
 * Do NOT select an element from the DOM without a js-hook.


When naming mixins that deal with css properties use the same name. Eg:
* @mixin border-radius()
* @mixin font-size()

When naming custom mixins, variables and placeholders be verbose and use intuitive naming. Eg:
* $header-background-blue: #0a4f9c
* %hotels-card-texture



<a name="organization"></a>
## 7. Organization

* Logically separate distinct pieces of code.
* Your main project sass file should only have @import rules within it.
* Keep Sass files short and readable.

<a name="base_project"></a>
## 8. Base Project

* Start any new project by installing beaker as a gem.
* The first line of your project Sass file should be :
@import base_project

base_project.sass includes:
 - Reset
 - Typographic Styles
 - All of _Utils

<a name="utils"></a>
## 9. Utils

_Utils.sass and the _utils folder contain all of our library code in the form of mixins, variables and placeholders. 

No code should go into _utils if it is not protected by one of the above to avoid unnecessary css bloat as all of this code is included by default.

Utils also includes a set of debug styles, designed to highlight common development errors in markup. To activate these @include debug() and add a .debug class to the body element. Obviously this should only be used in development.

<a name="common-ui"></a>
## 10. Common-Ui

_Common-ui contains all resusable widgets. None of these files are included by default so look to what you might need before choosing to @import them or accidentally duplicating code.

When adding to common-ui, create a new file for your module/widget so that it is available for others. Comment it heavily and add it to the styleguide.


<a name="styleguide"></a>
## 11. Styleguide

We plan to implement the KSS living styleguide (https://github.com/kneath/kss) which will allow commenting in our Sass to dictate the output of the styleguide.

This will be updated as we move forward with this project.





This document is derived from Nicolas Gallagher's Idiomatic CSS. (https://github.com/necolas/idiomatic-css) which has been adapted for our needs.


