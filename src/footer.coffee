render = (active, completed, filter) ->
    footer = document.querySelector('#footer')
    footer.innerHTML = TEMPLATE['footer.jade'](
        'active': active
        'completed': completed
        'filter': filter
    )
    clear_completed = footer.querySelector('#clear-completed')
    if not clear_completed
        return
    clear_completed.addEventListener 'click', ->
        remove_completed()
    return
render._name = 'render.footer'


remove_completed = ->
    tasks = get("tasks")
    new_tasks = tasks.filter (el, idx, array) ->
        return el.completed != true
    set("tasks", new_tasks)


hide = (tasks) ->
    footer = document.querySelector('#footer')
    if tasks.length == 0
        footer.style.display = 'none'
    else
        footer.style.display = 'block'
hide._name = 'hide.footer'


update_counts = (tasks) ->
    completed = tasks.filter( (el, idx, array) ->
        return el.completed == true
    ).length
    active = tasks.length - completed
    set('completed': completed, 'active': active)
update_counts._name = 'update_counts.footer'


subscribe(['active', 'completed', 'filter'], render)
subscribe('tasks', hide)
subscribe('tasks', update_counts)
