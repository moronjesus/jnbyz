module.exports = {
  presets: [
    '@vue/cli-plugin-babel/preset'
  ]
}
module.rules = {
  test: /\.pug$/,
  loader: 'pug-plain-loader'
}