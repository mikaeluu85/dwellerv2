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
        brand: '#FFC602',
        'brand-secondary': '#E29900',
        'brand-hue': 'rgba(255, 198, 2, 0.8)', // 80% opacity
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
