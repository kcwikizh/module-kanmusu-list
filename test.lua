local main = require('main')
local string = {
    format = string.format
}
local table = {
    insert = table.insert,
    concat = table.concat 
}
local frame = {
    expandTemplate = function (self, p)
        local title = p.title
        local args = p.args
        local keyValueList = {}

        for k, v in pairs(args) do
            table.insert(
                keyValueList,
                string.format('%s = %s', k, v)
            )
        end
        local output = string.format(
            '{{%s\n    |%s\n}}',
            title,
            table.concat(keyValueList, '\n    |')
        )
        return output
    end
}

frame.args = {'1'}
local f = assert(io.open('lv1.txt', 'w'))
f:write(main.main(frame))
f:close()

frame.args = {'99'}
local f = assert(io.open('lv99.txt', 'w'))
f:write(main.main(frame))
f:close()
