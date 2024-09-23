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
      buttonStyles: {
        'primary-button': 'bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded',
        'secondary-button': 'lg:w-1/2 w-full rounded-full bg-white px-3.5 py-2.5 tracking-wide text-center text-sm uppercase font-medium text-custom-black shadow-sm border border-light-grey hover:bg-super-light focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-brand',
        // Add more button styles as needed
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