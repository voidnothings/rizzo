![lp js cover book](http://github.com/lonelyplanet/avocado/edit/master/docs/images/lp_js_cover.png) 

# (wip) The Lonely Planet Guide to Javascript {CoffeeScript}.


A collection of best-practices and coding conventions.

#### Based on:

* Coffeescript style guide by polarmobile  [https://raw.github.com/polarmobile/coffeescript-style-guide]
* Github javascript style guide [https://github.com/styleguide/javascript]

##Coding Style

* Write new JS in CoffeeScript.
* Use soft-tabs with a two space indent.
* Always use camelCase, never underscores.
* Use camelCase (with a leading lowercase character) to name all variables, methods, and object properties.
* Use CamelCase (with a leading uppercase character) to name all classes.
* Use implicit parentheses when possible.
* For constants, use all uppercase with underscores: CONSTANT_LIKE_THIS
* Methods and variables that are intended to be "private" should begin with a leading underscore: _privateMethod: ->
* See the CoffeeScript documentation for good examples.
* Don't ever use $.get or $.post. Instead use $.ajax and provide both a success handler and an error handler.
* Use $.fn.on instead of $.fn.bind, $.fn.delegate and $.fn.live.
* Do we need that jQuery? plugins should have global consensus inside our team. 


###Existing JavaScript

  * Avoid adding new .js files.
  * Use soft-tabs with a two space indent.
  * Use semicolons. In production we use strong magnification and obfuscation that change your code.

## Selectors
Try to prefix all javascript-based selectors with js-. This will help to differentiate a presentational class from a functional class.

## Code Structure


### Testing With Jasmine

* Write specs in CoffeeScript.
* run guard -g assets to compile it on-the-fly.
* Use  /*_spec.coffee/ as filename pattern.
* Specs should be located at spec/javascripts/lib
* run 'be rake jasmine' to start jasmine server.
* run 'be rake clean_compile_run' for ci test (TODO: update this task name)

### AMD (requirejs)

We use require.js to manage our modules.


###Comments
The first word of the comment should be capitalized, unless the first word is an identifier that begins with a lower-case letter. 

If a comment is short, the period at the end can be omitted.

####Block comments
Block comments apply to the block of code that follows them.
Each line of a block comment starts with a # and a single space, and should be indented at the same level of the code that it describes.
Paragraphs inside of block comments are separated by a line containing a single #.

####Inline Comments
Inline comments are placed on the line immediately above the statement that they are describing.

##Functions

When declaring a function that takes arguments, always use a single space after the closing parenthesis of the arguments list:
```coffeescript
foo = (arg1, arg2) -> # Yes
foo = (arg1, arg2)-> # No


Do not use parentheses when declaring functions that take no arguments:
```coffeescript
bar = -> # Yes
bar = () -> # No

In cases where method calls are being chained and the code does not fit on a single line, each call should be placed on a separate line and indented by one level (i.e., two spaces), with a leading `.`.

```coffeescript
[1..3]
  .map((x) -> x * x)
  .concat([10..12])
  .filter((x) -> x < 11)
  .reduce((x, y) -> x + y)
```

When calling functions, choose to omit or include parentheses in such a way that optimizes for readability. Keeping in mind that "readability" can be subjective, the following examples demonstrate cases where parentheses have been omitted or included in a manner that the community deems to be optimal:

```coffeescript
baz 12

brush.ellipse x: 10, y: 20 # Braces can also be omitted or included for readability

foo(4).bar(8)

obj.value(10, 20) / obj.value(20, 10)

print inspect value

new Tag(new Value(a, b), new Arg(c))
```

You will sometimes see parentheses used to group functions (instead of being used to group function parameters). Examples of using this style (hereafter referred to as the "function grouping style"):

```coffeescript
($ '#selektor').addClass 'klass'

(foo 4).bar 8
```

This is in contrast to:

```coffeescript
$('#selektor').addClass 'klass'

foo(4).bar 8
```

In cases where method calls are being chained, some adopters of this style prefer to use function grouping for the initial call only:

```coffeescript
($ '#selektor').addClass('klass').hide() # Initial call only
(($ '#selektor').addClass 'klass').hide() # All calls
```

The function grouping style is not recommended. However, **if the function grouping style is adopted for a particular project, be consistent with its usage.**

<a name="strings"/>
## Strings

Use string interpolation instead of string concatenation:

```coffeescript
"this is an #{adjective} string" # Yes
"this is an " + adjective + " string" # No
```

Prefer single quoted strings (`''`) instead of double quoted (`""`) strings, unless features like string interpolation are being used for the given string.

<a name="conditionals"/>
## Conditionals

Favor `unless` over `if` for negative conditions.

Instead of using `unless...else`, use `if...else`:

```coffeescript
  # Yes
  if true
    ...
  else
    ...

  # No
  unless false
    ...
  else
    ...
```

Multi-line if/else clauses should use indentation:

```coffeescript
  # Yes
  if true
    ...
  else
    ...

  # No
  if true then ...
  else ...
```

<a name="looping_and_comprehensions"/>
## Looping and Comprehensions

Take advantage of comprehensions whenever possible:

```coffeescript
  # Yes
  result = (item.name for item in array)

  # No
  results = []
  for item in array
    results.push item.name
```

To filter:

```coffeescript
result = (item for item in array when item.name is "test")
```

To iterate over the keys and values of objects:

```coffeescript
object = one: 1, two: 2
alert("#{key} = #{value}") for key, value of object
```
## Extending Native Objects

Do not modify native objects.

For example, do not modify `Array.prototype` to introduce `Array#forEach`.

<a name="exceptions"/>
## Exceptions

Do not suppress exceptions.

## Annotations

Use annotations when necessary to describe a specific action that must be taken against the indicated block of code.

Write the annotation on the line immediately above the code that the annotation is describing.

The annotation keyword should be followed by a colon and a space, and a descriptive note.

```coffeescript
  # FIXME: The client's current state should *not* affect payload processing.
  resetClientState()
  processPayload()
```

If multiple lines are required by the description, indent subsequent lines with two spaces:

```coffeescript
  # TODO: Ensure that the value returned by this call falls within a certain
  #   range, or throw an exception.
  analyze()
```

Annotation types:

- `TODO`: describe missing functionality that should be added at a later date
- `FIXME`: describe broken code that must be fixed
- `OPTIMIZE`: describe code that is inefficient and may become a bottleneck
- `HACK`: describe the use of a questionable (or ingenious) coding practice
- `REVIEW`: describe code that should be reviewed to confirm implementation

If a custom annotation is required, the annotation should be documented in the project's README.

<a name="miscellaneous"/>
## Miscellaneous

`and` is preferred over `&&`.

`or` is preferred over `||`.

`is` is preferred over `==`.

`not` is preferred over `!`.

`or=` should be used when possible:

```coffeescript
temp or= {} # Yes
temp = temp || {} # No
```

Prefer shorthand notation (`::`) for accessing an object's prototype:

```coffeescript
Array::slice # Yes
Array.prototype.slice # No
```

Prefer `@property` over `this.property`.

```coffeescript
return @property # Yes
return this.property # No
```

However, avoid the use of **standalone** `@`:

```coffeescript
return this # Yes
return @ # No
```

Avoid `return` where not required, unless the explicit return increases clarity.

Use splats (`...`) when working with functions that accept variable numbers of arguments:

```coffeescript
console.log args... # Yes

(a, b, c, rest...) -> # Yes

