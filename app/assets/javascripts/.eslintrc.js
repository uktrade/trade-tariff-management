module.exports = {
    "env": {
        "browser": true
    },
    "extends": [
      "eslint:recommended",
      "plugin:vue/strongly-recommended"
    ],
    "parserOptions": {
        "ecmaVersion": 5
    },
    "rules": {
        "indent": [
            "error",
            2
        ],
        "linebreak-style": [
            "error",
            "unix"
        ],
        "quotes": [
            "warn",
            "double"
        ],
        "semi": [
            "warn",
            "always"
        ],
        "vue/require-default-prop": {
          off: true
        }
    },
    "globals": {
      "$": true,
      "moment": true,
      "Vue": true
    }
};
