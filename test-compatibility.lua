-- Cross-platform compatibility test script
-- This file can be used to test the configuration across platforms

local M = {}

function M.test_paths()
  print("Testing cross-platform path functions...")
  
  -- Test path joining
  if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    print("Platform: Windows")
  elseif vim.fn.has("wsl") == 1 then
    print("Platform: WSL")
  elseif vim.fn.has("mac") == 1 then
    print("Platform: macOS")
  elseif vim.fn.has("unix") == 1 then
    print("Platform: Unix/Linux")
  end
  
  -- Test path separator
  local test_path = vim.fn.expand("~/test/file.txt")
  print("Path separator test:", test_path)
end

function M.test_clipboard()
  print("Testing clipboard configuration...")
  print("Clipboard setting:", vim.opt.clipboard:get())
  
  if vim.g.clipboard then
    print("Clipboard config found:")
    for k, v in pairs(vim.g.clipboard) do
      print("  " .. k .. ":", type(v) == "table" and "table" or v)
    end
  else
    print("No custom clipboard config")
  end
end

function M.test_performance()
  print("Testing performance optimizations...")
  
  -- Test cache cleanup
  local start_time = os.time()
  
  -- Simulate cache operations
  local test_cache = {}
  for i = 1, 1000 do
    test_cache["key" .. i] = { value = i, timestamp = os.time() }
  end
  
  -- Cleanup simulation
  local current_time = os.time()
  local cleaned = 0
  for key, entry in pairs(test_cache) do
    if current_time - entry.timestamp > 1 then
      test_cache[key] = nil
      cleaned = cleaned + 1
    end
  end
  
  local end_time = os.time()
  print("Cache cleanup test: cleaned", cleaned, "entries in", end_time - start_time, "seconds")
end

-- Run tests
M.test_paths()
M.test_clipboard()
M.test_performance()

print("Cross-platform compatibility tests completed!")