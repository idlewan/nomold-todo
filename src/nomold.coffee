last_id = -1
ids = {}
values = []

callbacks = []
bindings = []

# subscribing creates an entry in ids for each vars requested if they don't have one
window.subscribe = (list_args, fn) ->
    args_id = []
    if not Array.isArray(list_args)
        list_args = [list_args]

    for arg in list_args
        if not ids.hasOwnProperty(arg)
            last_id += 1
            ids[arg] = last_id
        args_id.push(ids[arg])

    cb_closed = ->
        params = (values[i] for i in args_id)
        fn.apply(null, params)
    info 'subscribe:', fn._name, list_args
    cb_closed._name = fn._name
    callbacks.push(cb_closed)
    cb_id = callbacks.length - 1

    for id in args_id
        bindings[id] ?= []
        bindings[id].push(cb_id)
    return


notify = (id) ->
    fns_ids = bindings[id]
    if not fns_ids
        return
    for fn_id in fns_ids
        info 'callback:', callbacks[fn_id]._name
        callbacks[fn_id]()
    return


# avoid running several same callbacks when a group of values change
# each callback runs at most once per set_multiple (if it needs to)
set_multiple = (key_values, do_notify) ->
    info 'set_multiple:', key_values, do_notify
    cbs_to_call = {}
    for k, v of key_values
        id = ids[k]
        values[id] = v

        fns_ids = bindings[id]
        if not fns_ids
            continue
        for fn_id in fns_ids
            cbs_to_call[fn_id] = true

    if do_notify == false
        return
    
    for cb_id of cbs_to_call
        info 'callback:', callbacks[cb_id]._name
        callbacks[cb_id]()
        

window.set = (var_name, value, do_notify) ->
    if typeof var_name == 'object'
        if value != undefined and not (value == false || value == true)
            assert( value != undefined and value != false, "asdf")
            warn """
            werror: set is used with an object and a value.
            Use either set(:string:, value [, notify? ]) or set(:object: [,notify?])
                you used: set(%s, %s, %s)""", var_name, value, do_notify
            return
        set_multiple(var_name, value) # value is really do_notify here
        return

    info 'set:', var_name, value, do_notify

    id = ids[var_name]

    values[id] = value

    if do_notify == false
        return
    notify(id)
    return

window.add = (var_name, new_value) ->
    info 'add:', var_name, new_value
    if not ids.hasOwnProperty(var_name)
        last_id += 1
        ids[var_name] = last_id

    id = ids[var_name]

    if values[id] == undefined
        values[id] = []

    if not Array.isArray(values[id])
        error 'error: "%s" not an array, cannot add', var_name, new_value
        return

    values[id].push(new_value)

    notify(id)
    return

window.remove = (var_name, idx) ->
    info 'remove:', var_name, idx
    if not ids.hasOwnProperty(var_name)
        error 'error: "%s" not defined, cannot remove its index "%d"',
            var_name, idx

    id = ids[var_name]
    if not Array.isArray(values[id])
        error 'error: "%s" already set and not an array, cannot remove its index "%d"',
            var_name, idx
        return


    if not values[id].hasOwnProperty(idx)
        error 'error: idx "%d" in "%s" inexistant, cannot remove', idx, var_name
        return

    values[id].splice(idx, 1)

    notify(id)
    return

window.replace_in = (var_name, idx, new_value, do_notify) ->
    info 'replace_in:', var_name, idx, new_value
    if not ids.hasOwnProperty(var_name)
        error 'error: "%s" not defined, cannot replace its index "%d"',
            var_name, idx

    id = ids[var_name]
    if not Array.isArray(values[id])
        error 'error: "%s" already set and not an array, cannot replace its index "%d"',
            var_name, idx
        return


    if not values[id].hasOwnProperty(idx)
        error 'error: idx "%d" in "%s" inexistant, cannot remove', idx, var_name
        return

    values[id][idx] = new_value

    if do_notify
        notify(id)
    return

window.get = (var_name) ->
    info 'get:', var_name
    if not ids.hasOwnProperty(var_name)
        error 'error: "%s" not defined (never seen), cannot get', var_name
    id = ids[var_name]
    if not values.hasOwnProperty(id)
        error 'error: "%s" not defined (never set), cannot get', var_name
    return values[id]
