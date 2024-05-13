const path = require('path');

module.exports = {
  webpack: (config, { isServer }) => {
    // Add support for '@' alias
    config.resolve.alias['@'] = path.resolve(__dirname);

    return config;
  },
};
