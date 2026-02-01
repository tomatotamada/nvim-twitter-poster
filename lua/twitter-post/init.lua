local M = {}

local function url_encode(str)
	if str then
		str = string.gsub(str, "\n", "\r\n")
		str = string.gsub(str, "([^%w _%%%-%.~])", function(c)
			return string.format("%%%02X", string.byte(c))
		end)
		str = string.gsub(str, " ", "+")
	end
	return str
end

local function open_browser(url)
	local cmd
	if vim.fn.has("mac") == 1 then
		cmd = { "open", url }
	elseif vim.fn.has("wsl") == 1 or vim.fn.has("win32") == 1 then
		cmd = { "cmd.exe", "/c", "start", "", url }
	else
		cmd = { "xdg-open", url }
	end
	vim.fn.jobstart(cmd, { detach = true })
end

local function open_tweet_intent(text)
	local encoded = url_encode(text)
	local url = "https://twitter.com/intent/tweet?text=" .. encoded
	open_browser(url)
	print("ブラウザでツイート画面を開きました 🐦")
end

local function get_script_path()
	local str = debug.getinfo(2, "S").source:sub(2)
	local plugin_root = str:match("(.*/)") .. "../../"
	return plugin_root .. "scripts/tweet.py"
end

function M.setup()
	local script_path = get_script_path()

	local python_exec = script_path:gsub("tweet.py", ".venv/bin/python")

	vim.api.nvim_create_user_command("Tweet", function(opts)
		local content = opts.args

		local cmd = string.format("'%s' '%s' '%s'", python_exec, script_path, content:gsub("'", "'\\''"))

		vim.fn.jobstart(cmd, {
			on_exit = function(_, code)
				if code == 0 then
					print("Twitterに投稿しました！ 🐦")
				else
					print("投稿に失敗しました... (.envやライブラリを確認してください)")
				end
			end,
			on_stderr = function(_, data)
				if data then
					for _, line in ipairs(data) do
						if line ~= "" then
							print("Error: " .. line)
						end
					end
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

		local cmd = string.format("'%s' '%s' '%s'", python_exec, script_path, text:gsub("'", "'\\''"))

		vim.fn.jobstart(cmd, {
			on_exit = function(_, code)
				if code == 0 then
					print("選択範囲をTweetしました！ 🐦")
				else
					print("Tweet失敗...")
				end
			end,
			on_stderr = function(_, data)
				if data then
					for _, line in ipairs(data) do
						if line ~= "" then
							print("Error: " .. line)
						end
					end
				end
			end,
		})
	end, { range = true })

	-- Web Intent版（APIキー不要）
	vim.api.nvim_create_user_command("TweetIntent", function(opts)
		local content = opts.args
		if content == "" then
			print("テキストを入力してください")
			return
		end
		open_tweet_intent(content)
	end, { nargs = "+" })

	vim.api.nvim_create_user_command("TweetIntentSelection", function()
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
			print("テキストを選択してください")
			return
		end
		open_tweet_intent(text)
	end, { range = true })
end

return M
