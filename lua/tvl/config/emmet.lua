vim.g.user_emmet_leader_key = "f"
vim.g.user_emmet_mode = "n"
vim.g.user_emmet_settings = {
  variables = { lang = "ja" },
  javascript = {
    extends = "jsx",
  },
  html = {
    default_attributes = {
      option = { value = vim.null },
      textarea = { id = vim.null, name = vim.null, cols = 10, rows = 10 },
    },
    snippets = {
      ["!"] = "<!DOCTYPE html>\n"
          .. '<html lang="en">\n'
          .. "<head>\n"
          .. '\t<meta charset="${charset}">\n'
          .. '\t<meta name="viewport" content="width=device-width, initial-scale=1.0">\n'
          .. '\t<meta http-equiv="X-UA-Compatible" content="ie=edge">\n'
          .. "\t<title></title>\n"
          .. "</head>\n"
          .. "<body>\n\t${child}|\n</body>\n"
          .. "</html>",
    },
  },
}
