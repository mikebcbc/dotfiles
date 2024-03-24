return {
  {
    "nvim-pack/nvim-spectre",
    lazy = false,
    config = function()
      require("spectre").setup()
    end
  }
}
