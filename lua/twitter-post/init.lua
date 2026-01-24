local M = {}

local function get_script_path()
	local str = debug.getinfo(2, "S").source:sub(2)
	local plugin_root = str:match("(.*/)") .. "../../"
	return plugin_root .. "scripts/tweet.py"
end

function M.setup()
	local script_path = get_script_path()
	local python_exec = script_path:gsub("scripts/tweet.py", "venv/bin/python")

	vim.api.nvim_create_user_command("Tweet", function(opts)
		local content = opts.args
		local cmd = string.format("'%s' '%s' '%s'", python_path, script_path, content:gsub("'", "'\\''"))

		vim.fn.jobstart(cmd, {
			on_exit = function(_, code)
				if code == 0 then
					print("Twitterに投稿しました！ 🐦")
				else
					print("投稿に失敗しました... (.envやライブラリを確認してください)")
				end
			end,
		})
	end, { nargs = "+" })

	vim.api.nvim_create_user_command("TweetSelection", function(opts)
		local start_pos = vim.api.nvim_buf_get_mark(0, "<")
		local end_pos = vim.api.nvim_buf_get_mark(0, ">")
		local lines = vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, end_pos[1], false)

		if #lines > 0 then
			local last_col = end_pos[2] + 1
			if last_col < #lines[#lines] then
				lines[#lines] = string.sub(lines[#lines], 1, last_col)
			end
			local start_col = start_pos[2]
			if start_col > 0 then
				lines[1] = string.sub(lines[1], start_col + 1)
			end
		end

		local text = table.concat(lines, "\n")
		if text == "" then
			return
		end

		local cmd = string.format("'%s' '%s' '%s'", script_path, text:gsub("'", "'\\''"))

		vim.fn.jobstart(cmd, {
			on_exit = function(_, code)
				if code == 0 then
					print("選択範囲をTweetしました！ 🐦")
				else
					print("Tweet失敗...")
				end
			end,
		})
	end, { range = true })
end

return M
