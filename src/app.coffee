window.ENTER_KEY = 13
window.ESCAPE_KEY = 27

# Don't trigger updates from the router when it loads
is_starting = true

set("filter", "all", !is_starting)
# do not trigger a footer and list render yet

router = Router
    '/': -> set('filter', 'all', !is_starting)
    '/active': -> set('filter', 'active', !is_starting)
    '/completed': -> set('filter', 'completed', !is_starting)

router.init() # thanks to is_starting, does not trigger an update

is_starting = false

my_tasks = []
# TODO: load tasks from localstorage

set("tasks", my_tasks)
### This will trigger:
    - 'render' in list
    - 'hide' in footer (hide footer element if there is no tasks)
    - 'update_counts' in footer that will update 'active' and 'completed'
        - 'active' and 'completed' trigger 'render' in footer
###

todo_input = document.getElementById('new-todo')

todo_input.addEventListener 'keypress', (e) ->
    # Add a new todo item
    if e.keyCode == ENTER_KEY
        if e.target.value.trim() == ''
            return
        add("tasks", title: e.target.value)
        e.target.value = ''
    return
