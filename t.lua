-- ������� ��� ������ ����� � ���������� ������� � ����������
local function parseFile(filePath)
    local file = io.open(filePath, "r")  -- ��������� ���� ��� ������
    if not file then return nil end  -- ��������� ���������� �������� �����
    
    local functionsAndVariables = {}  -- ������ ��� �������� ������� � ����������

    -- ������ ���� ���������
    for line in file:lines() do
        -- ��������� ��� ������� ��� ����������, ��������� HTML-���� � ������
        local functionName = line:match("function%s+([%w_%.]+)%(")
        local variableName = line:match("([%w_]+)%s*=")

        if not line:find("---") and functionName then
            table.insert(functionsAndVariables, functionName)  -- ��������� ��� ������� � ������
        elseif not line:find("---") and variableName then
            table.insert(functionsAndVariables, variableName)  -- ��������� ��� ���������� � ������
        end
    end

    file:close()  -- ��������� ����
    return functionsAndVariables  -- ���������� ������ �����
end


-- ������ ������������� �������
local filePath = "library/moonloader.lua"
local result = parseFile(filePath)


-- save as txt in format lua table
local file = io.open("result.txt", "w")
file:write("{\n")
for i, v in ipairs(result) do
    file:write("    \""..v.."\",\n")
end
file:write("}")
file:close()
print("Done!")