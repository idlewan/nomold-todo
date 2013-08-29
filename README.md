# noMold TodoMVC Example
noMold is a very small library/framework that helps to write small testable modules that don't depend upon each other.

It provide a **mediator/observer**-inspired interface between modules:
you first register *callbacks* that need to be called __whenever a variable change__ (the variable is handled/stored by the library).
You change the value of the variables with a *setter function*, and your previously-registered callbacks *are called*.


# Hacking
Use `make coffee` to watch and compile coffeescript files and `watch make` for jade templates.


# Templates
The *jade* templates are compiled under `_js/` and are automatically named `templatename.jade.js`. Don't forget to add them in `<scripts>` tags to your html page.

They are then available as pre-compiled functions attached to the `TEMPLATE` object:

    mydiv.innerHTML = TEMPLATE['mytemplate.jade']({
        'template_var_1': 123,
        'template_var_2': "aaa",
    })


# TODO
- use localstorage to retrieve tasks
- the checkmark at the top for 'everything is done' has no action yet
- noMold: have a "don't call this callback" parameter for replace_in to avoid triggering a template update that overwrites the html elements. That would allow css transitions to work, by manually setting css classes on the modified element
