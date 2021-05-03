Timer = {}

Timer.group = {}

function returnTask(object, key, final, duration, finish)
	--assert(object[key])
	--print(key)
	return {
		object = object,
		key = key,
		initial = object[key],
		final = final,
		difference = final - object[key],
		time = 0,
		duration = duration,
		finish = finish or function() end
	}
end

Timer.tween = function(duration, tasks, finish)
	for object, items in pairs(tasks) do
		for key, final in pairs(items) do
			table.insert(Timer.group, returnTask(object, key, final, duration, finish))
		end
	end
end

Timer.update = function(dt)
	for k, task in pairs(Timer.group) do
		task.time = task.time + dt
		task.object[task.key] = task.initial + task.difference*(task.time/task.duration)

		if task.time >= task.duration then
			task.object[task.key] = task.final
			task.finish()
			Timer.group[k] = nil
		end
	end
end
