const gulp = require('gulp');
const svgo = require('gulp-svgo');

function optimizeSvgs() {
    return gulp.src('node_modules/openmoji/color/svg/*.svg')
        .pipe(svgo())
        .pipe(gulp.dest('../assets/openmoji'));
}

function copyData() {
    return gulp.src('node_modules/openmoji/data/openmoji.csv')
        .pipe(gulp.dest('../assets'));
}

exports.default = gulp.series(optimizeSvgs, copyData);
