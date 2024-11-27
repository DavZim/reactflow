var path = require('path');

module.exports = {
    entry: path.join(__dirname, 'srcjs', 'reactflow.jsx'),
    output: {
        path: path.join(__dirname, 'inst/htmlwidgets'),
        filename: 'reactflow.js'
    },
    module: {
        rules: [
            {
                test: /\.jsx?$/,
                loader: 'babel-loader',
                options: {
                    presets: ['@babel/preset-env', '@babel/preset-react']
                }
            },
            // For CSS so that import "path/style.css"; works
            {
                test: /\.css$/,
                use: ['style-loader', 'css-loader']
            }
        ]
    },
    resolve: {
        alias: {
            'react/jsx-runtime': require.resolve('react/jsx-runtime'),
            'react/jsx-dev-runtime': require.resolve('react/jsx-dev-runtime'),
          }
        //alias: {
         //   "react/jsx-dev-runtime": "react/jsx-dev-runtime.js",
         //   "react/jsx-runtime": "react/jsx-runtime.js"
        //}
    },
    externals: {
        'react': 'window.React',
        'react-dom': 'window.ReactDOM',
        'reactR': 'window.reactR'
    },
    stats: {
        colors: true
    },
    devtool: 'source-map'
};