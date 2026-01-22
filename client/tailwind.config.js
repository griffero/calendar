/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        // Linear-inspired color palette
        gray: {
          50: '#f9fafb',
          100: '#f3f4f6',
          150: '#eceef1',
          200: '#e5e7eb',
          300: '#d1d5db',
          400: '#9ca3af',
          500: '#6b7280',
          600: '#4b5563',
          700: '#374151',
          750: '#2d3748',
          800: '#1f2937',
          850: '#1a202c',
          900: '#111827',
          950: '#0d1117',
        },
        primary: {
          50: '#f0f5ff',
          100: '#e0ebff',
          200: '#c2d6ff',
          300: '#94b8ff',
          400: '#5c8fff',
          500: '#3b6cf4',
          600: '#2952d9',
          700: '#1e3fb0',
          800: '#1a348f',
          900: '#1a2f75',
          950: '#121d49',
        },
        accent: {
          purple: '#8b5cf6',
          blue: '#3b82f6',
          cyan: '#06b6d4',
          green: '#22c55e',
          yellow: '#eab308',
          orange: '#f97316',
          red: '#ef4444',
          pink: '#ec4899',
        },
      },
      fontFamily: {
        sans: ['Inter', '-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Roboto', 'sans-serif'],
        mono: ['JetBrains Mono', 'SF Mono', 'Consolas', 'monospace'],
      },
      fontSize: {
        '2xs': ['0.625rem', { lineHeight: '0.875rem' }],
      },
      spacing: {
        '18': '4.5rem',
        '88': '22rem',
        '128': '32rem',
      },
      animation: {
        'fade-in': 'fadeIn 150ms ease-out',
        'fade-out': 'fadeOut 150ms ease-in',
        'slide-in': 'slideIn 200ms ease-out',
        'slide-out': 'slideOut 200ms ease-in',
        'scale-in': 'scaleIn 150ms ease-out',
        'scale-out': 'scaleOut 150ms ease-in',
        'spin-slow': 'spin 2s linear infinite',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        fadeOut: {
          '0%': { opacity: '1' },
          '100%': { opacity: '0' },
        },
        slideIn: {
          '0%': { transform: 'translateX(-100%)' },
          '100%': { transform: 'translateX(0)' },
        },
        slideOut: {
          '0%': { transform: 'translateX(0)' },
          '100%': { transform: 'translateX(-100%)' },
        },
        scaleIn: {
          '0%': { transform: 'scale(0.95)', opacity: '0' },
          '100%': { transform: 'scale(1)', opacity: '1' },
        },
        scaleOut: {
          '0%': { transform: 'scale(1)', opacity: '1' },
          '100%': { transform: 'scale(0.95)', opacity: '0' },
        },
      },
      boxShadow: {
        'soft': '0 2px 8px 0 rgba(0, 0, 0, 0.08)',
        'medium': '0 4px 16px 0 rgba(0, 0, 0, 0.12)',
        'hard': '0 8px 32px 0 rgba(0, 0, 0, 0.16)',
        'inner-soft': 'inset 0 1px 2px 0 rgba(0, 0, 0, 0.05)',
      },
      borderRadius: {
        'sm': '0.25rem',
        'DEFAULT': '0.375rem',
        'md': '0.5rem',
        'lg': '0.75rem',
        'xl': '1rem',
      },
      transitionDuration: {
        '0': '0ms',
        '75': '75ms',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms')({ strategy: 'class' }),
    require('@tailwindcss/typography'),
  ],
}
