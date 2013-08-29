list = document.querySelector("#todo-list")

render = (tasks, filter) ->
    main = document.querySelector("#main")
    if tasks.length == 0
        main.style.display = 'none'
    else
        main.style.display = 'block'

    if filter == 'all'
        tasks_to_display = tasks
    else if filter == 'active'
        tasks_to_display = tasks.filter( (el, idx, array) ->
            return el.completed != true
        )
    else
        tasks_to_display = tasks.filter( (el, idx, array) ->
            return el.completed == true
        )
    list.innerHTML = TEMPLATE['list.jade'](
        'tasks': tasks_to_display
    )
    return
render._name = 'render.list'


list.addEventListener 'click', (e) ->
    target = e.target

    # you clicked on the destroy button
    if target.classList.contains 'destroy'
        remove_item(target)
    
    # you clicked on the checkmark
    else if target.classList.contains 'toggle'
        li = target
        while li.nodeName != 'LI'
            li = li.parentNode

        li.classList.toggle 'completed'

        update_item(li)

    return


remove_item = (destroy_button) ->
    li = destroy_button
    while li.nodeName != 'LI'
        li = li.parentNode

    id = li.dataset.id
    remove("tasks", id)
    return


update_item = (li) ->
    id = li.dataset.id
    title = li.querySelector('label').innerHTML
    completed = li.classList.contains 'completed'
    replace_in("tasks", id, {'title': title, 'completed': completed})
    return


list.addEventListener 'dblclick', (e) ->
    target = e.target
    if target.nodeName == 'LABEL'
        edit_item(target)
    return


edit_item = (label) ->
    li = label
    while li.nodeName != 'LI'
        li = li.parentNode

    input = document.createElement 'input'
    input.className = 'edit'
    input.value = label.innerHTML

    li.appendChild(input)
    li.classList.add 'editing'

    input.addEventListener 'blur', ->
        value = input.value.trim()
        discarding = input.dataset.discard
        console.log 'discarding', discarding

        if value.length and not discarding
            ## (it re-renders on top, but it gets the value from there):
            label.innerHTML = input.value
            # TODO: save
            update_item(li)
        li.classList.remove 'editing'
        li.removeChild input
        return

    input.addEventListener 'keypress', (e) ->
        console.log 'e.keyCode', e.keyCode
        if e.keyCode == ENTER_KEY
            input.blur()
        else if e.keyCode == ESCAPE_KEY
            input.dataset.discard = true
            input.blur()
        return

    input.focus()
    return


subscribe(['tasks', 'filter'], render)
