call = load
function interpret(encoded)
    local bit32 = require("bit32")
    local custom_table = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-@'
    local decode_table = {}
    local xor_key = 0x5A
    for i = 1, #custom_table do decode_table[custom_table:sub(i, i)] = i - 1 end
    local decoded_data = {}
    local bits = 0
    local val = 0
    for i = 1, #encoded do
        local char = encoded:sub(i, i)
        if char ~= "#" then
            local index = decode_table[char]
            if index == nil then return nil, "Invalid character" end
            val = bit32.bor(bit32.lshift(val, 6), index)
            bits = bits + 6
            if bits >= 8 then
                bits = bits - 8
                local byte = bit32.band(bit32.rshift(val, bits), 0xFF)
                byte = bit32.bxor(byte, xor_key)
                decoded_data[#decoded_data + 1] = string.char(byte)
            end
        end
    end
    return table.concat(decoded_data)
end
