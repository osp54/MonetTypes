---@meta
---Effil is a multithreading library for Lua. It allows to spawn native threads and safe data exchange. Effil has been designed to provide clear and simple API for lua developers.
local effil = {}

---Is a global predefined shared table. This table always present in any thread (any Lua state).
effil.G = {}
effil.gc = {}

---Force garbage collection, however it doesn't guarantee deletion of all effil objects.
function effil.gc.collect() end

---Show number of allocated shared tables and channels.
---@return number @current number of allocated objects. Minimum value is 1, effil.G is always present.
function effil.gc.count() end

---Get/set GC memory step multiplier. Default is 2.0. GC triggers collecting when amount of allocated objects growth in step times.
---@param new_value? number @value of step to set. If it's nil then function will just return a current value.
---@return number old_value is current (if new_value == nil) or previous (if new_value ~= nil) value of step.
function effil.gc.step(new_value) end

---Pause GC. Garbage collecting will not be performed automatically. Function does not have any input or output.
function effil.gc.pause() end

---Resume GC. Enable automatic garbage collecting.
function effil.gc.resume() end

---Get GC state.
---@return boolean @true if automatic garbage collecting is enabled or false otherwise. By default returns true.
function effil.gc.enabled() end

---@class ThreadHandle
local ThreadHandle = {}

---@alias TimeMetric "ms"|"s"|"m"|"h"|"d"
---@alias ThreadStatus "running"|"paused"|"cancelled"|"completed"|"failed"


---Returns thread status.
---@return ThreadStatus, string?, string? @Status, error message and stack trace if thread failed.
function ThreadHandle:status() end

---Waits for thread completion and returns function result or nothing in case of error.
---@param time? number
---@param metric? TimeMetric
---@return ... @Results of captured function invocation or nothing in case of error.
function ThreadHandle:get(time, metric) end

---Waits for thread completion and returns thread status.
---Returns status of thread. The output is the same as thread:status()
---@param time? any
---@param metric? any
---@return ThreadStatus, string?, string? @Status, error message and stack trace if thread failed.
function ThreadHandle:wait(time, metric) end

---Interrupts thread execution. Once this function was invoked 'cancellation' flag is set and thread can be stopped sometime in the future (even after this function call done). To be sure that thread is stopped invoke this function with infinite timeout. Cancellation of finished thread will do nothing and return true.
---@param time? number
---@param metric? TimeMetric
---@return boolean @true if thread was stopped or false
function ThreadHandle:cancel(time, metric) end

---Pauses thread. Once this function was invoked 'pause' flag is set and thread can be paused sometime in the future (even after this function call done). To be sure that thread is paused invoke this function with infinite timeout.
---@param time? number
---@param metric? TimeMetric
---@return boolean @true if thread was paused or false. If the thread is completed function will return false
function ThreadHandle:pause(time, metric) end

---Resumes paused thread. Function resumes thread immediately if it was paused. This function does nothing for completed thread. Function has no input and output parameters.
function ThreadHandle:resume() end

---@class Runner
---@type fun(...:any):ThreadHandle@Run captured function with specified arguments in separate thread and returns thread handle.
local Runner = {
    ---Is a Lua package.path value for new state. Default value inherits package.path form parent state.
    path = "",
    ---Is a Lua package.cpath value for new state. Default value inherits package.cpath form parent state
    cpath = "",
    ---Number of lua instructions lua between cancelation points (where thread can be stopped or paused).
    ---<br>
    ---Default value is 200.
    ---<br>
    ---If this values is 0 then thread uses only explicit cancelation points.
    step = 200,
}

---Creates thread runner. Runner spawns new thread for each invocation.
---@param func function
---@return Runner @thread runner object to configure and run a new thread
function effil.thread(func) end

---Gives unique identifier.
---@return string @unique string id for current thread.
function effil.thread_id() end

---Explicit cancellation point. Function checks cancellation or pausing flags of current thread and if it's required it performs corresponding actions (cancel or pause thread).
function effil.yield() end

---Suspend current thread.
---@param time number
---@param metric? TimeMetric
function effil.sleep(time, metric) end

---Returns the number of concurrent threads supported by implementation. Basically forwards value from std::thread::hardware_concurrency.
---@return number @number of concurrent hardware threads.
function effil.hardware_threads() end

---Works exactly the same way as standard pcall except that it will not catch thread cancellation error caused by thread:cancel() call.
---@param func function
---@param ... unknown arguments to pass to functions
---@return boolean, ... @status, true if no error occurred, false otherwise, in case of error return one additional result with message of error, otherwise return function call results
function effil.pcall(func, ...) end

---Creates new empty shared table.
---@generic T:table
---@param tbl? T @it can be only regular Lua table which entries will be copied to shared table.
---@return T @new instance of empty shared table. It can be empty or not, depending on tbl content.
function effil.table(tbl) end

---Sets a new metatable to shared table. Similar to standard setmetatable.
---@generic T:table
---@param tbl T should be shared table for which you want to set metatable.
---@param mtbl table should be regular table or shared table which will become a metatable. If it's a regular table effil will create a new shared table and copy all fields of mtbl.Set mtbl equal to nil to delete metatable from shared table.
---@return T @returns tbl with a new metatable value similar to standard Lua setmetatable method.
function effil.setmetatable(tbl, mtbl) end

---Returns current metatable. Similar to standard getmetatable
---@param tbl table should be shared table
---@return table @metatable of specified shared table. Returned table always has type effil.table. Default metatable is nil
function effil.getmetatable(tbl) end

---Set table entry without invoking metamethod __newindex. Similar to standard rawset
---@generic T:table
---@param tbl T should be shared table
---@param key any key of table to override. The key can be of any [supported type](https://github.com/effil/effil?tab=readme-ov-file#important-notes)
---@param value any value to set. The value can be of any [supported type](https://github.com/effil/effil?tab=readme-ov-file#important-notes)
---@return T @the same shared table tbl
function effil.rawset(tbl, key, value) end

---Gets table value without invoking metamethod __index. Similar to standard rawget
---@param tbl table should be shared table
---@param key any key of table to receive a specific value. The key can be of any [supported type](https://github.com/effil/effil?tab=readme-ov-file#important-notes)
---@return any @required value stored under a specified key
function effil.rawget(tbl, key) end

---Truns effil.table into regular Lua table.
---@generic T:table
---@param tbl T should be shared table
---@return T @lua table with the same content as shared table
function effil.dump(tbl) end

---@class Channel
local Channel = {}

---Pushes message to channel.
---@param ... any @any number of values of [supported types](https://github.com/effil/effil?tab=readme-ov-file#important-notes). Multiple values are considered as a single channel message so one push to channel decreases capacity by one.
---@return boolean pushed is equal to true if value(-s) fits channel capacity, false otherwise.
function Channel:push(...) end

---Pop message from channel. Removes value(-s) from channel and returns them. If the channel is empty wait for any value appearance.
---@param time number
---@param metric TimeMetric
---@return ... variable amount of values which were pushed by a single channel:push() call.
function Channel:pop(time, metric) end

---Get actual amount of messages in channel.
---@return number @amount of messages in channel.
function Channel:size() end

---Creates a new channel.
---@param capacity? number capacity of channel. If capacity equals to 0 or to nil size of channel is unlimited. Default capacity is 0.
---@return Channel @new instance of channel
function effil.channel(capacity) end

---Returns number of entries in Effil object.
---@param obj table @shared table or channel.
---@return number @number of entries in shared table or number of messages in channel.
function effil.size(obj) end

---@alias EffilType "effil.thread"|"effil.table"|"effil.channel"
---@alias LuaType "thread"|"table"|"userdata"|"function"|"number"|"string"|"boolean"|"nil"

---Threads, channels and tables are userdata. Thus, type() will return userdata for any type. If you want to detect type more precisely use effil.type. It behaves like regular type(), but it can detect effil specific userdata.
---@param obj any @object of any type.
---@return EffilType|LuaType @string name of type. If obj is Effil object then function returns string like effil.table in other cases it returns result of lua_typename function.
function effil.type(obj) end

return effil