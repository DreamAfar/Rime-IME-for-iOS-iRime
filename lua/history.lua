local function init_func(env) env.history = {oo = "", ii = "", xx = ""} end

local function fini_func(env) end

local function proc_func(key, env)
    local Rejected, Accepted, Noop = 0, 1, 2
    local engine = env.engine
    local context = engine.context

    if key.keycode == 0x3d or key.keycode == 0x2d then --  3d "="  2d '-'
        local word = context.input:match(".*(%w%w)$")
        if (word == "oo" or word == "ii" or word == "xx") then
            -- if env.history[word] then   --  可以試試 用 hash key 檢查 這樣 是以 hash key 範圍
            context:pop_input(2) -- remove back 2 char
            if key.keycode == 0x3d then --  save commit_text to history[word]
                env.history[word] = context:get_commit_text() or ""
            else -- keycode == 2d  append to  commit_text and commit
                engine:commit_text(context:get_commit_text() ..
                                       env.history[word])
            end
            context:clear() -- clear context.input
            return Accepted
        end
    end
    return Noop
end
return {init = init_func, func = proc_func, fini = fini_func}
