-- adapted from https://github.com/ray-x/go.nvim/blob/master/lua/go/format.lua
local api = vim.api
local vfn = vim.fn
local utils = require('go.utils')
local log = utils.log

local M = {}

local run = function(bufnr)
  bufnr = bufnr or 0
  local command = string.format(
    "goimports-reviser -rm-unused -set-alias -company-prefixes=pb -output=stdout %s | gofumpt -l | golines -m 130 --shorten-comments",
    api.nvim_buf_get_name(bufnr))

  if bufnr == 0 then
    if vfn.getbufinfo('%')[1].changed == 1 then
      vim.cmd('write')
    end
  end
  if vim.o.mod == true then
    vim.cmd('write')
  end

  local old_lines = api.nvim_buf_get_lines(0, 0, -1, true)

  local j = vfn.jobstart(vim.fn.split(command, " "), {
    on_stdout = function(_, data, _)
      data = utils.handle_job_data(data)
      if not data then
        return
      end
      if not utils.check_same(old_lines, data) then
        vim.notify('updating codes', vim.log.levels.DEBUG)
        api.nvim_buf_set_lines(0, 0, -1, false, data)
        vim.cmd('write')
      else
        vim.notify('already formatted', vim.log.levels.DEBUG)
      end
      old_lines = nil
    end,
    on_stderr = function(_, data, _)
      data = utils.handle_job_data(data)
      if data then
        log(vim.inspect(data) .. ' from stderr')
      end
    end,
    on_exit = function(_, data, _)
      if data ~= 0 then
        return vim.notify('golines failed ' .. tostring(data), vim.log.levels.ERROR)
      end
      old_lines = nil
      vim.defer_fn(function()
        if vfn.getbufinfo('%')[1].changed == 1 then
          vim.cmd('write')
        end
        vim.cmd(":GoImport")
      end, 300)
    end,
    stdout_buffered = true,
    stderr_buffered = true,
  })
  vfn.chansend(j, old_lines)
  vfn.chanclose(j, 'stdin')
end

M.format_go = run

return M
