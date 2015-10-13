module.exports = (grunt) ->
    
    grunt.loadNpmTasks task for task in [
        "grunt-contrib-copy"
        "grunt-contrib-clean"
        "grunt-contrib-coffee"
        "grunt-contrib-jade"
        "grunt-contrib-sass"
        "grunt-contrib-watch"
        "grunt-contrib-uglify"
        "grunt-webpack"
        "grunt-contrib-cssmin"
        "grunt-jasmine-nodejs"
    ]
    
    grunt.initConfig
        copy:
            deploy: 
                files: [
                    expand: true
                    cwd: "build"
                    src: ["**/min.js", "**/min.css", "**/*.html"]
                    dest: "deploy"
                ]
        coffee:
            options:
                bare: true
            build:
                files: [
                            expand: true
                            cwd: "src"
                            src: ["**/**.unit.coffee"]
                            dest: "build"
                            ext: ".unit.js"
                        ,
                            expand: true
                            cwd: "src"
                            src: ["**/**.coffee", "!**/**.unit.coffee"]
                            dest: "build"
                            ext: ".js"                        
                    ]
        jade:
            build:
                expand: true
                cwd: "src"
                src: ["**/**.jade"]
                dest: "build"
                ext: ".html"
        sass:
            build:
                expand: true
                cwd: "src"
                src: ["**/**.scss"]
                dest: "build"
                ext: ".css"
        webpack:
            editor:
                entry: "./build/editor/eventBindings.js"
                output:
                    path: "build/editor"
                    filename: "packed.js"      
        uglify:
            build:
                files:
                    "build/editor/min.js": "build/editor/packed.js"     
        cssmin:
            editor:
                files:
                    "build/editor/min.css": ["build/*.css", "build/editor/**/*.css"]
        clean:
            build: "build"
            deploy: "deploy"
        jasmine_nodejs:
            unit:
                options:
                    specNameSuffix: ".unit.js"
                    reporters:
                        console:
                            verbosity: 2
                specs: ["build/**"]
        watch:
            options:
                atBegin: true
            files: ["src/**/*"],
            tasks: ["build", "deploy"]
    
    grunt.registerTask "build", ["clean:build", "coffee", "jasmine_nodejs", "jade", "sass", "webpack", "uglify", "cssmin"]
    grunt.registerTask "deploy", ["clean:deploy", "copy:deploy"]
