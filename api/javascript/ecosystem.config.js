module.exports = {
    apps: [
        {
            name: 'sakay-api-javascript',
            script: './dist/src/index.js',
            instances: 1,
            exec_mode: 'fork',
            autorestart: true,
            watch: false,
            max_memory_restart: '500M',
            env: {
                NODE_ENV: 'DEV',
            },
            env_production: {
                NODE_ENV: 'PROD',
            },
        },
    ],
};
