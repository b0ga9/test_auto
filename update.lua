script_version('3')

function main()
    while not isSampAvailable() do wait(0) end
    local lastver = update():getLastVersion()
    sampAddChatMessage('������ ��������, ������: '..lastver, -1)
    sampRegisterChatCommand("add", cmd_12)
    if thisScript().version ~= lastver then
        sampRegisterChatCommand('scriptupd', function()
            update():download()
        end)
        sampAddChatMessage('����� ���������� ������� ('..thisScript().version..' -> '..lastver..'), ������� /scriptupd ��� ����������!', -1)
    end
    wait(-1)
end

function update()
    local raw = 'https://raw.githubusercontent.com/b0ga9/test_auto/master/update.json'
    local dlstatus = require('moonloader').download_status
    local requests = require('requests')
    local f = {}
    function f:getLastVersion()
        local response = requests.get(raw)
        if response.status_code == 200 then
            return decodeJson(response.text)['last']
        else
            return 'UNKNOWN'
        end
    end
    function f:download()
        local response = requests.get(raw)
        if response.status_code == 200 then
            downloadUrlToFile(decodeJson(response.text)['url'], thisScript().path, function (id, status, p1, p2)
                print('�������� '..decodeJson(response.text)['url']..' � '..thisScript().path)
                if status == dlstatus.STATUSEX_ENDDOWNLOAD then
                    sampAddChatMessage('������ ��������, ������������...', -1)
                    thisScript():reload()
                end
            end)
        else
            sampAddChatMessage('������, ���������� ���������� ����������, ���: '..response.status_code, -1)
        end
    end
    return f
end

function cmd_12(arg)
    sampShowDialog(1000,'��������������','{FFFF00}������� ������ �������: v1.0'.."\n{FFFFFF}���������� ���",'�������',"", 0)-- body
end