return {
  "Exafunction/codeium.vim",
  event = "BufEnter",
  config = function()
    -- Change '<C-g>' here to any keycode you like.
    vim.keymap.set("i", "<c-g>", function()
      return vim.fn["codeium#Accept"]()
    end, { expr = true, silent = true })
    vim.keymap.set("i", "<C-n>", function()
      return vim.fn["codeium#CycleCompletions"](1)
    end, { expr = true, silent = true })
    vim.keymap.set("i", "<C-j>", function()
      return vim.fn["codeium#CycleCompletions"](-1)
    end, { expr = true, silent = true })
    vim.keymap.set("i", "<c-x>", function()
      return vim.fn["codeium#Clear"]()
    end, { expr = true, silent = true })

    -- API kEY
    vim.g.codeium_api_key =
      "eyJhbGciOiJSUzI1NiIsImtpZCI6IjhkNzU2OWQyODJkNWM1Mzk5MmNiYWZjZWI2NjBlYmQ0Y2E1OTMxM2EiLCJ0eXAiOiJKV1QifQ.eyJuYW1lIjoiSU1BTiBLaW1pYWVpIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hL0FDZzhvY0lrN3lEX3V4Skt5UFAzLUdNNnJfTGpUQXVqUjc2TkZMTWdaUW1jbzVXbGx0WT1zOTYtYyIsImlzcyI6Imh0dHBzOi8vc2VjdXJldG9rZW4uZ29vZ2xlLmNvbS9leGEyLWZiMTcwIiwiYXVkIjoiZXhhMi1mYjE3MCIsImF1dGhfdGltZSI6MTcyNTgzMTc2OCwidXNlcl9pZCI6InE1a3dTeWJsWlJiTU4zRHF3czBhd1NzbDlHaTEiLCJzdWIiOiJxNWt3U3libFpSYk1OM0Rxd3MwYXdTc2w5R2kxIiwiaWF0IjoxNzI4MzgwODMzLCJleHAiOjE3MjgzODQ0MzMsImVtYWlsIjoiaW5raW1pYWVpQGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7Imdvb2dsZS5jb20iOlsiMTA4NDI0NjU4NDI0MTg2Njg5Njg4Il0sImVtYWlsIjpbImlua2ltaWFlaUBnbWFpbC5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJnb29nbGUuY29tIn19.tGVHc-Xd9OQkaV6BHlJSci0OmL2bIaIFdWRNKfCnPaJYz6oiSD6eqBZVNgt1YzhBWFzdLqDwxxFjljWaMI7vNQF2fyfnTcGG0d20WD-lP35rkvQzQ-iTPtELp3qddz_1w33hUF2zDhnj5wmIBz1_JlA4HbhRd2jB24He7HMc13LaDx-Acjq7M1bskhncI4am_gWYEEljE6UzrMnojvSCGvl-t2dwjdGyphpXkwDJ8L0r1Uy-9ktVgvL9MOeTBB5fU1SNIEakMNZA8cxtigaEUAW4W4do6xnPDO2XRe6TC3qkLQcocu2uQk0dMf7O8FHdOMSi1IfXESfk-NJUTwF8qw"
  end,
}
