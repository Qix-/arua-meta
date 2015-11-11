import test from 'ava';
import sync from 'glob';

var files = sync('examples/**/*.ar');

console.log(process.cwd());
console.log([].slice.call(files));
