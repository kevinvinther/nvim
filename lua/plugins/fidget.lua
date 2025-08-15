return {
  'j-hui/fidget.nvim',
  event = 'LspAttach',
  opts = {
    progress = {
      suppress_on_insert = true,
      display = {
        done_ttl = 2,
        progress_icon = {
          pattern = {
            ' 󰫃 ',
            ' 󰫄 ',
            ' 󰫅 ',
            ' 󰫆 ',
            ' 󰫇 ',
            ' 󰫈 ',
          },
        },
      },
    },
  },
}
