# 🚀 npm-info.nvim ![Neovim](https://img.shields.io/badge/Neovim-%2357A143.svg?logo=neovim&logoColor=white) ![Lua](https://img.shields.io/badge/Lua-%232C2D72.svg?logo=lua&logoColor=white)

A smart Neovim plugin that displays npm dependency information directly in your `package.json`! 📦💡

## ✨ Key Features

- 🔍 **Automatic detection** of dependencies in `package.json`
- 📌 **Installed versions** shown inline (⚡️ Instant)
- 🚨 **Outdated version alerts** (🔴 High contrast)
- 📊 **Supports:**
  - `dependencies`
  - `devDependencies`
  - `peerDependencies`
  - `optionalDependencies`
- 🌈 **NERD Fonts support** (Custom icons)
- ⚡️ Real-time updates with `BufWritePost`

## 📦 Installation

Using [Lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "pxndxs/npm-info.nvim",
  event = "BufEnter package.json",
  config = true, -- Auto-configuration
  dependencies = {
    "nvim-treesitter/nvim-treesitter" -- 📚 Required for parsing
  }
}
```

## ⚙️ Configuration (Optional)

```lua
require("npm-info").setup({
  icons = {
    beta = "󰂡",
    current = "",
    isLatest = "",
    outdated = "",
  },
  hl_groups = {
    beta = "DiagnosticWarn",
    current  = "Comment",
    isLatest = "NpmLatest",
    outdated = "NpmOutdated",
  },
  messages = {
    beta = "beta",
    current = "Current",
    isLatest = "is Latest",
    outdated = "Latest %s",
  },
  show_installed = true,
})
````

## 🕵️ Technical Deep Dive

### 🔍 Data Structure
```json
{
  "dependencies": {
    "lodash": "^4.17.21",  <!-- 🚀👆 4.17.21 (latest: 4.17.21) -->
    "vue": "3.2.47"        <!-- ⚡ 3.2.47 -->
  }
}
```

### 📡 NPM Commands Used
| Command | Function |
|---------|---------|
| `npm list --json --depth=0` | Get installed version |
| `npm outdated --json` | Detect outdated versions |

### ⚙️ Dependencies
- Neovim ≥ 0.9.0
- nvim-treesitter
- Node.js ≥ 16.0.0

## 🛠️ Troubleshooting

**Issue:** Versions not showing
**Solution:**
1. Verify npm installation: `npm -v`
2. Ensure read permissions
3. Update nvim-treesitter

## 🤝 Contributing

PRs welcome! 👾
1. Fork the repository
2. Create your branch: `git checkout -b feat/new-feature`
3. Commit: `git commit -am 'Add some feature'`
4. Push: `git push origin feat/new-feature`
5. Open a PR ✨

---

📜 **License:** MIT © 2024 Pxndxs 🐼
