# Changelog

## [2.2.1](https://github.com/loctvl842/nvim/compare/v2.2.0...v2.2.1) (2024-04-02)


### Bug Fixes

* fold shouldn't appear in neo-tree ([770db30](https://github.com/loctvl842/nvim/commit/770db306d776de41994a0970a458cec45844c03e))

## [2.2.0](https://github.com/loctvl842/nvim/compare/v2.1.0...v2.2.0) (2024-03-14)


### Features

* **Lsp:** Add Go language server support ([cff1e5c](https://github.com/loctvl842/nvim/commit/cff1e5cf1720ae5677c3e0791b4887f4471e1994))
* **lsp:** Add support for Dockerfile language server ([457ca88](https://github.com/loctvl842/nvim/commit/457ca881fe540ba6845cb54de68bd82af8515829))

## [2.1.0](https://github.com/loctvl842/nvim/compare/v2.0.0...v2.1.0) (2024-02-25)


### Features

* vue development ([7810203](https://github.com/loctvl842/nvim/commit/7810203e677eda33205ac33c2764eb28d466857b))

## [2.0.0](https://github.com/loctvl842/nvim/compare/v1.0.0...v2.0.0) (2024-02-03)


### ⚠ BREAKING CHANGES

* BeastVim

### Features

* BeastVim ([798dfac](https://github.com/loctvl842/nvim/commit/798dfac3578086bd135e6dc6e041d89714016fde))

## 1.0.0 (2024-02-03)


### ⚠ BREAKING CHANGES

* first version

### Features

* add `noice` ([9ca1844](https://github.com/loctvl842/nvim/commit/9ca184426d8c0b84acc61b9c53ccf74b534f3191))
* add black ([9150c14](https://github.com/loctvl842/nvim/commit/9150c143c1676f72c2c34979d7f654319346ee56))
* add doc ([6ee6f9b](https://github.com/loctvl842/nvim/commit/6ee6f9b5a64472879e4e2ec4966262b402adc8fa))
* add support for `php` - lsp (intelephense) ([1bf59cf](https://github.com/loctvl842/nvim/commit/1bf59cfa3a3e9db2994d6f4ef9127a9303b227b4))
* auto set root folder on enter nvim ([592e003](https://github.com/loctvl842/nvim/commit/592e003f1385cf35da6fdd91fbd002af41efa95b))
* **coding:** try starcoder ([6a0f32c](https://github.com/loctvl842/nvim/commit/6a0f32cd18eb2a747c2de40678d675aef897eafc))
* config `lualine` setup with two style `float` or `basic` ([8b20b4b](https://github.com/loctvl842/nvim/commit/8b20b4ba625fe867d26c548db8d4fbb464949869))
* **conform:** use conform as default formatter ([cf4562d](https://github.com/loctvl842/nvim/commit/cf4562d3b1fcc35b35b3b8ad288b08adadeab7d3))
* custom UI easier by only edit colorscheme ([6f4ae70](https://github.com/loctvl842/nvim/commit/6f4ae70e7ab720cd9d850f9fe4c0db53222d8a92))
* don't search in these folder ([59e593d](https://github.com/loctvl842/nvim/commit/59e593dfc9e7e741cfbb1ae9642ba1085cb53ae5))
* don't use default `lua_ls` to format code ([469cbcb](https://github.com/loctvl842/nvim/commit/469cbcbc71f4b8133937a12425db48a18a2846ee))
* **dressing:** use another telescope theme for code action ([9d6a1a6](https://github.com/loctvl842/nvim/commit/9d6a1a67c4f5cf52dc5220b1e8084066f7911da9))
* first version ([5577828](https://github.com/loctvl842/nvim/commit/5577828100304b650d6afaaa305004b1b1047a34))
* **lsp:** only use pyright for completion ([211c735](https://github.com/loctvl842/nvim/commit/211c735b41a73824f5a74d932d492da345c4e338))
* **lsp:** setup python ([70a9554](https://github.com/loctvl842/nvim/commit/70a9554947e91d79667c42728a6c588059697881))
* **lsp:** support `rust_analyzer` and add `inlay_hint` ([01df75e](https://github.com/loctvl842/nvim/commit/01df75e5f51a5604e2a3939fd7da6892c1be6ba0))
* **lsp:** support python lsp ([4a64025](https://github.com/loctvl842/nvim/commit/4a64025987b9b1f738449b820db0d7504ad485b4))
* **neo-tree:** try to group empty dir ([d2405d0](https://github.com/loctvl842/nvim/commit/d2405d091250ab6a86420fb3a87e81088c3cb16a))
* search buffer ([11e789e](https://github.com/loctvl842/nvim/commit/11e789e5a18bac3aa36e4046ef18da0b3e0a5dcc))
* test ci ([64708f4](https://github.com/loctvl842/nvim/commit/64708f40667dffee02bc5ad059bcf7ecbe738218))
* try `mini.pair`` as an alternative to `nvim-autopairs` ([d150fb4](https://github.com/loctvl842/nvim/commit/d150fb4c7870bf47529aa3f28b8a27c22d3cca29))
* use ChatGPT ([9372028](https://github.com/loctvl842/nvim/commit/937202880a2e72c7c65bc5e2fd8c9398e1ca9697))
* **util:** better way to handle borders ([b5c5cf7](https://github.com/loctvl842/nvim/commit/b5c5cf74e317d76d5bcd524b3e6ddd63d57bc913))


### Bug Fixes

* `get_highlight_value` can't format boolean ([59fcff8](https://github.com/loctvl842/nvim/commit/59fcff868f8b594deff63205c93a3825ce3d0d27))
* `toggleterm` isn't loaded if using `nvim test.js` ([bfc7558](https://github.com/loctvl842/nvim/commit/bfc7558eccdb168f7f0cc8900785aa76207b1e07))
* do not load ChatGPT ([5a7327f](https://github.com/loctvl842/nvim/commit/5a7327f0e28b163ec42f8a9d11aaa8feb5973cc2))
* icon ufo ([763542e](https://github.com/loctvl842/nvim/commit/763542e2929065333257ea677fd354c5b8d39e5a))
* latest nvim-cmp can't be used with codeium ([efbc504](https://github.com/loctvl842/nvim/commit/efbc504cb1442ed19c64c9f2f864a8a967bfb57b))
* **lsp:** this duplicate error with pyright ([01d15da](https://github.com/loctvl842/nvim/commit/01d15da49e026b5a5660ffee142bd9e6f24da925))
* no comment on new line ([413237a](https://github.com/loctvl842/nvim/commit/413237a45868c573eea94a2e26fd3b2015c87e6b))
* open `dashboard` after installing plugins ([e676d7f](https://github.com/loctvl842/nvim/commit/e676d7fcb8aac01adec057e6a6f7030dd066c70c))
* overlap error code tsserver and eslint ([b7b044f](https://github.com/loctvl842/nvim/commit/b7b044f48964ee0a478e9a35163e2e752b34f477))
* running jdtls twice ([3c3ff07](https://github.com/loctvl842/nvim/commit/3c3ff074182ea149e4c9a2820d766ee0dec3a46c))
* **servers:** disable hint of pyright ([2d4bed4](https://github.com/loctvl842/nvim/commit/2d4bed48cfa16525641ff09ac44a63e2df56025f))
* strange ![behavior](https://www.reddit.com/r/neovim/comments/11tn1oy/comment/jcky0kt/?context=3) on escape ([6fc9647](https://github.com/loctvl842/nvim/commit/6fc96474a65014e6bdca41f9fbc3346cfacb0d92))
* temporarily fix `ft_ignore` of `statuscol` ([1d2198d](https://github.com/loctvl842/nvim/commit/1d2198dd3abc584429d27995850015f3a4f2ae81))
* typescript wrong mapping ([975d6c9](https://github.com/loctvl842/nvim/commit/975d6c963dbc2ce88ecdbfc7a30ebf8c9515f6cb))
* update nerd font v3 ([c330556](https://github.com/loctvl842/nvim/commit/c3305561f06b58bd0f6325e460fa6ce869a1d25d))
* wrong mapping ([ced1839](https://github.com/loctvl842/nvim/commit/ced183994f949e10ede2fefb14e2d6f5475b623c))


### Performance Improvements

* increase `keyword_length` for java to improve performace of `jdtls` ([b87d757](https://github.com/loctvl842/nvim/commit/b87d75785aaddc8f2358c9aa52be5ccdd832697f))
