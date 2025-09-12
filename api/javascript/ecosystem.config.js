module.exports = {
    apps: [
        {
            name: 'sakay-api-javascript',
            script: 'dist/index.js',
            instances: 1,
            autorestart: true,
            watch: false,
            max_memory_restart: '500M',
            env: {
                NODE_ENV: 'DEV',
                PORT: 3000,
            },
            env_production: {
                NODE_ENV: 'PROD',
                PORT: 3000,
            },
        },
    ],
};
