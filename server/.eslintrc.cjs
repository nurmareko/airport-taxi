module.exports = {
  root: true,
  extends: ['airbnb-base'],
  env: {
    node: true,
    es2022: true,
  },
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
  },
  ignorePatterns: ['node_modules/', 'coverage/', 'dist/', '.vercel/'],
  rules: {
    // Node's native ES modules require extensions on relative imports.
    'import/extensions': ['error', 'ignorePackages', { js: 'always' }],
    'import/no-extraneous-dependencies': ['error', {
      devDependencies: ['test/**/*.js', '*.config.js', '.eslintrc.cjs'],
    }],
  },
  overrides: [
    {
      files: ['test/**/*.js'],
      env: { jest: true },
    },
  ],
};
