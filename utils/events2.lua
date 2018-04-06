local Event = {}

local on_init_event_name = -1
local on_load_event_name = -2

local event_handlers = {}-- map of event_name to handlers[]
local on_nth_tick_event_handlers = {}-- map of tick to handlers[]

local function on_event(event)
    local handlers = event_handlers[event.name]
    
    for _, handler in ipairs(handlers) do
        handler(event)
    end
end

local function on_nth_tick_event(event)
    local handlers = on_nth_tick_event_handlers[event.nth_tick]
    
    for _, handler in ipairs(handlers) do
        handler(event)
    end
end

function Event.add(event_name, handler)
    local handlers = event_handlers[event_name]
    if not handlers then
        event_handlers[event_name] = {handler}
        script.on_event(event_name, on_event)
    else
        table.insert(handlers, handler)
    end
end

function Event.on_init(handler)
    local handlers = event_handlers[on_init_event_name]
    if not handlers then
        event_handlers[on_init_event_name] = {handler}
        script.on_init(on_event)
    else
        table.insert(handlers, handler)
    end
end

function Event.on_load(handler)
    local handlers = event_handlers[on_load_event_name]
    if not handlers then
        event_handlers[on_load_event_name] = {handler}
        script.on_load(on_event)
    else
        table.insert(handlers, handler)
    end
end

function Event.on_nth_tick(tick, handler)
    local handlers = on_nth_tick_event_handlers[tick]
    if not handlers then
        event_handlers[tick] = {handler}
        script.on_nth_tick(tick, on_nth_tick_event)
    else
        table.insert(handlers, handler)
    end
end

return Event
