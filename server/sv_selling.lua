local getCopsAmount = function() -- TODO
	-- local copsAmount = 0
	-- local onlinePlayers = exports.it_bridge:GetOnlinePlayers()
	-- if Config.Debug then lib.print.info('Online Players: ', #onlinePlayers) end
	-- for i=1, #onlinePlayers do
	-- 	local currentPlayer = onlinePlayers[i]
	-- 	if currentPlayer then
	-- 		local job = exports.it_bridge:GetPlayerJob(currentPlayer.source)
	-- 		if Config.Debug then lib.print.info('Player', onlinePlayers[i],  'Job: ', job.name) end
	-- 		for _, v in pairs(Config.PoliceJobs) do
	-- 			if job.name == v then
	-- 				if Config.OnlyCopsOnDuty then
	-- 					if job.onDuty then
	-- 						copsAmount = copsAmount + 1
	-- 					end
	-- 				else
	-- 					copsAmount = copsAmount + 1
	-- 				end
	-- 			end
	-- 		end
	-- 	end
	-- end
	-- return copsAmount
	return 100
end

RegisterNetEvent('it-drugs:server:initiatedrug', function(cad)
	local src = source
	local Player = exports.qbx_core:GetPlayer(src)
	if Player then
		local price = cad.price * cad.amount
		if Config.SellSettings['giveBonusOnPolice'] then
			local copsamount = getCopsAmount()
			if copsamount > 0 and copsamount < 3 then
				price = price * 1.2
			elseif copsamount >= 3 and copsamount <= 6 then
				price = price * 1.5
			elseif copsamount >= 7 and copsamount <= 10 then
				price = price * 1.7
			elseif copsamount >= 10 then
				price = price * 2.0
			end
		end
		price = math.floor(price)
		if exports.ox_inventory:GetItemCount(src, cad.item) >= cad.amount then
			if exports.ox_inventory:RemoveItem(src, tostring(cad.item), cad.amount) then
				math.randomseed(GetGameTimer())
				local stealChance = math.random(0, 100)
				if stealChance < Config.SellSettings['stealChance'] then
					ShowNotification(src, _U('NOTIFICATION__STOLEN__DRUG'), 'Error')
				else
					local moneyType = 'cash'
					local rewardItems = nil
					if Config.SellEverywhere['enabled'] then
						moneyType = Config.SellEverywhere.drugs[cad.item].moneyType or 'cash'
						rewardItems = Config.SellEverywhere.drugs[cad.item].rewardItems
					else
						moneyType = Config.SellZones[cad.zone].drugs[cad.item].moneyType or 'cash'
						rewardItems = Config.SellZones[cad.zone].drugs[cad.item].rewardItems
					end

					exports.qbx_core:AddMoney(src, moneyType, price, "Money from Drug Selling")
					if rewardItems then
						for _, v in pairs(rewardItems) do
							exports.ox_inventory:AddItem(src, v.name, (v.amount * cad.amount))
						end
					end
					ShowNotification(src, _U('NOTIFICATION__SOLD__DRUG'):format(price), 'Success')
				end
				local coords = GetEntityCoords(GetPlayerPed(src))
				SendToWebhook(src, 'sell', nil, ({item = cad.item, amount = cad.amount, price = price, coords = coords}))
				if Config.Debug then print('You got ' .. cad.amount .. ' ' .. cad.item .. ' for $' .. price) end
			else
				ShowNotification(src, _U('NOTIFICATION__SELL__FAIL'):format(cad.item), 'Error')
			end
		else
			ShowNotification(src, _U('NOTIFICATION__NO__ITEM__LEFT'):format(cad.item), 'Error')
		end
	end
end)

lib.callback.register('it-drugs:server:getCopsAmount', function(source)
	return getCopsAmount()
end)