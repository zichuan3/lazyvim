lsp：
    目前的lsp使用neovim的0.11版本的lsp配置，会自动读取当前目录下lsp文件夹里面的lsp配置文件，
当前的配置差不多已经够了，今后应该不会大规模的更改了

用mini.diff替代了gitsign，oil.nvim替代了neo-tree，

toggle-term是在当前打开终端的，
如果在<c-\>之前加上数字，则打开的是不同的终端，再次按<c-\>打开的是上次的终端

使用oil偶尔有bug产生,与bufferline不太搭配？以后再看看。

使用code_run来运行文件
