const coc = require('coc.nvim')

function activate(context) {
  context.subscriptions.push(
    coc.commands.registerCommand('learn-coc-extension.Command', async () => {
      coc.window.showMessage(`learn-coc-extension Commands works!`)
    })
  )
}

module.exports = {
  activate,
}
