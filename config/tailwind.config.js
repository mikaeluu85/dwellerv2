const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        'primary': '#FFC602',
        'primary-30': '#FFD74E',
        'secondary': '#E29900',
        'custom-black': '#222222',
        'dark-grey': '#484848',
        'light-grey': '#767676',
        'background-light': '#F7F7F7',
        'super-light': '#DDDDDD',
        'positive-green': '#00C851',
        'negative-red': '#FF4444',
        'alert-yellow': '#FFBB33',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/container-queries'),
  ]
}