window.log = ->
    console.log.apply console, arguments

window.error = ->
    console.error.apply console, arguments

window.warn = ->
    console.warn.apply console, arguments

window.assert = ->
    console.assert.apply console, arguments

if /WebKit/.test navigator.userAgent
    window.info = ->
        if Array.isArray arguments[0] or typeof arguments[0] == 'object'
            console.info.apply console, arguments
            return

        new_args = []
        args = arguments

        prefix_it = ->
            new_args.push "%c " +
                args[0].substring(0, args[0].length - 1) + " %c"

        # colors from http://www.colorcombos.com/color-schemes/532/ColorCombo532.html
        switch args[0]
            when "subscribe:"
                prefix_it()
                new_args.push "background: #102e37; color: white"
            when "set:", "set_multiple:"
                prefix_it()
                new_args.push "background: #2bbbd8; color: white"
            when "add:", "remove:", "replace_in:"
                prefix_it()
                new_args.push "background: #f78d3f; color: white"
            when "get:"
                prefix_it()
                new_args.push "background: #fcd271; color: #102e37"
            when "callback:"
                prefix_it()
                new_args.push "background: #e8ede0; color: #f78d3f"
            else
                new_args.push "%c " + args[0] + " %c"
                new_args.push "background: #e8ede0; color: #102e37"

        # reset colors
        new_args.push "background: white, color: black"
            
        for i in [1..args.length - 1]
            new_args.push args[i]
        console.info.apply console, new_args
else
    window.info = ->
        console.info.apply console, arguments
