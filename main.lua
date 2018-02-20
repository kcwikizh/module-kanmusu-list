local shipData = {}
if mw then
    shipData = require('模块:舰娘数据') 
else
    shipData = require('ship_data')
end

local p = {}

local string = {
    format = string.format,
    find = string.find
}
local table = {
    concat = table.concat,
    insert = table.insert,
    sort = table.sort
}
local math = {
    floor = math.floor
}

local shipTypeTable = {
    '海防舰',
    '驱逐舰',
    '轻巡洋舰',
    '重雷装巡洋舰',
    '重巡洋舰',
    '航空巡洋舰',
    '轻空母',
    '巡洋战舰',
    '战舰',
    '航空战舰',
    '正规空母',
    '超弩建战舰',
    '潜水舰',
    '潜水空母',
    '补给舰',
    '水上机母舰',
    '扬陆舰',
    '装甲空母',
    '工作舰',
    '潜水空母',
    '练习巡洋舰',
    '补给舰'
}
local shipSpeedTable = {
    [0] = '陆上基地',
    [5] = '低速',
    [10] = '高速'
}
local shipRangeTable = {
    [0] = '无',
    [1] = '短',
    [2] = '中',
    [3] = '长',
    [4] = '超长'
}


local function getInt (n)
    if type(n) ~= 'number' or n ~= math.floor(n) then
        return nil
    end
    
    return n
end


local function getShipDataToArgs (ship, args, wikiId, suffix, level)
    local index = level == 1 and 1 or 2
    if suffix == '' then
        args['编号'] = wikiId
        if ship['级别'][2] == 0 then
            args['级别'] = ship['级别'][1]
        else
            args['级别'] = string.format('%s号', table.concat(ship['级别']))
        end
        args['类型'] = shipTypeTable[ship['舰种']]
    end

    args[string.format('名字%s', suffix)] = ship['中文名']
    args[string.format('耐久%s', suffix)] = ship['数据']['耐久'][index]
    args[string.format('火力%s', suffix)] = ship['数据']['火力'][index]
    args[string.format('雷装%s', suffix)] = ship['数据']['雷装'][index]
    args[string.format('对空%s', suffix)] = ship['数据']['对空'][index]
    args[string.format('装甲%s', suffix)] = ship['数据']['装甲'][index]
    args[string.format('对潜%s', suffix)] = ship['数据']['对潜'][index]
    args[string.format('回避%s', suffix)] = ship['数据']['回避'][index]
    args[string.format('索敌%s', suffix)] = ship['数据']['索敌'][index]
    args[string.format('运%s', suffix)] = ship['数据']['运'][index]
    args[string.format('速力%s', suffix)] = shipSpeedTable[ship['数据']['速力']]
    args[string.format('射程%s', suffix)] = shipRangeTable[ship['数据']['射程']]
    args[string.format('燃料%s', suffix)] = ship['消耗']['燃料']
    args[string.format('弹药%s', suffix)] = ship['消耗']['弹药']
    local nPlanes = 0
    for _, v in ipairs(ship["装备"]["搭载"]) do
        local n = getInt(v)
        if n and n > 0 then
            nPlanes = nPlanes + n
        end
    end
    args[string.format('搭载%s', suffix)] = nPlanes
end


function p.main (frame)
    local shipDataTb = shipData.shipDataTb
    local wikiIdList = {}
    for v in pairs(shipDataTb) do
        table.insert(wikiIdList, v)
    end
    table.sort(wikiIdList)

    local templateArgsList = {}
    local templateArgs = {}
    local ship = {}
    local suffix = ''
    local level = tonumber(frame.args[1])
    if level ~= 1 and level ~= 99 then
        level = 1
    end
    for _, wikiId in ipairs(wikiIdList) do
        ship = shipDataTb[wikiId]
        if ship == nil then
            return 'Unknow wiki ID: ' .. tostring(wikiId)
        end
        if not string.find(wikiId, 'a') then
            table.insert(templateArgsList, {})
            suffix = ''
        else
            suffix = '2'
        end
        templateArgs = templateArgsList[#templateArgsList]
        local status, msg = pcall(getShipDataToArgs, ship, templateArgs,
                                  wikiId, suffix, level)
        if status == false then
            return string.format('Data error, wiki ID: %s\n%s', wikiId, msg)
        end
    end

    local output = ''
    for _, args in ipairs(templateArgsList) do
        output = string.format(
            '%s%s\n',
            output,
            frame:expandTemplate({title='舰娘列表', args=args}))
    end

    return output
end


return p

