local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Konfigurasi waktu & titik awal-akhir
local totalTime = 720 -- 12 menit (720 detik)
local steps = 720 -- 1 detik per langkah
local delayPerStep = totalTime / steps -- 1 detik

-- Ganti posisi awal dan akhir ini sesuai map Everest
local startPos = Vector3.new(-920, 320, -150) -- Misal Camp 1
local endPos = Vector3.new(-650, 1020, -350) -- Misal Summit

-- Fungsi interpolasi posisi
local function interpolateVector3(startPos, endPos, t)
	return startPos + (endPos - startPos) * t
end

-- Mulai fly
hrp.Anchored = true
print("Mulai fly ke summit...")

for step = 1, steps do
	local t = step / steps
	local targetPos = interpolateVector3(startPos, endPos, t)
	hrp.CFrame = CFrame.new(targetPos)
	task.wait(delayPerStep)
end

-- Matikan fly setelah selesai
hrp.Anchored = false
print("Selesai fly. Sampai Summit.")
